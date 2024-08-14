import 'package:flutter/cupertino.dart';
import 'package:kleber_bank/login/otp_screen.dart';
import 'package:kleber_bank/login/terms_and_privacy.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';

import '../dashboard/dashboard.dart';
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

  var tabLabelList = ['Terms-Conditions', 'Privacy-Policies'];

  Future<void> doLogin(BuildContext context) async {
    CommonFunctions.showLoader(context);
    await ApiCalls.login(userNameController.text, pwdController.text).then(
      (value) async {
        if (value) {
          await ApiCalls.getUserInfo().then(
            (value) async {
              CommonFunctions.dismissLoader(context);
              if (value != null) {
                if (!(value.user?.tosAccepted ?? false)) {
                  CommonFunctions.navigate(context, TermsAndPrivacy());
                }else if ((value.verification ?? '').isEmpty) {
                  CommonFunctions.navigate(context, Dashboard());
                } else if (value.verification == 'sms' || value.verification == 'email') {
                  CommonFunctions.showLoader(context);
                  await ApiCalls.sendOtp().then(
                    (value) {
                      CommonFunctions.dismissLoader(context);
                      if (value != null && value.containsKey('success')) {
                        CommonFunctions.navigate(context, OTPScreen(value));
                      }
                    },
                  );
                }else if (value.verification == 'authentification') {
                  CommonFunctions.navigate(context, OTPScreen(null));
                }
              }
            },
          );
        } else {
          CommonFunctions.dismissLoader(context);
        }
      },
    );
    notifyListeners();
  }

  Future<void> reSend(BuildContext context,{bool removeStack=false}) async {
    CommonFunctions.showLoader(context);
    await ApiCalls.sendOtp().then(
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
    await ApiCalls.verifyOtp(getOTP(), AppConst.userModel?.verification ?? '').then(
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
    await ApiCalls.getTermOfService().then(
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
    if(accepted){
      CommonFunctions.showLoader(context);
      await ApiCalls.acceptanceTermsOfService().then(
            (value) async {
          CommonFunctions.dismissLoader(context);
          if (value != null) {
            if(value['success']){
              await reSend(context,removeStack: true);
            }
            notifyListeners();
          }
        },
      );
    }
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
