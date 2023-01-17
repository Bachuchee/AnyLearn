import 'package:anylearn/Theme/colors.dart';
import 'package:anylearn/models/pocket_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/course.dart';
import '../home/components/CourseCard.dart';

class UserCourses extends ConsumerStatefulWidget {
  const UserCourses({super.key});

  @override
  ConsumerState<UserCourses> createState() => _UserCoursesState();
}

class _UserCoursesState extends ConsumerState<UserCourses> {
  final _client = PocketClient.client;

  List<Course> _userCourses = [];

  @override
  void initState() {
    super.initState();
    PocketClient.getUserCourses(PocketClient.model.id).then(
      (value) => setState(
        () {
          _userCourses = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: () {
              context.go('/new-course');
            },
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
            itemCount: _userCourses.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => CourseCard(
              onClick: () {},
              username: _userCourses[index].user!.username,
              courseTitle: _userCourses[index].title,
              courseImage: NetworkImage(
                _client
                    .getFileUrl(_userCourses[index].model!,
                        _userCourses[index].imageName)
                    .toString(),
              ),
              userImage: NetworkImage(
                _client
                    .getFileUrl(
                      _userCourses[index].user!.model!,
                      _userCourses[index].user!.avatarName,
                    )
                    .toString(),
              ),
              courseChips: _userCourses[index].topics,
            ),
          ),
        ),
      ],
    );
  }
}
