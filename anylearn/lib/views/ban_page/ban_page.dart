import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BanPage extends StatelessWidget {
  const BanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Banned")),
      body: const Center(
        child: Text("It looks like the ban hammer hit you"),
      ),
    );
  }
}
