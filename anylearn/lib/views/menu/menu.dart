import 'package:anylearn/Theme/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      useIndicator: true,
      indicatorColor: secondarySurface,
      selectedIconTheme: const IconThemeData(color: secondaryColor),
      selectedLabelTextStyle: const TextStyle(color: secondaryColor),
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home_filled),
          label: Text(items[0]),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.dataset_outlined),
          selectedIcon: const Icon(Icons.dataset_rounded),
          label: Text(items[1]),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.dataset_linked_outlined),
          selectedIcon: const Icon(Icons.dataset_linked),
          label: Text(items[2]),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.person_outlined),
          selectedIcon: const Icon(Icons.person),
          label: Text(items[3]),
        ),
      ],
      selectedIndex: _index,
      minWidth: MediaQuery.of(context).size.width * 0.05,
      onDestinationSelected: (value) {
        setState(() {
          _index = value;
        });
      },
    );
  }
}
