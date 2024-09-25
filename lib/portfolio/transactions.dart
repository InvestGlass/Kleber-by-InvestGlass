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

  Future<void> _fetchPageActivity(BuildContext context,) async {
    List<TransactionModel> list = await ApiCalls.getTransactionList(context,pageKey, widget.portfolioName);
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Padding(
          padding: EdgeInsets.only(left: rSize * 0.015, right: rSize * 0.015, top: rSize * 0.05),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: FlutterFlowTheme.of(context).primary,
                      )),
                  Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        FFLocalizations.of(context).getText(
                          'dx3hqly7' /* Transactions as of */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Roboto',
                              color: FlutterFlowTheme.of(context).primary,
                              fontSize: rSize*0.025,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        DateFormat('yyyy-MM-dd', FFLocalizations.of(context).languageCode).format(DateTime.now()),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Roboto',
                              fontSize: rSize*0.02,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  SizedBox()
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
                    padding: EdgeInsets.symmetric(vertical: rSize * 0.01),
                    // shrinkWrap: true,
                    builderDelegate: PagedChildBuilderDelegate<TransactionModel>(noItemsFoundIndicatorBuilder: (context) {
                      return AppWidgets.emptyView(FFLocalizations.of(context).getText(
                        'u52470kh' /* No Transactions Found */,
                      ), context);
                    }, itemBuilder: (context, item, index) {
                      String currency = item.portfolioSecurity!.referenceCurrency!;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: rSize * 0.005,horizontal: rSize * 0.005),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(rSize*0.010),
                        ),
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
                                              fontSize: rSize*0.016,
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
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            size: rSize*0.015,
                                          )),
                                    ],
                                  ),
                                  if (_notifier.selectedTransactionIndex != index) ...{
                                    SizedBox(
                                      height: rSize * 0.005,
                                    ),
                                    AppWidgets.portfolioListElement(
                                      context,
                                      FFLocalizations.of(context).getText(
                                        'nkc71403' /* Security Name */,
                                      ),
                                      item.portfolioSecurity?.securityName ?? '',
                                    ),
                                    AppWidgets.portfolioListElement(
                                        context,
                                        FFLocalizations.of(context).getText(
                                          'xc0jtpk9' /* Status */,
                                        ),
                                        item.statusView ?? '')
                                  },
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
                                            borderRadius: BorderRadius.circular(rSize*0.015),
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
                                                  '$currency ${CommonFunctions.formatDoubleWithThousandSeperator('${item.openPrice!}', item.openPrice == 0, 2)}'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(
                                                  context,
                                                  FFLocalizations.of(context).getText(
                                                    'pgdm3cxj' /* Amount */,
                                                  ),
                                                  '$currency ${item.amount ?? ''}'),
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
                ),
              ),
            ],
          ),
        ));
  }
}
