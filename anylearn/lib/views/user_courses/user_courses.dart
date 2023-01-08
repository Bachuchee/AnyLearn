import 'package:anylearn/Theme/colors.dart';
import 'package:anylearn/models/pocket_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/course.dart';
import '../home/components/CourseCard.dart';

final userCourseProvider = StateProvider<List<Course>>((ref) => []);

class UserCourses extends ConsumerStatefulWidget {
  const UserCourses({super.key});

  @override
  ConsumerState<UserCourses> createState() => _UserCoursesState();
}

class _UserCoursesState extends ConsumerState<UserCourses> {
  final _client = PocketClient.client;

  @override
  void initState() {
    super.initState();
    PocketClient.getUserCourses(PocketClient.model.id)
        .then((value) => ref.read(userCourseProvider.notifier).state = value);
  }

  @override
  Widget build(BuildContext context) {
    final courseList = ref.watch(userCourseProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add),
                Text("Add New"),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 24.0,
              crossAxisSpacing: 30.0,
              childAspectRatio: 1.4,
            ),
            itemCount: courseList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => CourseCard(
              username: courseList[index].user!.username,
              courseTitle: courseList[index].title,
              courseImage: NetworkImage(
                _client
                    .getFileUrl(
                        courseList[index].model!, courseList[index].imageName!)
                    .toString(),
              ),
              userImage: NetworkImage(
                _client
                    .getFileUrl(
                      courseList[index].user!.model!,
                      courseList[index].user!.avatarName,
                    )
                    .toString(),
              ),
              courseChips: courseList[index].topics,
            ),
          ),
        ),
      ],
    );
  }
}
