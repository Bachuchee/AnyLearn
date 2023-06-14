import 'package:anylearn/models/topic.dart';
import 'package:anylearn/models/user.dart';
import 'package:pocketbase/pocketbase.dart';

class Course {
  Course({
    this.id = '',
    this.title = '',
    this.description = '',
    this.user,
    this.imageName = '',
    this.model,
    this.rating = 0,
  });

  final String id;
  double rating = 0;
  String title;
  String description;
  String imageName;
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

  void removeTopic(Topic topic) {
    topics.remove(topic);
  }

  DateTime get created {
    final dateList = model?.created.split(" ")[0].split("-") ?? [];
    if (dateList.isEmpty) {
      return DateTime(0);
    }
    return DateTime(
      int.parse(dateList[0]),
      int.parse(dateList[1]),
      int.parse(dateList[2]),
    );
  }

  int compare(Course other) {
    return created.compareTo(other.created);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'user_id': user!.id,
      };
}
