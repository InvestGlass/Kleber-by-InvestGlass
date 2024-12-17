import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kleber_bank/portfolio/portfolio_controller.dart';
import 'package:kleber_bank/portfolio/transaction_model.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../main.dart';
import '../utils/api_calls.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import '../utils/searchable_dropdown.dart';

class Transactions extends StatefulWidget {
  final String portfolioName;

  const Transactions(this.portfolioName, {super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late PortfolioController _notifier;
  final PagingController<int, TransactionModel> pagingController =
      PagingController(firstPageKey: 1);
  int pageKey = 1;

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPageActivity(context);
    });
    super.initState();
  }

  Future<void> _fetchPageActivity(
    BuildContext context,
  ) async {
    var notifier = Provider.of<PortfolioController>(context, listen: false);
    List<TransactionModel> list = await ApiCalls.getTransactionList(
        context,
        pageKey,
        widget.portfolioName,
        notifier.tranColumn,
        notifier.tranDirection,
    notifier.selectedDate);
    final isLastPage = list.length < 10;
    if (isLastPage) {
      pagingController.appendLastPage(list);
    } else {
      pageKey++;
      pagingController.appendPage(list, pageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    c = context;
    _notifier = Provider.of<PortfolioController>(context);
    return Scaffold(
        appBar: AppWidgets.appBar(
            context,
            FFLocalizations.of(context).getText(
              'u192lk22' /* Transactions*/,
            ),
            leading: AppWidgets.backArrow(context)),
        body: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: rSize * 0.015,
                ),
                Expanded(
                  child: SearchableDropdown(
                    selectedValue: _notifier.selectedTransactionFilter,
                    isSearchable: false,
                    searchHint: 'Select Types',
                    onChanged: (p0) {
                      _notifier.selectTransactionFilter(p0);
                      pageKey = 1;
                      pagingController.refresh();
                    },
                    items: _notifier.transactionFilterTypeList
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: AppStyles.inputTextStyle(context),
                            ),
                          ),
                        )
                        .toList(),
                    searchMatchFn: null,
                    selectedItemBuilder: (BuildContext context) {
                      return _notifier.transactionFilterTypeList.map((item) {
                        return Row(
                          children: [
                            Icon(
                              Icons.sort_rounded,
                              color: FlutterFlowTheme.of(context).customColor4,
                              size: rSize * 0.024,
                            ),
                            SizedBox(width: rSize * 0.008),
                            Text(item,
                                style: AppStyles.inputTextStyle(context)),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
                SizedBox(width: rSize*0.01,),
                GestureDetector(
                  onTap: () {
                    AppWidgets.openDatePicker(
                      context,
                          (value) {
                        if (value is DateTime) {
                          /*  final String startDate =
                         CommonFunctions.getYYYYMMDD(
                              value.startDate!);
                          final String endDate =
                          CommonFunctions.getYYYYMMDD(
                              value.endDate!);*/
                          _notifier.setDate(CommonFunctions.getYYYYMMDD(
                              value));
                          pagingController.refresh();
                          print(value);
                          Navigator.pop(context);
                          setState(() {});
                        }
                      },
                          () {
                        Navigator.pop(context);
                      },mode: DateRangePickerSelectionMode.single
                    );
                  },
                  child: Container(
                    height: rSize*0.055,
                    width: rSize*0.055,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(rSize * 0.010),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                      child: Icon(FontAwesomeIcons.calendar,color: FlutterFlowTheme.of(context).customColor4,)),
                ),
                SizedBox(
                  width: rSize * 0.015,
                ),
              ],
            ),
            SizedBox(
              height: rSize * 0.015,
            ),
            if(_notifier.selectedDate.isNotEmpty)...{
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: rSize*0.015),
                    padding: EdgeInsets.symmetric(horizontal: rSize*0.01,vertical: rSize*0.005),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(rSize * 0.007),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Row(
                        children: [
                          Text(_notifier.selectedDate,style: AppStyles.inputTextStyle(context),),
                          SizedBox(width: rSize*0.005),
                          GestureDetector(
                              onTap: (){
                                _notifier.setDate('');
                                pagingController.refresh();
                              },
                              child: Icon(Icons.close,color: FlutterFlowTheme.of(context).customColor4,size: rSize*0.02,))
                        ],
                      ))
                ],
              )
              ,
            },
            Flexible(
              child: RefreshIndicator(
                onRefresh: () async {
                  pageKey = 1;
                  pagingController.refresh();
                },
                child: PagedListView<int, TransactionModel>(
                  pagingController: pagingController,
                  padding: EdgeInsets.only(
                      left: rSize * 0.015,
                      right: rSize * 0.015,
                      top: rSize * 0.01),
                  // shrinkWrap: true,
                  builderDelegate: PagedChildBuilderDelegate<TransactionModel>(
                      noItemsFoundIndicatorBuilder: (context) {
                    return AppWidgets.emptyView(
                        FFLocalizations.of(context).getText(
                          'u52470kh' /* No Transactions Found */,
                        ),
                        context);
                  }, itemBuilder: (context, item, index) {
                    String currency =
                        item.portfolioSecurity!.referenceCurrency!;
                    return Container(
                      decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: AppStyles.shadow(),
                          borderRadius: BorderRadius.circular(rSize * 0.01)),
                      margin: EdgeInsets.symmetric(vertical: rSize * 0.005),
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(rSize * 0.015),
                        children: [
                          GestureDetector(
                            onTap: () =>
                                _notifier.selectTransactionIndex(index),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: rSize * 0.06,
                                        width: rSize * 0.06,
                                        margin: EdgeInsets.only(
                                            right: rSize * 0.01),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .customColor4,
                                              width: 1.5,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                rSize * 0.01)),
                                        // padding: EdgeInsets.all(rSize*0.001),
                                        child: Image.asset(
                                          'assets/app_launcher_icon.png',
                                          height: rSize * 0.08,
                                        )),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                item.id.toString(),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .displaySmall
                                                    .override(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: rSize * 0.016,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              )),
                                              SizedBox(
                                                width: rSize * 0.015,
                                              ),
                                              AnimatedRotation(
                                                  turns: _notifier
                                                              .selectedTransactionIndex ==
                                                          index
                                                      ? 0.75
                                                      : 0.5,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  child: AppWidgets.doubleBack(
                                                      context)),
                                            ],
                                          ),
                                          if (_notifier
                                                  .selectedTransactionIndex !=
                                              index) ...{
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item.portfolioSecurity
                                                            ?.securityName ??
                                                        '',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontSize:
                                                              rSize * 0.016,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .customColor4,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ),
                                                AppWidgets.buildRichText(
                                                    context,
                                                    '$currency ${getSeparatorFormat(item.amount!)}')
                                              ],
                                            ),
                                            AppWidgets.portfolioListElement(
                                                context,
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'xc0jtpk9' /* Status */,
                                                ),
                                                item.transactionStatus ?? '')
                                          },
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (_notifier.selectedTransactionIndex ==
                                    index) ...{
                                  ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    children: [
                                      SizedBox(
                                        height: rSize * 0.01,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          // color: AppColors.kViolate.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                              rSize * 0.015),
                                        ),
                                        // padding: EdgeInsets.all(rSize * 0.015),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppWidgets.portfolioListElement(
                                                context,
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'j72npzob' /* Type */,
                                                ),
                                                item.transactionType ?? ''),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(
                                                context,
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'fyy6awn3' /* Portfolio Name */,
                                                ),
                                                item.portfolioName ?? ''),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(
                                                context,
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'nkc71403' /* Security Name */,
                                                ),
                                                item.portfolioSecurity
                                                        ?.securityName ??
                                                    ''),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(
                                                context,
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '691qwpww' /* Quantity */,
                                                ),
                                                getSeparatorFormat(
                                                    item.quantity!)),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(
                                                context,
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'xopvpm3o' /* Price */,
                                                ),
                                                '$currency ${getSeparatorFormat(item.openPrice!)}',
                                                richText: AppWidgets.buildRichText(
                                                    context,
                                                    '$currency ${getSeparatorFormat(item.openPrice!)}')),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(
                                                context,
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'pgdm3cxj' /* Amount */,
                                                ),
                                                '$currency ${getSeparatorFormat(item.amount!)}',
                                                richText: AppWidgets.buildRichText(
                                                    context,
                                                    '$currency ${getSeparatorFormat(item.amount!)}')),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(
                                                context,
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'yx8usjux' /* Trade Date */,
                                                ),
                                                DateFormat('yyyy-MM-dd HH:mm')
                                                    .format(DateTime.parse(item
                                                        .transactionDatetime!))),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(
                                                context,
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '7r8yq7mw' /* Status */,
                                                ),
                                                item.statusView ?? ''),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                }
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ));
  }

  String getSeparatorFormat(double item) =>
      CommonFunctions.formatDoubleWithThousandSeperator(
          item.toString(), item == 0, 2);
}
