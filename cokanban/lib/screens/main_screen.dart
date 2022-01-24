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

  Future<dynamic> getBoardAmount() async {
    dynamic query = db.collection("boards");
    dynamic snapshot = await query.get();
    dynamic count = snapshot.size;
    return count;
  }

  // Widget that creates the info for each column
  Widget _columnItemBuilder(BuildContext conext, int index) {
    late String text;

    if (index == 0) {
      text = "To-Do";
    }
    if (index == 1) {
      text = "In Process";
    }
    if (index == 2) {
      text = "Done";
    }
    if (index > 2) {
      text = "New Board";
    }

    return StreamBuilder(
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
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(
                        snapshot.data!.docs.elementAt(index).get("title"),
                        style: const TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 0, 94, 131)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Task(),
                  ],
                ),
              ),
            );
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
                            builder: (context) => const ProfileScreen(),
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
                                kToolbarHeight),
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
