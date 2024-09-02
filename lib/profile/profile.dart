import 'package:flutter/material.dart';
import 'package:kleber_bank/login/login.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/profile/change_password.dart';
import 'package:kleber_bank/profile/profile_controller.dart';
import 'package:kleber_bank/utils/app_colors.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:provider/provider.dart';

import '../login/on_boarding_page_widget.dart';
import '../main_controller.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileController _notifier;
  late MainController _mainNotifier;

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<ProfileController>(context);
    _mainNotifier = Provider.of<MainController>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: rSize * 0.015, vertical: MediaQuery.of(context).padding.top + 10),
        children: [
          Text(
            SharedPrefUtils.instance.getUserData().user!.username!,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'Roboto',
                  fontSize: 20.0,
                  letterSpacing: 0.0,
                ),
          ),
          Text(
            SharedPrefUtils.instance.getUserData().user!.email!,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primary,
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.normal,
                ),
          ),
          SizedBox(
            height: rSize * 0.03,
          ),
          Text(
            FFLocalizations.of(context).getText(
              'wl1ownor' /* Account Settings */,
            ),
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Roboto',
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(
            height: rSize * 0.02,
          ),
          cell(
            FFLocalizations.of(context).getText(
              'afxtmzhw' /* Change Password */,
            ),
            () => CommonFunctions.navigate(context, ChangePassword()),
          ),
          SizedBox(
            height: rSize * 0.01,
          ),
          cell(
            FFLocalizations.of(context).getText(
              'wvo4yj9k' /* Change Language*/,
            ),
            () => openLanguageSelectionBottomSheet(),
          ),
          SizedBox(
            height: rSize * 0.02,
          ),
          Row(
            children: [
              SizedBox(
                width: rSize * 0.02,
              ),
              Expanded(
                child: Text(
                  FFLocalizations.of(context).getText(
                    'znd2aszb' /* Switch to Dark Mode */,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: FlutterFlowTheme.of(context).primary),
                child: Switch(
                  value: _mainNotifier.isDarkModel(),
                  onChanged: (value) {
                    _mainNotifier.changeTheme(value);
                  },
                  activeColor: FlutterFlowTheme.of(context).primary,
                ),
              ),
              SizedBox(
                width: rSize * 0.015,
              ),
            ],
          ),
          SizedBox(
            height: rSize * 0.015,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await SharedPrefUtils.instance.logout();
                  CommonFunctions.navigate(context, const OnBoardingPageWidget(), removeAllScreensFromStack: true);
                },
                child: Card(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),elevation: 2,
                  child: AppWidgets.btn(
                      context,
                      FFLocalizations.of(context).getText(
                        'c0xbwwci' /* Logout */,
                      ),
                      bgColor: FlutterFlowTheme.of(context).secondaryBackground,
                      horizontalPadding: 40,verticalPadding: 17),
                ),
              ),
            ],
          ),
        ],
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
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          'cnc2a7kn' /* Change Language */,
                        ),
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                              fontFamily: 'Roboto',
                              color: FlutterFlowTheme.of(context).primary,
                              fontSize: 26.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Container(
                        height: 0.5,
                        margin: EdgeInsets.symmetric(vertical: rSize * 0.0075),
                        width: double.infinity,
                        color: AppColors.kHint,
                      ),
                      languageSelectionElement(
                          0,
                          FFLocalizations.of(context).getText(
                            'english' /* english */,
                          )),
                      languageSelectionElement(
                          1,
                          FFLocalizations.of(context).getText(
                            'arabic' /* arabic */,
                          )),
                      languageSelectionElement(
                          2,
                          FFLocalizations.of(context).getText(
                            'vietnamese' /* vietnamese */,
                          )),
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

  Row languageSelectionElement(int value, String label) {
    return Row(
      children: [
        Theme(
          data: ThemeData(unselectedWidgetColor: FlutterFlowTheme.of(context).primaryText),
          child: Radio(
            value: value,
            activeColor: FlutterFlowTheme.of(context).primary,
            groupValue: _notifier.selectedLanguage,
            onChanged: (p0) {
              _notifier.changeLanguage(p0!);
              Navigator.pop(context);
            },
          ),
        ),
        Expanded(
            child: Text(
          label,
          style: FlutterFlowTheme.of(context).displaySmall.override(
                fontFamily: 'Roboto',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
        )),
      ],
    );
  }

  Widget cell(String title, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                title,
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Roboto',
                      letterSpacing: 0.0,
                    ),
              )),
              RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 15,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
