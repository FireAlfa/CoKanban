import 'package:cokanban/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            theme: ThemeData.dark(),
            home: const SignInScreen(
              providerConfigs: [
                EmailProviderConfiguration(),
              ],
            ),
          );
        }
        final user = FirebaseAuth.instance.currentUser!;
        return MainScreen(userID: user.uid);
      },
    );
  }
}
