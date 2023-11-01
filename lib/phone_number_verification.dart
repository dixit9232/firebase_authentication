import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Verification extends StatefulWidget {
  var verificationId;

  Verification(this.verificationId);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  GlobalKey<FormState> Formkey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  String errorMassage = '';

  Future Verify() async {
    setState(() {
      loading = true;
    });
    final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otpController.text);
    await _auth.signInWithCredential(credential).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
          (route) => false);
      setState(() {
        loading = false;
      });
    }).onError((FirebaseAuthException error, stackTrace) {
      errorMassage = error.message!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Verify'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Form(
              key: Formkey,
              child: TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Enter OTP',
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: OutlineInputBorder()),
                  validator: MultiValidator([
                    MinLengthValidator(6, errorText: 'Enter valid OTP'),
                    MaxLengthValidator(6, errorText: 'Enter valid OTP'),
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
                    if (Formkey.currentState!.validate()) {Verify();}
                  },
                  child: (loading)
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Submit Code')),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              errorMassage,
              style: TextStyle(color: Colors.red),
            )
          ]),
        ),
      ),
    );
  }
}
