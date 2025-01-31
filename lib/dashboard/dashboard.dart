import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kleber_bank/documents/documents.dart';
import 'package:kleber_bank/documents/documents2.dart';
import 'package:kleber_bank/documents/upload_document.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/portfolio/bank_transfer.dart';
import 'package:kleber_bank/portfolio/portfolio.dart';
import 'package:kleber_bank/proposals/chat/chat_history.dart';
import 'package:kleber_bank/universal_list.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import '../market/market.dart';
import '../notifications/notification_list.dart';
import '../portfolio/portfolio_controller.dart';
import '../profile/profile.dart';
import '../proposals/proposal_model.dart';
import '../proposals/proposals.dart';
import '../stratagy/stratagy.dart';
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
  StreamController<String> controller = StreamController.broadcast();

  @override
  void initState() {
    if (AppConst.userModel != null) {
      SharedPrefUtils.instance
          .putString(USER_DATA, jsonEncode(AppConst.userModel!.toJson()));
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
    c = context;
    _controller = Provider.of<DashboardController>(context);
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppWidgets.appBar(context, getTitle(),
          leading: Container(
              padding: EdgeInsets.all(rSize * 0.008),
              child: Image.asset(
                'assets/app_launcher_icon.png',
              )),
          actions: [
            AppWidgets.click(
              onTap: () =>
                  CommonFunctions.navigate(context,  NotificationList()),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: rSize * 0.005, right: rSize * 0.005),
                    child: Icon(FontAwesomeIcons.bell,
                        size: rSize * 0.02,
                        color: FlutterFlowTheme.of(context).customColor4),
                  ),
                  Positioned(
                    top: rSize * 0.013,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(rSize * 0.005),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: FlutterFlowTheme.of(context).primary),
                      child: Text('2',
                          style: AppStyles.inputTextStyle(context).copyWith(
                              color: FlutterFlowTheme.of(context).info,
                              fontSize: rSize * 0.01)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: rSize * 0.015,
            )
          ]),
      bottomNavigationBar: Wrap(
        children: [
          Container(
            margin:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Row(
              children: [
                actionMenuItem(
                    context,
                    fit: FlexFit.tight,
                    AppStyles.iconBg(context,
                        data: FontAwesomeIcons.house, size: rSize * 0.020, onTap: () {
                      changeTab(0);
                    },
                        padding: EdgeInsets.all(rSize * 0.015),
                        color: getColor(0)),
                    FFLocalizations.of(context).getText(
                      'fiha8uf5' /* Overview */,
                    ),
                    i: 0),
                actionMenuItem(
                    context,
                    fit: FlexFit.tight,
                    AppStyles.iconBg(context,
                        data: Icons.add_chart_outlined,
                        size: rSize * 0.020, onTap: () {
                      changeTab(1);
                    },
                        padding: EdgeInsets.all(rSize * 0.015),
                        color: getColor(1)),
                    FFLocalizations.of(context).getText(
                      'xn2nrgyp' /* Portfolio */,
                    ),
                    i: 1),
                actionMenuItem(
                  context,
                  fit: FlexFit.tight,
                  AppStyles.iconBg(context,
                      data: FontAwesomeIcons.grip, size: rSize * 0.020, onTap: () {
                    showOptions();
                  },
                      padding: EdgeInsets.all(rSize * 0.015),
                      customIcon: null,
                      color: FlutterFlowTheme.of(context).customColor4),
                  FFLocalizations.of(context).getText(
                    'more',
                  ),
                ),
                actionMenuItem(
                    context,
                    fit: FlexFit.tight,
                    AppStyles.iconBg(context,
                        data: Icons.auto_graph, size: rSize * 0.020, onTap: () {
                      changeTab(3);
                      controller.add('');
                    },
                        padding: EdgeInsets.all(rSize * 0.015),
                        color: getColor(3)),
                    FFLocalizations.of(context).getText(
                      'nkifu7jq' /* Proposal */,
                    ),
                    i: 3),
                actionMenuItem(
                    context,
                    fit: FlexFit.tight,
                    AppStyles.iconBg(context,
                        data: FontAwesomeIcons.user,
                        size: rSize * 0.020, onTap: () {
                      changeTab(4);
                    },
                        padding: EdgeInsets.all(rSize * 0.015),
                        color: getColor(4)),
                    FFLocalizations.of(context).getText(
                      'w5wtcpj4' /* Profile */,
                    ),
                    i: 4),
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
              label: FFLocalizations.of(context).getText('fiha8uf5' */ /* Home */ /*)),
          BottomNavigationBarItem(
              icon: AppStyles.iconBg(context,
                  data: Icons.add_chart_outlined, size: rSize * 0.020, padding: EdgeInsets.all(rSize * 0.015), color: getColor(1)),
              label: FFLocalizations.of(context).getText('xn2nrgyp' */ /* Portfolio */ /*)),
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
              label: FFLocalizations.of(context).getText('nkifu7jq' */ /* Proposal */ /*)),
          BottomNavigationBarItem(
              icon: AppStyles.iconBg(context, data: Icons.face, size: rSize * 0.020, padding: EdgeInsets.all(rSize * 0.015), color: getColor(4)),
              label: FFLocalizations.of(context).getText('w5wtcpj4' */ /* Profile */ /*)),
        ],
      ),*/
      body: PageView(
        controller: pagingController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Home(),
          const Portfolio(),
          const Documents(),
          Proposals(controller),
          const Profile(),
        ],
        onPageChanged: (page) {},
      ),
    );
  }

  void changeTab(int i) {
    _controller.changeIndex(i);
    pagingController.animateToPage(i,
        duration: const Duration(microseconds: 500), curve: Curves.bounceInOut);
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        child: Wrap(
          children: [
            /*SizedBox(
              height: rSize*0.3,
              child: GridView(

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 1),
              children: [
                actionMenuItem(
                  context,
                  AppStyles.iconBg(context,
                      data: FontAwesomeIcons.chartLine,
                      color: FlutterFlowTheme.of(context).customColor4,
                      size: rSize * 0.020, onTap: () {
                        Navigator.pop(context);
                        CommonFunctions.navigate(context, const Market());
                      },
                      padding: EdgeInsets.all(rSize * 0.015),
                      customIcon: null),
                  FFLocalizations.of(context).getText(
                    'd33p2mgm' *//* Market *//*,
                  ),
                ),
                actionMenuItem(
                  context,
                  AppStyles.iconBg(context,
                      data: Icons.currency_exchange,
                      size: rSize * 0.020, onTap: () async {
                        // Navigator.pop(context);
                        PortfolioController n =
                        Provider.of<PortfolioController>(context,
                            listen: false);
                        CommonFunctions.showLoader(context);
                        await Future.wait([
                          n.getPortfolioList(context, 0, notify: true),
                          n.fetchDropDownData(
                              context, 'transaction_type'),
                          n.fetchDropDownData(context, 'currency'),
                          n.fetchDropDownData(
                              context, 'transaction_status'),
                        ]).then(
                              (value) async {
                            if (n.currencyList.isNotEmpty) {
                              await n.selectCurrency(
                                  context, n.currencyList[0]);
                            }
                            CommonFunctions.dismissLoader(context);
                            CommonFunctions.navigate(
                                context, const BankTransfer());
                          },
                        );
                      },
                      padding: EdgeInsets.all(rSize * 0.015),
                      color:
                      FlutterFlowTheme.of(context).customColor4),
                  FFLocalizations.of(context).getText(
                    'bank_transfer',
                  ),
                ),
                actionMenuItem(
                  context,
                  AppStyles.iconBg(context,
                      data: Icons.file_copy,
                      size: rSize * 0.020, onTap: () {
                        Navigator.pop(context);
                        CommonFunctions.navigate(
                            context, const Documents2());
                      },
                      padding: EdgeInsets.all(rSize * 0.015),
                      color:
                      FlutterFlowTheme.of(context).customColor4),
                  FFLocalizations.of(context).getText(
                    '1vddbh59' *//* Document *//*,
                  ),
                ),
                actionMenuItem(
                  context,
                  AppStyles.iconBg(context,
                      data: FontAwesomeIcons.upload,
                      size: rSize * 0.020, onTap: () {
                        Navigator.pop(context);
                        CommonFunctions.navigate(
                            context, const UploadDocument());
                      },
                      padding: EdgeInsets.all(rSize * 0.015),
                      color:
                      FlutterFlowTheme.of(context).customColor4),
                  FFLocalizations.of(context).getText(
                    '3hz1whes' *//* Upload *//*,
                  ),
                ),
                actionMenuItem(
                  context,
                  AppStyles.iconBg(context,
                      data: FontAwesomeIcons.scaleBalanced,
                      size: rSize * 0.020, onTap: () {
                        Navigator.pop(context);
                        CommonFunctions.navigate(
                            context, const Strategy());
                      },
                      padding: EdgeInsets.all(rSize * 0.015),
                      color:
                      FlutterFlowTheme.of(context).customColor4),
                  'Strategy',
                ),
                actionMenuItem(
                  context,
                  AppStyles.iconBg(context,
                      data: FontAwesomeIcons.gavel,
                      size: rSize * 0.020, onTap: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.all(rSize * 0.015),
                      color:
                      FlutterFlowTheme.of(context).customColor4),
                  'Universal List',
                ),
              ],
              ),
            ),*/
            Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: AppStyles.shadow(),
                    borderRadius: BorderRadius.circular(rSize * 0.01)),
                margin: EdgeInsets.only(
                    bottom: rSize * 0.11,
                    left: rSize * 0.01,
                    right: rSize * 0.01),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: rSize * 0.010),
                  child: Column(
                    children: [
                      SizedBox(
                        height: rSize * 0.05,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          actionMenuItem(
                            context,
                            AppStyles.iconBg(context,
                                data: FontAwesomeIcons.chartLine,
                                color: FlutterFlowTheme.of(context).customColor4,
                                size: rSize * 0.020, onTap: () {
                              Navigator.pop(context);
                              CommonFunctions.navigate(context, const Market());
                            },
                                padding: EdgeInsets.all(rSize * 0.015),
                                customIcon: null),
                            FFLocalizations.of(context).getText(
                              'd33p2mgm' /* Market */,
                            ),
                          ),
                          actionMenuItem(
                            context,
                            AppStyles.iconBg(context,
                                data: Icons.currency_exchange,
                                size: rSize * 0.020, onTap: () async {
                              // Navigator.pop(context);
                              PortfolioController n =
                                  Provider.of<PortfolioController>(context,
                                      listen: false);
                              CommonFunctions.showLoader(context);
                              await Future.wait([
                                n.getPortfolioList(context, 0, notify: true),
                                n.fetchDropDownData(
                                    context, 'transaction_type'),
                                n.fetchDropDownData(context, 'currency'),
                                n.fetchDropDownData(
                                    context, 'transaction_status'),
                              ]).then(
                                (value) async {
                                  if (n.currencyList.isNotEmpty) {
                                    await n.selectCurrency(
                                        context, n.currencyList[0]);
                                  }
                                  CommonFunctions.dismissLoader(context);
                                  CommonFunctions.navigate(
                                      context, const BankTransfer());
                                },
                              );
                            },
                                padding: EdgeInsets.all(rSize * 0.015),
                                color:
                                    FlutterFlowTheme.of(context).customColor4),
                            FFLocalizations.of(context).getText(
                              'bank_transfer',
                            ),
                          ),
                          actionMenuItem(
                            context,
                            AppStyles.iconBg(context,
                                data: Icons.file_copy,
                                size: rSize * 0.020, onTap: () {
                              Navigator.pop(context);
                              CommonFunctions.navigate(
                                  context, const Documents2());
                            },
                                padding: EdgeInsets.all(rSize * 0.015),
                                color:
                                    FlutterFlowTheme.of(context).customColor4),
                            FFLocalizations.of(context).getText(
                              '1vddbh59' /* Document */,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: rSize * 0.05,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          actionMenuItem(
                            context,
                            AppStyles.iconBg(context,
                                data: FontAwesomeIcons.upload,
                                size: rSize * 0.020, onTap: () {
                              Navigator.pop(context);
                              CommonFunctions.navigate(
                                  context, const UploadDocument());
                            },
                                padding: EdgeInsets.all(rSize * 0.015),
                                color:
                                    FlutterFlowTheme.of(context).customColor4),
                            FFLocalizations.of(context).getText(
                              '3hz1whes' /* Upload */,
                            ),
                          ),
                          actionMenuItem(
                            context,
                            AppStyles.iconBg(context,
                                data: FontAwesomeIcons.scaleBalanced,
                                size: rSize * 0.020, onTap: () {
                              Navigator.pop(context);
                              CommonFunctions.navigate(
                                  context, const Strategy());
                            },
                                padding: EdgeInsets.all(rSize * 0.015),
                                color:
                                    FlutterFlowTheme.of(context).customColor4),
                            FFLocalizations.of(context).getText(
                              'strategy',
                            ),
                          ),
                          actionMenuItem(
                            context,
                            AppStyles.iconBg(context,
                                data: FontAwesomeIcons.gavel,
                                size: rSize * 0.020, onTap: () {
                              CommonFunctions.navigate(context, const UniversalList());
                            },
                                padding: EdgeInsets.all(rSize * 0.015),
                                color:
                                    FlutterFlowTheme.of(context).customColor4),
                            FFLocalizations.of(context).getText(
                              'universe_list',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: rSize * 0.05,
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

  Widget actionMenuItem(BuildContext context, Widget image, String label,
      {int i = -1, FlexFit fit = FlexFit.loose}) {
    return Flexible(
      fit: fit,
      child: Column(
        children: [
          image,
          SizedBox(height: rSize * 0.01,),
          Text(
            label,
            maxLines: 1,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: i == _controller.selectedIndex
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).customColor4,
                  fontSize: rSize * 0.016,
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

  String getTitle() {
    if (_controller.selectedIndex == 0) {
      return FFLocalizations.of(context).getText(
        'fiha8uf5' /* Overview */,
      );
    } else if (_controller.selectedIndex == 1) {
      return FFLocalizations.of(context).getText(
        'xn2nrgyp' /* Portfolio */,
      );
    } else if (_controller.selectedIndex == 3) {
      return FFLocalizations.of(context).getText(
        'nkifu7jq' /* Proposal */,
      );
    } else if (_controller.selectedIndex == 4) {
      return FFLocalizations.of(context).getText(
        'w5wtcpj4' /* Profile */,
      );
    }
    return '';
  }
}
