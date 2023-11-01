import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  bool loading = false;
  String errorMassage='';
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future Forgot() async {
    setState(() {
      loading=true;
    });
    _auth
        .sendPasswordResetEmail(email: emailController.text)
        .then((value){
          errorMassage='We sent an email pleasee checkout mailbox or spam';
          Timer(Duration(seconds: 3), () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen(),), (route) => false);
          });
          setState(() {
            loading=false;
          });
        })
        .onError((FirebaseAuth error, stackTrace) {
          errorMassage='Invalid email';
          setState(() {
            loading=false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _key,
                child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Enter email',
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        border: OutlineInputBorder()),
                    validator: MultiValidator([
                      EmailValidator(errorText: 'Enter valid Email'),
                      RequiredValidator(errorText: 'This field is requierd'),
                    ])),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        Forgot();
                      }
                    },
                    child: (loading)
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text('Reset Passeord')),
              ),
              SizedBox(height: 10,),
              Text(errorMassage,style: TextStyle(color: Colors.red),)
            ],
          ),
        ),
      ),
    );
  }
}
