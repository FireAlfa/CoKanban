import 'package:flutter/material.dart';

class Task extends StatefulWidget {
  final String title;
  final String tag;
  final String description;

  const Task({
    Key? key,
    required this.title,
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
              Text(widget.title),
              const Spacer(),
              Text(widget.tag),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(widget.description),
        ],
      ),
    );
  }
}
