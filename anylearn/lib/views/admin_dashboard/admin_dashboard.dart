import 'package:anylearn/Theme/colors.dart';
import 'package:anylearn/views/admin_dashboard/new_topic_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../models/pocket_client.dart';
import '../../models/topic.dart';
import '../../models/user.dart';
import '../user_follows/UserCard.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  List<Topic> _topics = [];
  List<User> _bannedUsers = [];

  @override
  void initState() {
    super.initState();
    PocketClient.getTopics().then(
      (value) => setState(
        () => _topics = value,
      ),
    );
    PocketClient.getBannedUsers().then(
      (value) => setState(
        () => _bannedUsers = value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Topics", style: TextStyle(fontSize: 36)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
            child: Row(
              children: [
                SizedBox(
                  height: 80.0,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: _topics.length,
                    itemBuilder: (context, index) {
                      return InputChip(
                        padding: const EdgeInsets.all(8.0),
                        label: Text(_topics[index].name),
                        onSelected: (val) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title:
                                  Text("Delete Topic: ${_topics[index].name}?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      PocketClient.client
                                          .collection('topics')
                                          .delete(_topics[index].id);
                                      _topics.removeAt(index);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("No"),
                                ),
                              ],
                            ),
                          );
                        },
                        checkmarkColor: secondaryColor,
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8.0,
                      width: 8.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => NewTopicDialog(
                          (newTopic) => setState(
                            () => _topics.add(
                              Topic(newTopic, ""),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          indent: 8.0,
          endIndent: 8.0,
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Banned Users", style: TextStyle(fontSize: 36)),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 24.0,
              crossAxisSpacing: 30.0,
              childAspectRatio: 1.4,
            ),
            itemCount: _bannedUsers.length,
            itemBuilder: (context, index) => UserCard(_bannedUsers[index]),
          ),
        ),
      ],
    );
  }
}