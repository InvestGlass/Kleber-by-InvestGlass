import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/utils/app_widgets.dart';

import '../utils/app_styles.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar('New Trade'),
      body: Card(
        color: Colors.white,
        margin: EdgeInsets.all(rSize*0.015),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(rSize*0.015),
          children: [
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                // showSelectedItems: true,
                showSearchBox: true,
                searchDelay: Duration.zero,
              ),
              items: ["ALPHA",'BETA'],
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: AppStyles.dropDownInputDecoration(AppWidgets.textFieldLabel('Portfolio')),
              ),
              onChanged: print,
              selectedItem:null,
            ),
            SizedBox(height: rSize*0.015,),
            TextFormField(
              readOnly: true,
              decoration: AppStyles.inputDecoration(context,hint: 'Name, ISIN, FIGI or Ticket',label:'Name, ISIN, FIGI or Ticket' ),
            ),
            SizedBox(height: rSize*0.015,),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                // showSelectedItems: true,
                showSearchBox: true,
                searchDelay: Duration.zero,constraints:BoxConstraints(maxHeight: rSize*0.3)
              ),
              items: ["SELL TO OPEN",'SELL TO CLOSE'],
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: AppStyles.dropDownInputDecoration(AppWidgets.textFieldLabel('Type')),
              ),
              onChanged: print,
              selectedItem: null,
            ),
            SizedBox(height: rSize*0.015,),
            TextFormField(
              readOnly: true,
              onTap: () {
                // openDateTimePicker();
              },
              decoration: AppStyles.inputDecoration(context,hint: 'Select Date and Time',label:'Time In Force' ),
            ),
            SizedBox(height: rSize*0.015,),
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
