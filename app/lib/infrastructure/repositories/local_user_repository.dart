import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/local_user.dart';

class LocalUserRepository {
  static const _userKey = 'user';
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  /// Save the user to local storage asynchronously
  Future<void> saveUser(User user) async {
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// Retrieve the saved user from local storage asynchronously
  Future<User?> getUser() async {
    final userString = await prefs.getString(_userKey);

    if (userString != null) {
      final userJson = jsonDecode(userString) as Map<String, dynamic>;
      return User.fromJson(userJson);
    }
    return null; // Return null if no user is saved
  }

  /// Check if a user is saved in local storage asynchronously
  Future<bool> hasUser() async {
    return await prefs.containsKey(_userKey);
  }

  /// Delete the saved user asynchronously
  Future<void> deleteUser() async {
    await prefs.remove(_userKey);
  }
}
