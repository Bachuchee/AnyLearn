import 'package:flutter/material.dart';

import 'components/CourseCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: const Center(
        child: CourseCard(
          username: "Bachuchee",
          courseImage: AssetImage('assets/images/login_splash.jpg'),
          userImage: AssetImage('assets/images/DefaultAvatar.jpg'),
          courseTitle: "The best introduction to programming",
          courseChips: ["Science", "Programming", "Python"],
        ),
      ),
    );
  }
}
