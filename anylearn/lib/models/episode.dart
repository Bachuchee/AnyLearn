import 'package:pocketbase/pocketbase.dart';

import 'course.dart';

class Episode {
  Episode({
    this.episodeNumber = 0,
    this.title = "",
    this.description = "",
    this.thumbnailName = "",
    this.videoName = "",
    this.course,
  });

  int episodeNumber;
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
  )   : episodeNumber = json['episode_number'],
        title = json['title'],
        description = json['description'],
        thumbnailName = json['thumbnail'],
        videoName = json['video'];

  Map<String, dynamic> toJson() => {
        'episode_number': episodeNumber,
        'title': title,
        'description': description,
        'course_id': course!.id,
      };
}
