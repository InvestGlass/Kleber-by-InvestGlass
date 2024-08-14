import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/portfolio/portfolio.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import '../market/market.dart';
import '../profile/profile.dart';
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
  late PageController controller;

  late DashboardController _controller;

  @override
  void initState() {
    if (AppConst.userModel != null) {
      SharedPrefUtils.instance.putString(USER_DATA, AppConst.userModel!.toRawJson());
    }
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<DashboardController>(context);
    return Scaffold(
      key: _scaffoldkey,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        height: rSize * 0.12,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              'assets/bgBottomNavDark.png',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                bottombarCell(
                    context,
                    0,
                    Icons.home_rounded,
                    FFLocalizations.of(context).getText(
                      'fiha8uf5' /* Home */,
                    )),
                bottombarCell(
                    context,
                    1,
                    Icons.bar_chart,
                    FFLocalizations.of(context).getText(
                      'xn2nrgyp' /* Portfolio */,
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
                      'nkifu7jq' /* Proposal */,
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
                      'w5wtcpj4' /* Profile */,
                    )),
              ],
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: 30,
              child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/app_launcher_icon.png',
                    scale: 1.7,
                  )),
            ),
          ],
        ),
      ),
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
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          )),*/
      drawer: AppWidgets.drawer((i) {
        _scaffoldkey.currentState!.closeDrawer();
        _controller.changeIndex(i);
        controller.animateToPage(i, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
        // controller=PageController(initialPage: value);
      }),
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: const [
          Home(),
          Portfolio(),
          // Market(),
          Proposals(),
          Profile(),
        ],
        onPageChanged: (page) {},
      ),
    );
  }

  Widget bottombarCell(BuildContext context, int index, IconData iconData, String label, {Widget? widget}) {
    return GestureDetector(
      onTap: () {
        _controller.changeIndex(index);
        controller.animateToPage(index, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: rSize * 0.01,
          ),
          Container(
            margin: EdgeInsets.only(top: 10,bottom: 5),
            width: _controller.iconSize,
            height: _controller.iconSize,
            decoration: const BoxDecoration(),
            child: widget ??
                Icon(
                  iconData,
                  color: _controller.selectedIndex != index ? FlutterFlowTheme.of(context).customColor5 : FlutterFlowTheme.of(context).primary,
                  size: _controller.iconSize,
                ),
          ),
          Text(
            label,
            maxLines: 1,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.of(context).customColor5,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  lineHeight: 1.0,
                ),
          ),
        ],
      ),
    );
  }
}
