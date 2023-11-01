import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/login_screen.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deshboard'),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (route) => false));
              },
              child: Text('Logout'))),
    );
  }
}
