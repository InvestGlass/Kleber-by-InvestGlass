import 'package:flutter/material.dart';
import 'package:kleber_bank/portfolio/portfolio_model.dart';
import 'package:kleber_bank/utils/app_widgets.dart';

import '../main.dart';

class HealthCheck extends StatelessWidget {
  final Appropriateness? appropriateness, suitability;
  const HealthCheck(this.appropriateness,this.suitability,{super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar('Portfolio Health Check'),
      body: Card(
        color: Colors.white,
        margin: EdgeInsets.all(rSize*0.015),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(rSize*0.015),
          children: [
            AppWidgets.healthAlertElement('   Minor Issues',  Colors.blue, Icons.info_outline,'Suitability',suitability!),
            SizedBox(
              height: rSize * 0.015,
            ),
            AppWidgets.healthAlertElement('   Major Issues', Colors.red, Icons.report_problem_outlined,'Appropriateness',appropriateness!),
            SizedBox(
              height: rSize * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
