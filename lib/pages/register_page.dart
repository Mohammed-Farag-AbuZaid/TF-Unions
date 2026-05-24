import 'package:ez_email_field/ez_email_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:tf_union/constants/tfcolors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int currentStep = 0;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final TextEditingController _birthDate =TextEditingController();
  final phone = TextEditingController();
  final personalEmail = TextEditingController();
  final mobileCode = TextEditingController();
  final mailCode = TextEditingController();
  final prepSchool = TextEditingController();
  final thanawySchool = TextEditingController();
  final university = TextEditingController();
  final eduEmail = TextEditingController();
  final eduMailCode = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  String? stemSchool ;
  String? _selectedValue;
  String? _selectedGrade;
  String? _selectedYear;

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }){
    return Padding(padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)
            ),
            focusedBorder: OutlineInputBorder(
             borderSide: BorderSide( color: Colors.blue)
            ),
      ),
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
    )
    );
  }

 Widget buildDropdown<T>({
  required String label,
  required T? value,
  required List<T> items,
  required void Function(T?) onChanged,
  String? Function(T?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      value: value,
      items: items
          .map((option) => DropdownMenuItem<T>(
                value: option,
                child: Text(option.toString()),
              ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    ),
  );
}

  @override
  void disposal(){
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    _birthDate.dispose();
    phone.dispose();
    personalEmail.dispose();
    mobileCode.dispose();
    mailCode.dispose();
    prepSchool.dispose();
    thanawySchool.dispose();
    university.dispose();
    password.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stepper(
        type: StepperType.horizontal,
        steps: [
          Step(
            isActive: currentStep >= 0,
            title: Text('Account'),
            content: Container(
              child: Column(children: [
                buildTextField(controller: firstName, label: 'First Name'),
                buildTextField(controller: lastName, label: "Last Name"),
                buildTextField(controller: _birthDate, label: "Birth Date",
                readOnly: true,
                onTap: (){
                      _selectDate();
                    } ,
                    ),
                 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntlPhoneField(
                    controller: phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide( color: Colors.blue)
                        ),
                    ),
                    initialCountryCode: 'EG',
                    
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EZEmailField(
                    controller: personalEmail,
                    decoration: InputDecoration(
                        labelText: 'Personal Email',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide( color: Colors.blue)
                          ),
                      ),
                    
                  ),
                ),
                buildDropdown(label: 'Academic Level', value: _selectedValue, items: ['Prep School','Thanawy','STEM','University'], onChanged: (value) => setState(() => _selectedValue = value),
                validator: (value) => value == null ? 'please select an option' : null),
              ],)
            ),
          ),
          Step(
            isActive: currentStep >= 1,
            title: Text('Verification'),
            content: Container(
              child: Column(
                children: [
                  Text('You have resived 2 different codes in both your Mobile number and your personal Email', style: TextStyle(color: Colors.blue),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: mobileCode,
                      decoration: InputDecoration(
                            labelText: 'Mobile Verification Code',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide( color: Colors.blue)
                              ),
                        ),
                    
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: mailCode,
                      decoration: InputDecoration(
                            labelText: 'Email Verification Code',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide( color: Colors.blue)
                              ),
                        ),
                    
                    ),
                  )

                ],
              ),
            ),
          ),
          Step(
            isActive: currentStep >= 2,
            title: Text('Academic Info'),
            content: Container(
              child: Column(
                children: [
                  if (_selectedValue == 'Prep School')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: prepSchool,
                        decoration: InputDecoration(
                              labelText: 'Offecial School Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide( color: Colors.blue)
                                ),
                          ),
                      ),
                    ),
                  if (_selectedValue == 'Thanawy')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: thanawySchool,
                        decoration: InputDecoration(
                              labelText: 'Offecial School Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide( color: Colors.blue)
                                ),
                          ),
                      ),
                    ),
                  if (_selectedValue =='STEM')
                    buildDropdown(label: 'School', value: stemSchool, items: ['6th of October STEM School for Boys','October STEM School','Maadi STEM School for Girls','New Cairo STEM School','Alexandria STEM School','Dakahlia STEM School','Ismailia STEM High School','Red Sea STEM School','Assiut STEM School','Luxor STEM School','Sers El-Lyan STEM School for Girls','El-Sadat STEM School for Boys','Gharbia STEM School','Obour STEM School','Sharqia STEM School','Qena STEM School','Fayoum STEM School for Boys','Beni Suef STEM School','Minya STEM School for Boys','Sohag STEM School for Girls','Arish STEM School'], 
                    onChanged: (value) => setState(() => _selectedValue = value),
                    validator: (value) => value == null ? 'please select an option' : null),

                  if (_selectedValue != 'University') 
                  buildDropdown(label: 'Grade', value: _selectedGrade, items: ['Grade 7','Grade 8','Grade 9','Grade 10','Grade 11','Grade 12'], 
                  onChanged:(value) => setState(() => _selectedValue = value), ),
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                          labelText: 'Grade',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide( color: Colors.blue)
                            ),
                      ),
                    value: _selectedGrade,
                    items: ['Grade 7','Grade 8','Grade 9','Grade 10','Grade 11','Grade 12']
                      .map((option) => DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGrade = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select and option';
                      }
                      return null ;
                    },
                    ),
                ),
                if (_selectedValue == 'University')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                        controller: university,
                        decoration: InputDecoration(
                              labelText: 'Offecial University Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide( color: Colors.blue)
                                ),
                          ),
                      ),
                ),

                 if (_selectedValue == 'University')
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                          labelText: 'Year',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide( color: Colors.blue)
                            ),
                      ),
                    value: _selectedYear,
                    items: ['1st year','2nd year','3rd year','4th year','5th year','Master','PhD']
                      .map((option) => DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select and option';
                      }
                      return null ;
                    },
                    ),
                ),
                if (_selectedValue =='STEM' || _selectedValue == 'University')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EZEmailField(
                    controller: eduEmail,
                    decoration: InputDecoration(
                        labelText: 'Education Email',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide( color: Colors.blue)
                          ),
                      ),
                    
                  ),
                ),


                ],
              ),
            )
          ),
          
          Step(
            isActive: currentStep >= 3,
            title: Text('verification'),
            content: Container(
              child: Column(
                children: [
                  if (_selectedValue == 'STEM' || _selectedValue == 'University')
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: eduMailCode,
                      decoration: InputDecoration(
                            labelText: 'Email Verification Code',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide( color: Colors.blue)
                              ),
                        ),
                    
                    ),
                  )
                else
                Text("you're all Done")

                ],
              ),
            ),
          ),
          Step(
            isActive: currentStep >= 4,
            title: Text('Complete'),
            content: Container(
              child: Column(
                children: [
                  Text('create your username and password', style: TextStyle(color: Colors.blue),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: username,
                      decoration: InputDecoration(
                            labelText: 'username',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide( color: Colors.blue)
                              ),
                        ),
                    
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: password,
                      decoration: InputDecoration(
                            labelText: 'Password',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide( color: Colors.blue)
                              ),
                        ),
                    
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
        currentStep: currentStep,
        onStepContinue: (){
          
          final isLastStep = currentStep == 4;
          if (isLastStep) {
            print('completed');
          }
          setState(() => currentStep += 1);
        },
        onStepCancel: (){
          currentStep == 0 ? null : setState(() => currentStep -= 1);
        },
      ),
    ); 
  }
  Future<void> _selectDate() async{
    DateTime? _picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2014),
      initialDate: DateTime(2009),

    );
    if (_picked != null){
      setState(() {
        _birthDate.text = _picked.toString().split(" ")[0];
      });
    }
  }
}