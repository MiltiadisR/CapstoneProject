import 'package:flutter/material.dart';
import 'package:main/screens/Authenticate/forgetpassword/build_showmodalsheet.dart';
import 'package:main/services/auth.dart';
import 'package:main/shared/constants.dart';
import 'package:main/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xFF0C3b2E),
            appBar: AppBar(
              backgroundColor: Color(0xFFF5FBF4),
              elevation: 0.0,
              title: Text(
                "Sign in",
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
                        Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        )
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
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Color(0xFF1e2d4c)),
                                prefixIcon: Icon(Icons.person_outline_outlined,
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {
                                  ForgetPasswordScreen
                                      .buildshowmodalbottomsheet(context);
                                },
                                child: Text('Forget Password?',
                                    style:
                                        TextStyle(color: Color(0xFFacbdaa)))),
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
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Could not sigh in with those credentials';
                                  loading = false;
                                });
                              }
                            },
                            child: Text(
                              'Sign in',
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