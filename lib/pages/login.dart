import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/fields.dart';
import 'package:flutter_social_button/flutter_social_button.dart';


class Login extends StatefulWidget {
  const Login ({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
        
          children: [
            Spacer(),
            Center(child:  Image.asset('assets/BlackLogo.png', width: 200, height: 200,)),
            Center(
              child: Text('Welcome Back !', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),
            ),
            Center(
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
                    key: _loginFormKey,              
                    child: Column(
                      children: [
                        buildUsernameField(controller: username,label: 'Username'),
                        buildTextField(controller: password,label:'password'),
                          Container(
                            alignment: Alignment.topRight,
                          child: Text('Forgot Password ?',style: TextStyle(fontSize: 12, color: Colors.blue),),

                      ),
                      MaterialButton(
                        height: 50,
                        minWidth: 100,
                        color: TFColors.yellowPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        onPressed: () {
                        },
                        child: Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold ),)
                      )
                      ],
                      
                      
                    ),
                  )
                      )
                    )
              ),
              Text("--------------- or login with ----------------", style: TextStyle(fontSize: 12, color: Colors.grey),),
              SizedBox(
                width: 400,
                child: FlutterSocialButton(
                  onTap: (){},
                  buttonType: ButtonType.google,
                  
                ),
              ),
              Text('Don\'t have an account ? Register', style: TextStyle(fontSize: 12, color: Colors.blue),),
            
              Spacer(),
              Spacer(),
              Spacer(),
          ],
        ),
      ),
    );
  }
}