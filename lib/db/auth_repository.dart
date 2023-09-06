import 'dart:convert';

import 'package:puth_story/model/api/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository{
  final String stateKey = "auth_state";
  final String userKey = "auth_user";

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(stateKey) ?? false;
  }

  Future<bool> login(User user) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(userKey, json.encode(user.toJson()));
    preferences.setBool(stateKey, true);

    return true;
  }
  
  Future<User?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    return User.fromJson(json.decode(preferences.getString(userKey)!));
  }

  Future logout() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(userKey, "{}");
    preferences.setBool(stateKey, false);
  }
}