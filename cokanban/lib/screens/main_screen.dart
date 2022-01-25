import 'package:cokanban/screens/create_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'profile_screen.dart';
import 'package:cokanban/widgets/task.dart';

class MainScreen extends StatefulWidget {
  final String userID;
  const MainScreen({
    Key? key,
    required this.userID,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final db = FirebaseFirestore.instance;
  late Map<String, dynamic> task;

  // Widget that creates the info for each column
  Widget _columnItemBuilder(BuildContext conext, int index) {
    return StreamBuilder(
        stream: db.collection("boards").snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data!.docs.elementAt(index).data().isNotEmpty) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      snapshot.data!.docs.elementAt(index).get("title"),
                      style: const TextStyle(
                          fontSize: 30, color: Color.fromARGB(255, 0, 94, 131)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        kToolbarHeight -
                        90),
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder(
                      stream: db
                          .collection(
                              "boards/${snapshot.data!.docs.elementAt(index).id}/tasks")
                          .snapshots(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot2,
                      ) {
                        if (!snapshot2.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (snapshot2.data!.docs
                              .elementAt(0)
                              .data()
                              .isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot2.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                for (int i = 0;
                                    i < snapshot2.data!.docs.length;
                                    i++) {
                                  task = snapshot2.data!.docs
                                      .elementAt(index)
                                      .data();
                                  return Align(
                                    child: Task(
                                      title: task["name"].toString(),
                                      users: task["user"].toString(),
                                      tag: task["tag"].toString(),
                                      description:
                                          task["description"].toString(),
                                    ),
                                  );
                                }
                                throw '';
                              },
                            );
                          } else {
                            return const Center(child: Text("Board is Empty"));
                          }
                        }
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text("Board is Empty"));
            }
          }
        });
  }

  void _onItemFocus(int index) {
    setState(() {
      index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.doc("/users/${widget.userID}").snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot> snapshot,
      ) {
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
        if (doc != null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("CoKanban"),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              userID: widget.userID,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person)),
                )
              ],
            ),
            body: Stack(
              children: [
                // Get Boards data
                StreamBuilder(
                    stream: db.collection("boards").snapshots(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        // Screen sized columns for each Kanban board with side scroll
                        return SingleChildScrollView(
                          child: SizedBox(
                            // Height of column, gets screen size
                            height: (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top -
                                kToolbarHeight -
                                25),
                            child: ScrollSnapList(
                              onItemFocus: _onItemFocus,
                              itemSize: MediaQuery.of(context)
                                  .size
                                  .width, // Width of column, gets screen size
                              itemCount: snapshot.data!.size,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: _columnItemBuilder,
                            ),
                          ),
                        );
                      }
                    }),
                // Plus button to create new tasks
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CreateTaskScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_circle),
                      iconSize: 55,
                      color: const Color.fromARGB(255, 59, 64, 116),
                    ),
                  ),
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
}
