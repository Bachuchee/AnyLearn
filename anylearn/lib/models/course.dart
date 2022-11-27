import 'package:anylearn/models/topic.dart';
import 'package:anylearn/models/user.dart';
import 'package:pocketbase/pocketbase.dart';

class Course {
  Course(
      {this.id,
      this.title,
      this.description,
      this.user,
      this.imageName,
      this.model});

  final String? id;
  final String? title;
  final String? description;
  final String? imageName;
  final User? user;
  final RecordModel? model;
  final List<Topic> topics = [];

  Course.fromJson(Map<String, dynamic> json, this.model, RecordModel userModel)
      : id = model!.id,
        title = json['title'],
        description = json['description'],
        user = User.fromJson(userModel.data, userModel),
        imageName = json['image'];

  void addTopic(Topic topic) {
    topics.add(topic);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'imageName': imageName,
        'user': user!.toJson()
      };
}
