import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kleber_bank/documents/documents.dart';
import 'package:kleber_bank/documents/upload_document.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/portfolio/portfolio.dart';
import 'package:kleber_bank/proposals/chat/chat_history.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import '../market/market.dart';
import '../profile/profile.dart';
import '../proposals/proposal_model.dart';
import '../proposals/proposals.dart';
import '../utils/app_colors.dart';
import '../utils/app_widgets.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import 'dashboard_controller.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late PageController pagingController;

  late DashboardController _controller;

  @override
  void initState() {
    if (AppConst.userModel != null) {
      SharedPrefUtils.instance.putString(USER_DATA, AppConst.userModel!.toRawJson());
    }
    pagingController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.selectedIndex = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<DashboardController>(context);
    return Scaffold(
      key: _scaffoldkey,
      /*bottomNavigationBar: Container(
        color: Colors.transparent,
        height: rSize * 0.12,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'assets/bgBottomNavDark.png'
                  : 'assets/bgBottomNavLight.png',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                bottombarCell(
                    context,
                    0,
                    Icons.home_rounded,
                    FFLocalizations.of(context).getText(
                      'fiha8uf5' */ /* Home */ /*,
                    )),
                bottombarCell(
                    context,
                    1,
                    Icons.bar_chart,
                    FFLocalizations.of(context).getText(
                      'xn2nrgyp' */ /* Portfolio */ /*,
                    ),
                    widget: _controller.selectedIndex == 1
                        ? SvgPicture.asset(
                            Theme.of(context).brightness == Brightness.dark ? 'assets/bar-chart-dark-theme.svg' : 'assets/bar_chart.svg',
                            fit: BoxFit.contain,
                          )
                        : null),
                SizedBox(
                  width: rSize * 0.05,
                ),
                bottombarCell(
                    context,
                    2,
                    Icons.home_rounded,
                    FFLocalizations.of(context).getText(
                      'nkifu7jq' */ /* Proposal */ /*,
                    ),
                    widget: _controller.selectedIndex == 2
                        ? SvgPicture.asset(
                            Theme.of(context).brightness == Brightness.dark
                                ? 'assets/proposal-icon-new-dark-theme.svg'
                                : 'assets/proposal-icon-new.svg',
                            fit: BoxFit.contain,
                          )
                        : SvgPicture.asset(
                            Theme.of(context).brightness == Brightness.dark
                                ? 'assets/proposal-icon-new-unselected-dark-theme.svg'
                                : 'assets/proposal-icon-new-unselected.svg',
                            fit: BoxFit.contain,
                          )),
                bottombarCell(
                    context,
                    3,
                    Icons.account_circle_rounded,
                    FFLocalizations.of(context).getText(
                      'w5wtcpj4' */ /* Profile */ /*,
                    )),
              ],
            ),
            Positioned(
              // width: MediaQuery.of(context).size.width,
              bottom: 30,
              child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => showOptions(),
                    child: Image.asset(
                      'assets/app_launcher_icon.png',
                      scale: 1.7,
                    ),
                  )),
            ),
          ],
        ),
      ),*/
      /*bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: AppConst.titleList.map<Widget>(
                (e) {
                  return GestureDetector(
                    onTap: () {
                      _controller.changeIndex(AppConst.titleList.indexOf(e));
                      controller.animateToPage(AppConst.titleList.indexOf(e), duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
                    },
                    child: Wrap(
                      direction: Axis.vertical, alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: rSize * 0.008,
                        ),
                        Image.asset(
                          'assets/${e.toLowerCase()}.png',
                          scale: 25,
                          color: AppConst.titleList[_controller.selectedIndex] == e ? AppColors.kViolate : AppColors.kTextFieldInput,
                        ),
                        Text(
                          e,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto',
                            color:AppConst.titleList[_controller.selectedIndex] == e ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).customColor5,
                            fontSize: rSize*0.012,
                            letterSpacing: 0.0,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          )),
      drawer: AppWidgets.drawer((i) {
        _scaffoldkey.currentState!.closeDrawer();
        _controller.changeIndex(i);
        controller.animateToPage(i, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
        // controller=PageController(initialPage: value);
      }),*/
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: FlutterFlowTheme.of(context).info,
        currentIndex: _controller.selectedIndex,
        onTap: (value) {
          if (value != 2) {
            _controller.changeIndex(value);
            pagingController.animateToPage(value, duration: Duration(microseconds: 500), curve: Curves.bounceInOut);
          } else {
            showOptions();
          }
        },
        selectedLabelStyle: TextStyle(
          color: FlutterFlowTheme.of(context).primary,
          fontSize: rSize * 0.016,
          height: 0,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
        unselectedLabelStyle: TextStyle(
          color: FlutterFlowTheme.of(context).customColor4,
          fontSize: rSize * 0.016,
          height: 0,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
        elevation: 3,
        selectedItemColor: FlutterFlowTheme.of(context).primary,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: FlutterFlowTheme.of(context).customColor4,
        items: [
          BottomNavigationBarItem(
              icon: AppStyles.iconBg(context, data: Icons.home, size: rSize * 0.020, padding: EdgeInsets.all(rSize * 0.015), color: getColor(0)),
              label: FFLocalizations.of(context).getText('fiha8uf5' /* Home */)),
          BottomNavigationBarItem(
              icon: AppStyles.iconBg(context,
                  data: Icons.add_chart_outlined, size: rSize * 0.020, padding: EdgeInsets.all(rSize * 0.015), color: getColor(1)),
              label: FFLocalizations.of(context).getText('xn2nrgyp' /* Portfolio */)),
          BottomNavigationBarItem(
              icon: AppStyles.iconBg(context,
                  data: Icons.home,
                  size: rSize * 0.020,
                  padding: EdgeInsets.all(rSize * 0.015),
                  customIcon: Transform.rotate(angle: 1.7, child: Icon(Icons.compare_arrows, size: rSize * 0.025, color: getColor(2)))),
              label: FFLocalizations.of(context).getText('more')),
          BottomNavigationBarItem(
              icon:
                  AppStyles.iconBg(context, data: Icons.auto_graph, size: rSize * 0.020, padding: EdgeInsets.all(rSize * 0.015), color: getColor(3)),
              label: FFLocalizations.of(context).getText('nkifu7jq' /* Proposal */)),
          BottomNavigationBarItem(
              icon: AppStyles.iconBg(context, data: Icons.face, size: rSize * 0.020, padding: EdgeInsets.all(rSize * 0.015), color: getColor(4)),
              label: FFLocalizations.of(context).getText('w5wtcpj4' /* Profile */)),
        ],
      ),
      body: Container(
        decoration: AppStyles.commonBg(context),
        child: Stack(
          children: [
            PageView(
              controller: pagingController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                Home(),
                Portfolio(),
                Documents(),
                Proposals(),
                Profile(),
              ],
              onPageChanged: (page) {},
            ),
            /*Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.transparent,
                height: rSize * 0.12,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        Theme.of(context).brightness == Brightness.dark ? 'assets/bgBottomNavDark.png' : 'assets/bgBottomNavLight.png',
                        fit: BoxFit.cover,
                        // width: 200,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        bottombarCell(
                            context,
                            0,
                            Icons.home_rounded,
                            FFLocalizations.of(context).getText(
                              'fiha8uf5' */ /* Home */ /*,
                            )),
                        bottombarCell(
                            context,
                            1,
                            Icons.bar_chart,
                            FFLocalizations.of(context).getText(
                              'xn2nrgyp' */ /* Portfolio */ /*,
                            ),
                            widget: _controller.selectedIndex == 1
                                ? SvgPicture.asset(
                                    Theme.of(context).brightness == Brightness.dark ? 'assets/bar-chart-dark-theme.svg' : 'assets/bar_chart.svg',
                                    fit: BoxFit.contain,
                                  )
                                : null),
                        SizedBox(
                          width: rSize * 0.05,
                        ),
                        bottombarCell(
                            context,
                            2,
                            Icons.home_rounded,
                            FFLocalizations.of(context).getText(
                              'nkifu7jq' */ /* Proposal */ /*,
                            ),
                            widget: _controller.selectedIndex == 2
                                ? SvgPicture.asset(
                                    Theme.of(context).brightness == Brightness.dark
                                        ? 'assets/proposal-icon-new-dark-theme.svg'
                                        : 'assets/proposal-icon-new.svg',
                                    fit: BoxFit.contain,
                                  )
                                : SvgPicture.asset(
                                    Theme.of(context).brightness == Brightness.dark
                                        ? 'assets/proposal-icon-new-unselected-dark-theme.svg'
                                        : 'assets/proposal-icon-new-unselected.svg',
                                    fit: BoxFit.contain,
                                  )),
                        bottombarCell(
                            context,
                            3,
                            Icons.account_circle_rounded,
                            FFLocalizations.of(context).getText(
                              'w5wtcpj4' */ /* Profile */ /*,
                            )),
                      ],
                    ),
                    Positioned(
                      // width: MediaQuery.of(context).size.width,
                      bottom: isTablet?rSize * 0.038:rSize * 0.03,
                      child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () => showOptions(),
                            child: Image.asset(
                              'assets/app_launcher_icon.png',
                              scale: isTablet?0.7:1.7,
                              // height: rSize * 0.1,
                              // width: rSize * 0.1,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }

  Widget bottombarCell(BuildContext context, int index, IconData iconData, String label, {Widget? widget}) {
    return GestureDetector(
      onTap: () {
        _controller.changeIndex(index);
        pagingController.animateToPage(index, duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: rSize * 0.01,
          ),
          Container(
            margin: EdgeInsets.only(top: rSize * 0.010, bottom: 5),
            width: rSize * 0.04,
            height: rSize * 0.04,
            decoration: const BoxDecoration(),
            child: widget ??
                Icon(
                  iconData,
                  color: _controller.selectedIndex != index ? FlutterFlowTheme.of(context).customColor5 : FlutterFlowTheme.of(context).primary,
                  size: rSize * 0.04,
                ),
          ),
          Text(
            label,
            maxLines: 1,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.of(context).customColor5,
                  fontSize: rSize * 0.014,
                  letterSpacing: 0.0,
                  lineHeight: 1.0,
                ),
          ),
        ],
      ),
    );
  }

  // bool isPortfolio(int index) => _controller.selectedIndex==1 && index==1;

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        child: Wrap(
          children: [
            Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: AppStyles.shadow(),
                    borderRadius: BorderRadius.circular(rSize * 0.01)),
                margin: EdgeInsets.only(bottom: rSize * 0.11, left: rSize * 0.030, right: rSize * 0.030),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: rSize * 0.010, horizontal: rSize * 0.020),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      actionMenuItem(
                        context,
                        AppStyles.iconBg(context,
                            data: Icons.file_copy,
                            size: rSize * 0.020,
                            padding: EdgeInsets.all(rSize * 0.015),
                            color: FlutterFlowTheme.of(context).customColor4),
                        FFLocalizations.of(context).getText(
                          '13mzcnly' /* Document */,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          CommonFunctions.navigate(context, const Documents());
                        },
                      ),

                      actionMenuItem(
                        context,
                        AppStyles.iconBg(context,
                            data: Icons.home,
                            size: rSize * 0.020,
                            padding: EdgeInsets.all(rSize * 0.015),
                            customIcon: SvgPicture.asset(
                              Theme.of(context).brightness == Brightness.dark
                                  ? 'assets/money-bill-trend-up-solid-dark-theme.svg'
                                  : 'assets/money-bill-trend-up-solid.svg',
                              fit: BoxFit.contain,
                              color: FlutterFlowTheme.of(context).customColor4,
                              height: rSize * 0.025,
                              width: rSize * 0.025,
                            )),
                        FFLocalizations.of(context).getText(
                          'o5wm04m6' /* Market */,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          CommonFunctions.navigate(context, const Market());
                        },
                      ),

                      actionMenuItem(
                        context,
                        AppStyles.iconBg(context,
                            data: FontAwesomeIcons.upload,
                            size: rSize * 0.020,
                            padding: EdgeInsets.all(rSize * 0.015),
                            color: FlutterFlowTheme.of(context).customColor4),
                        FFLocalizations.of(context).getText(
                          '3hz1whes' /* Upload */,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          CommonFunctions.navigate(context, const UploadDocument());
                        },
                      ),

                      actionMenuItem(
                        context,
                        AppStyles.iconBg(context,
                            data: FontAwesomeIcons.message,
                            size: rSize * 0.020,
                            padding: EdgeInsets.all(rSize * 0.015),
                            color: FlutterFlowTheme.of(context).customColor4),
                        FFLocalizations.of(context).getText(
                          'chat',
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          CommonFunctions.navigate(context, ChatHistory(ProposalModel(advisor: Advisor(name: 'Static', phoneOffice: '123'))));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionMenuItem(BuildContext context, Widget image, String label, {required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          image,
          Text(
            label,
            maxLines: 1,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.of(context).customColor4,
                  fontSize: rSize * 0.014,
                  letterSpacing: 0.0,
                  lineHeight: 1.0,
                ),
          )
        ],
      ),
    );
  }

  getColor(int i) {
    if (_controller.selectedIndex == i) {
      return FlutterFlowTheme.of(context).primary;
    }
    return FlutterFlowTheme.of(context).customColor4;
  }
}
