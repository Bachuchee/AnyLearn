import 'package:anylearn/models/pocket_client.dart';
import 'package:anylearn/views/shared/main-app-bar.dart';
import 'package:flutter/material.dart';

import '../../models/course.dart';
import '../../models/topic.dart';
import 'components/CourseCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _client = PocketClient.client;
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    PocketClient.getCourses().then(
      (value) => setState(() => _courses = value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 24.0,
          crossAxisSpacing: 30.0,
          childAspectRatio: 1.4,
        ),
        itemCount: _courses.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => CourseCard(
          username: _courses[index].user!.username,
          courseTitle: _courses[index].title,
          courseImage: NetworkImage(
            _client
                .getFileUrl(_courses[index].model!, _courses[index].imageName!)
                .toString(),
          ),
          userImage: NetworkImage(
            _client
                .getFileUrl(
                  _courses[index].user!.model!,
                  _courses[index].user!.avatarName,
                )
                .toString(),
          ),
          courseChips: _courses[index].topics,
        ),
      ),
    );
  }
}
