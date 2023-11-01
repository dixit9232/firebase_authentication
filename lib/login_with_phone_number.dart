import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'phone_number_verification.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool showPassword = true;
  bool loading = false;
  String code = '+91';
  GlobalKey<FormState> Formkey = GlobalKey<FormState>();
  TextEditingController numberController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMassage = '';

  Future LoginWithPhone() async {
    setState(() {
      loading=true;
    });
    _auth.verifyPhoneNumber(
      phoneNumber: code+numberController.text,
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {
        errorMassage = error.message!;
      },
      codeSent: (verificationId, forceResendingToken) {
        setState(() {
          loading=false;
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Verification(verificationId),
            ),
            (route) => true);
      },
      codeAutoRetrievalTimeout: (error) {
        errorMassage = error;
        setState(() {
          loading=false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Phone Number'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Form(
              key: Formkey,
              child: IntlPhoneField(
                initialCountryCode: 'IN',
                onCountryChanged: (value) {
                  code = value.dialCode;
                },
                decoration: InputDecoration(
                    labelText: 'Enter Phone number',
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    border: OutlineInputBorder()),
                controller: numberController,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (Formkey.currentState!.validate()) {
                      LoginWithPhone();
                    }
                  },
                  child: (loading)?CircularProgressIndicator(color: Colors.white,):Text('Send Code')),
            )
          ]),
        ),
      ),
    );
  }
}
