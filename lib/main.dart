import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:motiveGSv2/provider/announcements.dart';
import 'package:motiveGSv2/utils/authentication_service.dart';
import 'package:motiveGSv2/provider/motiveList.dart';
import 'package:motiveGSv2/screens/homeMotive.dart';
import 'package:motiveGSv2/screens/openScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider<User>(
          create: (BuildContext context) =>
              context.read<AuthenticationService>().userChanges,
        ),
        ChangeNotifierProxyProvider<AuthenticationService, Motives>(
          update: (BuildContext ctx, AuthenticationService auth,
                  Motives previousMotives) =>
              Motives(
            auth.token,
            previousMotives == null ? [] : previousMotives.items,
            auth.userId,
          ),
          create: null,
        ),
        ChangeNotifierProvider<Announcements>.value(
          value: Announcements(),
        ),
      ],
      child: MaterialApp(
        title: 'Motive GS',
        theme: ThemeData(),
        home: AuthenticationWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User firebaseUser = context.watch<User>();

    if (firebaseUser != null && firebaseUser.emailVerified) {
      return HomeMotive();
    } else {
      return OpenScreen();
    }
  }
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     final authFirebase = FirebaseAuth.instance;
//     User user;
//     print(authFirebase.currentUser.email);
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider.value(
//           value: Auth(),
//         ),
//         ChangeNotifierProxyProvider<Auth, Motives>(
//           update: (ctx, auth, previousMotives) => Motives(
//             auth.token,
//             previousMotives == null ? [] : previousMotives.items,
//             auth.userId,
//           ),
//           create: null,
//         ),
//         ChangeNotifierProvider.value(
//           value: Announcements(),
//         ),
//       ],
//       child: Consumer<Auth>(
//         builder: (ctx, auth, _) => MaterialApp(
//           title: 'Motive GS',
//           theme: ThemeData(),
//           home: auth.isAuth
//               ? HomeMotive()
//               : FutureBuilder(
//                   future: auth.tryAutoLogin(),
//                   builder: (ctx, authResultSnapShot) =>
//                       authResultSnapShot.connectionState ==
//                               ConnectionState.waiting
//                           ? SplashScreen()
//                           : OpenScreen(),
//                 ),
//           // // home: HomeMotive(),
//           debugShowCheckedModeBanner: false,
//         ),
//       ),
//     );
//   }
// }
