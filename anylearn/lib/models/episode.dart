import 'package:pocketbase/pocketbase.dart';

import 'course.dart';

class Episode {
  Episode({
    this.title = "",
    this.description = "",
    this.thumbnailName = "",
    this.videoName = "",
    this.course,
  });

  String title;
  String description;
  String thumbnailName;
  String videoName;
  Course? course;
  RecordModel? episodeModel;

  Episode.fromJson(
    Map<String, dynamic> json,
    RecordModel this.episodeModel,
    Course this.course,
  )   : title = json['title'],
        description = json['description'],
        thumbnailName = json['thumbnail'],
        videoName = json['video'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'course_id': course!.id,
      };
}
