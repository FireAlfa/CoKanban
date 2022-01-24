import 'package:flutter/material.dart';

class Task extends StatelessWidget {
  const Task({
    Key? key,
  }) : super(key: key);

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
            children: const [
              Text("Title"),
              Spacer(),
              Text("Tag"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("Description")
        ],
      ),
    );
  }
}