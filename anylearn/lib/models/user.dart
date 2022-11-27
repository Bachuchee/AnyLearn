import 'package:pocketbase/pocketbase.dart';

class User {
  User(this.id, this.username, this.email, this.about, this.avatarName,
      this.model);

  final String id;
  final String email;
  final String username;
  final String about;
  final String avatarName;
  final RecordModel? model;

  User.fromJson(Map<String, dynamic> json, this.model)
      : id = model!.id,
        email = json['email'],
        username = json['username'],
        about = json['about'],
        avatarName = json['avatar'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'about': about,
        'avatarName': avatarName,
      };
}
