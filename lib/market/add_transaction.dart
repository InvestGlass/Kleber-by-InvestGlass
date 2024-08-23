import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/utils/app_widgets.dart';

import '../utils/app_styles.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyles.commonBg(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppWidgets.appBar(context,'New Trade',centerTitle: true),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(rSize*0.015),
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
              child: Text(
                FFLocalizations.of(context).getText(
                  'xn2nrgyp' /* Portfolio */,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                ),
              ),
            ),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                // showSelectedItems: true,
                showSearchBox: true,
                searchDelay: Duration.zero,
              ),
              items: ["ALPHA",'BETA'],
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: AppStyles.dropDownInputDecoration(context,AppWidgets.textFieldLabel('Portfolio')),
              ),
              onChanged: print,
              selectedItem:null,
            ),
            SizedBox(height: rSize*0.015,),
            label(context, 'rumkikc1' /* Name, ISIN, FIGI or Ticket */),
            TextFormField(
              readOnly: true,
              decoration: AppStyles.inputDecoration(context,hint: 'Name, ISIN, FIGI or Ticket',label:'Name, ISIN, FIGI or Ticket' ),
            ),
            SizedBox(height: rSize*0.015,),
            label(context, 'whkrwls1' /* Type */),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                // showSelectedItems: true,
                showSearchBox: true,
                searchDelay: Duration.zero,constraints:BoxConstraints(maxHeight: rSize*0.3)
              ),
              items: ["SELL TO OPEN",'SELL TO CLOSE'],
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: AppStyles.dropDownInputDecoration(context,AppWidgets.textFieldLabel('Type')),
              ),
              onChanged: print,
              selectedItem: null,
            ),
            SizedBox(height: rSize*0.015,),
            label(context, '7fx237xy' /* Time In Force */),
            TextFormField(
              readOnly: true,
              onTap: () {
                // openDateTimePicker();
              },
              decoration: AppStyles.inputDecoration(context,hint: 'Select Date and Time',label:'Time In Force' ),
            ),
            SizedBox(height: rSize*0.015,),
            label(context,'2mpa9jiq' /* Notes */),
            TextFormField(
              decoration: AppStyles.inputDecoration(context,hint: 'Enter note...',label:'Notes' ),
            ),
            SizedBox(height: rSize*0.015,),
            TextFormField(
              decoration: AppStyles.inputDecoration(context,hint: 'Order Type',label:'Order Type' ),
            ),
            SizedBox(height: rSize*0.015,),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: AppStyles.inputDecoration(context,hint: 'Quantity',label:'Quantity', ),
            ),
            SizedBox(height: rSize*0.015,),
            TextFormField(
              readOnly: true,
              decoration: AppStyles.inputDecoration(context,label:'Current Price (\$)'),
            ),
            SizedBox(height: rSize*0.015,),
            TextFormField(
              readOnly: true,
              decoration: AppStyles.inputDecoration(context,label:'Limit Price (\$)'),
            ),
            SizedBox(height: rSize*0.015,),
            TextFormField(
              readOnly: true,
              decoration: AppStyles.inputDecoration(context,label:'Amount (\$)'),
            ),
            SizedBox(height: rSize*0.03,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppWidgets.btn(context,'Transmit',horizontalPadding: rSize*0.02),
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding label(BuildContext context,String text) {
    return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
                0.0, 0.0, 0.0, 5.0),
            child: Text(
              FFLocalizations.of(context).getText(
                text,
              ),
              style: FlutterFlowTheme.of(context)
                  .bodyMedium
                  .override(
                fontFamily: 'Roboto',
                fontSize: 16.0,
                letterSpacing: 0.0,
              ),
            ),
          );
  }

  /*void openDateTimePicker() {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true, onChanged: (date) {
          print('change $date in time zone ' +
              date.timeZoneOffset.inHours.toString());
        }, onConfirm: (date) {
          print('confirm $date');
        }, currentTime: DateTime.now());
  }*/
}
