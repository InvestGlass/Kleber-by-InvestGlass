import 'dart:convert';

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
      SharedPrefUtils.instance.putString(USER_DATA, jsonEncode(AppConst.userModel!.toJson()));
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
    c=context;
    _controller = Provider.of<DashboardController>(context);
    return Scaffold(
      key: _scaffoldkey,
      bottomNavigationBar: Wrap(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Row(
              children: [
                actionMenuItem(
                  context,
                  AppStyles.iconBg(context,
                      data: Icons.home,
                      size: rSize * 0.020,
                      padding: EdgeInsets.all(rSize * 0.015),
                      color: getColor(0)),
                  FFLocalizations.of(context).getText(
                      'fiha8uf5' /* Home */,
                  ),
                  onTap: () {
                    changeTab(0);
                  },i: 0
                ),
                actionMenuItem(
                  context,
                  AppStyles.iconBg(context,
                      data: Icons.add_chart_outlined,
                      size: rSize * 0.020,
                      padding: EdgeInsets.all(rSize * 0.015),
                      color: getColor(1)),
                  FFLocalizations.of(context).getText(
                      'xn2nrgyp' /* Portfolio */,
                  ),
                  onTap: () {
                    changeTab(1);
                  },i: 1
                ),
                actionMenuItem(
                  context,
                  AppStyles.iconBg(context,
                      data: Icons.file_copy,
                      size: rSize * 0.020,
                      padding: EdgeInsets.all(rSize * 0.015),
                      customIcon: Image.asset('assets/more.png', scale: 0.5,color: getColor(2),),
                      color: FlutterFlowTheme.of(context).customColor4),
                  FFLocalizations.of(context).getText(
                    'more',
                  ),
                  onTap: () {
                    showOptions();
                  },
                ),
                actionMenuItem(
                  context,
                  AppStyles.iconBg(context,
                      data: Icons.auto_graph,
                      size: rSize * 0.020,
                      padding: EdgeInsets.all(rSize * 0.015),
                      color: getColor(3)),
                  FFLocalizations.of(context).getText(
                      'nkifu7jq' /* Proposal */,
                  ),
                  onTap: () {
                    changeTab(3);
                  },i: 3
                ),
                actionMenuItem(
                  context,
                  AppStyles.iconBg(context,
                      data: Icons.face,
                      size: rSize * 0.020,
                      padding: EdgeInsets.all(rSize * 0.015),
                      color: getColor(4)),
                  FFLocalizations.of(context).getText(
                      'w5wtcpj4' /* Profile */,
                  ),
                  onTap: () {
                    changeTab(4);
                  },i: 4
                ),
              ],
            ),
          ),
        ],
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
        ),
        unselectedLabelStyle: TextStyle(
          color: FlutterFlowTheme.of(context).customColor4,
          fontSize: rSize * 0.016,
          height: 0,
          fontWeight: FontWeight.w600,
        ),
        elevation: 3,
        selectedItemColor: FlutterFlowTheme.of(context).primary,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: FlutterFlowTheme.of(context).customColor4,
        items: [
          BottomNavigationBarItem(
              icon: AppStyles.iconBg(context, data: Icons.home, size: rSize * 0.020, padding: EdgeInsets.all(rSize * 0.015), color: getColor(0)),
              label: FFLocalizations.of(context).getText('fiha8uf5' *//* Home *//*)),
          BottomNavigationBarItem(
              icon: AppStyles.iconBg(context,
                  data: Icons.add_chart_outlined, size: rSize * 0.020, padding: EdgeInsets.all(rSize * 0.015), color: getColor(1)),
              label: FFLocalizations.of(context).getText('xn2nrgyp' *//* Portfolio *//*)),
          BottomNavigationBarItem(
              icon: AppStyles.iconBg(context,
                  data: Icons.home,
                  size: rSize * 0.020,
                  padding: EdgeInsets.all(rSize * 0.015),
                  customIcon: Image.asset('assets/more.png', scale: 0.5,color: getColor(2),)),
              label: FFLocalizations.of(context).getText('more'),),
          BottomNavigationBarItem(
              icon:
                  AppStyles.iconBg(context, data: Icons.auto_graph, size: rSize * 0.020, padding: EdgeInsets.all(rSize * 0.015), color: getColor(3)),
              label: FFLocalizations.of(context).getText('nkifu7jq' *//* Proposal *//*)),
          BottomNavigationBarItem(
              icon: AppStyles.iconBg(context, data: Icons.face, size: rSize * 0.020, padding: EdgeInsets.all(rSize * 0.015), color: getColor(4)),
              label: FFLocalizations.of(context).getText('w5wtcpj4' *//* Profile *//*)),
        ],
      ),*/
      body: PageView(
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
    );
  }

  void changeTab(int i) {
    _controller.changeIndex(i);
    pagingController.animateToPage(i, duration: Duration(microseconds: 500), curve: Curves.bounceInOut);
  }


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
                margin: EdgeInsets.only(bottom: rSize * 0.11, left: rSize * 0.015, right: rSize * 0.015),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: rSize * 0.010),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      actionMenuItem(
                        context,
                        AppStyles.iconBg(context,
                            data: Icons.file_copy,
                            size: rSize * 0.020,
                            padding: EdgeInsets.all(rSize * 0.015),
                            color: FlutterFlowTheme.of(context).primary),
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
                              color: FlutterFlowTheme.of(context).primary,
                              height: rSize * 0.025,
                              width: rSize * 0.025,
                            )),
                        FFLocalizations.of(context).getText(
                          'd33p2mgm' /* Market */,
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
                            color: FlutterFlowTheme.of(context).primary),
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
                            color: FlutterFlowTheme.of(context).primary),
                        FFLocalizations.of(context).getText(
                          'chat',
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          CommonFunctions.navigate(context, ChatHistory(ProposalModel(advisor: Advisor(name: SharedPrefUtils.instance.getUserData().user!.advisor!.name.toString(), phoneOffice: '+41763358815'))));
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

  Widget actionMenuItem(BuildContext context, Widget image, String label, {required void Function() onTap, int i=-1}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            image,
            Text(
              label,
              maxLines: 1,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: i==_controller.selectedIndex?FlutterFlowTheme.of(context).primary:FlutterFlowTheme.of(context).customColor4,
                    fontSize: rSize * 0.016,
                  ),
            )
          ],
        ),
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
