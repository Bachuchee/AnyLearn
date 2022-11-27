import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../Theme/colors.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    this.userImage,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  final ImageProvider? userImage;

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
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: secondaryColor,
        ),
        onPressed: () {},
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
              image: widget.userImage != null
                  ? DecorationImage(image: widget.userImage!, fit: BoxFit.cover)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
