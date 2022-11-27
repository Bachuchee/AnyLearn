import 'package:anylearn/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    this.user,
    this.courseImage,
    this.courseTitle,
    this.courseChips,
  });

  final Image? courseImage;
  final User? user;
  final String? courseTitle;
  final List<String>? courseChips;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
