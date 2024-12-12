import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';

import 'main.dart';

class MainController extends ChangeNotifier {
  bool isTokenEmpty() => SharedPrefUtils.instance.getString(USER_DATA).isEmpty;

  bool isDarkMode() =>
      SharedPrefUtils.instance.getBool(IS_DARK_MODE, defaultValue: false);

  void clearToken() {
    SharedPrefUtils.instance.logout();
    // notifyListeners();
  }

  void changeTheme(isDarkMode) {
    SharedPrefUtils.instance.putBool(IS_DARK_MODE, isDarkMode);
    notifyListeners();
  }

  int tempSelectedLanguage = 0;

  void tempLanguageSelection(int code) {
    tempSelectedLanguage = code;
    notifyListeners();
  }

  void resetTimer() {
    try {
      DateTime tokenTime = JwtDecoder.getExpirationDate(
          SharedPrefUtils.instance.getString(TOKEN));
      if (!kReleaseMode) {
        return;
      }
      if (inactivityTimer != null) {
        inactivityTimer!.cancel();
      }
      inactivityTimer = Timer(
          Duration(seconds: tokenTime.difference(DateTime.now()).inSeconds),
          () {
        if (c != null && SharedPrefUtils.instance.getString(TOKEN).isNotEmpty) {
          CommonFunctions.cleanAndLogout(c!);
        }
      });
      print(
          "Difference in seconds: ${tokenTime.difference(DateTime.now()).inSeconds}");
    } catch (e) {
      print(e.toString());
    }
  }

  void changeLanguage(int codeIndex) {
    SharedPrefUtils.instance
        .putString(SELECTED_LANGUAGE, AppConst.languageCodes[codeIndex]);
    notifyListeners();
  }
}
