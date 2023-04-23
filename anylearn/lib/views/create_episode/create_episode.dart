import 'package:anylearn/models/episode.dart';
import 'package:anylearn/models/user.dart';
import 'package:anylearn/views/home/components/CourseCard.dart';
import 'package:anylearn/views/view_course/components/episode_tile.dart';
import 'package:anylearn/views/view_course/view_course.dart';
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

final newEpisodeProvider = StateProvider(
  (ref) => Episode(
    course: ref.read(currentCourseProivder),
  ),
);

class CreateEpisode extends ConsumerStatefulWidget {
  const CreateEpisode({super.key});

  @override
  ConsumerState<CreateEpisode> createState() => _CreateEpisodeState();
}

class _CreateEpisodeState extends ConsumerState<CreateEpisode> {
  final userAvatar = NetworkImage(
    PocketClient.client
        .getFileUrl(PocketClient.model, PocketClient.model.data['avatar'])
        .toString(),
  );

  Uint8List? _imageData;
  Uint8List? _videoData;

  @override
  void initState() {
    super.initState();
    resetProvider();
  }

  void resetProvider() async {
    ref.read(newEpisodeProvider.notifier).state = Episode(
      course: ref.read(currentCourseProivder),
    );
  }

  Future<void> setEpisodeImage() async {
    final imageData = await AnyFileService.getImage();
    if (imageData.isNotEmpty) {
      setState(() {
        _imageData = imageData;
      });
    }
  }

  Future<void> setEpisodeVideo() async {
    final videoData = await AnyFileService.getVideo();
    if (videoData.isNotEmpty) {
      setState(() {
        _videoData = videoData;
      });
    }
  }

  void createEpisode() async {
    final newEpisode = ref.watch(newEpisodeProvider);
    if (await PocketClient.createEpisode(
      newEpisode,
      _imageData!,
      _videoData!,
    )) {
      resetProvider();
      context.goNamed(
        "ViewCourse",
        params: {'courseId': newEpisode.course!.model!.id},
      );
    }
  }

  bool canSubmit() {
    final episodeData = ref.watch(newEpisodeProvider);

    return episodeData.title.isNotEmpty &&
        episodeData.description.isNotEmpty &&
        _imageData != null &&
        _videoData != null;
  }

  @override
  Widget build(BuildContext context) {
    final newEpisodeData = ref.watch(newEpisodeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.goNamed(
              "ViewCourse",
              params: {'courseId': newEpisodeData.course!.model!.id},
            );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Create a new episode:",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 40.0,
                  ),
                ),
              ),
              Row(
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
                              ref
                                  .read(newEpisodeProvider.notifier)
                                  .state
                                  .title = value;
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
                                  .read(newEpisodeProvider.notifier)
                                  .state
                                  .description = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 260.0,
                    height: 260.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setEpisodeImage();
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
                      SizedBox(
                        width: 260.0,
                        height: 260.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setEpisodeVideo();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.upload,
                                size: 50.0,
                              ),
                              Text(
                                "Upload Video",
                                style: TextStyle(
                                  fontSize: 30.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "Status: ${_videoData != null ? "uploaded" : "waiting"}",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: _videoData != null ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
              Container(
                color: Colors.grey,
                child: EpisodeTile(
                  newEpisodeData,
                  image: _imageData != null ? MemoryImage(_imageData!) : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(100.0, 50.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                  ),
                  onPressed: canSubmit()
                      ? () {
                          createEpisode();
                        }
                      : null,
                  child: const Text('Submit'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
