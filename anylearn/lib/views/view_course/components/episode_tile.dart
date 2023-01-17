import 'package:anylearn/models/pocket_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../models/episode.dart';

class EpisodeTile extends StatefulWidget {
  const EpisodeTile(this.episode, {super.key});

  final Episode episode;

  @override
  State<EpisodeTile> createState() => _EpisodeTileState();
}

class _EpisodeTileState extends State<EpisodeTile> {
  final _client = PocketClient.client;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: InkWell(
          onTap: () {},
          mouseCursor: MaterialStateMouseCursor.clickable,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              visualDensity: const VisualDensity(vertical: 3),
              leading: Image.network(
                _client
                    .getFileUrl(widget.episode.episodeModel!,
                        widget.episode.thumbnailName)
                    .toString(),
                scale: 2.0,
              ),
              title: Text(widget.episode.title),
            ),
          ),
        ),
      ),
    );
  }
}
