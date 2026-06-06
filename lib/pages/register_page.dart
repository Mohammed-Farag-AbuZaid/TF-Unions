import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/fields.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/widgets/costum_dialog.dart';
import 'dart:js' as js;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int currentStep = 0;
  final _accountFormKey = GlobalKey<FormState>();
  final _academicFormKey = GlobalKey<FormState>();
  final _userInfoFormKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final TextEditingController _birthDate = TextEditingController();
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
  String? usernameError;
  bool checkingUsername = false;
  bool usernameAvailable = false;
  bool isLoading = false;

  Future<void> _verifyEmail() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );
      await userCredential.user!.sendEmailVerification();
      setState(() {
        isLoading = false;
      });
      showCostumDialog(
        context: context,
        title: 'Verification Email Sent',
        content:
            'Please check your inbox and click the link to verify your email \nand come back to Register.',
        confirmText: 'Check Email',
        onConfirm: () {
          js.context.callMethod('open', ['https://mail.google.com']);
        },
      );
      setState(() => currentStep += 1); // move to next step
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      showCostumDialog(
        context: context,
        title: 'Error',
        content: e.message ?? 'Error',
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  Future<void> checkUsername(String value) async {
    if (value.isEmpty) return;

    setState(() {
      checkingUsername = true;
      usernameAvailable = false;
    });

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: value)
        .get();

    setState(() {
      checkingUsername = false;

      if (querySnapshot.docs.isNotEmpty) {
        usernameError = 'Username already taken';
        usernameAvailable = false;
      } else {
        usernameError = null;
        usernameAvailable = true;
      }
    });
  }

  Future<bool> isEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;

    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    return user?.emailVerified ?? false;
  }

  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
    });
    final isVerified = await isEmailVerified();

    if (!isVerified) {
      showCostumDialog(
        context: context,
        title: 'Email Not Verified',
        content: 'Please verify your email first.',
        confirmText: 'Verify',
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      String level = _selectedValue!;

      // Create comprehensive user document
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        if (level == 'STEM') 'stemSchool': stemSchool,
        if (level == 'Thanawy') 'thanawySchool': thanawySchool.text,
        if (level == 'Prep School') 'prepSchool': prepSchool.text,
        if (level == 'University') 'university': university.text,
        if (level == 'University') 'faculty': faculty.text,
        if (level != 'University') 'grade': _selectedGrade,
        if (level == 'University') 'year': _selectedYear,
        'firstName': firstName.text,
        'lastName': lastName.text,
        'email': user.email,
        'phone': phone.text,
        'gender': _selectedGender,
        'birthDate': _birthDate.text,
        'username': username.text,
        'academicLevel': level,
        'registrationDate': Timestamp.now(),
      });

      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      setState(() => currentStep += 1);
    } catch (e) {
      debugPrint('Registration error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 90,
        title: Center(
          child: SizedBox(
            width: 250,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 30),
              child: Image.asset('assets/BlackLogo.png'),
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1800),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(
                      context,
                    ).colorScheme.copyWith(primary: TFColors.yellowPrimary),
                  ),
                  child: Stepper(
                    type: MediaQuery.of(context).size.width <= minRegisterWidth
                        ? StepperType.vertical
                        : StepperType.horizontal,
                    steps: [
                      Step(
                        isActive: currentStep >= 0,
                        title: Text(
                          'Welcome',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Center(
                          child: Card(
                            elevation: 30,
                            margin: const EdgeInsets.only(top: 24, bottom: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              width: 430,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 24,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'A few seconds sparate you from .....\nWe are thrilled to see you here, we promise to do our best',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: TFColors.textfieldbg,
                                      height: 1.5,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(
                                          context,
                                        ).pushReplacementNamed('login');
                                      },
                                      child: Text(
                                        'Have an account ? Login',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Step(
                        isActive: currentStep >= 1,
                        title: Text(
                          'Account',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Center(
                          child: Card(
                            elevation: 30,
                            margin: const EdgeInsets.only(top: 24, bottom: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              width: 430,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 24,
                              ),
                              child: Form(
                                key: _accountFormKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteractionIfError,
                                child: Column(
                                  children: [
                                    buildTextField(
                                      controller: firstName,
                                      label: 'First Name',
                                    ),
                                    buildTextField(
                                      controller: lastName,
                                      label: "Last Name",
                                    ),
                                    buildTextField(
                                      controller: _birthDate,
                                      label: "Birth Date",
                                      readOnly: true,
                                      onTap: () {
                                        _selectDate();
                                      },
                                    ),
                                    buildDropdown(
                                      label: 'Gender',
                                      value: _selectedGender,
                                      items: ['Male', 'Female'],
                                      onChanged: (value) => setState(
                                        () => _selectedGender = value,
                                      ),
                                      validator: (value) => value == null
                                          ? 'please select an option'
                                          : null,
                                    ),
                                    buildDropdown(
                                      label: 'Academic Level',
                                      value: _selectedValue,
                                      items: [
                                        'Prep School',
                                        'Thanawy',
                                        'STEM',
                                        'University',
                                      ],
                                      onChanged: (value) => setState(
                                        () => _selectedValue = value,
                                      ),
                                      validator: (value) => value == null
                                          ? 'please select an option'
                                          : null,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IntlPhoneField(
                                        controller: phone,
                                        decoration: InputDecoration(
                                          labelText: 'Phone Number',
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        initialCountryCode: 'EG',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Step(
                        isActive: currentStep >= 2,
                        title: Text(
                          'Academic Info',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Center(
                          child: Card(
                            elevation: 30,
                            margin: const EdgeInsets.only(top: 24, bottom: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              width: 430,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 24,
                              ),
                              child: Form(
                                key: _academicFormKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteractionIfError,

                                child: Column(
                                  children: [
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
                                      buildDropdown(
                                        label: 'School',
                                        value: stemSchool,
                                        items: [
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
                                        onChanged: (value) =>
                                            setState(() => stemSchool = value),
                                        validator: (value) => value == null
                                            ? 'please select an option'
                                            : null,
                                      ),

                                    if (_selectedValue != 'University')
                                      buildDropdown(
                                        label: 'Grade',
                                        value: _selectedGrade,
                                        items: [
                                          'Grade 7',
                                          'Grade 8',
                                          'Grade 9',
                                          'Grade 10',
                                          'Grade 11',
                                          'Grade 12',
                                        ],
                                        onChanged: (value) => setState(
                                          () => _selectedGrade = value,
                                        ),
                                        validator: (value) => value == null
                                            ? 'please select an option'
                                            : null,
                                      ),

                                    if (_selectedValue == 'University')
                                      buildTextField(
                                        controller: university,
                                        label: 'Official University Name',
                                      ),

                                    if (_selectedValue == 'University')
                                      buildDropdown(
                                        label: 'year',
                                        value: _selectedYear,
                                        items: [
                                          '1st year',
                                          '2nd year',
                                          '3rd year',
                                          '4th year',
                                          '5th year',
                                          'Master',
                                          'PhD',
                                        ],
                                        onChanged: (value) => setState(
                                          () => _selectedYear = value,
                                        ),
                                        validator: (value) => value == null
                                            ? 'please select an option'
                                            : null,
                                      ),

                                    if (_selectedValue == 'University')
                                      buildTextField(
                                        controller: faculty,
                                        label: 'Faculty',
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Step(
                        isActive: currentStep >= 3,
                        title: Text(
                          'Become a user',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Center(
                          child: Card(
                            elevation: 30,
                            margin: const EdgeInsets.only(top: 24, bottom: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              width: 430,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 24,
                              ),
                              child: Form(
                                key: _userInfoFormKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteractionIfError,

                                child: Column(
                                  children: [
                                    buildMailField(
                                      controller: email,
                                      label: 'personal Email',
                                    ),
                                    buildUsernameField(
                                      controller: username,
                                      label: 'username',
                                      errorText: usernameError,
                                      onChanged: checkUsername,
                                      suffixIcon: checkingUsername
                                          ? const Padding(
                                              padding: EdgeInsets.all(12),
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            )
                                          : usernameAvailable
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          : null,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        obscureText: true,
                                        controller: password,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.length < 6) {
                                            return 'Password must be at least 6 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Step(
                        isActive: currentStep >= 4,
                        title: Text(
                          'Complete',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Container(
                          child: Column(
                            children: [
                              Text(
                                'We sent you a verification email.\nPlease check your inbox and click the link brfore clicking the Register button.',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                          return Row(
                            children: <Widget>[
                              if (currentStep == 0)
                                ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  child: const Text('Start'),
                                ),
                              if (currentStep < 4 &&
                                  currentStep != 3 &&
                                  currentStep != 0)
                                ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  child: const Text('Next'),
                                ),
                              if (currentStep == 3)
                                ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  child: const Text('send verification link'),
                                ),

                              if (currentStep == 4)
                                ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  child: const Text('Register'),
                                ),
                              if (currentStep > 0 && currentStep < 5)
                                TextButton(
                                  onPressed: details.onStepCancel,
                                  child: const Text('Previous'),
                                ),
                            ],
                          );
                        },
                    currentStep: currentStep,
                    onStepContinue: () async {
                      if (currentStep == 0) {
                        setState(() => currentStep += 1);
                      } else if (currentStep == 1) {
                        if (_accountFormKey.currentState?.validate() ?? false) {
                          setState(() => currentStep += 1);
                        }
                      } else if (currentStep == 2) {
                        if (_academicFormKey.currentState?.validate() ??
                            false) {
                          setState(() => currentStep += 1);
                        }
                      } else if (currentStep == 3) {
                        if (usernameError != null || !usernameAvailable) {
                          return;
                        }
                        if (_userInfoFormKey.currentState?.validate() ??
                            false) {
                          await _verifyEmail();
                        }
                      } else if (currentStep == 4) {
                        bool verified = await isEmailVerified();

                        if (verified) {
                          await registerUser();
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('homePage');
                        } else {
                          showCostumDialog(
                            context: context,
                            title: 'Email Not Verified',
                            content: 'Please verify your email first.',
                            confirmText: 'Verify',
                            onConfirm: () {
                              js.context.callMethod('open', [
                                'https://mail.google.com',
                              ]);
                            },
                          );
                          return;
                        }
                      }
                    },
                    onStepCancel: () {
                      if (currentStep != 0) {
                        setState(() => currentStep -= 1);
                      } else {
                        currentStep == 0
                            ? null
                            : setState(() => currentStep -= 1);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Dialog(
              backgroundColor: Colors.black.withAlpha(10),
              child: Center(
                child: CircularProgressIndicator(color: TFColors.yellowPrimary),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2014),
      initialDate: DateTime(2009),
    );
    if (picked != null) {
      setState(() {
        _birthDate.text = picked.toString().split(" ")[0];
      });
    }
  }
}
