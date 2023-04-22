import 'package:anylearn/models/pocket_client.dart';
import 'package:anylearn/views/shared/profile-avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Theme/colors.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  MainAppBar({
    super.key,
    this.userImage,
    this.appbarExtension,
    this.onClickNotification,
    required this.showWindow,
  }) : preferredSize = Size.fromHeight(
          (appbarExtension == null ? kToolbarHeight : kToolbarHeight + 50.0),
        );

  final ImageProvider? userImage;
  final PreferredSizeWidget? appbarExtension;
  final void Function()? onClickNotification;
  final bool showWindow;

  @override
  final Size preferredSize;

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  bool _newNotifications = false;

  Future<void> checkForNewNotifications() async {
    try {
      while (true) {
        Future.delayed(const Duration(milliseconds: 500));

        final status =
            await PocketClient.checkUnreadNotifications(PocketClient.model.id);

        setState(() {
          _newNotifications = status;
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();

    checkForNewNotifications();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'assets/images/Logo.png',
        height: 200.0,
        width: 200.0,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: widget.onClickNotification,
            icon: Icon(
              _newNotifications
                  ? widget.showWindow
                      ? Icons.notifications_active
                      : Icons.notifications_active_outlined
                  : widget.showWindow
                      ? Icons.notifications_rounded
                      : Icons.notifications_none,
              color: secondaryColor,
            ),
          ),
        ),
        ProfileAvatar(
          userImage: widget.userImage,
          onClick: () {
            context.goNamed(
              'UserProfile',
              params: {'userId': PocketClient.model.id},
            );
          },
        ),
      ],
      bottom: widget.appbarExtension,
    );
  }
}
