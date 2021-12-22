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
  late TextEditingController controller;
  Map<String, Object> data = HashMap();

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("New Task"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 80, 0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(255, 91, 151, 179),
                filled: true,
                hintText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 80, 0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(255, 91, 151, 179),
                filled: true,
                hintText: 'Users',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 80, 0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(255, 91, 151, 179),
                filled: true,
                hintText: 'Tags',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(255, 91, 151, 179),
                filled: true,
                hintText: 'Description',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (text) {},
            ),
          ),
        ],
      ),
    );
  }
}
