import 'package:flutter/material.dart';
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
  final birthDate = TextEditingController();
  final email = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stepper(
        type: StepperType.horizontal,
        steps: [
          Step(
            isActive: currentStep == 0,
            title: Text('Account'),
            content: Container(
              child: Column(children: [
                TextFormField(
                  controller: firstName,
                  decoration: InputDecoration(labelText: 'First Name'),
                ),
                TextFormField(
                  controller: lastName,
                  decoration: InputDecoration(labelText: 'Last Name'),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Birth Date',
                    prefixIcon: Icon(Icons.calendar_today)
                  ),)
              ],)
            ),
          ),
          Step(
            isActive: currentStep >= 1,
            title: Text('Academic Info'),
            content: Container(),
          ),
          Step(
            isActive: currentStep >= 2,
            title: Text('Complete'),
            content: Container(),
          ),
        ],
        currentStep: currentStep,
        onStepContinue: (){
          print(firstName);
          final isLastStep = currentStep == 2;
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
}