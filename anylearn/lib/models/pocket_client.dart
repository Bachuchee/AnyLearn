import 'package:anylearn/controllers/duration_service.dart';
import 'package:anylearn/models/episode.dart';
import 'package:anylearn/models/topic.dart';
import 'package:anylearn/models/user.dart';
import 'package:anylearn/models/view_status.dart';
import 'package:anylearn/views/view_course/view_course.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
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

  static Future<Episode> getEpisode(String id) async {
    final episodeModel = await _client.collection('episodes').getOne(id);
    final course = await getCourseById(episodeModel.data['course_id']);
    return Episode.fromJson(episodeModel.data, episodeModel, course);
  }

  static Future<List<Course>> getOngoingCourses(Topic? topicFilter) async {
    try {
      final List<Course> courses = [];
      final courseList = await _client
          .collection('course_status')
          .getList(filter: 'user_id = "${model.id}"');
      for (var courseModel in courseList.items) {
        final curCourse = await getCourseById(courseModel.data['course_id']);
        final topicNames = <String>[];
        for (var element in curCourse.topics) {
          topicNames.add(element.name);
        }
        if (topicFilter == null || topicNames.contains(topicFilter.name)) {
          courses.add(curCourse);
        }
      }
      return courses;
    } catch (e) {
      return [];
    }
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

        existingCourses.add(curCourse.id);
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

      String filter = 'user_id = "$userId"';

      final courseList =
          await _client.collection('courses').getList(filter: filter);

      for (var courseRecord in courseList.items) {
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

        existingCourses.add(curCourse.id);
        courses.add(curCourse);
      }

      return courses;
    } catch (e) {
      return [];
    }
  }

  static Future<Course> getCourseById(String id) async {
    try {
      final topicList = await getTopics();

      final courseRecord = await _client.collection('courses').getOne(id);

      final userModel = await _client
          .collection('users')
          .getOne(courseRecord.data['user_id']);

      final course =
          Course.fromJson(courseRecord.data, courseRecord, userModel);

      final curTopics = await _client
          .collection('course_topics')
          .getList(filter: 'course = "${courseRecord.id}"');

      for (var topic in curTopics.items) {
        final curTopic = topicList
            .firstWhere((element) => element.id == topic.data['topic']);
        course.addTopic(curTopic);
      }

      return course;
    } catch (e) {
      return Course();
    }
  }

  static Future<ViewStatus> getSavedPosition(
    String userId,
    String courseId,
    int epNumber,
  ) async {
    try {
      final statusList = await _client.collection("course_status").getList(
            filter: 'user_id = "$userId" && course_id = "$courseId"',
            sort: "-created",
          );

      if (statusList.items.length > 1) {
        for (var item in statusList.items.sublist(1)) {
          _client.collection('course_status').delete(item.id);
        }
      }
      final status = statusList.items[0];

      if (status.data["current_episode"] != epNumber) {
        return ViewStatus(status.data["current_episode"], Duration.zero);
      }
      print("got here bro");
      return ViewStatus(epNumber, parseDuration(status.data["position"]));
    } catch (e) {
      print("failed");
      return const ViewStatus(-1, Duration.zero);
    }
  }

  static Future<void> updateWatchStatus(
    String courseId,
    String userId,
    Duration pos,
    int epNumber,
    bool hasBeenCreated,
  ) async {
    try {
      final status = await _client.collection("course_status").getList(
          filter: 'user_id = "$userId" && course_id = "$courseId"',
          sort: "-created");

      if (status.items.length > 1) {
        for (var item in status.items.sublist(1)) {
          _client.collection('course_status').delete(item.id);
        }
      }
      if (status.items.isEmpty || !hasBeenCreated) {
        final body = {
          "user_id": userId,
          "course_id": courseId,
          "current_episode": epNumber,
          "position": pos.toString(),
        };
        await _client.collection("course_status").create(body: body);
      } else {
        final body = {
          "current_episode": epNumber,
          "position": pos.toString(),
        };
        await _client
            .collection("course_status")
            .update(status.items[0].id, body: body);
      }
    } catch (e) {}
  }

  static Future<bool> createCourse(
    Course newCourse,
    Uint8List courseImage,
  ) async {
    final courseData = newCourse.toJson();

    final image = MultipartFile.fromBytes(
      'image',
      courseImage,
      filename: 'courseImage.png',
    );

    try {
      final courseRecord = await _client.collection('courses').create(
        body: courseData,
        files: [image],
      );

      for (final topic in newCourse.topics) {
        final body = {'course': courseRecord.id, 'topic': topic.id};

        await _client.collection('course_topics').create(body: body);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> createEpisode(
    Episode newEpisode,
    Uint8List episodeImage,
    Uint8List episodeVideo,
  ) async {
    final episodeData = newEpisode.toJson();

    final image = MultipartFile.fromBytes(
      'thumbnail',
      episodeImage,
      filename: 'episodeImage.png',
    );

    final video = MultipartFile.fromBytes(
      'video',
      episodeVideo,
      filename: 'episodeVideo.mp4',
    );

    try {
      final episodeRecord = await _client.collection('episodes').create(
        body: episodeData,
        files: [image, video],
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Episode>> getCourseEpisodes(Course course) async {
    try {
      final episodeModels = await _client.collection("episodes").getList(
            filter: 'course_id = "${course.id}"',
            sort: '+episode_number',
          );

      final List<Episode> episodeList = [];

      for (final episodeModel in episodeModels.items) {
        final newEpisode = Episode.fromJson(
          episodeModel.data,
          episodeModel,
          course,
        );

        episodeList.add(newEpisode);
      }
      return episodeList;
    } catch (e) {
      return [];
    }
  }

  static RecordModel get model {
    return _client.authStore.model as RecordModel;
  }
}
