import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/servises/database.dart';
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

  // Sign in anonymously
  Future<CustomUser?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String name, String phone) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user!;

      // Create a new document for the  user with the uid
      await DatabaseService(uid: user.uid).updateUserData(name, phone, email);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
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
