import 'package:estacionamiento_uaem/firebase_options.dart';
import 'package:estacionamiento_uaem/login/sign_in_screen.dart';
import 'package:estacionamiento_uaem/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Orientación vertical hacia arriba
    DeviceOrientation.portraitDown, // Orientación vertical hacia abajo
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            theme: ThemeData.dark(useMaterial3: true),
            debugShowCheckedModeBanner: false,
            home: AuthenticationWrapper(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error initializing Firebase'),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return const HomeScreen();
    } else {
      return const SignInScreen();
    }
  }
}
