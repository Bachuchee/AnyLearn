import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/pocket_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pocketClient = PocketClient.getClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: const Center(
        child: SelectableText("Hello :)"),
      ),
    );
  }
}
