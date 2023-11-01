import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home:(FirebaseAuth.instance.currentUser!=null)?Dashboard():LoginScreen(),theme: ThemeData(primarySwatch: Colors.deepPurple),
    debugShowCheckedModeBanner: false,
  ));
}
// https://fir-authentication-41537.firebaseapp.com/__/auth/handler