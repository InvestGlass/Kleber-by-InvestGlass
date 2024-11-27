import 'package:kleber_bank/login/login.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/common_functions.dart';

import '../main.dart';
import '../utils/button_widget.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import 'package:flutter/material.dart';

class OnBoardingPageWidget extends StatefulWidget {
  const OnBoardingPageWidget({super.key});

  @override
  State<OnBoardingPageWidget> createState() => _OnBoardingPageWidgetState();
}

class _OnBoardingPageWidgetState extends State<OnBoardingPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    c=context;
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        decoration: AppStyles.commonBg(context),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(rSize*0.030, rSize*0.035, rSize*0.030, rSize*0.030),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: MediaQuery.of(context).padding.top-(20),
                    decoration: const BoxDecoration(),
                  ),
                  Expanded(
                    child: Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: Image.asset(
                                  Theme.of(context).brightness == Brightness.dark
                                      ? 'assets/onboarding_background_dark_theme.png'
                                      : 'assets/onborading_background.png',
                                ).image,
                              ),
                              borderRadius: BorderRadius.circular(rSize*0.012),
                            ),
                          ),
                          if (false)
                            Container(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              height: MediaQuery.sizeOf(context).height * 1.0,
                              decoration: BoxDecoration(
                                color: const Color(0x64FFFFFF),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.78),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(child: SizedBox(),),
                                    Expanded(
                                      flex: 2,
                                      child: GestureDetector(
                                        onTap: () => CommonFunctions.navigate(context, const Login(), removeCurrentScreenFromStack: true),
                                        child: AppWidgets.btn(context, FFLocalizations.of(context).getText(
                                          '3h41wkxj' /* Sign in */,
                                        )),
                                      ),
                                    ),
                                    const Expanded(child: SizedBox(),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.0, -1.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(rSize*0.008),
                              child: Image.asset(
                                Theme.of(context).brightness == Brightness.dark ? 'assets/white-investglass.png' : 'assets/logo.png',
                                width: rSize*0.150,
                                height: rSize*0.050,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
