import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:kleber_bank/login/user_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const TOKEN = "token";
const USER_DATA = "user_data";
const IS_DARK_MODE = "is_dark_mode";

class SharedPrefUtils {
  final SharedPreferences prefs;
  static late SharedPrefUtils instance;

  SharedPrefUtils._(this.prefs);

  static Future<void> createInstance() async {
    instance = SharedPrefUtils._(await SharedPreferences.getInstance());
  }

  void putBool(String key, bool value) {
    prefs.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    if (prefs.containsKey(key)) {
      return prefs.getBool(key) ?? defaultValue;
    }
    return defaultValue;
  }

  bool? getBoolWithoutDefaultValue(String key) {
    if (prefs.containsKey(key)) {
      return prefs.getBool(key);
    }
    return null;
  }

  void putDouble(String key, double value) {
    prefs.setDouble(key, value);
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    if (prefs.containsKey(key)) {
      return prefs.getDouble(key) ?? defaultValue;
    }
    return defaultValue;
  }

  void putString(String key, String value) {
    prefs.setString(key, value);
  }

  String getString(String key, {String defaultValue = ""}) {
    if (prefs.containsKey(key)) {
      return prefs.getString(key) ?? defaultValue;
    }
    return defaultValue;
  }

  void putInt(String key, int value) {
    prefs.setInt(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    if (prefs.containsKey(key)) {
      return prefs.getInt(key) ?? defaultValue;
    }
    return defaultValue;
  }

  UserInfotModel getUserData() {
    final localData = SharedPrefUtils.instance.getString(USER_DATA);
    Map<String, dynamic> json=jsonDecode(localData);
    return UserInfotModel.fromJson(json);
  }

  static void storeUserData(UserInfotModel userDetails) async {

  }

  Future<bool> logout() async {
    await prefs.remove(TOKEN);
    await prefs.remove(USER_DATA);
    return true;
  }
}
