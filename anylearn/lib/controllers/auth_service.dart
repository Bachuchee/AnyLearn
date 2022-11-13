import 'dart:html';

import 'package:anylearn/models/pocket_client.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final _client = PocketClient.client;

  static Future<void> refreshAuth() async {
    final prefs = await SharedPreferences.getInstance();

    final exists = prefs.containsKey("token");

    final authToken = prefs.getString("token") ?? "";

    _client.authStore.save(authToken, _client.authStore.model);
  }

  static Future<void> saveAuth(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", token);
  }

  static Future<bool> checkAuth() async {
    try {
      await _client.users.refresh();

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateProfile(
      String username, List<String> topics) async {
    try {
      final body = {
        "username": username,
        "about": " ",
        "user_topics": topics,
        "is_admin": false,
        "is_banned": false,
      };

      await _client.records
          .update("profiles", PocketClient.userModel.profile!.id, body: body);

      return true;
    } catch (e) {
      print("error occured");
      return false;
    }
  }
}
