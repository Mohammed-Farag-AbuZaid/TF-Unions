import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/utils/saved_accounts.dart';
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
  List<SavedAccountEntry> _savedAccounts = [];

  @override
  void initState() {
    super.initState();
    _savedAccounts = SavedAccountsStore.list();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _syncProfile(User user, [Map<String, dynamic>? vpsUser]) async {
    SavedAccountsStore.saveFromUser(user);
    final rawName =
        (vpsUser?['fullName'] ?? vpsUser?['name'] ?? user.displayName ?? user.email?.split('@').first ?? 'Scholar')
            .toString()
            .trim();
    final parts = rawName.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'id': user.uid,
        'uid': user.uid,
        'firstName': vpsUser?['firstName'] ?? (parts.isNotEmpty ? parts.first : rawName),
        'lastName': vpsUser?['lastName'] ?? (parts.length > 1 ? parts.sublist(1).join(' ') : ''),
        'fullName': rawName,
        'username': rawName,
        'email': user.email ?? '',
        if ((vpsUser?['phone'] ?? '').toString().isNotEmpty) 'phone': vpsUser!['phone'],
        if ((vpsUser?['academicLevel'] ?? '').toString().isNotEmpty) 'academicLevel': vpsUser!['academicLevel'],
        if ((vpsUser?['grade'] ?? '').toString().isNotEmpty) 'grade': vpsUser!['grade'],
        if ((vpsUser?['stemSchool'] ?? '').toString().isNotEmpty) 'stemSchool': vpsUser!['stemSchool'],
        'profilePicture': user.photoURL ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  Future<UserCredential?> _tryMigrateVpsAccount(String em, String pw) async {
    try {
      final res = await http
          .post(
            Uri.parse('https://n8n.tfunions.com/tf-api/api/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': em.trim(), 'password': pw}),
          )
          .timeout(const Duration(seconds: 4));
      if (res.statusCode != 200) return null;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final vpsUser = (body['user'] as Map<String, dynamic>?) ?? <String, dynamic>{};
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: em.trim(),
        password: pw,
      );
      if (cred.user != null) {
        final fullName = (vpsUser['fullName'] ?? vpsUser['name'] ?? em.split('@').first)
            .toString()
            .trim();
        if (fullName.isNotEmpty) {
          await cred.user!.updateDisplayName(fullName);
        }
        await _syncProfile(cred.user!, vpsUser);
      }
      return cred;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw FirebaseAuthException(
          code: 'wrong-password',
          message:
              'Account already exists in Firebase Auth. Use Forgot password? or Continue with Google.',
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _handleLogin() async {
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;
    setState(() => isLoading = true);
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );
      if (cred.user != null) {
        await _syncProfile(cred.user!);
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('homePage');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'invalid-credential' ||
          e.code == 'wrong-password') {
        try {
          final migrated = await _tryMigrateVpsAccount(
            email.text.trim(),
            password.text,
          );
          if (migrated != null) {
            if (!mounted) return;
            Navigator.of(context).pushReplacementNamed('homePage');
            return;
          }
        } on FirebaseAuthException catch (migErr) {
          if (!mounted) return;
          showCostumDialog(
            context: context,
            title: 'Sign-In Info',
            content: migErr.message ?? 'Could not retrieve account.',
            onConfirm: () => Navigator.pop(context),
          );
          return;
        }
      }
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
      UserCredential cred;
      if (kIsWeb) {
        try {
          cred = await FirebaseAuth.instance.signInWithPopup(provider);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'popup-blocked' ||
              e.code == 'operation-not-supported-in-this-environment') {
            await FirebaseAuth.instance.signInWithRedirect(provider);
            return;
          }
          if (e.code == 'popup-closed-by-user' ||
              e.code == 'cancelled-popup-request') {
            return;
          }
          rethrow;
        }
      } else {
        cred = await FirebaseAuth.instance.signInWithProvider(provider);
      }
      final user = cred.user;
      if (user != null) {
        await _syncProfile(user);
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('homePage');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final msg = e.code == 'unauthorized-domain'
          ? 'This domain is not authorized in Firebase Auth. Please contact TF Unions support.'
          : (e.message ?? 'Could not sign in with Google.');
      showCostumDialog(
        context: context,
        title: 'Google Sign-In Error',
        content: msg,
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
    final narrow = MediaQuery.of(context).size.width < 520;
    return Scaffold(
      backgroundColor: TFColors.canvas,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: narrow ? 14 : 20,
                  vertical: narrow ? 16 : 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      narrow ? 20 : 28,
                      narrow ? 22 : 28,
                      narrow ? 20 : 28,
                      narrow ? 24 : 30,
                    ),
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                } else {
                                  Navigator.of(context)
                                      .pushReplacementNamed('homePage');
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                foregroundColor: TFColors.muted,
                              ),
                              icon: const Icon(Icons.arrow_back_rounded, size: 16),
                              label: const Text(
                                'Home',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Welcome back',
                            style: TextStyle(
                              fontFamily: 'Bricolage Grotesque',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: TFColors.ink,
                              letterSpacing: -0.7,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Sign in with your saved TF Passport, Google, or email.',
                            style: TextStyle(fontSize: 14, color: TFColors.muted),
                          ),
                          if (_savedAccounts.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: TFColors.canvas,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: TFColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Saved accounts on this device',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: TFColors.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  for (final acct in _savedAccounts)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: TFColors.surface,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: TFColors.border),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  if (acct.provider == 'google') {
                                                    _handleGoogleLogin();
                                                  } else {
                                                    setState(() => email.text = acct.email);
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 13,
                                                      backgroundColor: TFColors.accent,
                                                      child: Text(
                                                        acct.name.isNotEmpty
                                                            ? acct.name[0].toUpperCase()
                                                            : 'T',
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 9),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            acct.name,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color: TFColors.ink,
                                                            ),
                                                          ),
                                                          Text(
                                                            acct.provider == 'google'
                                                                ? '${acct.email} · Google'
                                                                : acct.email,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                              fontSize: 11.5,
                                                              color: TFColors.muted,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              tooltip: 'Remove',
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(
                                                minWidth: 26,
                                                minHeight: 26,
                                              ),
                                              onPressed: () {
                                                SavedAccountsStore.remove(acct.email);
                                                setState(() {
                                                  _savedAccounts =
                                                      SavedAccountsStore.list();
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.close_rounded,
                                                size: 16,
                                                color: TFColors.muted,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 18),
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
      ),
    );
  }
}
