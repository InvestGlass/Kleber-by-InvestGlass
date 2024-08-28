import 'package:kleber_bank/login/login.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/common_functions.dart';

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
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        decoration: AppStyles.commonBg(context),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(30.0, 35.0, 30.0, 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 10 + MediaQuery.of(context).padding.top,
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
                              borderRadius: BorderRadius.circular(12.0),
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
                                FFButtonWidget(
                                  onPressed: () async {
                                    CommonFunctions.navigate(context, Login(), removeCurrentScreenFromStack: true);
                                  },
                                  text: FFLocalizations.of(context).getText(
                                    '3h41wkxj' /* Sign in */,
                                  ),
                                  options: FFButtonOptions(
                                    width: MediaQuery.sizeOf(context).width * 0.5,
                                    height: 50.0,
                                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 3.0,
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  showLoadingIndicator: false,
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0.0, -1.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                Theme.of(context).brightness == Brightness.dark ? 'assets/white-investglass.png' : 'assets/logo.png',
                                width: 150.0,
                                height: 50.0,
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
