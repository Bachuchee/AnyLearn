import 'package:anylearn/models/topic.dart';
import 'package:anylearn/models/user.dart';
import 'package:pocketbase/pocketbase.dart';

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
    return User.fromJson(userRecord.data);
  }

  static RecordModel get model {
    return _client.authStore.model as RecordModel;
  }
}
