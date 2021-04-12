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

  get tapSound {
    return _prefs.getBool('tapSound') ?? true;
  }

  setTapSound(bool value) {
    _prefs.setBool('tapSound', value);
  }
}