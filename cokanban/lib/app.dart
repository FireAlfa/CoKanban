import 'package:cokanban/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final user = FirebaseAuth.instance.currentUser!;

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
      home: const MainScreen(),
    );
  }
}
