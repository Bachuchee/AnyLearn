import 'package:anylearn/Theme/colors.dart';
import 'package:anylearn/models/pocket_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../models/episode.dart';

class EpisodeTile extends StatefulWidget {
  const EpisodeTile(
    this.episode, {
    super.key,
    this.onClick,
    this.onDelete,
    this.image,
    this.isCreator = false,
  });

  final Episode episode;
  final void Function()? onClick;
  final void Function()? onDelete;
  final ImageProvider<Object>? image;
  final bool isCreator;

  @override
  State<EpisodeTile> createState() => _EpisodeTileState();
}

class _EpisodeTileState extends State<EpisodeTile> {
  final _client = PocketClient.client;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: InkWell(
          onTap: widget.onClick,
          onHover: (value) {
            setState(() => _isHovering = value);
          },
          mouseCursor: MaterialStateMouseCursor.clickable,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              visualDensity: const VisualDensity(vertical: 3),
              leading: widget.image != null
                  ? Image(
                      image: widget.image!,
                    )
                  : null,
              title: Text(
                widget.episode.title,
                style: TextStyle(color: secondaryColor),
              ),
              subtitle: Text(
                widget.episode.description,
                style: TextStyle(color: secondaryColor.withOpacity(0.7)),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: widget.isCreator && _isHovering
                  ? IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: widget.onDelete,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
