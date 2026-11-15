import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/utils/saved_accounts.dart';
import 'package:tf_union/widgets/fields.dart';
import 'package:tf_union/widgets/costum_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final _birthDate = TextEditingController();
  final phone = TextEditingController();
  final prepSchool = TextEditingController();
  final thanawySchool = TextEditingController();
  final university = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final faculty = TextEditingController();

  String? stemSchool;
  String? _selectedValue;
  String? _selectedGrade;
  String? _selectedYear;
  String? _selectedGender;

  bool isLoading = false;
  bool _obscurePassword = true;

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

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);

    try {
      late final UserCredential cred;
      try {
        cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          setState(() => isLoading = false);
          if (!mounted) return;
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

      final fullName =
          '${firstName.text.trim()} ${lastName.text.trim()}'.trim();
      if (fullName.isNotEmpty) {
        await cred.user?.updateDisplayName(fullName);
      }

      await _saveUserData();
      if (cred.user != null) {
        SavedAccountsStore.saveFromUser(cred.user!);
      }
      try {
        await cred.user?.sendEmailVerification();
      } catch (_) {}

      if (!mounted) return;
      setState(() => isLoading = false);
      Navigator.of(context).pushReplacementNamed('homePage');
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      if (!mounted) return;
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

  Future<void> _saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final level = _selectedValue ?? 'STEM';
    final fullName = '${firstName.text.trim()} ${lastName.text.trim()}'.trim();

    final payload = {
      'uid': user.uid,
      'firstName': firstName.text.trim(),
      'lastName': lastName.text.trim(),
      'fullName': fullName,
      'username': username.text.trim().isNotEmpty
          ? username.text.trim()
          : fullName,
      'email': email.text.trim(),
      'birthDate': _birthDate.text,
      'gender': _selectedGender,
      'phone': phone.text.trim(),
      'academicLevel': level,
      'level': level,
      'stemSchool': level == 'STEM' ? stemSchool : '',
      'prepSchool': level == 'Prep School' ? prepSchool.text.trim() : null,
      'thanawySchool': level == 'Thanawy' ? thanawySchool.text.trim() : null,
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
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(payload, SetOptions(merge: true));
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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: TFColors.accent,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Future<void> _handleGoogleRegister() async {
    setState(() => isLoading = true);
    try {
      final provider = GoogleAuthProvider()
        ..addScope('email')
        ..addScope('profile');
      UserCredential cred;
      if (kIsWeb) {
        try {
          cred = await FirebaseAuth.instance.signInWithPopup(provider);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'popup-blocked' ||
              e.code == 'operation-not-supported-in-this-environment') {
            await FirebaseAuth.instance.signInWithRedirect(provider);
            return;
          }
          if (e.code == 'popup-closed-by-user' ||
              e.code == 'cancelled-popup-request') {
            return;
          }
          rethrow;
        }
      } else {
        cred = await FirebaseAuth.instance.signInWithProvider(provider);
      }
      final user = cred.user;
      if (user != null) {
        SavedAccountsStore.saveFromUser(user);
        final fullName =
            (user.displayName ?? user.email?.split('@').first ?? 'Scholar')
                .trim();
        final parts =
            fullName.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'id': user.uid,
          'uid': user.uid,
          'firstName': parts.isNotEmpty ? parts.first : fullName,
          'lastName': parts.length > 1 ? parts.sublist(1).join(' ') : '',
          'fullName': fullName,
          'username': fullName,
          'email': user.email ?? '',
          'profilePicture': user.photoURL ?? '',
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('homePage');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showCostumDialog(
        context: context,
        title: 'Google Sign-Up Error',
        content: e.message ?? 'Could not sign up with Google.',
        onConfirm: () => Navigator.pop(context),
      );
    } catch (e) {
      if (!mounted) return;
      showCostumDialog(
        context: context,
        title: 'Google Sign-Up Error',
        content: e.toString(),
        onConfirm: () => Navigator.pop(context),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.of(context).size.width < 520;
    return Scaffold(
      backgroundColor: TFColors.canvas,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: narrow ? 14 : 20,
                  vertical: narrow ? 16 : 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      narrow ? 18 : 28,
                      narrow ? 20 : 28,
                      narrow ? 18 : 28,
                      narrow ? 24 : 32,
                    ),
                    decoration: BoxDecoration(
                      color: TFColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: TFColors.border),
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                } else {
                                  Navigator.of(context)
                                      .pushReplacementNamed('homePage');
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                foregroundColor: TFColors.muted,
                              ),
                              icon: const Icon(Icons.arrow_back_rounded, size: 16),
                              label: const Text(
                                'Home',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Create your TF Passport',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: TFColors.ink,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'One unified identity across TF Unions, TF News, STEM Union, and STEM Shop.',
                            style: TextStyle(
                              fontSize: 14.5,
                              color: TFColors.muted,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 46,
                            child: OutlinedButton.icon(
                              onPressed: isLoading ? null : _handleGoogleRegister,
                              style: OutlinedButton.styleFrom(
                                backgroundColor: TFColors.surface,
                                foregroundColor: TFColors.ink,
                                side: const BorderSide(color: TFColors.border),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(
                                Icons.g_mobiledata_rounded,
                                size: 26,
                                color: TFColors.accent,
                              ),
                              label: const Text(
                                'Continue with Google',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () => Navigator.of(
                                context,
                              ).pushReplacementNamed('login'),
                              child: const Text(
                                'Already have an account? Sign in',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: TFColors.accent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      _sectionHeader('Personal Info'),
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
                            filled: true,
                            fillColor: TFColors.tile,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      _sectionHeader('Academic Info'),
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
                      _sectionHeader('Account Credentials'),
                      buildMailField(
                        controller: email,
                        label: 'Personal Email',
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          obscureText: _obscurePassword,
                          controller: password,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            filled: true,
                            fillColor: TFColors.tile,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
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
                          ),
                          validator: (v) {
                            if (v == null || v.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TFColors.accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ),
          if (isLoading)
            Container(
              color: Colors.white70,
              child: const Center(
                child: CircularProgressIndicator(color: TFColors.accent),
              ),
            ),
        ],
      ),
      ),
    );
  }
}
