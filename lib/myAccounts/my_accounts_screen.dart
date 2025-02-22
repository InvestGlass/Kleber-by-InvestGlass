import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kleber_bank/login/user_info_model.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';

import '../main.dart';
import '../utils/app_styles.dart';
import '../utils/flutter_flow_theme.dart';

class MyAccountsScreen extends StatefulWidget {
  const MyAccountsScreen({super.key});

  @override
  _MyAccountsScreenState createState() => _MyAccountsScreenState();
}

class _MyAccountsScreenState extends State<MyAccountsScreen> {
  String cardNumber = '8888 4242 4242 8888';
  String expiryDate = '12/25';
  String cardHolderName = 'John Doe';
  String cvvCode = '12345';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(context, "ALL MY ACCOUNTS", leading: AppWidgets.backArrow(context)),
      body: ListView(
        shrinkWrap: true,
        children: [
          CreditCardWidget(
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            cardBgColor: Colors.blueAccent,
            bankName: 'Arab Bank',
            onCreditCardWidgetChange: (creditCardBrand) {},
          ),
          Container(
            margin: EdgeInsets.only(left: rSize * 0.015, right: rSize * 0.015, bottom: rSize * 0.015),
            padding: EdgeInsets.all(rSize * 0.015),
            decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: AppStyles.shadow(),
                borderRadius: BorderRadius.circular(rSize * 0.01)),
            child: Row(
              children: [
                buildColumn(context, 'Income', FlutterFlowTheme.of(context).success, FontAwesomeIcons.arrowUp),
                buildColumn(context, 'Outcome', FlutterFlowTheme.of(context).error, FontAwesomeIcons.arrowDown),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left:rSize*0.015,top:rSize*0.015,bottom:rSize*0.01),
            child: Text('Detail of Movements',style: FlutterFlowTheme.of(context).displaySmall.override(
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: rSize * 0.016,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              listItem(context, 'Restaurant Manhattan', FlutterFlowTheme.of(context).success, FontAwesomeIcons.arrowUp),
              listItem(context, 'Salary Deposit', FlutterFlowTheme.of(context).success, FontAwesomeIcons.arrowUp),
              listItem(context, 'Central Market', FlutterFlowTheme.of(context).error, FontAwesomeIcons.arrowDown),
            ],
          )
        ],
      ),
    );
  }

  Widget buildColumn(BuildContext context, String name, Color color, IconData arrow) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: rSize * 0.005, horizontal: rSize * 0.02),
            margin: EdgeInsets.only(bottom: rSize * 0.01),
            decoration:
                BoxDecoration(border: Border.all(color: FlutterFlowTheme.of(context).alternate, width: 1), borderRadius: BorderRadius.circular(100)),
            child: Text(name,
                style: FlutterFlowTheme.of(context).displaySmall.override(
                      color: FlutterFlowTheme.of(context).customColor4,
                      fontSize: rSize * 0.016,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                    )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                arrow,
                color: color,
                size: rSize * 0.02,
              ),
              Text(
                '  CHF 9,302.00',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontSize: rSize * 0.02,
                      color: color,
                      letterSpacing: 0.0,
                    ),
              )
            ],
          )
        ],
      ),
    );
  }
  Widget listItem(BuildContext context, String name, Color color, IconData arrow) {
    return Container(
      decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: AppStyles.shadow(),
          borderRadius: BorderRadius.circular(rSize * 0.01)),
      padding: EdgeInsets.all(rSize*0.015),
      margin: EdgeInsets.symmetric(vertical: rSize*0.007,horizontal: rSize*0.015),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.explosion,color: FlutterFlowTheme.of(context).secondaryText,),
          SizedBox(width: rSize*0.015,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: FlutterFlowTheme.of(context).displaySmall.override(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: rSize * 0.016,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        )),
                Text('june 10, 2024',
                    style: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .override(
                      color:
                      FlutterFlowTheme.of(context).customColor4,
                      fontSize: rSize * 0.014,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CHF 9,302.00  ',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontSize: rSize * 0.02,
                  color: color,
                  letterSpacing: 0.0,
                ),
              ),
              Icon(
                arrow,
                color: color,
                size: rSize * 0.02,
              ),
            ],
          )
        ],
      ),
    );
  }

  User? user() => SharedPrefUtils.instance.getUserData().user;
}
