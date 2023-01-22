import 'package:anylearn/models/episode.dart';
import 'package:anylearn/views/view_episode/components/videoplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Theme/colors.dart';
import '../../models/pocket_client.dart';
import '../shared/profile-avatar.dart';
import '../view_course/view_course.dart';

final episodeProvider = StateProvider<Episode>((ref) => Episode());

class ViewEpisode extends ConsumerStatefulWidget {
  ViewEpisode({super.key, this.episodeId = ""});

  String episodeId;

  @override
  ConsumerState<ViewEpisode> createState() => _ViewEpisodeState();
}

class _ViewEpisodeState extends ConsumerState<ViewEpisode> {
  final _client = PocketClient.client;

  Future<void> getEpisode() async {
    ref.read(episodeProvider.notifier).state =
        await PocketClient.getEpisode(widget.episodeId);
  }

  @override
  Widget build(BuildContext context) {
    final episode = ref.watch(episodeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
            userImage: NetworkImage(
              _client
                  .getFileUrl(
                      PocketClient.model, PocketClient.model.data['avatar'])
                  .toString(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: episode.videoName != ""
                ? AnyLearnVideoPlayer(
                    _client
                        .getFileUrl(episode.episodeModel!, episode.videoName)
                        .toString(),
                  )
                : const CircularProgressIndicator(color: secondaryColor),
          ),
        ],
      ),
    );
  }
}
