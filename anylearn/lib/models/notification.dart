import 'package:anylearn/models/course.dart';
import 'package:anylearn/models/user.dart';

class AppNotification {
  const AppNotification(
    this.id,
    this.relatedCourse,
    this.relatedUser,
    this.message,
    this.wasRead,
  );

  final String id;
  final Course? relatedCourse;
  final User relatedUser;
  final String message;
  final bool wasRead;
}
