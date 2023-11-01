
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/dashboard.dart';
import 'package:firebase_authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showPassword = true;
  bool loading = false;
  String erroeMassage='';
  GlobalKey<FormState> Formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passswordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future SignUp() async {
    setState(() {
      loading=true;
    });
    auth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passswordController.text)
        .then((value) {
          setState(() {
            loading = false;
          });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
          (route) => false);
    }).onError((FirebaseAuthException error, stackTrace) {
      erroeMassage=error.message!;
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('SignUp'), centerTitle: true),
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
                        SignUp();
                      }
                    },
                    child: (loading)
                        ? CircularProgressIndicator(color: Colors.white,)
                        : Text('SignUp')),
              ),
              SizedBox(height: 10,),
              Text(erroeMassage,style: TextStyle(color: Colors.red),),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => true);
                    },
                    child: Text(
                      "Login",
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
