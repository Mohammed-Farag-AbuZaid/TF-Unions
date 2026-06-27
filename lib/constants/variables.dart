import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const double mobileWidth = 700;
const double minRegisterWidth = 1000;

final ValueNotifier<User?> currentUser = ValueNotifier(
  FirebaseAuth.instance.currentUser,
);

bool get loggedIn => currentUser.value != null;