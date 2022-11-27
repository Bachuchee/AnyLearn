class User {
  User(this.id, this.username, this.email, this.about, this.avatarName);

  final String id;
  final String email;
  final String username;
  final String about;
  final String avatarName;

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
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
