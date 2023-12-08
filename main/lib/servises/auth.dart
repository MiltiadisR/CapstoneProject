import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StreamController<CustomUser?> _userController =
      StreamController<CustomUser?>();

  Stream<CustomUser?> get userStream => _userController.stream;

  CustomUser? _userFromFirebaseUser(User? user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  // Sign anonymously
  Future<CustomUser?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Other authentication methods can be added here

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    _userController.add(null);
  }

  // Initialize the stream in the constructor
  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      CustomUser? customUser = _userFromFirebaseUser(user);
      _userController.add(customUser);
    });
  }

  // Dispose of the stream controller when done
  void dispose() {
    _userController.close();
  }
}
