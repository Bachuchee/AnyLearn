import 'package:anylearn/Theme/colors.dart';
import 'package:anylearn/models/notification.dart';
import 'package:anylearn/models/pocket_client.dart';
import 'package:anylearn/views/shared/profile-avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../view_course/view_course.dart';

class NotificationTile extends ConsumerStatefulWidget {
  const NotificationTile(this.notification, {super.key});

  final AppNotification notification;

  @override
  ConsumerState<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends ConsumerState<NotificationTile> {
  final _client = PocketClient.client;

  Future<void> viewCourse() async {
    ref.read(currentCourseProivder.notifier).state =
        widget.notification.relatedCourse!;

    PocketClient.markNotificationRead(widget.notification.id);

    context.goNamed(
      "ViewCourse",
      params: {'courseId': widget.notification.relatedCourse!.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfileAvatar(
        userImage: NetworkImage(
          _client
              .getFileUrl(
                widget.notification.relatedUser.model!,
                widget.notification.relatedUser.avatarName,
              )
              .toString(),
        ),
        size: 40.0,
      ),
      trailing: widget.notification.wasRead
          ? const Icon(
              Icons.done,
              color: Colors.green,
            )
          : IconButton(
              icon: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              onPressed: () =>
                  PocketClient.markNotificationRead(widget.notification.id),
            ),
      title: Text(
        widget.notification.message,
        style: const TextStyle(
          color: secondaryColor,
        ),
      ),
      onTap: widget.notification.relatedCourse != null ? viewCourse : null,
    );
  }
}
