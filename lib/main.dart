import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tf_union/pages/forget_password.dart';
import 'package:tf_union/pages/login.dart';
import 'package:tf_union/pages/register_page.dart';
import 'pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'TF-Unions',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        'register': (context) => RegisterPage(),
        'login': (context) => LoginPage(),
        'homePage': (context) => HomePage(),
        'forget_password': (context) => ForgetPasswordPage(),
      },
    );
  }
}
