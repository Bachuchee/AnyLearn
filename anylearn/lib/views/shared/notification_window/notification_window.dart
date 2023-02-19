import 'package:anylearn/Theme/colors.dart';
import 'package:anylearn/models/notification.dart';
import 'package:anylearn/models/pocket_client.dart';
import 'package:anylearn/views/shared/notification_window/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider = StateProvider<List<AppNotification>>((ref) => []);

class NotificationWindow extends ConsumerStatefulWidget {
  const NotificationWindow({super.key});

  @override
  ConsumerState<NotificationWindow> createState() => _NotificationWindowState();
}

class _NotificationWindowState extends ConsumerState<NotificationWindow> {
  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Card(
          child: ListView.separated(
            itemCount: notifications.length + 1,
            itemBuilder: (context, index) => index > 0
                ? NotificationTile(
                    notifications[index - 1],
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Notifications",
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ),
    );
  }
}
