import 'package:flutter/cupertino.dart';
import 'package:kleber_bank/login/otp_screen.dart';
import 'package:kleber_bank/login/terms_and_privacy.dart';
import 'package:kleber_bank/login/user_info_model.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:provider/provider.dart';

import '../dashboard/dashboard.dart';
import '../main_controller.dart';
import '../utils/api_calls.dart';
import '../utils/common_functions.dart';

class LoginController extends ChangeNotifier {
  TextEditingController userNameController = TextEditingController(), pwdController = TextEditingController();
  TextEditingController otpController1 = TextEditingController(),
      otpController2 = TextEditingController(),
      otpController3 = TextEditingController(),
      otpController4 = TextEditingController(),
      otpController5 = TextEditingController(),
      otpController6 = TextEditingController();
  FocusNode focusNode1 = FocusNode(),
      focusNode2 = FocusNode(),
      focusNode3 = FocusNode(),
      focusNode4 = FocusNode(),
      focusNode5 = FocusNode(),
      focusNode6 = FocusNode();
  bool hidePwd = true;

  var tabLabelList = ['ovw4ksp4' /* Term of Service */, 'sb815feb' /* Privacy Policy */];

  void doLogin(BuildContext context) async {
    CommonFunctions.showLoader(context);
    bool b=await ApiCalls.login(context,userNameController.text, pwdController.text);
    CommonFunctions.dismissLoader(context);
    if(b){
      Provider.of<MainController>(context,listen: false).resetTimer();
      CommonFunctions.showLoader(context);
      UserInfotModel? model=await ApiCalls.getUserInfo(context);
      CommonFunctions.dismissLoader(context);
      if (model != null) {
        userNameController.clear();
        pwdController.clear();
        if (!(model.user?.tosAccepted ?? false)) {
          CommonFunctions.navigate(context, const TermsAndPrivacy());
        }else if ((model.verification ?? '').isEmpty) {
          CommonFunctions.navigate(context, const Dashboard());
        } else if (model.verification == 'sms' || model.verification == 'email') {
          CommonFunctions.showLoader(context);
          await ApiCalls.sendOtp(context).then(
                (value) {
              CommonFunctions.dismissLoader(context);
              if (value != null && value.containsKey('success')) {
                CommonFunctions.navigate(context, OTPScreen(value));
              }
            },
          );
        }else if (model.verification == 'authentification') {
          CommonFunctions.navigate(context, const OTPScreen(null));
        }
      }
    }

  }

  String? warning;
  String? warning2;
  void clearValidations(bool clear,int i){
    if(clear){
      if(i==0){
        warning=null;
      }else {
        warning2 = null;
      }
      notifyListeners();
    }else{
      if(userNameController.text.isEmpty) {
        warning = 'Required';
      }
      if(pwdController.text.isEmpty) {
        warning2 = 'Required';
      }
      notifyListeners();
    }
  }

  Future<void> reSend(BuildContext context,{bool removeStack=false}) async {
    CommonFunctions.showLoader(context);
    await ApiCalls.sendOtp(context).then(
      (value) {
        CommonFunctions.dismissLoader(context);
        if (value != null && value.containsKey('success')) {
          CommonFunctions.showToast('Sent verification code on ${value['location']}', success: true);
          CommonFunctions.navigate(context, OTPScreen(value),removeCurrentScreenFromStack: removeStack);
        }
      },
    );
  }

  Future<void> verify(BuildContext context,Function onSecretKeyFound) async {
    CommonFunctions.showLoader(context);
    await ApiCalls.verifyOtp(context,getOTP(), AppConst.userModel?.verification ?? '').then(
      (value) {
        CommonFunctions.dismissLoader(context);
        if (value != null && value['success']) {
          if (!value.containsKey('secret')) {
            CommonFunctions.navigate(context, Dashboard());
          }else{
            if (value['secret']!=null) {
              onSecretKeyFound(value['secret']);
            }else{
              CommonFunctions.navigate(context, Dashboard());
            }
          }
        } else if (value != null && !value['success']) {
          CommonFunctions.showToast(value['message']);
          otpController1.text='';
          otpController2.text='';
          otpController3.text='';
          otpController4.text='';
          otpController5.text='';
          otpController6.text='';
          notifyListeners();
        }
      },
    );
  }

  Map<String, dynamic> termOfServiceContent = {'term_of_service': '', 'privacy_policy': ''};
  bool accepted=false;

  Future<void> termOfService(BuildContext context) async {
    CommonFunctions.showLoader(context);
    await ApiCalls.getTermOfService(context).then(
      (value) {
        CommonFunctions.dismissLoader(context);
        if (value != null) {
          termOfServiceContent=value;
          notifyListeners();
        }
      },
    );
  }

  Future<void> changeAcceptance(BuildContext context) async {
    accepted=!accepted;
    notifyListeners();
  }
  Future<void> accept(BuildContext context) async {
      CommonFunctions.showLoader(context);
      await ApiCalls.acceptanceTermsOfService(context).then(
            (value) async {
          CommonFunctions.dismissLoader(context);
          if (value != null) {
            if(value['success']){
              if (AppConst.userModel?.verification!=null) {
                await reSend(context,removeStack: true);
              }else{
                CommonFunctions.navigate(context, Dashboard());
              }
            }
            notifyListeners();
          }
        },
      );
    notifyListeners();
  }



  void changeVisibility() {
    hidePwd = !hidePwd;
    notifyListeners();
  }

  String getOTP() {
    return otpController1.text + otpController2.text + otpController3.text + otpController4.text + otpController5.text + otpController6.text;
  }

  void refresh() {
    notifyListeners();
  }
}
