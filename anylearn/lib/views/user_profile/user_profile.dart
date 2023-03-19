import 'package:anylearn/controllers/auth_service.dart';
import 'package:anylearn/views/user_profile/follow_button.dart';
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
  int _followerCount = 0;
  int _followingCount = 0;

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

  Future<void> getLiveFollowings() async {
    while (true) {
      int followers = await PocketClient.getFollowers(widget.userId);
      int following = await PocketClient.getFollowing(widget.userId);
      setState(() {
        _followerCount = followers;
        _followingCount = following;
      });
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getCourses();
    getLiveFollowings();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(curUserProvider);

    final destinationIndex = ref.watch(indexProvider);

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
            String destination = destinations[destinationIndex];
            context.goNamed(destination);
          },
        ),
        title: Text(
          user.username,
          style: const TextStyle(color: secondaryColor),
        ),
        actions: [
          if (PocketClient.isAdmin && user.model != null && !isUser)
            Tooltip(
              message: user.model!.data['is_banned'] ? "unban" : "ban",
              child: IconButton(
                onPressed: () {
                  _client.collection('users').update(
                    user.id,
                    body: {
                      'is_banned': !user.model!.data['is_banned'],
                    },
                  );
                  setState(() => user.model!.data['is_banned'] =
                      !user.model!.data['is_banned']);
                },
                icon: Icon(
                  user.model!.data['is_banned']
                      ? Icons.check_circle
                      : Icons.cancel,
                  color:
                      user.model!.data['is_banned'] ? Colors.green : Colors.red,
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
          if (user.id != PocketClient.model.id)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FollowButton(
                  PocketClient.model.id,
                  widget.userId,
                ),
              ),
            ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Followers: $_followerCount Following: $_followingCount",
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
