import 'package:ez_email_field/ez_email_field.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter/services.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/fields.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int currentStep = 0;
  final _accountFormKey = GlobalKey<FormState>();
  final _firstVerificationFormKey = GlobalKey<FormState>();
  final _academicFormKey = GlobalKey<FormState>();
  final _secondVerificationFormKey =GlobalKey<FormState>();
  final _userInfoFormKey = GlobalKey<FormState>();
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
  final FancyPasswordController password = FancyPasswordController();
  final passwordVerify = TextEditingController();
  String? stemSchool ;
  String? _selectedValue;
  String? _selectedGrade;
  String? _selectedYear;



  @override
  void dispose(){
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar( 
        title: Center(
          child: SizedBox(
            width: 150,
            child: Image.asset('assets/BlackLogo.png')),
        ),
          backgroundColor: Colors.black,
      ),
      body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1800),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: TFColors.yellowPrimary
                  )
                ),
              child: Stepper(
                type: StepperType.vertical,
                steps: [
                  Step(
                    isActive: currentStep >= 0,
                    title: Text('Welcome', style: TextStyle(fontWeight: FontWeight.bold),),
                    content:Center(
                    child: Card(
                      elevation: 30,
                      margin: const EdgeInsets.only(top: 24, bottom: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Container(
                        width: 430,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    children: [Text('A few seconds sparate you from .....\nWe are thrilled to see you here, we promise to do our best', textAlign: TextAlign.center, style: TextStyle(color: TFColors.textfieldbg, height: 1.5, fontSize: 16, fontWeight: FontWeight.w500),),
                        Container(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).pushReplacementNamed('login');
                            },
                            child: Text('Have an account ? Login', style: TextStyle(fontSize: 12, color: Colors.blue),)),
                        ),
                      ],
                  ),
                      )
                    )
                  )
                  ),
                  Step(
                    isActive: currentStep >= 1,
                    title: Text('Account', style: TextStyle(fontWeight: FontWeight.bold),),
                    content: Center(
                      child: Card(

                      elevation: 30,
                      margin: const EdgeInsets.only(top: 24, bottom: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Container(
                        width: 430,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        child: Form(
                          key: _accountFormKey,
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
                            buildMailField(controller: personalEmail, label: 'personal Email'),
                            
                            buildDropdown(label: 'Academic Level', value: _selectedValue, items: ['Prep School','Thanawy','STEM','University'], onChanged: (value) => setState(() => _selectedValue = value),
                            validator: (value) => value == null ? 'please select an option' : null),
                          ],)
                        ),
                      ),
                    ),
                  ),
                ),
                Step(
                  isActive: currentStep >= 2,
                  title: Text('Verification' , style: TextStyle(fontWeight: FontWeight.bold),),
                  content: Center(
                    child: Card(
                      elevation: 30,
                      margin: const EdgeInsets.only(top: 24, bottom: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Container(
                        width: 430,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Form(
                    key: _firstVerificationFormKey,              
                    child: Column(
                      children: [                        
                        buildVerificationFeild(controller: mobileCode, label: 'Mobile Verification Code'),
                        buildVerificationFeild(controller: mailCode, label: 'Email Verification Code')
                      ],
                    ),
                  ),
                      )
                    )
                  )
                ),
                Step(
                  isActive: currentStep >= 3,
                  title: Text('Academic Info', style: TextStyle(fontWeight: FontWeight.bold),),
                  content: Center(
                    child: Card(
                      elevation: 30,
                      margin: const EdgeInsets.only(top: 24, bottom: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Container(
                        width: 430,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Form(
                    key: _academicFormKey,              
                    child: Column(
                      children: [
                        if (_selectedValue == 'Prep School')
                        buildTextField(controller: prepSchool, label: 'Official School Name'),
                          
                        if (_selectedValue == 'Thanawy')
                        buildTextField(controller: thanawySchool, label: 'Official School Name'),
                            
                        if (_selectedValue =='STEM')
                          buildDropdown(label: 'School', value: stemSchool, items: ['6th of October STEM School for Boys','October STEM School','Maadi STEM School for Girls','New Cairo STEM School','Alexandria STEM School','Dakahlia STEM School','Ismailia STEM High School','Red Sea STEM School','Assiut STEM School','Luxor STEM School','Sers El-Lyan STEM School for Girls','El-Sadat STEM School for Boys','Gharbia STEM School','Obour STEM School','Sharqia STEM School','Qena STEM School','Fayoum STEM School for Boys','Beni Suef STEM School','Minya STEM School for Boys','Sohag STEM School for Girls','Arish STEM School'], 
                          onChanged: (value) => setState(() => stemSchool = value),
                          validator: (value) => value == null ? 'please select an option' : null),
                            
                        if (_selectedValue != 'University') 
                        buildDropdown(label: 'Grade', value: _selectedGrade, items: ['Grade 7','Grade 8','Grade 9','Grade 10','Grade 11','Grade 12'], 
                        onChanged:(value) => setState(() => _selectedGrade = value),
                        validator: (value) => value == null ? 'please select an option' : null ),
                        
                        
                      if (_selectedValue == 'University')
                      buildTextField(controller: university, label: 'Official University Name'),
                      
                            
                      if (_selectedValue == 'University')
                      buildDropdown(label: 'year', value: _selectedYear, items: ['1st year','2nd year','3rd year','4th year','5th year','Master','PhD'], 
                      onChanged: (value) => setState(() => _selectedYear = value), ),
                        
                      if (_selectedValue =='STEM' || _selectedValue == 'University')
                      buildMailField(controller: eduEmail, label: 'Education Email')
                            
                            
                      ],
                    ),
                  )
                      )
                    )
                  )
                ),
                
                Step(
                  isActive: currentStep >= 4,
                  title: Text('verification' , style: TextStyle(fontWeight: FontWeight.bold),),
                  content: Center(
                    child: Card(

                      elevation: 30,
                      margin: const EdgeInsets.only(top: 24, bottom: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Container(
                        width: 430,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        child:  Form(
                    key: _secondVerificationFormKey,              
                    child: Column(
                      children: [
                        buildVerificationFeild(controller: eduMailCode, label: 'Email Verification Code')
                            
                      ],
                    ),
                        )
                      )
                    )
                  ),
                ),
                Step(
                  isActive: currentStep >= 5,
                  title: Text('Become a user' , style: TextStyle(fontWeight: FontWeight.bold),),
                  content: Center(
                    child: Card(

                      elevation: 30,
                      margin: const EdgeInsets.only(top: 24, bottom: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Container(
                        width: 430,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        child:  Form(
                    key: _userInfoFormKey,              
                    child: Column(
                      children: [
                        buildUsernameField(controller: username, label: 'username', ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FancyPasswordField (
                            passwordController: password,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide( color: Colors.blue)
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.length < 6 ){
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                        )
                      )
                    )
                  ),
                ),
                Step(
                  isActive: currentStep >= 6,
                  title: Text('Complete', style: TextStyle(fontWeight: FontWeight.bold),),
                  content: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 30,),
                        Text('Welcome!\nNow you are a TF user\nyou can access all TF-Unions serveces via this account', textAlign: TextAlign.center ,style: TextStyle(color: TFColors.textfieldbg, height: 1.5, fontSize: 16, fontWeight: FontWeight.w500 ),),
                        SizedBox(height: 30,),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              )
                            ),
                            onPressed: (){}, 
                            child: Text('Back to your Dashboard')))
                      ],
                    ),
                  )
                  )
              ],
              controlsBuilder: (BuildContext context, ControlsDetails details){
                return Row(
                  children: <Widget>[
                    if (currentStep == 0)
                      ElevatedButton(onPressed: details.onStepContinue, child: const Text('Start')),
                    if (currentStep <5 && currentStep != 2 && currentStep != 0)
                      ElevatedButton(onPressed: details.onStepContinue, child: const Text('Next')),
                    if(currentStep == 2)
                      ElevatedButton(onPressed: details.onStepContinue, child: const Text('Verify')),
                    
                    if (currentStep == 5)
                      ElevatedButton(onPressed: details.onStepContinue, child: const Text('Register')),
                    if (currentStep > 0 && currentStep < 6)
                      TextButton(onPressed: details.onStepCancel, child: const Text('Previous'))
                  ],
                );
              },
              currentStep: currentStep,
              onStepContinue: () {
                if (currentStep == 0){
                  setState(() => currentStep += 1);
                }
                if (currentStep == 1) {
                  if (_accountFormKey.currentState?.validate() ?? false) {
                    setState(() => currentStep += 1);}
                } else if (currentStep == 2){
                  if (_firstVerificationFormKey.currentState?.validate() ?? false){
                    setState(() => currentStep += 1);}
                } else if (currentStep == 3){
                  if (_academicFormKey.currentState?.validate() ?? false){
                    if (!(_selectedValue == 'STEM' || _selectedValue == 'University')){
                      setState(() => currentStep +=2);
                    } else{
                    setState(() => currentStep += 1);}}
                } else if (currentStep == 4){
                  if (_secondVerificationFormKey.currentState?.validate() ?? false){
                    setState(() => currentStep += 1);}
                } else if (currentStep == 5){
                  if (_userInfoFormKey.currentState?.validate() ?? false){
                    setState(() => currentStep += 1);}
                }
                            
              },
              onStepCancel: (){
                if (currentStep == 4){
                  if (!(_selectedValue == "STEM" || _selectedValue == 'University')){
                    setState(() => currentStep -= 2);}
                  else {
                    setState(() => currentStep -= 1);
                  }
                  
                }
                else{
                currentStep == 0 ? null : setState(() => currentStep -= 1);
                }
              },
                            ),
                            )
            )
          
            
          ),
        ),
    ); 
  }
  Future<void> _selectDate() async{
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2014),
      initialDate: DateTime(2009),

    );
    if (picked != null){
      setState(() {
        _birthDate.text = picked.toString().split(" ")[0];
      });
    }
  }
}