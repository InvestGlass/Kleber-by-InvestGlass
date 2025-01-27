import 'package:flutter/material.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/portfolio/portfolio_controller.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/searchable_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../utils/common_functions.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import 'data_model.dart';

class BankTransfer extends StatefulWidget {
  const BankTransfer({super.key});

  @override
  State<BankTransfer> createState() => _BankTransferState();
}

class _BankTransferState extends State<BankTransfer> {
  late PortfolioController _notifier;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _notifier.selectedType='';
    _notifier.selectedStatus='';
    _notifier.amountController.clear();
    _notifier.selectedCurrency=null;
    _notifier.usdController.clear();
    _notifier.openRateController.clear();
    _notifier.selectedTransactionDate='';
    _notifier.selectedAccountingDate='';
    _notifier.selectedValueDate='';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<PortfolioController>(context);
    return Scaffold(
      appBar: AppWidgets.appBar(
          context,
          FFLocalizations.of(context)
              .getText(
                "bank_transfer",
              )
              .toUpperCase(),
          leading: AppWidgets.backArrow(context)),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(rSize * 0.015),
        children: [
          AppWidgets.label(
              context,
              FFLocalizations.of(context).getText(
                'xn2nrgyp' /* Portfolio */,
              )),
          SizedBox(
            height: rSize * 0.005,
          ),
          SearchableDropdown(
            selectedValue: _notifier.selectedPortfolio,
            searchHint: FFLocalizations.of(context).getText(
              'm7418olr' /* Search for transaction type */,
            ),
            hint: _notifier.selectedPortfolio?.title ?? '',
            onChanged: (p0) {
              _notifier.selectPortfolio(p0);
            },
            items: (_notifier.portfolioList)
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item.title!,
                        style: AppStyles.inputTextStyle(context),
                      ),
                    ))
                .toList(),
            searchMatchFn: (item, searchValue) {
              return CommonFunctions.compare(
                  searchValue, item.value.title.toString());
            },
          ),
          SizedBox(
            height: rSize * 0.015,
          ),
          AppWidgets.label(
              context,
              FFLocalizations.of(context).getText(
                'lvtq8f1d' /* trans type */,
              )),
          SizedBox(
            height: rSize * 0.005,
          ),
          SearchableDropdown(
            selectedValue: _notifier.selectedType,
            searchHint: '',
            onChanged: (p0) {},
            items: _notifier.cashTransactionTypeList
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        _notifier.capitalizeFirstLetter(item.name??'').replaceAll('_', ' '),
                        style: AppStyles.inputTextStyle(context),
                      ),
                    ))
                .toList(),
            searchMatchFn: (item, searchValue) =>  CommonFunctions.compare(
              searchValue, item.value.name.toString()),
            isSearchable: true,
          ),
          SizedBox(
            height: rSize * 0.015,
          ),
          AppWidgets.label(
              context,
              FFLocalizations.of(context).getText(
                'z3seosat' /* transaction status */,
              )),
          SizedBox(
            height: rSize * 0.005,
          ),
          SearchableDropdown(
            selectedValue: _notifier.selectedStatus,
            searchHint: '',
            onChanged: (p0) {},
            items: _notifier.statusList
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item.name??'',
                        style: AppStyles.inputTextStyle(context),
                      ),
                    ))
                .toList(),
            searchMatchFn: (item, searchValue) =>  CommonFunctions.compare(
                searchValue, item.value.name.toString()),
            isSearchable: true,
          ),
          SizedBox(
            height: rSize * 0.015,
          ),
          AppWidgets.label(
              context,
              FFLocalizations.of(context).getText(
                '4noemhfd' /* amount */,
              )),
          Container(
            margin: EdgeInsets.only(top: rSize * 0.005, bottom: rSize * 0.02),
            padding: EdgeInsets.only(
                top: rSize * 0.01, left: rSize * 0.01, right: rSize * 0.01),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(rSize * 0.012),
                border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate, width: 2)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Currency',
                        style: AppStyles.inputTextStyle(
                          context,
                        ).copyWith(fontSize: rSize * 0.014),
                      ),
                      SearchableDropdown(
                        selectedValue: _notifier.selectedCurrency,
                        searchHint: '',
                        onChanged: (p0) {
                          _notifier.selectCurrency(context,p0);
                        },
                        items: _notifier.currencyList
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item.name??'',
                                    style: AppStyles.inputTextStyle(context),
                                  ),
                                ))
                            .toList(),
                        searchMatchFn: (item, searchValue) {
                          return CommonFunctions.compare(searchValue, item.value.name.toString());
                        },
                        broderColor: Colors.transparent,
                        height: rSize * 0.04,
                        padding: EdgeInsets.zero,
                        isSearchable: true,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Amount',
                        style: AppStyles.inputTextStyle(context)
                            .copyWith(fontSize: rSize * 0.014),
                      ),
                      TextFormField(
                        controller: _notifier.amountController,
                        style: AppStyles.inputTextStyle(context),
                        textAlign: TextAlign.end,
                        onChanged: (value) {
                          _notifier.calculate(value);
                        },
                        decoration: AppStyles.inputDecoration(context,
                            focusColor: Colors.transparent,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: rSize * 0.005),
                            hint: 'Enter Amount'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          TextFormField(
            controller: _notifier.usdController,
            style: AppStyles.inputTextStyle(context),
            keyboardType: TextInputType.number,
            readOnly: true,
            onChanged: (value) {},
            decoration: AppStyles.inputDecoration(context,
              focusColor: FlutterFlowTheme.of(context).alternate,
                prefix: Container(
                  height: rSize * 0.056,
                  width: rSize * 0.060,
                  margin: EdgeInsets.only(right: rSize * 0.010),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(rSize * 0.010),
                        bottomLeft: Radius.circular(rSize * 0.010),
                      ),
                      color: FlutterFlowTheme.of(context)
                          .alternate
                          .withOpacity(0.2)),
                  child: Text(
                    _notifier.selectedPortfolio?.referenceCurrency??'',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          letterSpacing: 0,
                        ),
                  ),
                ),
                contentPadding: EdgeInsets.all(rSize * 0.015)),
          ),
          SizedBox(
            height: rSize * 0.015,
          ),
          AppWidgets.label(
              context,
              FFLocalizations.of(context).getText(
                'wbwyrgib' /* open rate */,
              )),
          SizedBox(
            height: rSize * 0.005,
          ),
          TextFormField(
            controller: _notifier.openRateController,
            style: AppStyles.inputTextStyle(context),
            keyboardType: TextInputType.number,
            onChanged: (value) {},
            decoration: AppStyles.inputDecoration(context,
              focusColor: FlutterFlowTheme.of(context).alternate,
                prefix: Container(
                  height: rSize * 0.056,
                  width: ("${_notifier.selectedCurrency?.name??''}/USD").length*rSize*0.011,
                  margin: EdgeInsets.only(right: rSize * 0.010),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(rSize * 0.010),
                        bottomLeft: Radius.circular(rSize * 0.010),
                      ),
                      color: FlutterFlowTheme.of(context)
                          .alternate
                          .withOpacity(0.2)),
                  child: Text(
                    "${_notifier.selectedCurrency?.name??''}/USD",
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          letterSpacing: 0,
                        ),
                  ),
                ),
                contentPadding: EdgeInsets.all(rSize * 0.015)),
          ),
          SizedBox(
            height: rSize * 0.015,
          ),
          AppWidgets.label(
              context,
              FFLocalizations.of(context).getText(
                'e0lclrlh' /* trans date */,
              )),
          TextFormField(
            style: AppStyles.inputTextStyle(context),
            readOnly: true,
            controller: TextEditingController(text:_notifier.selectedTransactionDate ),
            onTap: () {
              AppWidgets.openDatePicker(context, (p0) {
                _notifier.selectTransactionDate(p0 as DateTime);
                Navigator.pop(context);
              },mode: DateRangePickerSelectionMode.single);
            },
            decoration: AppStyles.inputDecoration(
              context,
              focusColor: FlutterFlowTheme.of(context).alternate,
              contentPadding: EdgeInsets.all(rSize * 0.015),
              suffix: SizedBox(
                height: rSize * 0.056,
                width: rSize * 0.050,
              ),
            ),
          ),
          SizedBox(
            height: rSize * 0.015,
          ),
          AppWidgets.label(
              context,
              FFLocalizations.of(context).getText(
                'l33tyaq2' /* accounting date */,
              )),
          TextFormField(
            style: AppStyles.inputTextStyle(context),
            readOnly: true,
            controller: TextEditingController(text:_notifier.selectedAccountingDate ),
            onTap: () {
              AppWidgets.openDatePicker(context, (p0) {
                _notifier.selectAccountingDate(p0 as DateTime);
                Navigator.pop(context);
              },mode: DateRangePickerSelectionMode.single);
            },
            decoration: AppStyles.inputDecoration(
              context,
              focusColor: FlutterFlowTheme.of(context).alternate,
              contentPadding: EdgeInsets.all(rSize * 0.015),
              suffix: Container(
                height: rSize * 0.056,
                width: rSize * 0.050,
              ),
            ),
          ),
          SizedBox(
            height: rSize * 0.015,
          ),
          AppWidgets.label(
              context,
              FFLocalizations.of(context).getText(
                '580q4cpd' /* value date */,
              )),
          TextFormField(
            style: AppStyles.inputTextStyle(context),
            readOnly: true,
            controller: TextEditingController(text:_notifier.selectedValueDate ),
            onTap: () {
              AppWidgets.openDatePicker(context, (p0) {
                _notifier.selectValueDate(p0 as DateTime);
                Navigator.pop(context);
              },mode: DateRangePickerSelectionMode.single);
            },
            decoration: AppStyles.inputDecoration(
              context,
              focusColor: FlutterFlowTheme.of(context).alternate,
              contentPadding: EdgeInsets.all(rSize * 0.015),
              suffix: Container(
                height: rSize * 0.056,
                width: rSize * 0.050,
              ),
            ),
          ),
          SizedBox(
            height: rSize * 0.015,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppWidgets.btn(
                  context,
                  margin: EdgeInsets.only(bottom: padding.bottom),
                  FFLocalizations.of(context).getText(
                    'h2vfcolj',
                  ),
                  horizontalPadding: rSize * 0.03),
            ],
          )
        ],
      ),
    );
  }
}
