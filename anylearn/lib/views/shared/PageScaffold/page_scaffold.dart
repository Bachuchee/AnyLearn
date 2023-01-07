import 'package:anylearn/views/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/pocket_client.dart';
import '../main-app-bar.dart';

class PageScaffold extends StatefulWidget {
  const PageScaffold({super.key, required this.content, this.appbarExtension});

  final Widget content;
  final PreferredSizeWidget? appbarExtension;

  @override
  State<PageScaffold> createState() => _PageScaffoldState();
}

class _PageScaffoldState extends State<PageScaffold>
    with SingleTickerProviderStateMixin {
  final _client = PocketClient.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        userImage: NetworkImage(
          _client
              .getFileUrl(PocketClient.model, PocketClient.model.data['avatar'])
              .toString(),
        ),
        appbarExtension: widget.appbarExtension,
      ),
      resizeToAvoidBottomInset: false,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MenuPage(actionList: []),
          const VerticalDivider(
            width: 1.0,
            thickness: 1.0,
          ),
          Expanded(child: widget.content),
        ],
      ),
    );
  }
}
