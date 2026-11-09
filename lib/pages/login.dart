import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/utils/tf_api.dart';
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
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;
    setState(() => isLoading = true);
    try {
      // 1. Try VPS SSO API first
      try {
        final res = await http
            .post(
              Uri.parse('$kTfApiBaseUrl/auth/login'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'email': email.text.trim(),
                'password': password.text,
              }),
            )
            .timeout(const Duration(seconds: 8));
        if (res.statusCode == 200) {
          if (!mounted) return;
          Navigator.of(context).pushReplacementNamed('homePage');
          return;
        }
      } catch (_) {}

      // 2. Fallback to Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('homePage');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: TFColors.ink,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Sign in with your TF Passport.',
                        style: TextStyle(fontSize: 15, color: TFColors.muted),
                      ),
                      const SizedBox(height: 24),
                      buildMailField(
                        controller: email,
                        label: 'Email',
                      ),
                      buildTextField(
                        controller: password,
                        label: 'Password',
                        obscureText: true,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed('forget_password'),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontSize: 13,
                              color: TFColors.accent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TFColors.accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isLoading ? null : _handleLogin,
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed('register'),
                        child: const Text(
                          'Create a TF account',
                          style: TextStyle(
                            fontSize: 13,
                            color: TFColors.accent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
