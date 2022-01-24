import 'package:cokanban/widgets/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoKanban',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 112, 199, 238),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 112, 199, 238),
          //foregroundColor: Color.fromARGB(255, 11, 89, 128),
        ),
      ),
      home: const AuthGate(),
    );
  }
}
