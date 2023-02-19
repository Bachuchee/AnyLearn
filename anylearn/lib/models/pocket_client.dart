import 'dart:html';

import 'package:anylearn/controllers/duration_service.dart';
import 'package:anylearn/models/episode.dart';
import 'package:anylearn/models/follow.dart';
import 'package:anylearn/models/notification.dart';
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
    final user = User.fromJson(userRecord.data, userRecord);
    print("I: going to get topics");
    user.topics = await getUserTopics(user.id);
    return user;
  }

  static Future<List<Topic>> getUserTopics(String id) async {
    try {
      final topics = <Topic>[];
      final topicToUser = await _client
          .collection('user_topics')
          .getList(filter: 'user_id = "$id"');
      for (var record in topicToUser.items) {
        final topic =
            await _client.collection('topics').getOne(record.data['topic_id']);
        topics.add(
          Topic(
            topic.data['name'],
            topic.data['description'],
            topic.id,
          ),
        );
      }
      return topics;
    } catch (e) {
      print('I: failed');
      return [];
    }
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

  static Future<void> updateCourseRating(
    String userId,
    String courseId,
    double rating,
  ) async {
    try {
      final userRatingModels =
          await _client.collection('course_ratings').getList(
                filter: 'user_id = "$userId" && course_id = "$courseId"',
              );

      if (userRatingModels.items.length > 1) {
        for (var item in userRatingModels.items.sublist(1)) {
          _client.collection('course_status').delete(item.id);
        }
      }

      if (userRatingModels.items.isEmpty) {
        final body = {
          'user_id': userId,
          'course_id': courseId,
          'rating': rating,
        };
        await _client.collection('course_ratings').create(body: body);
      } else {
        final body = {'rating': rating};
        await _client.collection('course_ratings').update(
              userRatingModels.items.first.id,
              body: body,
            );
      }
    } catch (e) {}
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

        curCourse.rating = await getCourseRating(curCourse.id);

        existingCourses.add(curCourse.id);
        courses.add(curCourse);
      }

      return courses;
    } catch (e) {
      return [];
    }
  }

  static Future<double> getUserRating(String userId, String courseId) async {
    try {
      final ratingInfo = await _client.collection('course_ratings').getList(
            filter: 'user_id = "$userId" && course_id = "$courseId"',
          );

      return ratingInfo.items.first.data['rating'];
    } catch (e) {
      return 0;
    }
  }

  static Future<double> getCourseRating(String courseId) async {
    try {
      final ratingList = await _client
          .collection('course_ratings')
          .getList(filter: 'course_id = "$courseId"');

      double rating = 0;

      ratingList.items.fold(
        rating,
        (previousValue, element) => rating += element.data['rating'],
      );

      rating /= ratingList.items.length;

      return rating;
    } catch (e) {
      return 0;
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

        curCourse.rating = await getCourseRating(curCourse.id);

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

      course.rating = await getCourseRating(course.id);

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
      return ViewStatus(epNumber, parseDuration(status.data["position"]));
    } catch (e) {
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

      notifyNewCourse(courseRecord);

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> notifyNewCourse(RecordModel courseRecord) async {
    final followerList = await _client.collection('follows').getList(
          perPage: 100000000,
          filter: 'followed_id = "${courseRecord.data['user_id']}"',
        );

    for (var follower in followerList.items) {
      final body = {
        "sender_id": courseRecord.data['user_id'],
        "receiver_id": follower.data['follower_id'],
        "course_id": courseRecord.id,
        "episode_update": false,
        "was_read": false,
      };

      await _client.collection('notifications').create(body: body);
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

      notifyNewEpisode(episodeRecord);

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> notifyNewEpisode(RecordModel episodeRecord) async {
    final watchers = await _client
        .collection('course_status')
        .getList(filter: 'course_id = "${episodeRecord.data['course_id']}"');

    for (var watcher in watchers.items) {
      final body = {
        'sender_id': model.id,
        'receiver_id': watcher.data['user_id'],
        'course_id': episodeRecord.data['course_id'],
        'episode_update': true,
        'was_read': false,
      };

      if (watcher.data['user_id'] != model.id) {
        await _client.collection('notifications').create(body: body);
      }
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

  static Future<bool> checkFollowing(String follower, String followee) async {
    try {
      final follows = await _client.collection('follows').getList(
            filter: 'follower_id = "$follower" && followed_id = "$followee"',
          );

      final followData = follows.items.first.data;

      return followData['follower_id'] == follower &&
          followData['followed_id'] == followee;
    } catch (e) {
      return false;
    }
  }

  static Future<void> follow(String follower, String followee) async {
    try {
      if (!await checkFollowing(follower, followee)) {
        final body = {
          'follower_id': follower,
          'followed_id': followee,
        };

        await _client.collection('follows').create(body: body);
      }
    } catch (e) {}
  }

  static Future<void> unFollow(String follower, String followee) async {
    try {
      final follows = await _client.collection('follows').getList(
            filter: 'follower_id = "$follower" && followed_id = "$followee"',
          );

      final followData = follows.items.first;

      if (followData.data['follower_id'] == follower &&
          followData.data['followed_id'] == followee) {
        _client.collection('follows').delete(followData.id);
      }
    } catch (e) {}
  }

  static Future<int> getFollowers(String userId) async {
    try {
      final followList = await _client.collection('follows').getList(
            perPage: 100000000,
            filter: 'followed_id = "$userId"',
          );

      return followList.items.length;
    } catch (e) {
      return 0;
    }
  }

  static Future<int> getFollowing(String userId) async {
    try {
      final followList = await _client.collection('follows').getList(
            perPage: 100000000,
            filter: 'follower_id = "$userId"',
          );

      return followList.items.length;
    } catch (e) {
      return 0;
    }
  }

  static Future<List<User>> getFollowerUsers(String userId) async {
    try {
      final userList = <User>[];
      final followList = await _client.collection('follows').getList(
            perPage: 100000000,
            filter: 'follower_id = "$userId"',
          );

      for (var follow in followList.items) {
        final curUser = await getUser(follow.data['followed_id']);
        userList.add(curUser);
      }
      return userList;
    } catch (e) {
      return [];
    }
  }

  static Future<List<AppNotification>> getUserNotifications(
    String userId,
  ) async {
    try {
      final notificationList = <AppNotification>[];

      final notificationRecords = await _client
          .collection('notifications')
          .getList(filter: 'receiver_id = "$userId"', sort: "-created");

      for (var notification in notificationRecords.items) {
        final course = await getCourseById(notification.data['course_id']);

        final user = await getUser(notification.data['sender_id']);

        final message =
            'user ${user.username} just ${notification.data['episode_update'] ? 'added a new episode to the course - "${course.title}"!' : 'created a new course - "${course.title}!"'}';

        notificationList.add(
          AppNotification(
            notification.id,
            course,
            user,
            message,
            notification.data['was_read'],
          ),
        );
      }
      return notificationList;
    } catch (e) {
      return [];
    }
  }

  static Future<void> markNotificationRead(String notificationId) async {
    final body = {'was_read': true};

    await _client
        .collection('notifications')
        .update(notificationId, body: body);
  }

  static Future<bool> checkUnreadNotifications(String userId) async {
    try {
      final notificationRecords = await _client
          .collection('notifications')
          .getList(filter: 'receiver_id = "$userId" && was_read = false');

      return notificationRecords.items.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static RecordModel get model {
    return _client.authStore.model as RecordModel;
  }
}
