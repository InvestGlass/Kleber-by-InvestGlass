import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/portfolio/health_check.dart';
import 'package:kleber_bank/portfolio/portfolio_controller.dart';
import 'package:kleber_bank/portfolio/portfolio_model.dart';
import 'package:kleber_bank/portfolio/positions.dart';
import 'package:kleber_bank/portfolio/transactions.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import 'x_portfoli_item_bar_chart.dart';
import 'x_portfolio_item_line_chart.dart';
import '../utils/app_colors.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> with AutomaticKeepAliveClientMixin{
  late PortfolioController _notifier;
  final PagingController<int, PortfolioModel> pagingController = PagingController(firstPageKey: 1);
  int pageKey = 1;

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPageActivity();
    });
    super.initState();
  }

  Future<void> _fetchPageActivity() async {
    PortfolioController provider = Provider.of<PortfolioController>(context, listen: false);
    List<PortfolioModel> list = await provider.getPortfolioList(pageKey);
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
      body: Container(
        decoration: AppStyles.commonBg(context),
        child: RefreshIndicator(
          onRefresh: () async {
            pageKey = 1;
            pagingController.refresh();
          },
          child: PagedListView<int, PortfolioModel>(
            pagingController: pagingController,
            // shrinkWrap: true,
            padding: EdgeInsets.only(top: 40),
            builderDelegate: PagedChildBuilderDelegate<PortfolioModel>(noItemsFoundIndicatorBuilder: (context) {
              return const SizedBox();
            }, itemBuilder: (context, item, index) {
              return Card(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                margin: EdgeInsets.symmetric(horizontal: rSize * 0.01, vertical: rSize * 0.005),
                child: Padding(
                  padding: EdgeInsets.all(rSize * 0.015),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _notifier.selectIndex(index),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              item.title ?? '',
                              style: FlutterFlowTheme.of(context).displaySmall.override(
                                    fontFamily: 'Roboto',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            )),
                            if (_notifier.selectedIndex != index) ...{
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      '83o1ghax' /* Net Value */,
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Roboto',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Text(
                                    item.netValue ?? '',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Roboto',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ],
                              ),
                            },
                            SizedBox(
                              width: rSize * 0.015,
                            ),
                            RotatedBox(
                                quarterTurns: _notifier.selectedIndex == index ? 1 : 3,
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: 15,
                                ))
                          ],
                        ),
                      ),
                      if (_notifier.selectedIndex == index) ...{
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
                                padding: EdgeInsets.symmetric(vertical:rSize * 0.015),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppWidgets.portfolioListElement(
                                        context,
                                        FFLocalizations.of(context).getText(
                                          'hdgv1exn' /* Date */,
                                        ),
                                        '2024-08-02'),
                                    SizedBox(
                                      height: rSize * 0.005,
                                    ),
                                    AppWidgets.portfolioListElement(
                                        context,
                                        FFLocalizations.of(context).getText(
                                          'cm2ob3q4' /* Net Value */,
                                        ),
                                        item.netValue ?? ''),
                                    SizedBox(
                                      height: rSize * 0.005,
                                    ),
                                    AppWidgets.portfolioListElement(
                                        context,
                                        FFLocalizations.of(context).getText(
                                          'y6z0kvbz' /* Portfolio Value */,
                                        ),
                                        item.portfolioValue ?? ''),
                                    SizedBox(
                                      height: rSize * 0.005,
                                    ),
                                    AppWidgets.portfolioListElement(
                                        context,
                                        FFLocalizations.of(context).getText(
                                          '57fz6g1m' /* Amount Invested */,
                                        ),
                                        item.amountInvested ?? ''),
                                    SizedBox(
                                      height: rSize * 0.005,
                                    ),
                                    AppWidgets.portfolioListElement(
                                        context,
                                        FFLocalizations.of(context).getText(
                                          'rpfp7xvs' /* Cash Available */,
                                        ),
                                        item.cashAvailable ?? ''),
                                    SizedBox(
                                      height: rSize * 0.015,
                                    ),
                                    AppWidgets.divider(context),
                                    SizedBox(
                                      height: rSize * 0.015,
                                    ),
                                    if(item.performanceChart!.isNotEmpty)...{
                                      Text(
                                          FFLocalizations.of(context).getText(
                                            'zomhasya' /* Performance */,
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Roboto',
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,)
                                      ),
                                      SizedBox(
                                        height: rSize * 0.035,
                                      ),
                                      XPortfolioItemLineChart(
                                        width: MediaQuery.sizeOf(context).width * 1.0,
                                        height: 300.0,
                                        xLabels: item.performanceChart!.map((e) => e.date.toString().split(' ')[0]).toList(),
                                        listY: item.performanceChart!.map((e) => e.amount!).toList(),
                                        customWidth: item.performanceChart!.map((e) => e.amount).toList().length * 100,
                                        additionPercents: item.performanceChart!.map((e) => e.twrPercentage ?? 0.0).toList(),
                                      ),
                                    AppWidgets.divider(context)},
                                    SizedBox(
                                      height: rSize * 0.015,
                                    ),
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        '7h0zeqv0' /* Asset Class */,
                                      ),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Roboto',
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    SizedBox(
                                      height: rSize * 0.02,
                                    ),
                                    XPortfoliItemBarChart(
                                      width: MediaQuery.sizeOf(context).width * 1.0,
                                      height: 300.0,
                                      xLabels: item.assetClassChart!.map((e) => e.assetClass ?? '').toList(),
                                      listY1: item.assetClassChart!.map((e) => e.amount1!).toList(),
                                      listY2: item.assetClassChart!.map((e) => e.amount2!).toList(),
                                      showPercentageWithUpDownArrowOnTopOfBar: true,
                                      listY3: item.assetClassChart!.map((e) => e.amount3!).toList(),
                                      showAmountWhenClickOnBar: true,
                                    ),
                                    AppWidgets.divider(context),
                                    SizedBox(
                                      height: rSize * 0.015,
                                    ),
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        'o00oeypg' /* Currency */,
                                      ),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Roboto',
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,)
                                    ),
                                    SizedBox(
                                      height: rSize * 0.02,
                                    ),
                                    XPortfoliItemBarChart(
                                      width: MediaQuery.sizeOf(context).width * 1.0,
                                      height: 300.0,
                                      xLabels: item.currenciesChart!.map((e) => e.assetClass ?? '').toList(),
                                      listY1: item.currenciesChart!.map((e) => e.amount1!).toList(),
                                      listY2: item.currenciesChart!.map((e) => e.amount2!).toList(),
                                      showPercentageWithUpDownArrowOnTopOfBar: true,
                                      listY3: item.currenciesChart!.map((e) => e.amount3!).toList(),
                                      showAmountWhenClickOnBar: true,
                                    ),
                                    AppWidgets.divider(context),
                                    SizedBox(
                                      height: rSize * 0.02,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          FFLocalizations.of(context).getText(
                                            '6u2u1x9z' /* Health Alerts */,
                                          ),
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Roboto',
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                        ))),
                                        if (item.appropriateness!.listDetails!.isNotEmpty || item.suitability!.listDetails!.isNotEmpty) ...{
                                          GestureDetector(
                                            onTap: () => CommonFunctions.navigate(context, HealthCheck(item.appropriateness, item.suitability)),
                                            child: Text(
                                              FFLocalizations.of(context).getText(
                                                '2um0eu09' /* Detail */,
                                              ),
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Roboto',
                                                    color: FlutterFlowTheme.of(context).primary,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                           RotatedBox(
                                              quarterTurns: 2,
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                color: FlutterFlowTheme.of(context).primary,
                                                size: 12,
                                              ))
                                        },
                                      ],
                                    ),
                                    SizedBox(
                                      height: rSize * 0.015,
                                    ),
                                    AppWidgets.healthAlertElement(context,
                                        '   ${FFLocalizations.of(context).getText(
                                          'kc4yx2mm' /* MINOR ISSUES */,
                                        )}',
                                        FlutterFlowTheme.of(context).primaryBackground,
                                        Icons.info_outline,
                                        '',
                                        item.appropriateness!,FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: 'Roboto',
                                      color:
                                      FlutterFlowTheme.of(context)
                                          .warning,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    )),
                                    SizedBox(
                                      height: rSize * 0.015,
                                    ),
                                    AppWidgets.healthAlertElement(context,
                                        '   ${FFLocalizations.of(context).getText(
                                          'ko88t7mf' /* MAJOR ISSUES */,
                                        )}',
                                        FlutterFlowTheme.of(context).primaryBackground,
                                        Icons.report_problem_outlined,
                                        '',
                                        item.suitability!,FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: 'Roboto',
                                      color: FlutterFlowTheme.of(context)
                                          .error,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      },
                      SizedBox(
                        height: rSize * 0.01,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    CommonFunctions.navigate(context, Positions(item.id!));
                                  },
                                  child: AppWidgets.btn(
                                      context,bgColor: FlutterFlowTheme.of(context).customColor1,
                                      FFLocalizations.of(context).getText(
                                        'd8zszkbn' /* Positions */,
                                      ),
                                      verticalPadding: rSize * 0.005))),
                          SizedBox(
                            width: rSize * 0.01,
                          ),
                          Expanded(
                              child: GestureDetector(
                                  onTap: () => CommonFunctions.navigate(context, Transactions(item.title!)),
                                  child: AppWidgets.btn(
                                      context,
                                      FFLocalizations.of(context).getText(
                                        'u192lk22' /* Transactions */,
                                      ),bgColor: FlutterFlowTheme.of(context).customColor1,
                                      verticalPadding: rSize * 0.005))),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
