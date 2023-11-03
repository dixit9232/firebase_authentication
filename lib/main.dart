import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/firebase_options.dart';
import 'package:firebase_authentication/realtime%20databse/notes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MaterialApp(themeMode: ThemeMode.system,darkTheme: ThemeData.dark(useMaterial3: true),
     home:(FirebaseAuth.instance.currentUser!=null)?Notes():LoginScreen(),theme: ThemeData(primarySwatch: Colors.deepPurple),
    debugShowCheckedModeBanner: false,
  ));
}
