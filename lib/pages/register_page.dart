import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/fields.dart';
import 'package:tf_union/widgets/costum_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final _birthDate = TextEditingController();
  final phone = TextEditingController();
  final prepSchool = TextEditingController();
  final thanawySchool = TextEditingController();
  final university = TextEditingController();
  final username = TextEditingController(); // currently unused (field disabled)
  final password = TextEditingController();
  final faculty = TextEditingController();

  // Dropdowns
  String? stemSchool;
  String? _selectedValue;
  String? _selectedGrade;
  String? _selectedYear;
  String? _selectedGender;

  // Username state (only used if the username field is re-enabled)
  String? usernameError;
  bool checkingUsername = false;
  bool usernameAvailable = false;

  // Flow state
  bool isLoading = false;
  bool _obscurePassword = true; // toggled by the eye icon

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    _birthDate.dispose();
    phone.dispose();
    prepSchool.dispose();
    thanawySchool.dispose();
    university.dispose();
    password.dispose();
    username.dispose();
    faculty.dispose();
    super.dispose();
  }

  // Looks up `usernames/{value}` in Firestore to see if the username is taken.
  Future<void> checkUsername(String value) async {
    if (value.isEmpty) return;
    setState(() {
      checkingUsername = true;
      usernameAvailable = false;
    });
    try {
      final doc = await FirebaseFirestore.instance
          .collection('usernames')
          .doc(value)
          .get();
      setState(() {
        checkingUsername = false;
        if (doc.exists) {
          usernameError = 'Username already taken';
          usernameAvailable = false;
        } else {
          usernameError = null;
          usernameAvailable = true;
        }
      });
    } catch (e) {
      setState(() {
        checkingUsername = false;
        usernameError = 'Could not check username, try again';
        usernameAvailable = false;
      });
    }
  }

  // Creates the account directly (no email verification) and saves the profile.
  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);

    try {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          setState(() => isLoading = false);
          showCostumDialog(
            context: context,
            title: 'Account exists',
            content:
                'This email is already registered. Head to the login page instead.',
            confirmText: 'Go to Login',
            onConfirm: () {
              Navigator.of(context).pushReplacementNamed('login');
            },
          );
          return;
        }
        rethrow;
      }

      await _saveUserData();
      if (!mounted) return;
      setState(() => isLoading = false);
      Navigator.of(context).pushReplacementNamed('homePage');
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      showCostumDialog(
        context: context,
        title: 'Error',
        content: e.message ?? 'Something went wrong.',
        onConfirm: () => Navigator.pop(context),
      );
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Registration error: $e');
    }
  }

  // NOTE: the field names below are my best guess from the form controllers.
  // Replace them with your original fields if they differ.
  Future<void> _saveUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final level = _selectedValue!;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'firstName': firstName.text.trim(),
      'lastName': lastName.text.trim(),
      'email': email.text.trim(),
      'birthDate': _birthDate.text,
      'gender': _selectedGender,
      'phone': phone.text.trim(),
      'level': level,
      'school': level == 'Prep School'
          ? prepSchool.text.trim()
          : level == 'Thanawy'
              ? thanawySchool.text.trim()
              : level == 'STEM'
                  ? stemSchool
                  : null,
      'grade': level == 'University' ? null : _selectedGrade,
      'university': level == 'University' ? university.text.trim() : null,
      'year': level == 'University' ? _selectedYear : null,
      'faculty': level == 'University' ? faculty.text.trim() : null,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Username field is disabled for now, so skip reserving a username doc.
    if (username.text.trim().isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('usernames')
          .doc(username.text)
          .set({'uid': user.uid});
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2014),
      initialDate: DateTime(2009),
    );
    if (picked != null) {
      setState(() {
        _birthDate.text = picked.toString().split(' ')[0];
      });
    }
  }

  // ─── Section header helper ───────────────────────────────────────────────
  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: TFColors.yellowPrimary, size: 20),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.robotoSlab(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: TFColors.yellowPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: TFColors.yellowPrimary.withAlpha(60),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        title: Center(
          child: SizedBox(
            width: 200,
            child: Image.asset('assets/BlackLogo.png'),
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Title ──────────────────────────────────────────
                      Text(
                        'Join TF Union',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roadRage(
                          fontSize: 38,
                          color: TFColors.whitePrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'A few seconds separate you from being part of our family.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.exo2(
                          fontSize: 13,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.of(
                            context,
                          ).pushReplacementNamed('login'),
                          child: const Text(
                            'Already have an account? Login',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ),
                      ),

                      // ── Personal Info ──────────────────────────────────
                      _sectionHeader('Personal Info', Icons.person_outline),
                      buildTextField(
                        controller: firstName,
                        label: 'First Name',
                      ),
                      buildTextField(controller: lastName, label: 'Last Name'),
                      buildTextField(
                        controller: _birthDate,
                        label: 'Birth Date',
                        readOnly: true,
                        onTap: _selectDate,
                      ),
                      buildDropdown<String>(
                        label: 'Gender',
                        value: _selectedGender,
                        items: const ['Male', 'Female'],
                        onChanged: (v) => setState(() => _selectedGender = v),
                        validator: (v) =>
                            v == null ? 'Please select a gender' : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: IntlPhoneField(
                          controller: phone,
                          initialCountryCode: 'EG',
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: TFColors.hintDark),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),

                      // ── Academic Info ──────────────────────────────────
                      _sectionHeader('Academic Info', Icons.school_outlined),
                      buildDropdown<String>(
                        label: 'Academic Level',
                        value: _selectedValue,
                        items: const [
                          'Prep School',
                          'Thanawy',
                          'STEM',
                          'University',
                        ],
                        onChanged: (v) => setState(() => _selectedValue = v),
                        validator: (v) =>
                            v == null ? 'Please select your level' : null,
                      ),
                      if (_selectedValue == 'Prep School')
                        buildTextField(
                          controller: prepSchool,
                          label: 'Official School Name',
                        ),
                      if (_selectedValue == 'Thanawy')
                        buildTextField(
                          controller: thanawySchool,
                          label: 'Official School Name',
                        ),
                      if (_selectedValue == 'STEM')
                        buildDropdown<String>(
                          label: 'STEM School',
                          value: stemSchool,
                          items: const [
                            '6th of October STEM School for Boys',
                            'October STEM School',
                            'Maadi STEM School for Girls',
                            'New Cairo STEM School',
                            'Alexandria STEM School',
                            'Dakahlia STEM School',
                            'Ismailia STEM High School',
                            'Red Sea STEM School',
                            'Assiut STEM School',
                            'Luxor STEM School',
                            'Sers El-Lyan STEM School for Girls',
                            'El-Sadat STEM School for Boys',
                            'Gharbia STEM School',
                            'Obour STEM School',
                            'Sharqia STEM School',
                            'Qena STEM School',
                            'Fayoum STEM School for Boys',
                            'Beni Suef STEM School',
                            'Minya STEM School for Boys',
                            'Sohag STEM School for Girls',
                            'Arish STEM School',
                          ],
                          onChanged: (v) => setState(() => stemSchool = v),
                          validator: (v) =>
                              v == null ? 'Please select your school' : null,
                        ),
                      if (_selectedValue != null &&
                          _selectedValue != 'University')
                        buildDropdown<String>(
                          label: 'Grade',
                          value: _selectedGrade,
                          items: const [
                            'Grade 7',
                            'Grade 8',
                            'Grade 9',
                            'Grade 10',
                            'Grade 11',
                            'Grade 12',
                          ],
                          onChanged: (v) => setState(() => _selectedGrade = v),
                          validator: (v) =>
                              v == null ? 'Please select your grade' : null,
                        ),
                      if (_selectedValue == 'University') ...[
                        buildTextField(
                          controller: university,
                          label: 'Official University Name',
                        ),
                        buildDropdown<String>(
                          label: 'Year',
                          value: _selectedYear,
                          items: const [
                            '1st year',
                            '2nd year',
                            '3rd year',
                            '4th year',
                            '5th year',
                            'Master',
                            'PhD',
                          ],
                          onChanged: (v) => setState(() => _selectedYear = v),
                          validator: (v) =>
                              v == null ? 'Please select your year' : null,
                        ),
                        buildTextField(controller: faculty, label: 'Faculty'),
                      ],

                      // ── Account Credentials ────────────────────────────
                      _sectionHeader('Account Credentials', Icons.lock_outline),
                      buildMailField(
                        controller: email,
                        label: 'Personal Email',
                      ),
                      // Username field is currently disabled. If re-enabled it
                      // wires up to checkUsername(), usernameError and
                      // usernameAvailable.
                      /* buildUsernameField(
                        controller: username,
                        label: 'Username',
                        errorText: usernameError,
                        onChanged: checkUsername,
                        suffixIcon: checkingUsername
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : usernameAvailable
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                      ), */
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          obscureText: _obscurePassword,
                          controller: password,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: TFColors.hintDark),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),

                      // ── Submit button ──────────────────────────────────
                      const SizedBox(height: 28),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TFColors.yellowPrimary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            'Create Account',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Loading overlay ──────────────────────────────────────────────
          if (isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(color: TFColors.yellowPrimary),
              ),
            ),
        ],
      ),
    );
  }
}