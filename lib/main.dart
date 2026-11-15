import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/constants/variables.dart';
import 'package:tf_union/pages/forget_password.dart';
import 'package:tf_union/pages/login.dart';
import 'package:tf_union/pages/register_page.dart';
import 'package:tf_union/utils/saved_accounts.dart';
import 'pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> _syncSignedInUser(User user) async {
  SavedAccountsStore.saveFromUser(user);
  try {
    final fullName =
        (user.displayName ?? user.email?.split('@').first ?? 'Scholar').trim();
    final parts = fullName.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'id': user.uid,
      'uid': user.uid,
      'firstName': parts.isNotEmpty ? parts.first : fullName,
      'lastName': parts.length > 1 ? parts.sublist(1).join(' ') : '',
      'fullName': fullName,
      'username': fullName,
      'email': user.email ?? '',
      'profilePicture': user.photoURL ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  } catch (_) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kIsWeb) {
    try {
      final redir = await FirebaseAuth.instance.getRedirectResult();
      if (redir.user != null) {
        await _syncSignedInUser(redir.user!);
      }
    } catch (_) {}
  }

  try {
    currentUser.value = await FirebaseAuth.instance.authStateChanges().first
        .timeout(const Duration(seconds: 2), onTimeout: () => FirebaseAuth.instance.currentUser);
  } catch (_) {
    currentUser.value = FirebaseAuth.instance.currentUser;
  }
  if (currentUser.value != null) {
    SavedAccountsStore.saveFromUser(currentUser.value!);
  }

  FirebaseAuth.instance.authStateChanges().listen((user) {
    currentUser.value = user;
    if (user != null) {
      _syncSignedInUser(user);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: TFColors.canvas,
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Plus Jakarta Sans',
            ),
        colorScheme: const ColorScheme.light(
          primary: TFColors.accent,
          secondary: TFColors.gold,
          surface: TFColors.surface,
          onSurface: TFColors.ink,
        ),
      ),
      title: 'TF Unions',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        'register': (context) => const RegisterPage(),
        'login': (context) => const LoginPage(),
        'homePage': (context) => const HomePage(),
        'forget_password': (context) => const ForgetPasswordPage(),
      },
    );
  }
}
