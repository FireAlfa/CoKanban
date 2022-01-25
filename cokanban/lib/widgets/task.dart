import 'package:flutter/material.dart';

class Task extends StatefulWidget {
  final String title;
  final String users;
  final String tag;
  final String description;

  const Task({
    Key? key,
    required this.title,
    required this.users,
    required this.tag,
    required this.description,
  }) : super(key: key);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      width: 300,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 177, 229, 242),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 20),
              ),
              const Spacer(),
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 196, 196, 196)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                  child: Text(widget.tag),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(widget.users),
          const SizedBox(
            height: 15,
          ),
          Text(widget.description),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
