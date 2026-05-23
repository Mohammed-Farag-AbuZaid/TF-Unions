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
  String? _selectedValue;

  @override
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: firstName,
                    decoration: InputDecoration(
                      labelText: 'First Name',
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
                    controller: lastName,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
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
                  child: TextField(
                    controller: _birthDate,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Birth Date',
                      prefixIcon: Icon(Icons.calendar_today),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide( color: Colors.blue)
                      ),
                    ),
                    onTap: (){
                      _selectDate();
                    } ,
                    ),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                          labelText: 'Academic Level',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide( color: Colors.blue)
                            ),
                      ),
                    value: _selectedValue,
                    items: ['Prep School','Thanawy','STEM','University']
                      .map((option) =>DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select and option';
                      }
                      return null ;
                    },
                    ),
                )
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
                    TextFormField()

                ],
              ),
            )
          ),
          
          Step(
            isActive: currentStep >= 3,
            title: Text('verification'),
            content: Container(),
          ),
          Step(
            isActive: currentStep >= 4,
            title: Text('Complete'),
            content: Container(),
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