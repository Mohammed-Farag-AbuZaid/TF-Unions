import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/fields.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});
  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPasswordPage> {
  final _forgetPasswordFormKey = GlobalKey<FormState>();
  final email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Container(
        child: Column(
          children: [
            Spacer(),
            Center(
              child: Image.asset(
                'assets/BlackLogo.png',
                width: 200,
                height: 200,
              ),
            ),
            Center(
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
                    key: _forgetPasswordFormKey,
                    child: Column(
                      children: [
                        buildMailField(
                          controller: email,
                          label: 'Email',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: MaterialButton(
                            height: 50,
                            minWidth: 150,
                            color: TFColors.bglight1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Send Reset Link',
                              style: TextStyle(
                                fontSize: 16,
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
            ),
            

            Spacer(),
            Spacer(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
