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

  static Future<List<Course>> getCourses() async {
    try {
      final courseList =
          await _client.collection('courses').getFullList(batch: 200);

      final List<Course> courses = [];
      final topicList = await getTopics();

      for (var course in courseList) {
        final userModel =
            await _client.collection('users').getOne(course.data['user_id']);
        print("log: ${userModel.data.toString()}");
        final curCourse = Course.fromJson(course.data, course, userModel);

        for (var topic in course.data['course_topics']) {
          final curTopic =
              topicList.firstWhere((element) => element.id == topic);
          curCourse.addTopic(curTopic);
        }

        print("log: got here");

        courses.add(curCourse);
      }

      return courses;
    } catch (e) {
      print("failed");
      return [];
    }
  }

  static RecordModel get model {
    return _client.authStore.model as RecordModel;
  }
}
