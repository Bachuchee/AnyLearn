import 'package:anylearn/views/menu/menu.dart';
import 'package:anylearn/views/shared/notification_window/notification_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../../models/pocket_client.dart';
import '../main-app-bar.dart';

class PageScaffold extends ConsumerStatefulWidget {
  const PageScaffold({super.key, required this.content, this.appbarExtension});

  final Widget content;
  final PreferredSizeWidget? appbarExtension;

  @override
  ConsumerState<PageScaffold> createState() => _PageScaffoldState();
}

class _PageScaffoldState extends ConsumerState<PageScaffold>
    with SingleTickerProviderStateMixin {
  final _client = PocketClient.client;

  bool _showWindow = false;

  Future<void> liveNotifications() async {
    try {
      while (true) {
        ref.read(notificationProvider.notifier).state =
            await PocketClient.getUserNotifications(PocketClient.model.id);

        Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    liveNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showWindow = false),
      child: Scaffold(
        appBar: MainAppBar(
          userImage: NetworkImage(
            _client
                .getFileUrl(
                    PocketClient.model, PocketClient.model.data['avatar'])
                .toString(),
          ),
          appbarExtension: widget.appbarExtension,
          onClickNotification: () {
            setState(() => _showWindow = !_showWindow);
          },
          showWindow: _showWindow,
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MenuPage(),
                const VerticalDivider(
                  width: 1.0,
                  thickness: 1.0,
                ),
                Expanded(child: widget.content),
              ],
            ),
            if (_showWindow)
              const Align(
                alignment: Alignment.topRight,
                child: NotificationWindow(),
              ),
          ],
        ),
      ),
    );
  }
}
