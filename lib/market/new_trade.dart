import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/market/market_controller.dart';
import 'package:kleber_bank/market/market_list_model.dart';
import 'package:kleber_bank/portfolio/portfolio.dart';
import 'package:kleber_bank/portfolio/portfolio_controller.dart';
import 'package:kleber_bank/securitySelection/security_selection.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:provider/provider.dart';

import '../utils/app_styles.dart';
import '../utils/common_functions.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import '../utils/searchable_dropdown.dart';

class AddTransaction extends StatefulWidget {
  final MarketListModel model;

  const AddTransaction(this.model, {super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  late PortfolioController _portfolioNotifier;
  late MarketController _marketNotifier;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<MarketController>(context, listen: false).getTransactionTypes(context);
        Provider.of<PortfolioController>(context, listen: false).getPortfolioList(0, notify: true);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _portfolioNotifier = Provider.of<PortfolioController>(context);
    _marketNotifier = Provider.of<MarketController>(context);
    return Container(
      decoration: AppStyles.commonBg(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppWidgets.appBar(context, 'New Trade', centerTitle: true),
        body: Form(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(rSize * 0.015),
            children: [
              label(context, 'xn2nrgyp' /* Portfolio */),
              SearchableDropdown(
                selectedValue: _portfolioNotifier.selectedPortfolio,
                searchHint: FFLocalizations.of(context).getText(
                  'm7418olr' /* Search for transaction type */,
                ),
                onChanged: (p0) {
                  _portfolioNotifier.selectedPortfolio = p0;
                  _portfolioNotifier.notify();
                },
                items: _portfolioNotifier.portfolioList
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.title!,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Roboto',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ))
                    .toList(),
                searchMatchFn: (item, searchValue) {
                  return CommonFunctions.compare(searchValue, item.value.title.toString());
                },
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, 'rumkikc1' /* Name, ISIN, FIGI or Ticket */),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: _marketNotifier.selectedSecurity?.name),
                onTap: () => CommonFunctions.navigate(context, SecuritySelection(), onBack: (result) {
                  _marketNotifier.selectSecurity(result);
                }),
                decoration: AppStyles.inputDecoration(context,
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    suffix: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: FlutterFlowTheme.of(context).alternate),
                      child: Icon(
                        Icons.search_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                    ),
                    focusColor: FlutterFlowTheme.of(context).alternate),
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, 'whkrwls1' /* Type */),
              SearchableDropdown(
                selectedValue: _marketNotifier.selectedSecurityType,
                searchHint: FFLocalizations.of(context).getText(
                  'm7418olr' /* Search for transaction type */,
                ),
                onChanged: (p0) {
                  _marketNotifier.selectSecurityType(p0);
                },
                items: _marketNotifier.transactionTypeList
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.name!.replaceAll('_', ' '),
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Roboto',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ))
                    .toList(),
                searchMatchFn: (item, searchValue) {
                  return CommonFunctions.compare(searchValue, item.value.name.toString());
                },
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, '7fx237xy' /* Time In Force */),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                    text: _marketNotifier.selectedDateTime),
                onTap: () {
                  openDateTimePicker();
                },
                decoration: AppStyles.inputDecoration(context, focusColor: FlutterFlowTheme.of(context).alternate, contentPadding: EdgeInsets.all(15)),
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, '2mpa9jiq' /* Notes */),
              TextFormField(
                decoration: AppStyles.inputDecoration(context, focusColor: FlutterFlowTheme.of(context).alternate, contentPadding: EdgeInsets.all(15)),
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, 'u7hyldvt' /* Order Type */),
              TextFormField(
                decoration: AppStyles.inputDecoration(context, focusColor: FlutterFlowTheme.of(context).alternate, contentPadding: EdgeInsets.all(15)),
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, '2odrp5sn' /* Quantity */),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _marketNotifier.qtyController,
                onChanged: (value) {
                  _marketNotifier.updateAmount(widget.model.price!);
                },
                decoration: AppStyles.inputDecoration(context, focusColor: FlutterFlowTheme.of(context).alternate, contentPadding: EdgeInsets.all(15)),
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, 'lz424u11' /* Current Price */),
              TextFormField(
                readOnly: true,controller: TextEditingController(text: widget.model.price ?? ''),
                decoration: AppStyles.inputDecoration(context,
                    focusColor: FlutterFlowTheme.of(context).customColor4,
                    contentPadding: EdgeInsets.all(15),
                    prefix: Container(
                      height: 50,
                      width: 60,
                      margin: EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: FlutterFlowTheme.of(context).customColor4),
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'bhxqgsuw' /* USD $ */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Roboto',
                              letterSpacing: 0.0,
                            ),
                      ),
                    )),
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, 'q9p7fv0r' /* Limit Price */),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _marketNotifier.limitPriceController,
                onChanged: (value) {
                  _marketNotifier.updateAmount(widget.model.price!);
                },
                decoration: AppStyles.inputDecoration(context,
                    prefix: Container(
                      height: 50,
                      width: 60,
                      margin: EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: FlutterFlowTheme.of(context).alternate),
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'bhxqgsuw' /* USD $ */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Roboto',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                    contentPadding: EdgeInsets.all(15)),
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, '4noemhfd' /* Amount */),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: _marketNotifier.amount.toString()),
                decoration: AppStyles.inputDecoration(context,
                    focusColor: FlutterFlowTheme.of(context).customColor4,
                    contentPadding: EdgeInsets.all(15),
                    prefix: Container(
                      height: 50,
                      width: 60,
                      margin: EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: FlutterFlowTheme.of(context).customColor4),
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'bhxqgsuw' /* USD $ */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Roboto',
                              letterSpacing: 0.0,
                            ),
                      ),
                    )),
              ),
              SizedBox(
                height: rSize * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      _marketNotifier.transmit(widget.model,_portfolioNotifier.selectedPortfolio);
                    },
                    child: AppWidgets.btn(
                        context,
                        FFLocalizations.of(context).getText(
                          'h2vfcolj' /* Transmit */,
                        ),
                        horizontalPadding: rSize * 0.02,
                        bgColor: FlutterFlowTheme.of(context).primary),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding label(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
      child: Text(
        FFLocalizations.of(context).getText(
          text,
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Roboto',
              fontSize: 16.0,
              letterSpacing: 0.0,
            ),
      ),
    );
  }

  Future<void> openDateTimePicker() async {
    DateTime now = DateTime.now();
    _marketNotifier.selectedDate = await showDatePicker(
      context: context,
      initialDate: _marketNotifier.selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (_marketNotifier.selectedDate!=null) {
      _marketNotifier.selectedTime = await showTimePicker(context: context,
        initialTime:_marketNotifier.selectedTime??TimeOfDay.now(),
      );
      _marketNotifier.selectTime(context);
    }
  }
}
