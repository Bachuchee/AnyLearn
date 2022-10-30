import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PocketClient {
  static final _client = PocketBase('http://127.0.0.1:8090');

  static PocketBase getClient() {
    return _client;
  }

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
}
