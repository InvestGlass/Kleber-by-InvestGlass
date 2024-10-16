import 'package:flutter/material.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/common_functions.dart';

class ProfileController extends ChangeNotifier{
  bool showCurrentPwd=false,showNewPwd=false,showConfirmNewPwd=false;
  TextEditingController
  currentPwdController=TextEditingController(),
  newPwdController=TextEditingController(),
  confirmNewPwdController=TextEditingController();

  var selectedLanguage=0;

  void changeCurrentPwdVisibilityStatus(){
    showCurrentPwd=!showCurrentPwd;
    notifyListeners();
  }

  void changeNewPwdVisibilityStatus(){
    showNewPwd=!showNewPwd;
    notifyListeners();
  }

  void changeConfirmNewPwdVisibilityStatus(){
    showConfirmNewPwd=!showConfirmNewPwd;
    notifyListeners();
  }

  void changeLanguage(int language) {
    selectedLanguage=language;
    notifyListeners();
  }

  void changePassword(BuildContext context) {
    CommonFunctions.showLoader(context);
    ApiCalls.changePassword(context,currentPwdController.text, newPwdController.text).then((value) {
      CommonFunctions.dismissLoader(context);
      if (value) {
        Navigator.pop(context);
      }
    },);
  }
}