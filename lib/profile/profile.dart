import 'package:flutter/material.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/profile/change_password.dart';
import 'package:kleber_bank/profile/profile_controller.dart';
import 'package:kleber_bank/utils/app_colors.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:provider/provider.dart';

import '../main_controller.dart';
import '../utils/app_styles.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import '../utils/threat_listview.dart';

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
    c=context;
    _notifier = Provider.of<ProfileController>(context);
    _mainNotifier = Provider.of<MainController>(context);
    return Scaffold(
      bottomNavigationBar: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text('V ${packageInfo.version}',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontSize: rSize * 0.016,
                    color: FlutterFlowTheme.of(context).customColor4,
                  )),
          SizedBox(height: rSize * 0.03),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: rSize * 0.015,
            vertical: MediaQuery.of(context).padding.top + 10),
        children: [
          Text(
            (SharedPrefUtils.instance.getUserData().user?.client?.id??0).toString(),
            style: AppStyles.inputTextStyle(context),
          ),
          Text(
            SharedPrefUtils.instance.getUserData().user!.username!.toString(),
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontSize: rSize * 0.02,
                  letterSpacing: 0.0,
                ),
          ),
          /*Text(
            SharedPrefUtils.instance.getUserData().user!.email!,
            style: FlutterFlowTheme.of(context).bodySmall.override(

                  color: FlutterFlowTheme.of(context).primary,
                  fontSize: rSize*0.016,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.normal,
                ),
          ),*/
          SizedBox(
            height: rSize * 0.03,
          ),
          Text(
            FFLocalizations.of(context).getText(
              'wl1ownor' /* Profile Settings */,
            ),
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  color: FlutterFlowTheme.of(context).customColor4,
                  fontSize: rSize * 0.016,
                ),
          ),
          SizedBox(
            height: rSize * 0.02,
          ),
          cell(
            FFLocalizations.of(context).getText(
              'yot02jf2' /* Change Password */,
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
              Expanded(
                child: Text(
                  FFLocalizations.of(context).getText(
                    'znd2aszb' /* Switch to Dark Mode */,
                  ),
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        color: FlutterFlowTheme.of(context).customColor4,
                        fontSize: rSize * 0.016,
                      ),
                ),
              ),
              Theme(
                data: ThemeData(
                    unselectedWidgetColor:
                        FlutterFlowTheme.of(context).primary),
                child: Transform.scale(
                  scale: isTablet ? 1.5 : 0.8,
                  child: Switch(
                    value: _mainNotifier.isDarkMode(),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) {
                      _mainNotifier.changeTheme(value);
                    },
                    activeColor: FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
              SizedBox(
                width: isTablet ? rSize * 0.015 : 0,
              ),
            ],
          ),
          SizedBox(
            height: rSize * 0.015,
          ),
          Text(
            FFLocalizations.of(context).getText(
              'communication_support',
            ),
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  color: FlutterFlowTheme.of(context).customColor4,
                  fontSize: rSize * 0.016,
                ),
          ),
          SizedBox(
            height: rSize * 0.13,
          ),
          AppWidgets.click(
            onTap: () async {
              AppWidgets.openConfirmationDialog(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppWidgets.btn(
                    context,
                    FFLocalizations.of(context).getText(
                      'c0xbwwci' /* Logout */,
                    ),
                    margin: EdgeInsets.only(bottom: rSize * 0.015),
                    horizontalPadding: rSize * 0.040),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void openLanguageSelectionBottomSheet() {

    _mainNotifier.tempSelectedLanguage=AppConst.languageCodes.indexOf(
        SharedPrefUtils.instance.getString(SELECTED_LANGUAGE).isEmpty
            ? 'en'
            : SharedPrefUtils.instance.getString(SELECTED_LANGUAGE));
    showDialog(
      useRootNavigator: true,
      context: context,
      builder: (context) {
        _mainNotifier = Provider.of<MainController>(context);
        return Center(
          child: Wrap(
            children: [
              Container(
                decoration:
                BoxDecoration(color: FlutterFlowTheme.of(context).primaryBackground, borderRadius: BorderRadius.circular(rSize * 0.010)),
                margin: EdgeInsets.symmetric(horizontal: rSize * 0.015),
                child: Material(
                  color: Colors.transparent,
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        left: rSize * 0.02,
                        right: rSize * 0.02,
                        top: rSize * 0.03,
                        bottom: MediaQuery.of(context).viewInsets.bottom + rSize * 0.03),
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: AppWidgets.title(
                                  context,
                                  FFLocalizations.of(context).getText(
                                    'cnc2a7kn' /* Change Language */,
                                  ))),
                          AppWidgets.click(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: rSize * 0.025,
                              color: FlutterFlowTheme.of(context).customColor4,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: rSize*0.015,),
                      languageSelectionElement(
                          0,
                          FFLocalizations.of(context).getText(
                            'english' /* english */,
                          ),(p0) {
                            _mainNotifier.tempLanguageSelection(p0!);
                          },_mainNotifier.tempSelectedLanguage),
                      languageSelectionElement(
                          1,
                          FFLocalizations.of(context).getText(
                            'arabic' /* arabic */,
                          ),(p0) {
                        _mainNotifier.tempLanguageSelection(p0!);
                          },_mainNotifier.tempSelectedLanguage),
                      languageSelectionElement(
                          2,
                          FFLocalizations.of(context).getText(
                            'vietnamese' /* vietnamese */,
                          ),(p0) {
                        _mainNotifier.tempLanguageSelection(p0!);
                          },_mainNotifier.tempSelectedLanguage),
                      SizedBox(height: rSize*0.015,),
                      AppWidgets.click(
                        onTap: () {
                          _notifier.changeLanguage(_mainNotifier.tempSelectedLanguage);
                          _mainNotifier.changeLanguage(_notifier.selectedLanguage);
                          Navigator.pop(context);
                        },
                        child: AppWidgets.btn(context, FFLocalizations.of(context).getText(
                          'lmndaaco' /* Apply */,
                        )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget languageSelectionElement(int value, String label,void Function(int?)? onChanged,int groupValue) {
    return SizedBox(
      height: rSize * 0.050,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: isTablet ? rSize * 0.015 : 0,
          ),
          Theme(
            data: ThemeData(
              unselectedWidgetColor: FlutterFlowTheme.of(context).customColor4,
            ),
            child: Transform.scale(
              scale: rSize * 0.0012,
              child: Radio(
                value: value,
                activeColor: FlutterFlowTheme.of(context).customColor4,
                fillColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return FlutterFlowTheme.of(context).customColor4;
                  }
                  return FlutterFlowTheme.of(context).customColor4;
                }),
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(
            width: isTablet ? rSize * 0.01 : 0,
          ),
          Expanded(
              child: Text(
            label,
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  color: FlutterFlowTheme.of(context).customColor4,
                  fontSize: rSize * 0.016,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
          )),
        ],
      ),
    );
  }

  Widget cell(String title, void Function()? onTap) {
    return AppWidgets.click(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: AppStyles.shadow(),
            borderRadius: BorderRadius.circular(rSize * 0.01)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: rSize * 0.015, vertical: rSize * 0.02),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                title,
                style: FlutterFlowTheme.of(context).labelLarge.override(
                      color: FlutterFlowTheme.of(context).customColor4,
                    ),
              )),
              RotatedBox(
                  quarterTurns: 2, child: AppWidgets.doubleBack(context)),
            ],
          ),
        ),
      ),
    );
  }
}
