import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/utils/tf_api.dart';
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
      final selectedSchool = _selectedValue == 'Prep School'
          ? prepSchool.text.trim()
          : _selectedValue == 'Thanawy'
              ? thanawySchool.text.trim()
              : _selectedValue == 'STEM'
                  ? (stemSchool ?? 'General / Alumni')
                  : (university.text.trim().isNotEmpty
                      ? university.text.trim()
                      : 'General / Alumni');

      // 1. Register on VPS SSO API
      try {
        await http
            .post(
              Uri.parse('$kTfApiBaseUrl/auth/register'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'email': email.text.trim(),
                'password': password.text,
                'full_name':
                    '${firstName.text.trim()} ${lastName.text.trim()}'.trim(),
                'school_chapter': selectedSchool,
              }),
            )
            .timeout(const Duration(seconds: 8));
      } catch (_) {}

      // 2. Also create in Firebase Auth for dual compatibility
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
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

      await _saveUserData();
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

    final payload = {
      'uid': user.uid,
      'firstName': firstName.text.trim(),
      'lastName': lastName.text.trim(),
      'email': email.text.trim(),
      'birthDate': _birthDate.text,
      'gender': _selectedGender,
      'phone': phone.text.trim(),
      'academicLevel': level,
      'level': level,
      'stemSchool': level == 'STEM' ? stemSchool : '',
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
    };

    await TfApiService.saveDoc('users', user.uid, {
      ...payload,
      'createdAt': FieldValue.serverTimestamp(),
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: TFColors.ink),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Create your TF Passport',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: TFColors.ink,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'One unified identity across TF Unions, TF News, STEM Union, and STEM Shop.',
                        style: TextStyle(
                          fontSize: 15,
                          color: TFColors.muted,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 40),
                    ],
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
    );
  }
}
