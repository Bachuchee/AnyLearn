import 'package:anylearn/Theme/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/pocket_client.dart';

final indexProvider = StateProvider<int>((ref) => 0);
const destinations = [
  "Home",
  "UserCourses",
  "OngoingCourses",
  "Following",
  'Admin-Dashboard',
];

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage>
    with SingleTickerProviderStateMixin {
  final _items = [
    'Home',
    'My Courses',
    'Ongoing Courses',
    'Following',
    'Admin'
  ];

  final _actionList = [
    (BuildContext context) {
      context.go('/');
    },
    (BuildContext context) {
      context.go('/user-courses');
    },
    (BuildContext context) {
      context.go('/ongoing-courses');
    },
    (BuildContext context) {
      context.goNamed('Following');
    },
    (BuildContext context) {
      context.goNamed('Admin-Dashboard');
    },
  ];

  @override
  Widget build(BuildContext context) {
    int index = ref.watch(indexProvider);

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
          label: Text(_items[0]),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.dataset_outlined),
          selectedIcon: const Icon(Icons.dataset_rounded),
          label: Text(_items[1]),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.dataset_linked_outlined),
          selectedIcon: const Icon(Icons.dataset_linked),
          label: Text(_items[2]),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.person_outlined),
          selectedIcon: const Icon(Icons.person),
          label: Text(_items[3]),
        ),
        if (PocketClient.isAdmin)
          NavigationRailDestination(
            icon: const Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: const Icon(Icons.admin_panel_settings),
            label: Text(_items[4]),
          )
      ],
      selectedIndex: index,
      minWidth: MediaQuery.of(context).size.width * 0.05,
      onDestinationSelected: (value) {
        ref.read(indexProvider.notifier).state = value;
        _actionList[value](context);
      },
    );
  }
}
