import 'package:flutter/material.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/common_functions.dart';

class ProfileController extends ChangeNotifier{
  bool hideCurrentPwd=true,hideNewPwd=true,hideConfirmNewPwd=true;
  TextEditingController
  currentPwdController=TextEditingController(),
  newPwdController=TextEditingController(),
  confirmNewPwdController=TextEditingController();

  var selectedLanguage=0;

  void changeCurrentPwdVisibilityStatus(){
    hideCurrentPwd=!hideCurrentPwd;
    notifyListeners();
  }

  void changeNewPwdVisibilityStatus(){
    hideNewPwd=!hideNewPwd;
    notifyListeners();
  }

  void changeConfirmNewPwdVisibilityStatus(){
    hideConfirmNewPwd=!hideConfirmNewPwd;
    notifyListeners();
  }

  void changeLanguage(int language) {
    selectedLanguage=language;
    notifyListeners();
  }

  void changePassword(BuildContext context) {
    CommonFunctions.showLoader(context);
    ApiCalls.changePassword(currentPwdController.text, newPwdController.text).then((value) {
      CommonFunctions.dismissLoader(context);
      Navigator.pop(context);
    },);
  }
}