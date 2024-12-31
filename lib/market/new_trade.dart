import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/market/market_controller.dart';
import 'package:kleber_bank/market/market_list_model.dart';
import 'package:kleber_bank/portfolio/portfolio_controller.dart';
import 'package:kleber_bank/securitySelection/security_selection.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../portfolio/portfolio_model.dart';
import '../proposals/proposal_controller.dart';
import '../utils/app_styles.dart';
import '../utils/common_functions.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import '../utils/searchable_dropdown.dart';

class AddTransaction extends StatefulWidget {
  final MarketListModel? selectedSecurity;
  final PortfolioModel? selectedPortfolio;

  const AddTransaction(this.selectedSecurity, this.selectedPortfolio,
      {super.key});

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
        MarketController marketController =
            Provider.of<MarketController>(context, listen: false);
        PortfolioController portfolioController =
            Provider.of<PortfolioController>(context, listen: false);
        marketController.getTransactionTypes(context);
        portfolioController.getPortfolioList(context, 0, notify: true);
        portfolioController.selectedPortfolio = widget.selectedPortfolio;
        portfolioController.notify();
        marketController.selectSecurity(widget.selectedSecurity);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _portfolioNotifier.selectedPortfolio = null;
    _marketNotifier.selectedSecurityType = null;
    _marketNotifier.selectedDateTime = null;
    _marketNotifier.selectedSecurity = null;
    _marketNotifier.descController.clear();
    _marketNotifier.orderType.clear();
    _marketNotifier.qtyController.clear();
    _marketNotifier.limitPriceController.clear();
    _marketNotifier.amount = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    c = context;
    _portfolioNotifier = Provider.of<PortfolioController>(context);
    _proposalController = Provider.of<ProposalController>(context);
    _marketNotifier = Provider.of<MarketController>(context);
    return Scaffold(
      appBar: AppWidgets.appBar(
          context,
          FFLocalizations.of(context).getText(
            '7v8svtoq' /* new trnasaction */,
          ),
          centerTitle: true,
          leading: AppWidgets.backArrow(context)),
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
              hint: _portfolioNotifier.selectedPortfolio?.title ?? '',
              onChanged: (p0) {
                _portfolioNotifier.selectedPortfolio = p0;
                _portfolioNotifier.notify();
              },
              items: (widget.selectedPortfolio != null
                      ? []
                      : _portfolioNotifier.portfolioList)
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
            label(context, 'rumkikc1' /* Name, ISIN, FIGI or Ticket */),
            TextFormField(
              style: AppStyles.inputTextStyle(context),
              readOnly: true,
              onTap: () {
                if (widget.selectedSecurity == null) {
                  CommonFunctions.navigate(context, SecuritySelection(),
                      onBack: (result) {
                    _marketNotifier.selectSecurity(result);
                  });
                }
              },
              controller: TextEditingController(
                  text: _marketNotifier.selectedSecurity?.name),
              decoration: AppStyles.inputDecoration(context,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: rSize * 0.015, horizontal: rSize * 0.015),
                  suffix: widget.selectedSecurity != null
                      ? SizedBox(
                          height: rSize * 0.056,
                          width: rSize * 0.050,
                        )
                      : Container(
                          height: rSize * 0.056,
                          width: rSize * 0.050,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(rSize * 0.010),
                                bottomRight: Radius.circular(rSize * 0.010),
                              ),
                              color: FlutterFlowTheme.of(context).alternate),
                          child: Icon(
                            Icons.search_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: rSize * 0.024,
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
              searchHint: '',
              onChanged: (p0) {
                _marketNotifier.selectSecurityType(p0);
              },
              items: _marketNotifier.transactionTypeList
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.name!.replaceAll('_', ' '),
                          style: AppStyles.inputTextStyle(context),
                        ),
                      ))
                  .toList(),
              searchMatchFn: (item, searchValue) {
                return CommonFunctions.compare(
                    searchValue, item.value.name.toString());
              },
            ),
            SizedBox(
              height: rSize * 0.015,
            ),
            label(context, '7fx237xy' /* Time In Force */),
            TextFormField(
              style: AppStyles.inputTextStyle(context),
              readOnly: true,
              controller:
                  TextEditingController(text: _marketNotifier.selectedDateTime),
              onTap: () {
                openDateTimePicker();
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
            label(context, '2mpa9jiq' /* Notes */),
            TextFormField(
              style: AppStyles.inputTextStyle(context),
              controller: _marketNotifier.descController,
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
            /*SizedBox(
              height: rSize * 0.015,
            ),
            label(context, 'u7hyldvt' */ /* Order Type */ /*),
            TextFormField(
              style: AppStyles.inputTextStyle(context),
              controller: _marketNotifier.orderType,
              decoration: AppStyles.inputDecoration(
                context,
                focusColor: FlutterFlowTheme.of(context).alternate,
                contentPadding: EdgeInsets.all(rSize * 0.015),
                suffix: Container(
                  height: rSize * 0.056,
                  width: rSize * 0.050,
                ),
              ),
            ),*/
            SizedBox(
              height: rSize * 0.015,
            ),
            label(context, '2odrp5sn' /* Quantity */),
            TextFormField(
              style: AppStyles.inputTextStyle(context),
              keyboardType: TextInputType.number,
              controller: _marketNotifier.qtyController,
              onChanged: (value) {
                _marketNotifier.updateAmount(
                    _marketNotifier.selectedSecurity?.price ?? '');
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
            label(context, 'lz424u11' /* Current Price */),
            TextFormField(
              style: AppStyles.inputTextStyle(context),
              readOnly: true,
              controller: TextEditingController(
                  text: _marketNotifier.selectedSecurity?.price ?? ''),
              decoration: AppStyles.inputDecoration(context,
                  focusColor: FlutterFlowTheme.of(context)
                      .customColor4
                      .withOpacity(0.2),
                  contentPadding: EdgeInsets.all(rSize * 0.015),
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
                            .customColor4
                            .withOpacity(0.2)),
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
              style: AppStyles.inputTextStyle(context),
              keyboardType: TextInputType.number,
              controller: _marketNotifier.limitPriceController,
              onChanged: (value) {
                _marketNotifier.updateAmount(
                    _marketNotifier.selectedSecurity?.price ?? '');
              },
              decoration: AppStyles.inputDecoration(context,
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
                            .customColor4
                            .withOpacity(0.2)),
                    child: Text(
                      FFLocalizations.of(context).getText(
                        'bhxqgsuw' /* USD $ */,
                      ),
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
            label(context, '4noemhfd' /* Amount */),
            TextFormField(
              style: AppStyles.inputTextStyle(context),
              readOnly: true,
              controller: TextEditingController(
                  text: _marketNotifier.amount.toString()),
              decoration: AppStyles.inputDecoration(context,
                  focusColor: FlutterFlowTheme.of(context)
                      .customColor4
                      .withOpacity(0.2),
                  contentPadding: EdgeInsets.all(rSize * 0.015),
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
                            .customColor4
                            .withOpacity(0.2)),
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
                  onTap: () {
                    _marketNotifier.transmit(
                        _portfolioNotifier.selectedPortfolio,
                        context,
                        _proposalController);
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
    );
  }

  Padding label(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, rSize * 0.005),
      child: AppWidgets.label(
          context,
          FFLocalizations.of(context).getText(
            text,
          )),
    );
  }

  Future<void> openDateTimePicker() async {
    AppWidgets.openDatePicker(context, (p0) async {
      _marketNotifier.selectedDate =
          DateFormat('yyyy-mm-dd').parse(p0.toString());
      if (_marketNotifier.selectedDate != null) {
        Navigator.pop(context);
        _marketNotifier.selectedTime = await showTimePicker(
            context: context,
            initialTime: _marketNotifier.selectedTime ?? TimeOfDay.now(),
            builder: AppStyles.timePickerStyle);
        _marketNotifier.selectTime(context);
      }
    }, () {}, mode: DateRangePickerSelectionMode.single);
    /*DateTime now = DateTime.now();
    _marketNotifier.selectedDate = await showDatePicker(
      context: context,
      initialDate: _marketNotifier.selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
*/
  }
}
