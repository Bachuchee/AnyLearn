import 'dart:typed_data';

import 'package:anylearn/models/pocket_client.dart';
import 'package:http/http.dart';

import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final _client = PocketClient.client;

  static Future<void> refreshAuth() async {
    final prefs = await SharedPreferences.getInstance();

    final authToken = prefs.getString("token") ?? "";

    _client.authStore.save(authToken, _client.authStore.model);
  }

  static Future<void> saveAuth(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", token);
  }

  static Future<bool> checkAuth() async {
    try {
      await _client.collection('users').authRefresh();

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateProfile(
    String username,
    String about,
    Uint8List? imageData,
    List<String> topics,
  ) async {
    try {
      MultipartFile? imageFile;

      if (imageData != null) {
        imageFile = MultipartFile.fromBytes(
          'avatar',
          imageData,
          filename: 'avatar.png',
        );
      }

      final body = {
        "username": username,
        "about": about,
        "is_admin": false,
        "is_banned": false,
      };

      await _client.collection('users').update(
            PocketClient.model.id,
            body: body,
            files: imageFile != null ? [imageFile] : [],
          );

      final curTopics = await _client
          .collection('user_topics')
          .getList(filter: 'user_id = "${PocketClient.model.id}"');

      for (var curTopic in curTopics.items) {
        if (!topics.contains(curTopic.id)) {
          await _client.collection('user_topics').delete(curTopic.id);
        }
      }

      for (var topic in topics) {
        if (!curTopics.items.fold(false,
            (previousValue, element) => topic == element.id ? true : false)) {
          final body = {'user_id': PocketClient.model.id, 'topic_id': topic};
          await _client.collection('user_topics').create(body: body);
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _client.authStore.clear();

      prefs.clear();

      return true;
    } catch (e) {
      return false;
    }
  }
}
