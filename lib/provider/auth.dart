// import 'dart:async';
// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:motiveGSv2/models/http_exeption.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Auth with ChangeNotifier {
//   String _token;
//   DateTime _expiryDate;
//   String _userId;
//   Timer _authTimer;

//   bool get isAuth {
//     return token != null;
//   }

//   String get token {
//     if (
//         // _expiryDate != null &&
//         //   _expiryDate.isAfter(DateTime.now()) &&
//         _token != null) {
//       return _token;
//     }
//     return null;
//   }

//   String get userId {
//     return _userId;
//   }

//   Future<void> _authenticate(
//       String email, String password, String urlSegment) async {
//     final url =
//         "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDKXQ7c9oO7q52oTbDELdaOuiyeHvG6IdY";
//     try {
//       final response = await http.post(
//         url,
//         body: json.encode(
//           {
//             "email": email,
//             "password": password,
//             "returnSecureToken": true,
//           },
//         ),
//       );
//       final responseData = json.decode(response.body);
//       if (responseData["error"] != null) {
//         throw HttpException(responseData["error"]["message"]);
//       }

//       _token = responseData["idToken"];
//       _userId = responseData["localId"];
//       _expiryDate = DateTime.now().add(
//         Duration(
//           seconds: int.parse(
//             responseData["expiresIn"],
//           ),
//         ),
//       );
//       print(email);
//       _autoLogout();
//       notifyListeners();

//       final prefs = await SharedPreferences.getInstance();
//       final userData = json.encode({
//         'token': _token,
//         'userId': _userId,
//         'expiryDate': _expiryDate.toIso8601String()
//       });
//       prefs.setString('userData', userData);
//     } catch (error) {
//       print(error);
//       throw error;
//     }
//   }

//   // Future<void> signUp(String email, String password) async {
//   //   return _authenticate(email, password, "signUp");
//   // }
//   Future<void> signUp(String email, String password) async {
//     final auth = FirebaseAuth.instance;
//     try {
//       await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//     } catch (error) {
//       print(error);
//       throw error;
//     }
//   }

//   Future<void> checkEmailVerified() async {
//     final auth = FirebaseAuth.instance;
//     User user;

//     user = auth.currentUser;
//     await user.reload();
//     if (user.emailVerified) {
//       _userId = auth.currentUser.uid;
//       _token = await auth.currentUser.getIdToken();
//       print("yes");
//       notifyListeners();
//     } else {
//       print("NO");
//     }
//   }

//   Future<void> logIn(String email, String password) async {
//     return _authenticate(email, password, "signInWithPassword");
//   }

//   Future<bool> tryAutoLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!prefs.containsKey('userData')) {
//       return false;
//     }
//     final extractedUserData =
//         json.decode(prefs.getString('userData')) as Map<String, Object>;

//     final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
//     if (expiryDate.isBefore(DateTime.now())) {
//       return false;
//     }
//     _token = extractedUserData['token'];
//     _userId = extractedUserData['userId'];
//     _expiryDate = expiryDate;
//     notifyListeners();

//     _autoLogout();
//     return true;
//   }

//   Future<void> logout() async {
//     _token = null;
//     _userId = null;
//     _expiryDate = null;
//     if (_authTimer != null) {
//       _authTimer.cancel();
//       _authTimer = null;
//     }
//     notifyListeners();
//     final prefs = await SharedPreferences.getInstance();
//     prefs.clear();
//   }

//   void _autoLogout() {
//     if (_authTimer != null) {
//       _authTimer.cancel();
//     }
//     final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
//     _authTimer = Timer(
//       Duration(seconds: timeToExpiry),
//       logout,
//     );
//   }
// }
