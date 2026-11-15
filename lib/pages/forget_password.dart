import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/costum_dialog.dart';
import 'package:tf_union/widgets/fields.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});
  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPasswordPage> {
  final _forgetPasswordFormKey = GlobalKey<FormState>();
  final email = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!(_forgetPasswordFormKey.currentState?.validate() ?? false)) return;
    setState(() => _sending = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.text.trim(),
      );
      if (!mounted) return;
      showCostumDialog(
        context: context,
        title: 'Reset Link Sent',
        content:
            'A password reset link has been sent to ${email.text.trim()}. Please check your inbox or spam folder.',
        confirmText: 'Back to Sign In',
        onConfirm: () {
          Navigator.pop(context);
          Navigator.of(context).pushReplacementNamed('login');
        },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showCostumDialog(
        context: context,
        title: 'Error',
        content: e.message ?? 'Could not send reset email.',
        onConfirm: () => Navigator.pop(context),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TFColors.canvas,
      appBar: AppBar(
        backgroundColor: TFColors.canvas,
        elevation: 0,
        iconTheme: const IconThemeData(color: TFColors.ink),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              padding: const EdgeInsets.fromLTRB(28, 30, 28, 30),
              decoration: BoxDecoration(
                color: TFColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: TFColors.border),
              ),
              child: Form(
                key: _forgetPasswordFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Reset your password',
                      style: TextStyle(
                        fontFamily: 'Bricolage Grotesque',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: TFColors.ink,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Enter your email to receive a Firebase password reset link.',
                      style: TextStyle(fontSize: 14, color: TFColors.muted),
                    ),
                    const SizedBox(height: 20),
                    buildMailField(controller: email, label: 'Email'),
                    const SizedBox(height: 16),
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
                        onPressed: _sending ? null : _sendResetLink,
                        child: _sending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Send Reset Link',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed('login'),
                      child: const Text(
                        'Back to Sign In',
                        style: TextStyle(
                          fontSize: 13.5,
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
      ),
    );
  }
}
