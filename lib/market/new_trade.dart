import 'package:flutter/material.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/market/market_controller.dart';
import 'package:kleber_bank/market/market_list_model.dart';
import 'package:kleber_bank/portfolio/portfolio_controller.dart';
import 'package:kleber_bank/securitySelection/security_selection.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:provider/provider.dart';

import '../proposals/proposal_controller.dart';
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
  late ProposalController _proposalController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<MarketController>(context, listen: false).getTransactionTypes(context);
        Provider.of<PortfolioController>(context, listen: false).getPortfolioList(context,0, notify: true);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _portfolioNotifier.selectedPortfolio=null;
    _marketNotifier.selectedSecurityType=null;
    _marketNotifier.selectedDateTime=null;
    _marketNotifier.descController.clear();
    _marketNotifier.orderType.clear();
    _marketNotifier.qtyController.clear();
    _marketNotifier.limitPriceController.clear();
    _marketNotifier.amount=0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _portfolioNotifier = Provider.of<PortfolioController>(context);
    _proposalController = Provider.of<ProposalController>(context);
    _marketNotifier = Provider.of<MarketController>(context);
    return Container(
      decoration: AppStyles.commonBg(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppWidgets.appBar(context, FFLocalizations.of(context).getText(
          '7v8svtoq' /* new trnasaction */,
        ), centerTitle: true,leading:AppWidgets.backArrow(context)),
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
                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                color:FlutterFlowTheme.of(context).customColor4
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
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                    color:FlutterFlowTheme.of(context).customColor4
                ),
                readOnly: true,
                controller: TextEditingController(text: widget.model.name),
                decoration: AppStyles.inputDecoration(context,
                    contentPadding: EdgeInsets.symmetric(vertical: rSize*0.015, horizontal: rSize*0.015),
                    suffix: Container(
                      height: rSize*0.056,
                      width: rSize*0.050,
                      /*decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(rSize*0.010),
                            bottomRight: Radius.circular(rSize*0.010),
                          ),
                          color: FlutterFlowTheme.of(context).alternate),
                      child: Icon(
                        Icons.search_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: rSize*0.024,
                      ),*/
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
                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                color:FlutterFlowTheme.of(context).customColor4
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
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                    color:FlutterFlowTheme.of(context).customColor4
                ),
                readOnly: true,
                controller: TextEditingController(
                    text: _marketNotifier.selectedDateTime),
                onTap: () {
                  openDateTimePicker();
                },
                decoration: AppStyles.inputDecoration(context, focusColor: FlutterFlowTheme.of(context).alternate, contentPadding: EdgeInsets.all(rSize*0.015),suffix: Container(
                  height: rSize*0.056,
                  width: rSize*0.050,
                ),),
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, '2mpa9jiq' /* Notes */),
              TextFormField(
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                    color:FlutterFlowTheme.of(context).customColor4
                ),
                controller: _marketNotifier.descController,
                decoration: AppStyles.inputDecoration(context, focusColor: FlutterFlowTheme.of(context).alternate, contentPadding: EdgeInsets.all(rSize*0.015),suffix: Container(
                  height: rSize*0.056,
                  width: rSize*0.050,
                ),),
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, 'u7hyldvt' /* Order Type */),
              TextFormField(
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                    color:FlutterFlowTheme.of(context).customColor4
                ),controller: _marketNotifier.orderType,
                decoration: AppStyles.inputDecoration(context, focusColor: FlutterFlowTheme.of(context).alternate, contentPadding: EdgeInsets.all(rSize*0.015),suffix: Container(
                  height: rSize*0.056,
                  width: rSize*0.050,
                ),),
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, '2odrp5sn' /* Quantity */),
              TextFormField(
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                    color:FlutterFlowTheme.of(context).customColor4
                ),
                keyboardType: TextInputType.number,
                controller: _marketNotifier.qtyController,
                onChanged: (value) {
                  _marketNotifier.updateAmount(widget.model.price!);
                },
                decoration: AppStyles.inputDecoration(context, focusColor: FlutterFlowTheme.of(context).alternate, contentPadding: EdgeInsets.all(rSize*0.015),suffix: Container(
                  height: rSize*0.056,
                  width: rSize*0.050,
                ),),
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, 'lz424u11' /* Current Price */),
              TextFormField(
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                    color:FlutterFlowTheme.of(context).customColor4
                ),
                readOnly: true,controller: TextEditingController(text: widget.model.price ?? ''),
                decoration: AppStyles.inputDecoration(context,
                    focusColor: FlutterFlowTheme.of(context).customColor4,
                    contentPadding: EdgeInsets.all(rSize*0.015),
                    prefix: Container(
                      height: rSize*0.056,
                      width: rSize*0.060,
                      margin: EdgeInsets.only(right: rSize*0.010),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(rSize*0.010),
                            bottomLeft: Radius.circular(rSize*0.010),
                          ),
                          color: FlutterFlowTheme.of(context).customColor4),
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'bhxqgsuw' /* USD $ */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(

                              letterSpacing: 0,
                            ),
                      ),
                    )),
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, 'q9p7fv0r' /* Limit Price */),
              TextFormField(
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                    color:FlutterFlowTheme.of(context).customColor4
                ),
                keyboardType: TextInputType.number,
                controller: _marketNotifier.limitPriceController,
                onChanged: (value) {
                  _marketNotifier.updateAmount(widget.model.price!);
                },
                decoration: AppStyles.inputDecoration(context,
                    prefix: Container(
                      height: rSize*0.056,
                      width: rSize*0.060,
                      margin: EdgeInsets.only(right: rSize*0.010),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(rSize*0.010),
                            bottomLeft: Radius.circular(rSize*0.010),
                          ),
                          color: FlutterFlowTheme.of(context).alternate),
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'bhxqgsuw' /* USD $ */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(

                              letterSpacing: 0,
                            ),
                      ),
                    ),
                    contentPadding: EdgeInsets.all(rSize*0.015)),
              ),
              SizedBox(
                height: rSize * 0.015,
              ),
              label(context, '4noemhfd' /* Amount */),
              TextFormField(
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                    color:FlutterFlowTheme.of(context).customColor4
                ),
                readOnly: true,
                controller: TextEditingController(text: _marketNotifier.amount.toString()),
                decoration: AppStyles.inputDecoration(context,
                    focusColor: FlutterFlowTheme.of(context).customColor4,
                    contentPadding: EdgeInsets.all(rSize*0.015),
                    prefix: Container(
                      height: rSize*0.056,
                      width: rSize*0.060,
                      margin: EdgeInsets.only(right: rSize*0.010),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(rSize*0.010),
                            bottomLeft: Radius.circular(rSize*0.010),
                          ),
                          color: FlutterFlowTheme.of(context).customColor4),
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'bhxqgsuw' /* USD $ */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(

                              letterSpacing: 0,
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
                      _marketNotifier.transmit(widget.model,_portfolioNotifier.selectedPortfolio,context,_proposalController,widget.model);
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
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, rSize*0.005),
      child: AppWidgets.label(context, FFLocalizations.of(context).getText(
        text,
      )),
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
