import 'package:anylearn/models/pocket_client.dart';
import 'package:anylearn/views/home/components/home_filter.dart';
import 'package:anylearn/views/view_course/view_course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/course.dart';
import 'components/CourseCard.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _client = PocketClient.client;
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> viewCourse(int selectedIndex) async {
    ref.read(currentCourseProivder.notifier).state = _courses[selectedIndex];
    context.goNamed(
      "ViewCourse",
      params: {'courseId': _courses[selectedIndex].id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final topicFilter = ref.watch(filterProvider);

    PocketClient.getCourses(topicFilter).then(
      (value) => setState(() => _courses = value),
    );

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
                .getFileUrl(_courses[index].model!, _courses[index].imageName)
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
          onClick: () {
            viewCourse(index);
          },
          courseChips: _courses[index].topics,
          courseId: _courses[index].id,
        ),
      ),
    );
  }
}
