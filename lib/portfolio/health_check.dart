import 'package:flutter/material.dart';
import 'package:kleber_bank/portfolio/portfolio_model.dart';
import 'package:kleber_bank/utils/app_widgets.dart';

import '../main.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';

class HealthCheck extends StatelessWidget {
  final Appropriateness? appropriateness, suitability;

  const HealthCheck(this.appropriateness, this.suitability, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppWidgets.appBar(context, FFLocalizations.of(context).getText(
          'acyeoaaw' /* Portfolio Health Check */,
        ),leading: AppWidgets.backArrow(context)),
        body: Padding(
          padding: EdgeInsets.all(rSize * 0.015),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom:rSize * 0.015),
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    AppWidgets.healthAlertElement(context,
                        '   ${FFLocalizations.of(context).getText(
                          'kc4yx2mm' /* MINOR ISSUES */,
                        )}',
                        FlutterFlowTheme.of(context).secondaryBackground,
                        Icons.report_problem_outlined,
                        FFLocalizations.of(context).getText(
                          '3vkimctv' /* Appropriateness */,
                        ),
                        appropriateness!,
                        FlutterFlowTheme.of(context).bodyMedium.override(

                          color: FlutterFlowTheme.of(context).warning,
                          fontSize: rSize*0.016,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(
                      height: rSize * 0.015,
                    ),
                    AppWidgets.healthAlertElement(context,
                        '   ${FFLocalizations.of(context).getText(
                          'ko88t7mf' /* MAJOR ISSUES */,
                        )}',
                        FlutterFlowTheme.of(context).secondaryBackground,
                        Icons.info_outline,
                        FFLocalizations.of(context).getText(
                          'dxc8grzt' /* Suitability */,
                        ),
                        suitability!,
                        FlutterFlowTheme.of(context).bodyMedium.override(

                              color: FlutterFlowTheme.of(context).error,
                              fontSize: rSize*0.016,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            )),
                    SizedBox(
                      height: rSize * 0.02,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
