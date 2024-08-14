import 'package:flutter/material.dart';
import 'package:kleber_bank/login/login.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/profile/change_password.dart';
import 'package:kleber_bank/profile/profile_controller.dart';
import 'package:kleber_bank/utils/app_colors.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileController _notifier;
  @override
  Widget build(BuildContext context) {
    _notifier=Provider.of<ProfileController>(context);
    return Scaffold(
      body: Card(
        color: Colors.white,
        margin: EdgeInsets.all(rSize*0.015),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal:rSize*0.015,vertical:rSize*0.02),
          children: [
            Text('xofas14574',style: AppStyles.c656262W400S20,),
            Text('bolote235@wedersde.com',style: AppStyles.c3C496CW400S14,),
            SizedBox(height: rSize*0.03,),
            cell('Change Password',() => CommonFunctions.navigate(context,ChangePassword()),),
            SizedBox(height: rSize*0.02,),
            cell('Change Language',() => openLanguageSelectionBottomSheet(),),
            SizedBox(height: rSize*0.02,),
            Row(
              children: [
                SizedBox(width: rSize*0.02,),

                Expanded(
                  child: Text(
                    'Switch To Dark Mode',
                    style: AppStyles.c3C496CW500S16,
                  ),
                ),
                Switch(value: true, onChanged: (value) {

                },),
                SizedBox(width: rSize*0.015,),

              ],
            ),
            SizedBox(height: rSize*0.015,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () async {
                      await SharedPrefUtils.instance.logout();
                      CommonFunctions.navigate(context, Login(),removeAllScreensFromStack: true);
                    },
                    child: AppWidgets.btn(context,'Log out',horizontalPadding: rSize*0.03)),
              ],
            ),
          ],
        ),
      ),
    );


  }

  void openLanguageSelectionBottomSheet() {
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Wrap(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: rSize * 0.015),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      Text(
                        'Choose Language',
                        style: AppStyles.c656262W500S20,
                      ),
                      Container(
                        height: 0.5,
                        margin: EdgeInsets.symmetric(vertical: rSize * 0.0075),
                        width: double.infinity,
                        color: AppColors.kHint,
                      ),
                      sortDialogElement(0, 'English'),
                      sortDialogElement(1, 'Arabic'),
                      sortDialogElement(2, 'Vietnamese'),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Row sortDialogElement(int value, String label) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: _notifier.selectedLanguage,
          onChanged: (p0) {
            _notifier.changeLanguage(p0!);
            Navigator.pop(context);
          },
        ),
        Expanded(
            child: Text(
              label,
              style: AppStyles.c656262W500S18,
            )),
      ],
    );
  }

  Widget cell(String title,void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kHint.withOpacity(0.1),
          borderRadius:BorderRadius.circular(10)
        ),
        padding: EdgeInsets.symmetric(horizontal: rSize*0.02,vertical: rSize*0.015),
        child: Row(
          children: [
            Expanded(child: Text(title,style: AppStyles.c656262W400S16,)),
            RotatedBox(
                quarterTurns: 2,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.kTextFieldInput,
                  size: 15,
                ))
          ],
        ),
      ),
    );
  }
}
