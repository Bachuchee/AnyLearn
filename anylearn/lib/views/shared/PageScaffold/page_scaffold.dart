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
  late AnimationController _contoller;

  @override
  void initState() {
    super.initState();
    _contoller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _contoller.dispose();
    super.dispose();
  }

  bool _isDrawerOpen() {
    return _contoller.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _contoller.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _contoller.value == 0.0;
  }

  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _contoller.reverse();
    } else {
      _contoller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        userImage: NetworkImage(
          _client
              .getFileUrl(PocketClient.model, PocketClient.model.data['avatar'])
              .toString(),
        ),
        onClickMenu: _toggleDrawer,
        menuOpened: () {
          return _isDrawerOpen() || _isDrawerOpening();
        },
        appbarExtension: widget.appbarExtension,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          widget.content,
          _buildMenuDrawer(context),
        ],
      ),
    );
  }

  Widget _buildMenuDrawer(BuildContext context) {
    return AnimatedBuilder(
      animation: _contoller,
      builder: (context, child) => FractionalTranslation(
        translation: Offset(1.0 - _contoller.value, 0.0),
        child: _isDrawerClosed()
            ? const SizedBox()
            : MenuPage(
                actionList: [
                  () {
                    context.go('/');
                  },
                  () {},
                  () {},
                  () {},
                ],
              ),
      ),
    );
  }
}
