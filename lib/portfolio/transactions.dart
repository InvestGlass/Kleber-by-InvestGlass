import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kleber_bank/portfolio/portfolio_controller.dart';
import 'package:kleber_bank/portfolio/transaction_model.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../utils/api_calls.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';

class Transactions extends StatefulWidget {
  final String portfolioName;

  const Transactions(this.portfolioName, {super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late PortfolioController _notifier;
  final PagingController<int, TransactionModel> pagingController = PagingController(firstPageKey: 1);
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
    List<TransactionModel> list = await ApiCalls.getTransactionList(context, pageKey, widget.portfolioName);
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
    _notifier = Provider.of<PortfolioController>(context);
    return Scaffold(
        appBar: AppWidgets.appBar(
            context,
            FFLocalizations.of(context).getText(
              'u192lk22' /* Transactions*/,
            ),
            leading: AppWidgets.backArrow(context)),
        body: RefreshIndicator(
          onRefresh: () async {
            pageKey = 1;
            pagingController.refresh();
          },
          child: PagedListView<int, TransactionModel>(
            pagingController: pagingController,
            padding: EdgeInsets.only(left: rSize * 0.015, right: rSize * 0.015, top: rSize * 0.01),
            // shrinkWrap: true,
            builderDelegate: PagedChildBuilderDelegate<TransactionModel>(noItemsFoundIndicatorBuilder: (context) {
              return AppWidgets.emptyView(
                  FFLocalizations.of(context).getText(
                    'u52470kh' /* No Transactions Found */,
                  ),
                  context);
            }, itemBuilder: (context, item, index) {
              String currency = item.portfolioSecurity!.referenceCurrency!;
              return Container(
                decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: AppStyles.shadow(),
                    borderRadius: BorderRadius.circular(rSize * 0.01)),
                margin: EdgeInsets.symmetric(vertical: rSize * 0.005),
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(rSize * 0.015),
                  children: [
                    GestureDetector(
                      onTap: () => _notifier.selectTransactionIndex(index),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: rSize*0.06,
                                width: rSize*0.06,
                                  margin: EdgeInsets.only(right: rSize*0.01),
                                  decoration: BoxDecoration(border: Border.all(color: FlutterFlowTheme.of(context).customColor4,width: 1.5,),borderRadius: BorderRadius.circular(rSize*0.01)),
                                  // padding: EdgeInsets.all(rSize*0.001),
                                  child: Image.asset('assets/app_launcher_icon.png',height: rSize*0.08,)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          item.id.toString(),
                                          style: FlutterFlowTheme.of(context).displaySmall.override(

                                                color: FlutterFlowTheme.of(context).primaryText,
                                                fontSize: rSize * 0.016,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        )

                                        ),
                                        SizedBox(
                                          width: rSize * 0.015,
                                        ),
                                        AnimatedRotation(
                                            turns: _notifier.selectedTransactionIndex == index ? 0.75 : 0.5,
                                            duration: Duration(milliseconds: 300), child: AppWidgets.doubleBack(context)),
                                      ],
                                    ),
                                    if (_notifier.selectedTransactionIndex != index) ...{
                                      SizedBox(
                                        height: rSize * 0.005,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        Expanded(child: Text(
                                          item.portfolioSecurity?.securityName ?? '',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(

                                            fontSize: rSize*0.016,
                                            color: FlutterFlowTheme.of(context).customColor4,
                                            letterSpacing: 0.0,
                                          ),
                                        ),),
                                        AppWidgets.buildRichText(context, '$currency ${item.amount ?? ''}')
                                      ],)
                                      ,
                                      AppWidgets.portfolioListElement(
                                          context,
                                          FFLocalizations.of(context).getText(
                                            'xc0jtpk9' /* Status */,
                                          ),
                                          item.statusView ?? '')
                                    },
                                  ],
                                ),
                              ),
                            ],
                          ),


                          if (_notifier.selectedTransactionIndex == index) ...{
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
                                    borderRadius: BorderRadius.circular(rSize * 0.015),
                                  ),
                                  // padding: EdgeInsets.all(rSize * 0.015),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppWidgets.portfolioListElement(
                                          context,
                                          FFLocalizations.of(context).getText(
                                            'j72npzob' /* Type */,
                                          ),
                                          item.transactionType ?? ''),
                                      SizedBox(
                                        height: rSize * 0.005,
                                      ),
                                      AppWidgets.portfolioListElement(
                                          context,
                                          FFLocalizations.of(context).getText(
                                            'fyy6awn3' /* Portfolio Name */,
                                          ),
                                          item.portfolioName ?? ''),
                                      SizedBox(
                                        height: rSize * 0.005,
                                      ),
                                      AppWidgets.portfolioListElement(
                                          context,
                                          FFLocalizations.of(context).getText(
                                            'nkc71403' /* Security Name */,
                                          ),
                                          item.portfolioSecurity?.securityName ?? ''),
                                      SizedBox(
                                        height: rSize * 0.005,
                                      ),
                                      AppWidgets.portfolioListElement(
                                          context,
                                          FFLocalizations.of(context).getText(
                                            '691qwpww' /* Quantity */,
                                          ),
                                          item.quantity ?? ''),
                                      SizedBox(
                                        height: rSize * 0.005,
                                      ),
                                      AppWidgets.portfolioListElement(
                                          context,
                                          FFLocalizations.of(context).getText(
                                            'xopvpm3o' /* Price */,
                                          ),
                                          '$currency ${CommonFunctions.formatDoubleWithThousandSeperator('${item.openPrice!}', item.openPrice == 0, 2)}',
                                          richText: AppWidgets.buildRichText(context,
                                              '$currency ${CommonFunctions.formatDoubleWithThousandSeperator('${item.openPrice!}', item.openPrice == 0, 2)}')),
                                      SizedBox(
                                        height: rSize * 0.005,
                                      ),
                                      AppWidgets.portfolioListElement(
                                          context,
                                          FFLocalizations.of(context).getText(
                                            'pgdm3cxj' /* Amount */,
                                          ),
                                          '$currency ${item.amount ?? ''}',
                                          richText: AppWidgets.buildRichText(context, '$currency ${item.amount ?? ''}')),
                                      SizedBox(
                                        height: rSize * 0.005,
                                      ),
                                      AppWidgets.portfolioListElement(
                                          context,
                                          FFLocalizations.of(context).getText(
                                            'yx8usjux' /* Trade Date */,
                                          ),
                                          DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(item.transactionDatetime!))),
                                      SizedBox(
                                        height: rSize * 0.005,
                                      ),
                                      AppWidgets.portfolioListElement(
                                          context,
                                          FFLocalizations.of(context).getText(
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
        ));
  }
}
