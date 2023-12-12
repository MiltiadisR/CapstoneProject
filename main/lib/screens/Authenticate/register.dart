import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main/servises/auth.dart';
import 'package:main/shared/constants.dart';
import 'package:main/shared/loading.dart';

import 'signupcontroller.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';
  String phone = '';
  String name = '';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xFF0C3b2E),
            appBar: AppBar(
              backgroundColor: Color(0xFFF5FBF4),
              elevation: 0.0,
              title: Text(
                "Sign up",
                style: TextStyle(color: Color(0xFFacbdaa)),
              ),
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFFA3AB92))),
                    onPressed: () {
                      widget.toggleView(); // Call toggleView function
                    },
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.white),
                        Text('Sign in', style: TextStyle(color: Colors.white))
                      ],
                    ))
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: Form(
                      key: _formkey,
                      child: Column(
                          children: List.of(
                        [
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: controller.name,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Name',
                                hintStyle: TextStyle(color: Color(0xFF1e2d4c)),
                                prefixIcon: Icon(Icons.person_outline_rounded,
                                    color: Color(0xFF1e2d4c))),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter a name' : null,
                            onChanged: (val) {
                              setState(() => name = val);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: controller.email,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Color(0xFF1e2d4c)),
                                prefixIcon: Icon(Icons.email_outlined,
                                    color: Color(0xFF1e2d4c))),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: controller.phoneNo,
                            keyboardType: TextInputType.number,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Phone number',
                                hintStyle: TextStyle(color: Color(0xFF1e2d4c)),
                                prefixIcon: Icon(Icons.numbers,
                                    color: Color(0xFF1e2d4c))),
                            validator: (val) => val!.length < 10
                                ? 'Enter a valid phone number'
                                : null,
                            onChanged: (val) {
                              setState(() => phone = val);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: controller.password,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Color(0xFF1e2d4c)),
                                prefixIcon: Icon(Icons.fingerprint,
                                    color: Color(0xFF1e2d4c))),
                            validator: (val) => val!.length < 6
                                ? 'Enter a password 6+ characters long'
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) ;
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password, name, phone);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = 'please supply a valid email';
                                });
                              }
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFFA3AB92))),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          )
                        ],
                      )))),
            ),
          );
  }
}




//ElevatedButton(
//          child: Text("Sign in anonymously"),
//          onPressed: () async {
//            dynamic result = await _auth.signInAnon();
//            if (result == null) {
//              print('error sighing in');
//            } else {
//              print('Signed in');
//              print(result.uid);
//            }
//          },
//        ),