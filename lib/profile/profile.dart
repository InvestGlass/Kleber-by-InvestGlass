import 'package:flutter/material.dart';
import 'package:kleber_bank/login/login.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/profile/change_password.dart';
import 'package:kleber_bank/profile/profile_controller.dart';
import 'package:kleber_bank/utils/app_colors.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:provider/provider.dart';

import '../dashboard/dashboard_controller.dart';
import '../documents/documents_controller.dart';
import '../home/home_controller.dart';
import '../login/login_controller.dart';
import '../login/on_boarding_page_widget.dart';
import '../main_controller.dart';
import '../market/market_controller.dart';
import '../portfolio/portfolio_controller.dart';
import '../proposals/proposal_controller.dart';
import '../securitySelection/security_selection_controller.dart';
import '../utils/app_styles.dart';
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
      bottomNavigationBar: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text('V ${packageInfo.version}',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontSize: rSize * 0.016,
                    color: FlutterFlowTheme.of(context).customColor4,
                  )),
          SizedBox(height: rSize*0.03),
          GestureDetector(
            onTap: () async {
              openConfirmationDialog();
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: rSize * 0.015, vertical: MediaQuery.of(context).padding.top + 10),
        children: [
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
              'wl1ownor' /* Account Settings */,
            ),
            style: FlutterFlowTheme.of(context).displaySmall.override(
              color: FlutterFlowTheme.of(context).customColor4,
              fontSize: rSize * 0.016,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
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
              'cnc2a7kn' /* Change Language*/,
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
                  style: FlutterFlowTheme.of(context).displaySmall.override(
                    color: FlutterFlowTheme.of(context).customColor4,
                    fontSize: rSize * 0.016,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: FlutterFlowTheme.of(context).primary),
                child: Transform.scale(
                  scale: isTablet ? 2 : 0.8,
                  child: Switch(
                    value: _mainNotifier.isDarkModel(),
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
            style: FlutterFlowTheme.of(context).headlineSmall.override(fontSize: rSize * 0.016, color: FlutterFlowTheme.of(context).customColor4),
          ),
        ],
      ),
    );
  }

  void openLanguageSelectionBottomSheet() {
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            _notifier.selectedLanguage = AppConst.languageCodes.indexOf(
                SharedPrefUtils.instance.getString(SELECTED_LANGUAGE).isEmpty ? 'en' : SharedPrefUtils.instance.getString(SELECTED_LANGUAGE));
            return Wrap(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: rSize * 0.015),
                  decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(rSize * 0.02), topRight: Radius.circular(rSize * 0.02))),
                  child: Column(
                    children: [
                      AppWidgets.title(
                          context,
                          FFLocalizations.of(context).getText(
                            'cnc2a7kn' /* Change Language */,
                          )),
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

  Widget languageSelectionElement(int value, String label) {
    return SizedBox(
      height: rSize * 0.050,
      child: Row(
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
                fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return FlutterFlowTheme.of(context).customColor4;
                  }
                  return FlutterFlowTheme.of(context).customColor4;
                }),
                groupValue: _notifier.selectedLanguage,
                onChanged: (p0) {
                  _notifier.changeLanguage(p0!);
                  _mainNotifier.changeLanguage(_notifier.selectedLanguage);
                  Navigator.pop(context);
                },
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: AppStyles.shadow(),
            borderRadius: BorderRadius.circular(rSize * 0.01)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: rSize * 0.015, vertical: rSize * 0.02),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                title,
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      letterSpacing: 0.0,
                      color: FlutterFlowTheme.of(context).customColor4,
                    ),
              )),
              AppWidgets.doubleBack(context)
            ],
          ),
        ),
      ),
    );
  }

  void openConfirmationDialog() {
    showDialog(
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return Center(
          child: Wrap(
            children: [
              Material(
                color: Colors.transparent,
                child: Container(
                  decoration:
                      BoxDecoration(color: FlutterFlowTheme.of(context).primaryBackground, borderRadius: BorderRadius.circular(rSize * 0.010)),
                  margin: EdgeInsets.symmetric(horizontal: rSize * 0.04),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Wrap(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                                left: rSize * 0.02,
                                right: rSize * 0.02,
                                top: rSize * 0.03,
                                bottom: MediaQuery.of(context).viewInsets.bottom + rSize * 0.03),
                            children: [
                              AppWidgets.title(
                                  context,center: true,
                                  FFLocalizations.of(context).getText(
                                    'want_to_logout',
                                  )),
                              SizedBox(
                                height: rSize * 0.03,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: AppWidgets.btn(
                                            context,
                                            FFLocalizations.of(context).getText(
                                              's1jcpzx6' /* cancel */,
                                            ),
                                            borderOnly: true)),
                                  ),
                                  SizedBox(
                                    width: rSize * 0.02,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          SharedPrefUtils.instance.logout();
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MultiProvider(
                                                providers: [
                                                  ChangeNotifierProvider(create: (_) => MainController()),
                                                  ChangeNotifierProvider(create: (_) => LoginController()),
                                                  ChangeNotifierProvider(create: (_) => DashboardController()),
                                                  ChangeNotifierProvider(create: (_) => PortfolioController()),
                                                  ChangeNotifierProvider(create: (_) => ProfileController()),
                                                  ChangeNotifierProvider(create: (_) => ProposalController()),
                                                  ChangeNotifierProvider(create: (_) => MarketController()),
                                                  ChangeNotifierProvider(create: (_) => DocumentsController()),
                                                  ChangeNotifierProvider(create: (_) => HomeController()),
                                                  ChangeNotifierProvider(create: (_) => SecuritySelectionController()),
                                                ],
                                                child: OnBoardingPageWidget(),
                                              ),
                                            ),
                                                (Route<dynamic> route) => false, // Clear backstack
                                          );
                                        },
                                        child: AppWidgets.btn(
                                            context,
                                            textColor: Colors.white,
                                            FFLocalizations.of(context).getText(
                                              'c0xbwwci' /* logout */,
                                            ),
                                            bgColor: FlutterFlowTheme.of(context).primary)),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
