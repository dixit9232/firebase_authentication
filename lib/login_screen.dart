import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/dashboard.dart';
import 'package:firebase_authentication/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_with_phone_number.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = true;
  bool loading = false;
  String errorMasage = '';
  GlobalKey<FormState> Formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passswordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future Login() async {
    setState(() {
      loading = true;
    });
    auth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passswordController.text)
        .then((value) {
      setState(() {
        loading = false;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ),
            (route) => false);
      });
    }).onError((FirebaseAuthException error, stackTrace) {
      errorMasage = 'invalid email and password';
      setState(() {
        loading = false;
      });
    });
  }

  Future LoginWithGoogle() async {
    GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleauth = await googleuser!.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken, idToken: googleauth.idToken);
    auth.signInWithCredential(credential).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
          (route) => false);
    }).onError((FirebaseAuthException error, stackTrace) {
      errorMasage = error.message!;
    });
  }

  Future LoginWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    final credential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    auth.signInWithCredential(credential).then((value) {

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Dashboard()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Login'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: Formkey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextFormField(
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
              SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: passswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: showPassword,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: (showPassword)
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                      labelText: 'Enter Password',
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: OutlineInputBorder()),
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'password is required'),
                    MinLengthValidator(8,
                        errorText: 'password must be at least 8 digits long'),
                    PatternValidator('[1234567890]',
                        errorText: 'Enter At least one digit'),
                    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                        errorText:
                            'passwords must have at least one special character')
                  ])),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (Formkey.currentState!.validate()) {
                        Login();
                      }
                    },
                    child: (loading)
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text('Login')),
              ),
              SizedBox(height: 10),
              Text(
                errorMasage,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create a new account?",
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                          (route) => true);
                    },
                    child: Text(
                      "SignUp",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: OutlinedButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                        side: MaterialStatePropertyAll(BorderSide(
                          width: 1,
                        ))),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginWithPhoneNumber(),
                          ),
                          (route) => true);
                    },
                    child: Text('Login with phone number')),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        LoginWithGoogle();
                      },
                      icon: FaIcon(FontAwesomeIcons.google)),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        LoginWithFacebook();
                      },
                      icon: FaIcon(FontAwesomeIcons.facebook)),
                 Spacer(),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
