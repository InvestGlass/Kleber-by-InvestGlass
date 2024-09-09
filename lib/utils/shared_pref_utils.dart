import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:kleber_bank/login/user_info_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const TOKEN = "token";
const USER_DATA = "user_data";
const IS_DARK_MODE = "is_dark_mode";
const SELECTED_LANGUAGE = "selected_language";

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
    // putString(SELECTED_LANGUAGE, 'en');
    await prefs.remove(USER_DATA);
    await clearAppCache();
    await clearDocumentsDirectory();
    return true;
  }

  Future<void> clearAppCache() async {
    try {
      final directory = await getTemporaryDirectory();
      final cacheDir = Directory(directory.path);
      if (await cacheDir.exists()) {
        final files = cacheDir.listSync();
        for (var file in files) {
          if (file is File) {
            await file.delete();
          } else if (file is Directory) {
            await file.delete(recursive: true);
          }
        }
        print('Cache cleared');
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  Future<void> clearDocumentsDirectory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final docDir = Directory(directory.path);
      if (await docDir.exists()) {
        final files = docDir.listSync();
        for (var file in files) {
          if (file is File) {
            await file.delete();
          } else if (file is Directory) {
            await file.delete(recursive: true);
          }
        }
        print('Documents directory cleared');
      }
    } catch (e) {
      print('Error clearing documents directory: $e');
    }
  }
}
