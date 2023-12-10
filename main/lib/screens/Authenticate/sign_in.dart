import 'package:flutter/material.dart';
import 'package:main/servises/auth.dart';
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

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text("Sign in"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      widget.toggleView(); // Call toggleView function
                    },
                    child: Row(
                      children: [Icon(Icons.person), Text('Register')],
                    ))
              ],
            ),
            body: Container(
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
                          ),
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
                          ),
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.pink), // Change to the desired color
                          ),
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