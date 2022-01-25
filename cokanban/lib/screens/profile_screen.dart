import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cokanban/widgets/auth_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String userID;
  const ProfileScreen({Key? key, required this.userID}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final db = FirebaseFirestore.instance;
  late TextEditingController controller;

  Future<dynamic> getBoardAmount() async {
    dynamic query = db.collection("users");
    dynamic snapshot = await query.get();
    dynamic count = snapshot.size;
    return count;
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.doc("/users/${widget.userID}").snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot> snapshot,
      ) {
        // Future<dynamic> future = getBoardAmount();
        // future.then((dynamic boardAmount) {boardAmount = })
        // If we don't get the information yet, show loading indicator
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // If we have data, show the screen
        final doc = snapshot.data!.data();
        final String nickname = snapshot.data!.get("nickname");
        if (doc != null) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Profile"),
            ),
            body: Column(
              children: [
                const SizedBox(height: 90),
                const Icon(
                  Icons.person,
                  size: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  nickname,
                  textScaleFactor: 2,
                ),
                const SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nickname",
                    ),
                    controller: controller,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    onPressed: () {
                      db
                          .doc("/users/${widget.userID}")
                          .update({'nickname': controller.text});
                    },
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16)),
                    child: const Text("Save Changes")),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AuthGate(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 200, 0, 0),
                        textStyle: const TextStyle(fontSize: 18)),
                    child: const Text("Log out")),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          );
        } else // If we don't have data, create new user
        {
          db
              .doc("/users/${widget.userID}")
              .set({
                "UID": widget.userID.toString(),
                "nickname": "New User",
              })
              .then((_) {})
              .catchError((_) {});
          return const Center(
            child: SizedBox(
              width: 30,
              height: 30,
            ),
          );
        }
      },
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Your Profile"),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
            child: IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AuthGate(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout)),
          )
        ],
      ),
    );
  }*/
}
