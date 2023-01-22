import 'package:anylearn/Theme/colors.dart';
import 'package:anylearn/models/course.dart';
import 'package:anylearn/models/pocket_client.dart';
import 'package:anylearn/views/home/components/CourseCard.dart';
import 'package:anylearn/views/menu/menu.dart';
import 'package:anylearn/views/shared/profile-avatar.dart';
import 'package:anylearn/views/view_course/components/episode_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/episode.dart';

final currentCourseProivder = StateProvider<Course>((ref) => Course());

class ViewCourse extends ConsumerStatefulWidget {
  const ViewCourse({super.key, this.courseId = ''});

  final String courseId;

  @override
  ConsumerState<ViewCourse> createState() => _ViewCourseState();
}

class _ViewCourseState extends ConsumerState<ViewCourse> {
  final _client = PocketClient.client;

  List<Episode> _episodeList = [];

  Future<void> getCourse() async {
    final course = ref.read(currentCourseProivder);
    if (course.id != widget.courseId) {
      ref.read(currentCourseProivder.notifier).state =
          await PocketClient.getCourseById(widget.courseId);
    }
  }

  Future<void> getEpisodes() async {
    final course = ref.read(currentCourseProivder);
    PocketClient.getCourseEpisodes(course).then(
      (value) => setState(
        () {
          _episodeList = value;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCourse();
    getEpisodes();
  }

  @override
  Widget build(BuildContext context) {
    final course = ref.watch(currentCourseProivder);
    final isCreator = (PocketClient.model.id == course.user!.id);

    List<Widget> widgetList = [
      ListTile(
        leading: Hero(
          tag: profileTagTemplate + course.id,
          child: ProfileAvatar(
            userImage: NetworkImage(_client
                .getFileUrl(
                  course.user!.model!,
                  course.user!.avatarName,
                )
                .toString()),
          ),
        ),
        title: const Text("By"),
        subtitle: Hero(
          tag: usernameTemplate + course.id,
          child: Text(
            course.user!.username,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: secondaryColor,
            ),
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.description),
        title: Text(course.description),
      ),
      const Divider(
        height: 1.0,
        thickness: 1.0,
        indent: 16.0,
        endIndent: 16.0,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: const Text(
            "Chapters:",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: isCreator
              ? IconButton(
                  onPressed: () {
                    context.goNamed('NewEpisode');
                  },
                  icon: const Icon(Icons.add))
              : null,
        ),
      ),
    ];

    for (final episode in _episodeList) {
      widgetList.add(EpisodeTile(
        episode,
        image: NetworkImage(
          _client
              .getFileUrl(episode.episodeModel!, episode.thumbnailName)
              .toString(),
        ),
      ));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar.large(
            backgroundColor: secondarySurface,
            stretch: true,
            onStretchTrigger: () {
              // Function callback for stretch
              return Future<void>.value();
            },
            title: Text(
              course.title,
              style: const TextStyle(
                color: secondaryColor,
                fontSize: 12.0,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                final destinationIndex = ref.watch(indexProvider);
                String destination = destinations[destinationIndex];
                context.goNamed(destination);
              },
            ),
            actions: [
              ProfileAvatar(
                userImage: NetworkImage(
                  _client
                      .getFileUrl(
                          PocketClient.model, PocketClient.model.data['avatar'])
                      .toString(),
                ),
              ),
            ],
            expandedHeight: 500.0,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                  centerTitle: true,
                  title: Hero(
                    tag: textTagTemplate + course.id,
                    child: Text(
                      course.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Hero(
                        tag: courseTagTemplate + course.id,
                        child: Image.network(
                          _client
                              .getFileUrl(course.model!, course.imageName)
                              .toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, -0.7),
                            colors: <Color>[
                              Color(0x60000000),
                              Color(0x00000000),
                            ],
                          ),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, 1.0),
                            end: Alignment(0.0, 0.5),
                            colors: <Color>[
                              Color(0x60000000),
                              Color(0x00000000),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              widgetList,
            ),
          ),
        ],
      ),
    );
  }
}
