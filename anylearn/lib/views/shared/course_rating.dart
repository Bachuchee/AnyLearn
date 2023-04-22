import 'package:flutter/material.dart';

class CourseRating extends StatelessWidget {
  const CourseRating(this.courseRating, {Key? key}) : super(key: key);

  final double courseRating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            children: [
              Text(
                courseRating.toString(),
                style: TextStyle(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1.5
                    ..color = Colors.black,
                ),
              ),
              // Solid text as fill.
              Text(
                courseRating.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.star,
            color: Colors.amber,
          )
        ],
      ),
    );
  }
}
