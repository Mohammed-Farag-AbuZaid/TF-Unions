import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/fields.dart';

class EditProfileSheet extends StatefulWidget {
  final Map<String, dynamic> data;
  const EditProfileSheet({super.key, required this.data});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  late final TextEditingController firstName;
  late final TextEditingController lastName;
  late final TextEditingController phone;
  late final TextEditingController prepSchool;
  late final TextEditingController thanawySchool;
  late final TextEditingController university;
  late final TextEditingController faculty;
  late final TextEditingController birthDate;

  String? _selectedGender;
  String? _selectedValue;
  String? _selectedGrade;
  String? _selectedYear;
  String? stemSchool;

  @override
  void initState() {
    super.initState();
    final d = widget.data;
    firstName = TextEditingController(text: d['firstName'] ?? '');
    lastName = TextEditingController(text: d['lastName'] ?? '');
    phone = TextEditingController(text: d['phone'] ?? '');
    prepSchool = TextEditingController(text: d['prepSchool'] ?? '');
    thanawySchool = TextEditingController(text: d['thanawySchool'] ?? '');
    university = TextEditingController(text: d['university'] ?? '');
    faculty = TextEditingController(text: d['faculty'] ?? '');
    birthDate = TextEditingController(text: d['birthDate'] ?? '');

    _selectedGender = d['gender'];
    _selectedValue = d['academicLevel'];
    _selectedGrade = d['grade'];
    _selectedYear = d['year'];
    stemSchool = d['stemSchool'];
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    phone.dispose();
    prepSchool.dispose();
    thanawySchool.dispose();
    university.dispose();
    faculty.dispose();
    birthDate.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final level = _selectedValue!;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'phone': phone.text.trim(),
        'gender': _selectedGender,
        'birthDate': birthDate.text,
        'academicLevel': level,
        'prepSchool': level == 'Prep School' ? prepSchool.text.trim() : null,
        'thanawySchool': level == 'Thanawy' ? thanawySchool.text.trim() : null,
        'stemSchool': level == 'STEM' ? stemSchool : null,
        'university': level == 'University' ? university.text.trim() : null,
        'faculty': level == 'University' ? faculty.text.trim() : null,
        'grade': level != 'University' ? _selectedGrade : null,
        'year': level == 'University' ? _selectedYear : null,
      });

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated!')));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2014),
      initialDate: DateTime.tryParse(birthDate.text) ?? DateTime(2009),
    );
    if (picked != null) {
      setState(() {
        birthDate.text = picked.toString().split(' ')[0];
      });
    }
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 4),
      child: Row(
        children: [
          Icon(icon, color: TFColors.yellowPrimary, size: 16),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.robotoSlab(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: TFColors.yellowPrimary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              color: TFColors.yellowPrimary.withAlpha(50),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: 1,
        expand: false,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteractionIfError,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Text(
                  'Edit Profile',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoSlab(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TFColors.whitePrimary,
                  ),
                ),

                // ── Personal ──────────────────────────────────────────
                _sectionHeader('Personal Info', Icons.person_outline),
                buildTextField(controller: firstName, label: 'First Name'),
                buildTextField(controller: lastName, label: 'Last Name'),
                buildTextField(
                  controller: birthDate,
                  label: 'Birth Date',
                  readOnly: true,
                  onTap: _selectDate,
                ),
                buildDropdown<String>(
                  label: 'Gender',
                  value: _selectedGender,
                  items: const ['Male', 'Female'],
                  onChanged: (v) => setState(() => _selectedGender = v),
                  validator: (v) => v == null ? 'Please select a gender' : null,
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

                // ── Academic ──────────────────────────────────────────
                _sectionHeader('Academic Info', Icons.school_outlined),
                buildDropdown<String>(
                  label: 'Academic Level',
                  value: _selectedValue,
                  items: const ['Prep School', 'Thanawy', 'STEM', 'University'],
                  onChanged: (v) => setState(() {
                    _selectedValue = v;
                    _selectedGrade = null;
                    _selectedYear = null;
                    stemSchool = null;
                  }),
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
                if (_selectedValue != null && _selectedValue != 'University')
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

                // ── Save button ────────────────────────────────────────
                const SizedBox(height: 28),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TFColors.yellowPrimary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
