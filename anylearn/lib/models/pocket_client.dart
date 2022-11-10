import 'package:anylearn/models/topic.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PocketClient {
  static final _client = PocketBase('http://127.0.0.1:8090');

  static PocketBase getClient() {
    return _client;
  }

  static Future<List<Topic>> getTopics() async {
    final topicList = await _client.records.getFullList(
      'topics',
      batch: 200,
      filter: 'is_valid = True',
    );
    final List<Topic> topics = [];
    topicList.forEach((element) {
      topics.add(Topic(element.data['name'], element.data['description']));
    });

    return topics;
  }
}
