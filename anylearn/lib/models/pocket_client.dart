import 'package:anylearn/models/topic.dart';
import 'package:anylearn/models/user.dart';
import 'package:pocketbase/pocketbase.dart';

import 'course.dart';

class PocketClient {
  static final _client = PocketBase('http://127.0.0.1:8090');

  static PocketBase get client {
    return _client;
  }

  static Future<List<Topic>> getTopics() async {
    final topicList = await _client.collection('topics').getFullList(
          batch: 200,
          filter: 'is_valid = True',
        );
    final List<Topic> topics = [];
    // ignore: avoid_function_literals_in_foreach_calls
    topicList.forEach((element) {
      topics.add(
        Topic(
          element.data['name'],
          element.data['description'],
          element.id,
        ),
      );
    });

    return topics;
  }

  static Future<User> getUser(String id) async {
    final userRecord = await _client.collection('users').getOne(id);
    return User.fromJson(userRecord.data, userRecord);
  }

  static Future<List<Course>> getCourses(Topic? topicFilter) async {
    try {
      final List<Course> courses = [];
      final List<String> existingCourses = [];
      final topicList = await getTopics();

      String? filter =
          topicFilter == null ? null : 'topic = "${topicFilter.id}"';

      final courseList = await _client
          .collection('course_topics')
          .getList(filter: filter, sort: "-course");

      for (var courseId in courseList.items) {
        if (existingCourses.contains(courseId.data['course'])) {
          continue;
        }

        var courseRecord =
            await _client.collection('courses').getOne(courseId.data["course"]);

        final userModel = await _client
            .collection('users')
            .getOne(courseRecord.data['user_id']);

        final curCourse =
            Course.fromJson(courseRecord.data, courseRecord, userModel);

        final curTopics = await _client
            .collection('course_topics')
            .getList(filter: 'course = "${courseRecord.id}"');

        for (var topic in curTopics.items) {
          final curTopic = topicList
              .firstWhere((element) => element.id == topic.data['topic']);
          curCourse.addTopic(curTopic);
        }

        existingCourses.add(curCourse.id!);
        courses.add(curCourse);
      }

      return courses;
    } catch (e) {
      return [];
    }
  }

  static Future<List<Course>> getUserCourses(String userId) async {
    try {
      final List<Course> courses = [];
      final List<String> existingCourses = [];
      final topicList = await getTopics();

      String? filter = 'user_id = "$userId"';

      final courseList = await _client
          .collection('course_topics')
          .getList(filter: filter, sort: "-course");

      for (var courseId in courseList.items) {
        if (existingCourses.contains(courseId.data['course'])) {
          continue;
        }

        var courseRecord =
            await _client.collection('courses').getOne(courseId.data["course"]);

        final userModel = await _client
            .collection('users')
            .getOne(courseRecord.data['user_id']);

        final curCourse =
            Course.fromJson(courseRecord.data, courseRecord, userModel);

        final curTopics = await _client
            .collection('course_topics')
            .getList(filter: 'course = "${courseRecord.id}"');

        for (var topic in curTopics.items) {
          final curTopic = topicList
              .firstWhere((element) => element.id == topic.data['topic']);
          curCourse.addTopic(curTopic);
        }

        existingCourses.add(curCourse.id!);
        courses.add(curCourse);
      }

      return courses;
    } catch (e) {
      return [];
    }
  }

  static RecordModel get model {
    return _client.authStore.model as RecordModel;
  }
}
