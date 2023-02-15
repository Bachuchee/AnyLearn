import 'package:anylearn/controllers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../Theme/colors.dart';
import '../../models/course.dart';
import '../../models/pocket_client.dart';
import '../../models/user.dart';
import '../home/components/CourseCard.dart';
import '../menu/menu.dart';
import '../shared/profile-avatar.dart';
import '../view_course/view_course.dart';

final curUserProvider = StateProvider<User>((ref) => User());

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile(this.userId, {super.key});

  final String userId;

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  final _client = PocketClient.client;
  List<Course> _userCourses = [];

  Future<void> getUser() async {
    ref.read(curUserProvider.notifier).state = await PocketClient.getUser(
      widget.userId,
    );
  }

  Future<void> getCourses() async {
    final courses = await PocketClient.getUserCourses(widget.userId);
    setState(
      () {
        _userCourses = courses;
      },
    );
  }

  Future<void> viewCourse(int selectedIndex) async {
    ref.read(currentCourseProivder.notifier).state =
        _userCourses[selectedIndex];
    context.goNamed(
      "ViewCourse",
      params: {'courseId': _userCourses[selectedIndex].id},
    );
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(curUserProvider);

    final isUser = PocketClient.model.id == user.id;
    final List<Widget> topicChips = [];

    for (var topic in user.topics) {
      topicChips.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Chip(
            label: Text(topic.name),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: secondaryColor,
          ),
          onPressed: () {
            final destinationIndex = ref.watch(indexProvider);
            String destination = destinations[destinationIndex];
            context.goNamed(destination);
          },
        ),
        title: Text(
          user.username,
          style: const TextStyle(color: secondaryColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none,
                color: secondaryColor,
              ),
            ),
          ),
          if (isUser)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  context.goNamed('EditProfile');
                },
                icon: const Icon(
                  Icons.edit,
                  color: secondaryColor,
                ),
              ),
            ),
          if (isUser)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () async {
                  if (await AuthService.logout()) {
                    context.goNamed('Login');
                  }
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.red[600],
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        children: [
          if (user.model != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  width: 200.0,
                  child: ProfileAvatar(
                    userImage: NetworkImage(
                      _client
                          .getFileUrl(user.model!, user.avatarName)
                          .toString(),
                    ),
                    size: 200.0,
                  ),
                ),
              ),
            ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                user.username,
                style: const TextStyle(
                  color: secondaryColor,
                  fontSize: 40.0,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Followers: 0 Following: 0",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          if (topicChips.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: topicChips,
              ),
            ),
          if (user.about.replaceAll(' ', '') != "")
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        user.about,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          const Divider(
            height: 1.0,
            thickness: 1.0,
            indent: 16.0,
            endIndent: 16.0,
          ),
          Padding(
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
                onClick: () {
                  viewCourse(index);
                },
                courseRating: _userCourses[index].rating,
                courseChips: _userCourses[index].topics,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
