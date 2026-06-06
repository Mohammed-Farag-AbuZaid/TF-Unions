import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/costum_dialog.dart';
import 'package:tf_union/widgets/fields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                const Spacer(),
                Center(
                  child: Image.asset(
                    'assets/BlackLogo.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                const Center(
                  child: Text(
                    'Welcome Back !',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                        key: _loginFormKey,
                        child: Column(
                          children: [
                            buildMailField(controller: email, label: 'Email'),
                            buildTextField(
                              controller: password,
                              label: 'Password',
                              obscureText: true,
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('forget_password');
                                },
                                child: const Text(
                                  'Forgot Password ?',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            MaterialButton(
                              height: 50,
                              minWidth: 100,
                              color: TFColors.yellowPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () async {
                                if (!(_loginFormKey.currentState?.validate() ??
                                    false)) {
                                  return;
                                }

                                setState(() => isLoading = true);

                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                        email: email.text.trim(),
                                        password: password.text,
                                      );

                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('homePage');
                                } on FirebaseAuthException catch (e) {
                                  showCostumDialog(
                                    context: context,
                                    title: 'Error',
                                    content: e.message ?? 'Login failed',
                                    onConfirm: () => Navigator.pop(context),
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() => isLoading = false);
                                  }
                                }
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Text(
                  '--------------- or login with ----------------',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signInWithPopup(
                        GoogleAuthProvider(),
                      );
                      Navigator.of(context).pushReplacementNamed('homePage');
                    },
                    child: const Text('Login with Google'),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('register');
                  },
                  child: const Text(
                    'Don\'t have an account ? Register',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
                const Spacer(),
                const Spacer(),
                const Spacer(),
              ],
            ),
            if (isLoading)
              Dialog(
                backgroundColor: Colors.black.withAlpha(10),
                child: Center(
                  child: CircularProgressIndicator(
                    color: TFColors.yellowPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
