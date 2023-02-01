import 'package:anylearn/views/shared/profile-avatar.dart';
import 'package:flutter/material.dart';

import '../../Theme/colors.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  MainAppBar({
    super.key,
    this.userImage,
    this.appbarExtension,
  }) : preferredSize = Size.fromHeight(
          (appbarExtension == null ? kToolbarHeight : kToolbarHeight + 50.0),
        );

  final ImageProvider? userImage;
  final PreferredSizeWidget? appbarExtension;

  @override
  final Size preferredSize;

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
              Icons.notifications_none,
              color: secondaryColor,
            ),
          ),
        ),
        ProfileAvatar(userImage: widget.userImage),
      ],
      bottom: widget.appbarExtension,
    );
  }
}
