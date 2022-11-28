import 'dart:typed_data';

import 'package:anylearn/models/pocket_client.dart';
import 'package:http/http.dart';
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
    Uint8List imageData,
    List<String> topics,
  ) async {
    try {
      final imageFile = MultipartFile.fromBytes(
        'avatar',
        imageData,
        filename: 'avatar.png',
      );

      final body = {
        "username": username,
        "about": " ",
        "user_topics": topics,
        "is_admin": false,
        "is_banned": false,
      };

      print(body.toString());

      await _client
          .collection('users')
          .update(PocketClient.model.id, body: body, files: [imageFile]);

      return true;
    } catch (e) {
      return false;
    }
  }
}
