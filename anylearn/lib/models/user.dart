import 'package:anylearn/models/topic.dart';
import 'package:pocketbase/pocketbase.dart';

class User {
  User({
    this.id = "",
    this.username = "",
    this.about = "",
    this.avatarName = "",
    this.model,
  });

  String id;
  String username;
  String about;
  String avatarName;
  List<Topic> topics = [];
  RecordModel? model;

  User.fromJson(Map<String, dynamic> json, this.model)
      : id = model!.id,
        username = json['username'],
        about = json['about'],
        avatarName = json['avatar'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'about': about,
        'avatarName': avatarName,
      };
}
