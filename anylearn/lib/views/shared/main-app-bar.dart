import 'package:anylearn/views/shared/profile-avatar.dart';
import 'package:flutter/material.dart';

import '../../Theme/colors.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    this.userImage,
    required this.onClickMenu,
    required this.menuOpened,
    this.appbarExtension,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  final ImageProvider? userImage;
  final void Function() onClickMenu;
  final bool Function() menuOpened;
  final Widget? appbarExtension;

  @override
  final Size preferredSize;

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(microseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _iconController,
          color: secondaryColor,
        ),
        onPressed: () {
          setState(() {
            _isPlaying = !_isPlaying;
            _isPlaying ? _iconController.forward() : _iconController.reverse();
            widget.onClickMenu();
          });
        },
      ),
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
              Icons.search,
              color: secondaryColor,
            ),
          ),
        ),
        ProfileAvatar(userImage: widget.userImage),
      ],
    );
  }
}
