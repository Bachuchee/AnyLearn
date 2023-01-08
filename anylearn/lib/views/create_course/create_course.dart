import 'package:anylearn/models/user.dart';
import 'package:anylearn/views/home/components/CourseCard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../Theme/colors.dart';
import '../../controllers/file_service.dart';
import '../../models/course.dart';
import '../../models/pocket_client.dart';
import '../../models/topic.dart';
import '../shared/profile-avatar.dart';

final newCourseProvider = StateProvider(
  (ref) => Course(
    user: User.fromJson(PocketClient.model.data, PocketClient.model),
  ),
);

class CreateCourse extends ConsumerStatefulWidget {
  const CreateCourse({super.key});

  @override
  ConsumerState<CreateCourse> createState() => _CreateCourseState();
}

class _CreateCourseState extends ConsumerState<CreateCourse> {
  final userAvatar = NetworkImage(
    PocketClient.client
        .getFileUrl(PocketClient.model, PocketClient.model.data['avatar'])
        .toString(),
  );

  Uint8List? _imageData;
  List<Topic> _topicList = [];

  @override
  void initState() {
    super.initState();
    PocketClient.getTopics().then(
      (value) => setState(
        () {
          _topicList = value;
        },
      ),
    );
  }

  Future<void> setCourseImage() async {
    final imageData = await FileService.getImage();
    if (imageData.isNotEmpty) {
      setState(() {
        _imageData = imageData;
      });
    }
  }

  void createCourse() async {
    final newCourse = ref.watch(newCourseProvider);
    if (await PocketClient.createCourse(newCourse, _imageData!)) {
      ref.read(newCourseProvider.notifier).state = Course(
        user: User.fromJson(PocketClient.model.data, PocketClient.model),
      );
      context.go('/user-courses');
    }
  }

  bool canSubmit() {
    final courseData = ref.watch(newCourseProvider);

    return courseData.title.isNotEmpty &&
        courseData.description.isNotEmpty &&
        _imageData != null;
  }

  @override
  Widget build(BuildContext context) {
    final newCourseData = ref.watch(newCourseProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.go('/user-courses');
          },
          icon: const Icon(
            Icons.arrow_back,
            color: secondaryColor,
          ),
        ),
        title: Image.asset(
          'assets/images/Logo.png',
          height: 200.0,
          width: 200.0,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: secondaryColor,
              ),
            ),
          ),
          ProfileAvatar(
            userImage: userAvatar,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      width: 300.0,
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        maxLength: 50,
                        cursorColor: secondaryColor,
                        decoration: const InputDecoration(
                          filled: true,
                          labelText: "title",
                          labelStyle: TextStyle(color: secondaryColor),
                          focusColor: secondaryColor,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3.0,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            ref.read(newCourseProvider.notifier).state.title =
                                value;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 300.0,
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        maxLength: 120,
                        cursorColor: secondaryColor,
                        decoration: const InputDecoration(
                          filled: true,
                          labelText: "description",
                          labelStyle: TextStyle(color: secondaryColor),
                          focusColor: secondaryColor,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3.0,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            ref
                                .read(newCourseProvider.notifier)
                                .state
                                .description = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 300.0,
                  height: 300.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () {
                      setCourseImage();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.upload,
                          size: 50.0,
                        ),
                        Text(
                          "Upload Image",
                          style: TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 300.0,
                  child: VerticalDivider(
                    width: 1.0,
                    thickness: 1.0,
                  ),
                ),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Preview:",
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    CourseCard(
                      courseChips: newCourseData.topics,
                      username: PocketClient.model.data['username'],
                      userImage: userAvatar,
                      courseImage:
                          _imageData != null ? MemoryImage(_imageData!) : null,
                      courseTitle: newCourseData.title,
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  childAspectRatio: 1.0,
                  mainAxisExtent: 200.0,
                ),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _topicList.length,
                itemBuilder: (context, index) => InputChip(
                  selected: newCourseData.topics.contains(_topicList[index]),
                  onPressed: (newCourseData.topics.length < 3 ||
                          newCourseData.topics.contains(_topicList[index]))
                      ? () {
                          if (newCourseData.topics
                              .contains(_topicList[index])) {
                            setState(() {
                              newCourseData.removeTopic(_topicList[index]);
                            });
                          } else {
                            setState(() {
                              newCourseData.addTopic(_topicList[index]);
                            });
                          }
                        }
                      : null,
                  label: Text(_topicList[index].name),
                  backgroundColor: primarySurface,
                  selectedColor: selectedColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  minimumSize: Size(100.0, 50.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                ),
                onPressed: canSubmit()
                    ? () {
                        createCourse();
                      }
                    : null,
                child: const Text('Submit'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
