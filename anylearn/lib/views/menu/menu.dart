import 'package:anylearn/Theme/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.actionList});

  final List<void Function()> actionList;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  final items = [
    'Home',
    'My Courses',
    'Ongoing Courses',
    'Following',
  ];
  final _assets = const [
    AssetImage("images/menu_image.jpg"),
    AssetImage("images/course_image.jpg"),
    AssetImage("images/ongoing_image.jpg"),
    AssetImage("images/following_image.jpg"),
  ];
  final _imageShowing = [
    false,
    false,
    false,
    false,
  ];
  late final ScrollController _controller;
  double? _imageX = 0;
  double? _imageY = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void scrollSetter(PointerHoverEvent event) {
    final scrollPrecent =
        event.position.dy / MediaQuery.of(context).size.height;
    _controller.jumpTo(
      _controller.position.maxScrollExtent * scrollPrecent,
    );
    setState(() {
      _imageX = event.position.dx;
      _imageY = event.position.dy;
    });
  }

  void enterImage(int index) => _imageShowing[index] = true;

  void exitImage(int index) => _imageShowing[index] = false;

  @override
  Widget build(BuildContext context) {
    final _widgetList = <Widget>[];

    for (int i = 0; i < _imageShowing.length; i++) {
      _widgetList.add(
        Positioned(
          top: _imageY! - 500.0,
          left: _imageX! - 300.0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            curve: Curves.bounceIn,
            opacity: _imageShowing[i] ? 0.9 : 0.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: _imageShowing[i] ? 1000.0 : 900.0,
              width: _imageShowing[i] ? 600.0 : 450.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _assets[i],
                ),
              ),
            ),
          ),
        ),
      );
    }

    _widgetList.add(
      ListView.builder(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          vertical: 500.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) => OffMenuItem(
          items[i],
          () {
            enterImage(i);
          },
          () {
            exitImage(i);
          },
          action: widget.actionList[i],
        ),
      ),
    );

    return Scaffold(
      body: Container(
        color: secondarySurface,
        child: MouseRegion(
          onHover: scrollSetter,
          child: Stack(
            children: _widgetList,
          ),
        ),
      ),
    );
  }
}

class OffMenuItem extends StatefulWidget {
  const OffMenuItem(this.text, this.onEnter, this.onExit, {this.action});

  final String text;
  final void Function()? action;
  final Function() onEnter;
  final Function() onExit;

  @override
  State<OffMenuItem> createState() {
    return _OffMenuItemState();
  }
}

class _OffMenuItemState extends State<OffMenuItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(
        () {
          _hovered = true;
          widget.onEnter();
        },
      ),
      onExit: (event) => setState(
        () {
          _hovered = false;
          widget.onExit();
        },
      ),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.action,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              height: 10,
              thickness: 1,
              indent: 50.0,
              endIndent: 50.0,
              color: _hovered ? secondaryColor : Colors.transparent,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50.0, 10.0, 0.0, 10.0),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: _hovered
                      ? secondaryColor
                      : secondaryColor.withOpacity(0.5),
                  fontSize: 150.0,
                ),
              ),
            ),
            Divider(
              height: 10,
              thickness: 1,
              indent: 50.0,
              endIndent: 50.0,
              color: _hovered ? secondaryColor : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
