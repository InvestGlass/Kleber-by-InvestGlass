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
      _fetchPageActivity();
    });
    super.initState();
  }

  Future<void> _fetchPageActivity() async {
    List<TransactionModel> list = await ApiCalls.getTransactionList(pageKey, widget.portfolioName);
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
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          SizedBox(
            height: rSize * 0.015,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      FFLocalizations.of(context).getText(
                        'dx3hqly7' /* Transactions as of */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: 25.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      DateFormat('yyyy-MM-dd', FFLocalizations.of(context).languageCode).format(DateTime.now()),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        fontSize: 20.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close,size: 30,color: FlutterFlowTheme.of(context).primary,))
            ],
          ),
          SizedBox(
            height: rSize * 0.02,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                pageKey = 1;
                pagingController.refresh();
              },
              child: PagedListView<int, TransactionModel>(
                pagingController: pagingController,
                padding: EdgeInsets.all(rSize * 0.015),
                // shrinkWrap: true,
                builderDelegate: PagedChildBuilderDelegate<TransactionModel>(noItemsFoundIndicatorBuilder: (context) {
                  return const SizedBox();
                }, itemBuilder: (context, item, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: rSize * 0.005),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
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
                                  Expanded(
                                      child: Text(
                                    item.id.toString(),
                                    style: FlutterFlowTheme.of(context).displaySmall.override(
                                          fontFamily: 'Roboto',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  )),
                                  SizedBox(
                                    width: rSize * 0.015,
                                  ),
                                  RotatedBox(
                                      quarterTurns: _notifier.selectedTransactionIndex == index ? 1 : 3,
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: AppColors.kTextFieldInput,
                                        size: 15,
                                      )),
                                ],
                              ),
                              if (_notifier.selectedTransactionIndex != index) ...{
                                SizedBox(
                                  height: rSize * 0.005,
                                ),
                                AppWidgets.portfolioListElement(
                                  context,
                                  'Security Name',
                                  item.portfolioSecurity?.securityName ?? '',
                                ),
                                AppWidgets.portfolioListElement(context, 'Status', item.statusView ?? '')
                              },
                              if (_notifier.selectedTransactionIndex == index) ...{
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: rSize * 0.5,
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      SizedBox(
                                        height: rSize * 0.01,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          // color: AppColors.kViolate.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        // padding: EdgeInsets.all(rSize * 0.015),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AppWidgets.portfolioListElement(context, 'Type', item.transactionType ?? ''),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(context, 'Portfolio Name', item.portfolioName ?? ''),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(context, 'Security Name', item.portfolioSecurity?.securityName ?? ''),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(context, 'Quantity', item.quantity ?? ''),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(
                                                context,
                                                'Price',
                                                item.portfolioSecurity!.referenceCurrency! +
                                                    ' ' +
                                                    CommonFunctions.formatDoubleWithThousandSeperator('${item.openPrice!}', item.openPrice == 0, 2)),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(context, 'Amount', item.amount ?? ''),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(context, 'Trade Date', item.transactionDatetime ?? ''),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(context, 'Status', item.statusView ?? ''),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
      )),
    );
  }
}
