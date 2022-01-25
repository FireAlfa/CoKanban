import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({Key? key}) : super(key: key);

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final db = FirebaseFirestore.instance;
  late QueryDocumentSnapshot<Map<String, dynamic>> doc;
  late String uid;
  late TextEditingController nameController;
  late TextEditingController userController;
  late TextEditingController tagController;
  late TextEditingController descriptionController;
  Map<String, Object> data = HashMap();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    userController = TextEditingController();
    tagController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    tagController.dispose();
    userController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("New Task"),
      ),
      body: StreamBuilder(
        stream: db.collection("boards").snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          // If we don't get the information yet, show loading indicator
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // If we have data, show the screen
            doc = snapshot.data!.docs.elementAt(0);
            uid = snapshot.data!.docs.elementAt(0).id;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 80, 0),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 91, 151, 179),
                      filled: true,
                      hintText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 80, 0),
                  child: TextField(
                    controller: userController,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 91, 151, 179),
                      filled: true,
                      hintText: 'User',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 80, 0),
                  child: TextField(
                    controller: tagController,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 91, 151, 179),
                      filled: true,
                      hintText: 'Tag',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: TextField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 91, 151, 179),
                      filled: true,
                      hintText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    primary: const Color.fromARGB(255, 28, 128, 165),
                  ),
                  child: Text(doc.get("tasks").toString()),
                  onPressed: () {
                    setState(
                      () {
                        db.doc(uid).update(
                          {
                            'tasks': {'name': nameController.text}
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
