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

class _VideoPlayerState extends State<AnyLearnVideoPlayer>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late Future<void> _initPlayerFuture;
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _videoController = VideoPlayerController.network(widget.videoLink);

    _videoController.addListener(() {
      if (_videoController.value.isPlaying) {
        setState(() {
          _controller.forward();
        });
      } else {
        setState(() {
          _controller.reverse();
        });
      }
    });

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
    return MouseRegion(
      child: Column(
        children: [
          Container(
            height: 200.0,
            width: 500.0,
            color: secondarySurface,
            child: FutureBuilder(
              future: _initPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        height: _videoController.value.size?.height ?? 0,
                        width: _videoController.value.size?.width ?? 0,
                        child: VideoPlayer(_videoController),
                      ),
                    ),
                  );
                }
                return const CircularProgressIndicator(
                  color: secondaryColor,
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            width: 500.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (_videoController.value.isPlaying) {
                      _videoController.pause();
                      _controller.reverse();
                    } else {
                      if (_videoController.value.position ==
                          _videoController.value.duration) {
                        _videoController.seekTo(Duration.zero);
                      }
                      _videoController.play();
                      _controller.forward();
                    }
                  },
                  color: Colors.white,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: Tween<double>(begin: 0.0, end: 1.0)
                        .animate(_controller),
                  ),
                ),
                Slider(
                  value: _videoController.value.position.inSeconds > 0
                      ? _videoController.value.position.inSeconds /
                          _videoController.value.duration.inSeconds
                      : 0,
                  onChanged: (value) {
                    setState(
                      () {
                        _videoController
                            .seekTo(_videoController.value.duration * value);
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
