import 'package:anylearn/models/episode.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pod_player/pod_player.dart';
import 'package:video_player/video_player.dart';

import '../../Theme/colors.dart';
import '../../models/pocket_client.dart';
import '../shared/profile-avatar.dart';
import '../view_course/view_course.dart';

final episodeProvider = StateProvider<Episode>((ref) => Episode());

class ViewEpisode extends ConsumerStatefulWidget {
  const ViewEpisode({super.key, this.episodeId = ""});

  final String episodeId;

  @override
  ConsumerState<ViewEpisode> createState() => _ViewEpisodeState();
}

class _ViewEpisodeState extends ConsumerState<ViewEpisode> {
  final _client = PocketClient.client;

  late final Future<void> _initVid;

  late final PodPlayerController _podController;

  Future<void> setUpData() async {
    ref.read(episodeProvider.notifier).state =
        await PocketClient.getEpisode(widget.episodeId);

    final episode = ref.watch(episodeProvider);

    _podController = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(
        _client.getFileUrl(episode.episodeModel!, episode.videoName).toString(),
      ),
    )..initialise();
  }

  @override
  void initState() {
    super.initState();

    _initVid = setUpData();
  }

  @override
  void dispose() {
    super.dispose();
    _podController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final episode = ref.watch(episodeProvider);
    final md = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/Logo.png',
          height: 200.0,
          width: 200.0,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: secondaryColor,
          onPressed: () {
            context.goNamed("ViewCourse",
                params: {"courseId": episode.course!.id});
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
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: _initVid,
              builder: (context, snapshot) => snapshot.connectionState ==
                      ConnectionState.done
                  ? PodVideoPlayer(
                      controller: _podController,
                      videoThumbnail: DecorationImage(
                        image: NetworkImage(
                          _client
                              .getFileUrl(
                                  episode.episodeModel!, episode.thumbnailName)
                              .toString(),
                        ),
                        fit: BoxFit.cover,
                      ),
                      podProgressBarConfig: const PodProgressBarConfig(
                        backgroundColor: secondarySurface,
                        playingBarColor: secondaryColor,
                        circleHandlerColor: secondaryColor,
                        circleHandlerRadius: 0.0,
                      ),
                    )
                  : Container(
                      height: md.size.height * 1.1,
                      width: md.size.width * 0.4,
                      color: Colors.grey,
                    ),
            ),
          ),
          ListTile(
            title: Text(
              "Chapter #${episode.episodeNumber}",
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 14.0,
              ),
            ),
            subtitle: Text(
              episode.title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  episode.description,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
