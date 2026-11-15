import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  bool _obscurePassword = true;

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
        title: 'Sign-In Error',
        content: e.message ?? 'Invalid email or password.',
        onConfirm: () => Navigator.pop(context),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => isLoading = true);
    try {
      final provider = GoogleAuthProvider()
        ..addScope('email')
        ..addScope('profile');
      final cred = kIsWeb
          ? await FirebaseAuth.instance.signInWithPopup(provider)
          : await FirebaseAuth.instance.signInWithProvider(provider);
      final user = cred.user;
      if (user != null) {
        final fullName =
            (user.displayName ?? user.email?.split('@').first ?? 'Scholar')
                .trim();
        final parts = fullName.split(RegExp(r'\s+'));
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'firstName': parts.isNotEmpty ? parts.first : fullName,
          'lastName': parts.length > 1 ? parts.sublist(1).join(' ') : '',
          'fullName': fullName,
          'username': fullName,
          'email': user.email ?? '',
          'profilePicture': user.photoURL ?? '',
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('homePage');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showCostumDialog(
        context: context,
        title: 'Google Sign-In Error',
        content: e.message ?? 'Could not sign in with Google.',
        onConfirm: () => Navigator.pop(context),
      );
    } catch (e) {
      if (!mounted) return;
      showCostumDialog(
        context: context,
        title: 'Google Sign-In Error',
        content: e.toString(),
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
      backgroundColor: TFColors.canvas,
      appBar: AppBar(
        backgroundColor: TFColors.canvas,
        elevation: 0,
        iconTheme: const IconThemeData(color: TFColors.ink),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                    key: _loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Welcome back',
                          style: TextStyle(
                            fontFamily: 'Bricolage Grotesque',
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: TFColors.ink,
                            letterSpacing: -0.7,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Sign in with your TF Passport or Google account.',
                          style: TextStyle(fontSize: 14.5, color: TFColors.muted),
                        ),
                        const SizedBox(height: 24),
                        buildMailField(
                          controller: email,
                          label: 'Email',
                        ),
                        buildTextField(
                          controller: password,
                          label: 'Password',
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            tooltip: _obscurePassword
                                ? 'Show password'
                                : 'Hide password',
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: TFColors.muted,
                              size: 20,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
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
                        const SizedBox(height: 10),
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
                        const Row(
                          children: [
                            Expanded(child: Divider(color: TFColors.border)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'or continue with',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: TFColors.muted,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: TFColors.border)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 46,
                          child: OutlinedButton.icon(
                            onPressed: isLoading ? null : _handleGoogleLogin,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: TFColors.surface,
                              foregroundColor: TFColors.ink,
                              side: const BorderSide(color: TFColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(
                              Icons.g_mobiledata_rounded,
                              size: 26,
                              color: TFColors.accent,
                            ),
                            label: const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 14.5,
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
                              fontSize: 13.5,
                              color: TFColors.accent,
                              fontWeight: FontWeight.w600,
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
