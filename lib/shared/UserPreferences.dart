import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._ctor();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._ctor();

  SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  get sound {
    return _prefs.getBool('sound') ?? true;
  }

  setSound(bool value) {
    _prefs.setBool('sound', value);
  }

  static void setUserData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  static Future<String> getUserData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key)?? '');
  }

  static void setStringData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key,value);
  }

  static Future<String> getStringData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  get tapSound {
    return _prefs.getBool('tapSound') ?? true;
  }

  setTapSound(bool value) {
    _prefs.setBool('tapSound', value);
  }

  static Future<bool> clearSession() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.clear() ?? false;
  }
}
