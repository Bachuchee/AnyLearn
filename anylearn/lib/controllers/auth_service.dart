import 'package:anylearn/models/pocket_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final _client = PocketClient.getClient();

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
