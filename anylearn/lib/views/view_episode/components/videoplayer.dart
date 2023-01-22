import 'package:anylearn/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class AnyLearnVideoPlayer extends StatefulWidget {
  AnyLearnVideoPlayer(this.videoLink, {super.key});

  String videoLink;

  @override
  State<AnyLearnVideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<AnyLearnVideoPlayer> {
  late VideoPlayerController _videoController;
  late Future<void> _initPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _videoController = VideoPlayerController.network(widget.videoLink);

    _initPlayerFuture = _videoController.initialize();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _videoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        mouseCursor: MouseCursor.uncontrolled,
        onTap: () {
          if (_videoController.value.isPlaying) {
            _videoController.pause();
          } else {
            _videoController.play();
          }
        },
        child: Container(
          height: 200.0,
          width: 300.0,
          color: secondarySurface,
          child: FutureBuilder(
            future: _initPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: 200.0 / 300.0,
                  child: VideoPlayer(_videoController),
                );
              }
              return const CircularProgressIndicator(
                color: secondaryColor,
              );
            },
          ),
        ),
      ),
    );
  }
}
