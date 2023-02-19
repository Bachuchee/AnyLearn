import 'package:anylearn/views/menu/menu.dart';
import 'package:anylearn/views/user_follows/UserCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/pocket_client.dart';
import '../../models/user.dart';

class UserFollows extends ConsumerStatefulWidget {
  const UserFollows({super.key});

  @override
  ConsumerState<UserFollows> createState() => _UserFollowsState();
}

class _UserFollowsState extends ConsumerState<UserFollows> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    PocketClient.getFollowerUsers(PocketClient.model.id).then(
      (value) => setState(() => users = value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 24.0,
        crossAxisSpacing: 30.0,
        childAspectRatio: 1.4,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) => UserCard(users[index]),
    );
  }
}
