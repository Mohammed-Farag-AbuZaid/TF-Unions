import 'package:firebase_auth/firebase_auth.dart';

const double mobileWidth = 700;
const double minRegisterWidth = 1000;
bool loggedIn = false;

void _initializeAuthState() {
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      loggedIn = false;
    } else {
      loggedIn = true;
    }
  });
}
  