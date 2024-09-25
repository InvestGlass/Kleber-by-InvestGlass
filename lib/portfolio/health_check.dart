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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Padding(
          padding: EdgeInsets.all(rSize * 0.015),
          child: Column(
            children: [
              SizedBox(
                height: rSize * 0.015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      FFLocalizations.of(context).getText(
                        'acyeoaaw' /* Portfolio Health Check */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto',
                            color: FlutterFlowTheme.of(context).primary,
                            fontSize: rSize*0.025,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: FlutterFlowTheme.of(context).primary,
                      ))
                ],
              ),
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical:rSize * 0.015),
                children: [
                  AppWidgets.healthAlertElement(context,
                      '   ${FFLocalizations.of(context).getText(
                        'kc4yx2mm' /* MINOR ISSUES */,
                      )}',
                      FlutterFlowTheme.of(context).primaryBackground,
                      Icons.report_problem_outlined,
                      FFLocalizations.of(context).getText(
                        '3vkimctv' /* Appropriateness */,
                      ),
                      appropriateness!,
                      FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
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
                      FlutterFlowTheme.of(context).primaryBackground,
                      Icons.info_outline,
                      FFLocalizations.of(context).getText(
                        'dxc8grzt' /* Suitability */,
                      ),
                      suitability!,
                      FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto',
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
    );
  }
}
