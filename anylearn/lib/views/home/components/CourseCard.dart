import 'package:anylearn/Theme/colors.dart';
import 'package:flutter/material.dart';

import '../../../models/topic.dart';
import '../../shared/course_rating.dart';

const courseTagTemplate = "CourseImage_";
const profileTagTemplate = "ProfileImage_";
const textTagTemplate = "CourseTitle_";
const usernameTemplate = "UserName_";
const ratingTemplate = "Rating_";

class CourseCard extends StatefulWidget {
  const CourseCard({
    super.key,
    this.username,
    this.courseImage,
    this.userImage,
    this.courseTitle,
    this.courseRating = 0,
    required this.courseId,
    required this.onClick,
    required this.courseChips,
  });

  final ImageProvider? courseImage;
  final ImageProvider? userImage;
  final void Function() onClick;
  final String? username;
  final String? courseTitle;
  final String courseId;
  final double courseRating;
  final List<Topic> courseChips;

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Material(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: InkWell(
            customBorder: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            onTap: () {
              widget.onClick();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 14,
                  child: Stack(
                    children: [
                      Hero(
                        tag: courseTagTemplate + widget.courseId,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12.0),
                            ),
                            color: Colors.grey,
                            image: widget.courseImage != null
                                ? DecorationImage(
                                    image: widget.courseImage!,
                                    fit: BoxFit.cover)
                                : null,
                          ),
                        ),
                      ),
                      if (widget.courseRating > 0)
                        Align(
                          alignment: Alignment.topRight,
                          child: Hero(
                            tag: ratingTemplate + widget.courseId,
                            child: CourseRating(widget.courseRating),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Hero(
                      tag: textTagTemplate + widget.courseId,
                      child: Text(
                        widget.courseTitle != null ? widget.courseTitle! : " ",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Hero(
                          tag: profileTagTemplate + widget.courseId,
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              image: widget.userImage != null
                                  ? DecorationImage(
                                      image: widget.userImage!,
                                      fit: BoxFit.cover)
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Hero(
                          tag: usernameTemplate + widget.courseId,
                          child: Text(
                            widget.username != null ? widget.username! : " ",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14, color: secondaryColor),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.courseChips.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Chip(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                ),
                                label: Text(
                                  widget.courseChips[index].name,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
