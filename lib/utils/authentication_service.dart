import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  String _userId;
  String _token;

  String get token {
    return _token;
  }

  String get userId {
    return _userId;
  }

  AuthenticationService(this._firebaseAuth);

  Stream<User> get userChanges => _firebaseAuth.userChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _userId = _firebaseAuth.currentUser.uid;

      await _firebaseAuth.currentUser.getIdToken().then(
            (String value) => _token = value,
          );
    } on FirebaseAuthException catch (e) {
      throw e.message;
    }
  }

  Future<void> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Signed in';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> checkEmailVerified() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      _userId = auth.currentUser.uid;
      _token = await auth.currentUser.getIdToken();
      print('yes');
      // notifyListeners();
    } else {
      print('NO');
    }
  }
}
