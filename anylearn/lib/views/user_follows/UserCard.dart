import 'package:anylearn/Theme/colors.dart';
import 'package:anylearn/models/pocket_client.dart';
import 'package:anylearn/views/shared/profile-avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';

import '../../models/user.dart';

class UserCard extends StatefulWidget {
  const UserCard(this.user, {super.key});

  final User user;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProfileAvatar(
            userImage: NetworkImage(PocketClient.client
                .getFileUrl(widget.user.model!, widget.user.avatarName)
                .toString()),
            size: 100.0,
            onClick: () {
              context
                  .goNamed('UserProfile', params: {'userId': widget.user.id});
            },
          ),
        ),
        Text(
          widget.user.username,
          style: const TextStyle(
            color: secondaryColor,
            fontSize: 24.0,
          ),
        )
      ],
    );
  }
}
