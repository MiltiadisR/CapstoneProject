import 'package:flutter/material.dart';
import 'package:main/servises/auth.dart';
import 'package:main/shared/constants.dart';
import 'package:main/shared/loading.dart';

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
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text("Sign up"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      widget.toggleView(); // Call toggleView function
                    },
                    child: Row(
                      children: [Icon(Icons.person), Text('Sign in')],
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
                            hintText: 'Name',
                          ),
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
                            hintText: 'Phone number',
                          ),
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