import 'package:flutter/cupertino.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';

class MainController extends ChangeNotifier {
  bool isTokenEmpty() =>
      SharedPrefUtils.instance
          .getString(USER_DATA)
          .isEmpty;

  bool isDarkModel() =>
      SharedPrefUtils.instance
          .getBool(IS_DARK_MODE,defaultValue: true);

  void clearToken() {
    SharedPrefUtils.instance
        .logout();
    // notifyListeners();
  }

  void changeTheme(isDarkMode){
    SharedPrefUtils.instance
        .putBool(IS_DARK_MODE,isDarkMode);
    notifyListeners();
  }

  void changeLanguage(int codeIndex){
    SharedPrefUtils.instance
        .putString(SELECTED_LANGUAGE,AppConst.languageCodes[codeIndex]);
    notifyListeners();
  }
}