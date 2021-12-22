import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'config_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CoKanban"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ConfigScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(
            flex: 3,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .doc("/users/cFsh1dR5zOPwrDZTvpE0e7ONc1B2")
                .snapshots(),
            builder: (
              BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error.toString());
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data!.data()!;
              return Center(child: Text(data['nickname']));
            },
          ),
          const Spacer(
            flex: 1,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
          const Spacer(
            flex: 3,
          ),
        ],
      ),
    );
  }
}
