import 'package:flutter/material.dart';
import 'package:humidtemp/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  const String email = "testuser@gmail.com", password = "password123";
  WidgetsFlutterBinding.ensureInitialized();

  await initFirebase(email, password);

  runApp(const MyApp());
}

Future<void> initFirebase(final String email, final String password) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const HomePage(),
    );
  }
}
