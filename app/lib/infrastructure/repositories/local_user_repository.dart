import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/local_user.dart';

class LocalUserRepository {
  static const _userKey = 'user';

  // Singleton pattern for shared instance
  static final LocalUserRepository _instance = LocalUserRepository._internal();
  factory LocalUserRepository() => _instance;
  LocalUserRepository._internal();

  /// Save the user to local storage
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// Get the saved user from local storage
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);

    if (userString != null) {
      final userJson = jsonDecode(userString) as Map<String, dynamic>;
      return User.fromJson(userJson);
    }
    return null; // Return null if no user is saved
  }

  /// Check if a user is saved in local storage
  Future<bool> hasUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }

  /// Delete the saved user
  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}