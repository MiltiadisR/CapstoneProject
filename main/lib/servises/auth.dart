import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'main\lib\models\user.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _userfromFirebaseUser(Firebase user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // Sign anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign with email and password

  // register with email and password

  // sign out
}
