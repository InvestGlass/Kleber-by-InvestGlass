import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
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

import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import 'x_portfoli_item_bar_chart.dart';
import 'x_portfolio_item_line_chart.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> with AutomaticKeepAliveClientMixin {
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
    List<PortfolioModel> list = await provider.getPortfolioList(context, pageKey);
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
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          pageKey = 1;
          pagingController.refresh();
        },
        child: PagedListView<int, PortfolioModel>(
          pagingController: pagingController,
          // shrinkWrap: true,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 50),
          builderDelegate: PagedChildBuilderDelegate<PortfolioModel>(noItemsFoundIndicatorBuilder: (context) {
            return AppWidgets.emptyView(
                FFLocalizations.of(context).getText(
                  'l0x6h75l' /*No portfolio found*/,
                ),
                context);
          }, itemBuilder: (context, item, index) {
            return Container(
              decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: AppStyles.shadow(),
                  borderRadius: BorderRadius.circular(rSize * 0.01)),
              margin: EdgeInsets.symmetric(horizontal: rSize * 0.01, vertical: rSize * 0.005),
              child: Padding(
                padding: EdgeInsets.only(left: rSize * 0.015, right: rSize * 0.015, bottom: rSize * 0.015),
                child: Column(
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => _notifier.selectIndex(index),
                      child: Padding(
                        padding: EdgeInsets.only(top: rSize * 0.015),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              item.title ?? '',
                              style: FlutterFlowTheme.of(context).displaySmall.override(
                                    fontFamily: 'Roboto',
                                    color: FlutterFlowTheme.of(context).customColor4,
                                    fontSize: rSize * 0.016,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _notifier.selectedIndex == index
                                      ? ''
                                      : FFLocalizations.of(context).getText(
                                          '83o1ghax' /* Net Value */,
                                        ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Roboto',
                                        color: FlutterFlowTheme.of(context).customColor4,
                                        fontSize: rSize * 0.014,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                SizedBox(
                                  height: rSize * 0.005,
                                ),
                                if (_notifier.selectedIndex != index) ...{buildRichText(item, context, item.netValue!)},
                              ],
                            ),
                            SizedBox(
                              width: rSize * 0.015,
                            ),
                            RotatedBox(
                                quarterTurns: _notifier.selectedIndex == index ? 1 : 4,
                                child: AppWidgets.doubleBack(context))
                          ],
                        ),
                      ),
                    ),
                    if (_notifier.selectedIndex == index) ...{
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: rSize * 0.5,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                // color: AppColors.kViolate.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(rSize * 0.015),
                              ),
                              padding: EdgeInsets.symmetric(vertical: rSize * 0.015),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppWidgets.portfolioListElement(
                                      context,
                                      FFLocalizations.of(context).getText(
                                        'hdgv1exn' /* Date */,
                                      ),
                                      DateFormat('yyyy-MM-dd').format(DateTime.now())),
                                  SizedBox(
                                    height: rSize * 0.005,
                                  ),
                                  AppWidgets.portfolioListElement(
                                      context,
                                      FFLocalizations.of(context).getText(
                                        'cm2ob3q4' /* Net Value */,
                                      ),
                                      item.netValue ?? '',
                                      richText: buildRichText(item, context, item.netValue ?? '')),
                                  SizedBox(
                                    height: rSize * 0.005,
                                  ),
                                  AppWidgets.portfolioListElement(
                                      context,
                                      FFLocalizations.of(context).getText(
                                        'y6z0kvbz' /* Portfolio Value */,
                                      ),
                                      item.portfolioValue ?? '',
                                      richText: buildRichText(item, context, item.portfolioValue ?? '')),
                                  SizedBox(
                                    height: rSize * 0.005,
                                  ),
                                  AppWidgets.portfolioListElement(
                                      context,
                                      FFLocalizations.of(context).getText(
                                        '57fz6g1m' /* Amount Invested */,
                                      ),
                                      item.amountInvested ?? '',
                                      richText: buildRichText(item, context, item.amountInvested ?? '')),
                                  SizedBox(
                                    height: rSize * 0.005,
                                  ),
                                  AppWidgets.portfolioListElement(
                                      context,
                                      FFLocalizations.of(context).getText(
                                        'rpfp7xvs' /* Cash Available */,
                                      ),
                                      item.cashAvailable ?? '',
                                      richText: buildRichText(item, context, item.cashAvailable ?? '')),
                                  SizedBox(
                                    height: rSize * 0.015,
                                  ),
                                  AppWidgets.divider(context),
                                  SizedBox(
                                    height: rSize * 0.015,
                                  ),
                                  if (item.performanceChart!.isNotEmpty) ...{
                                    Text(
                                        FFLocalizations.of(context).getText(
                                          'zomhasya' /* Performance */,
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Roboto',
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              fontSize: rSize * 0.016,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w500,
                                            )),
                                    SizedBox(
                                      height: rSize * 0.035,
                                    ),
                                    XPortfolioItemLineChart(
                                      width: MediaQuery.sizeOf(context).width * 1,
                                      height: rSize * 0.300,
                                      xLabels: item.performanceChart!.map((e) => e.date.toString().split(' ')[0]).toList(),
                                      listY: item.performanceChart!.map((e) => e.amount!).toList(),
                                      customWidth: item.performanceChart!.map((e) => e.amount).toList().length * 100,
                                      additionPercents: item.performanceChart!.map((e) => e.twrPercentage ?? 0.0).toList(),
                                    ),
                                    AppWidgets.divider(context)
                                  },
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
                                          fontSize: rSize * 0.016,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  SizedBox(
                                    height: rSize * 0.02,
                                  ),
                                  XPortfoliItemBarChart(
                                    width: MediaQuery.sizeOf(context).width * 1,
                                    height: rSize * 0.300,
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
                                            fontSize: rSize * 0.016,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                          )),
                                  SizedBox(
                                    height: rSize * 0.02,
                                  ),
                                  XPortfoliItemBarChart(
                                    width: MediaQuery.sizeOf(context).width * 1,
                                    height: rSize * 0.300,
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
                                                    fontSize: rSize * 0.016,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w500,
                                                  ))),
                                      GestureDetector(
                                        onTap: () => CommonFunctions.navigate(context, HealthCheck(item.appropriateness, item.suitability)),
                                        child: Text(
                                          FFLocalizations.of(context).getText(
                                            '2um0eu09' /* Detail */,
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Roboto',
                                                color: FlutterFlowTheme.of(context).primary,
                                                fontSize: rSize * 0.016,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                      RotatedBox(
                                          quarterTurns: 2,
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            color: FlutterFlowTheme.of(context).primary,
                                            size: rSize * 0.012,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: rSize * 0.015,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, rSize * 0.010, 0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(rSize * 0.012),
                                                  bottomRight: Radius.circular(0.0),
                                                  topLeft: Radius.circular(rSize * 0.012),
                                                  topRight: Radius.circular(0.0),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0, rSize * 0.020, 0, rSize * 0.020),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, rSize * 0.020),
                                                      child: SizedBox(
                                                        width: rSize * 0.140,
                                                        height: rSize * 0.115,
                                                        child: Stack(
                                                          alignment: const AlignmentDirectional(0, 1.0),
                                                          children: [
                                                            Container(
                                                              width: rSize * 0.100,
                                                              height: rSize * 0.100,
                                                              decoration: const BoxDecoration(
                                                                color: Color(0x3FF9CF58),
                                                              ),
                                                              child: Icon(
                                                                Icons.warning_amber_rounded,
                                                                color: FlutterFlowTheme.of(context).warning,
                                                                size: rSize * 0.050,
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: const AlignmentDirectional(1, -1.0),
                                                              child: Container(
                                                                width: rSize * 0.040,
                                                                height: rSize * 0.030,
                                                                decoration: BoxDecoration(
                                                                  color: FlutterFlowTheme.of(context).warning,
                                                                ),
                                                                alignment: const AlignmentDirectional(0, 0.0),
                                                                child: Text(
                                                                  (int length) {
                                                                    return '$length${length <= 10 ? '' : '+'}';
                                                                  }(item.appropriateness!.listDetails?.length ?? 0),
                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                        fontFamily: 'Roboto',
                                                                        color: FlutterFlowTheme.of(context).info,
                                                                        fontSize: rSize * 0.016,
                                                                        letterSpacing: 0,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      FFLocalizations.of(context).getText(
                                                        'kc4yx2mm' /* MINOR ISSUES */,
                                                      ),
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Roboto',
                                                            fontSize: rSize * 0.016,
                                                            letterSpacing: 0,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: rSize * 0.002,
                                            decoration: const BoxDecoration(),
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(0.0),
                                                  bottomRight: Radius.circular(rSize * 0.012),
                                                  topLeft: Radius.circular(0.0),
                                                  topRight: Radius.circular(rSize * 0.012),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0, rSize * 0.020, 0, rSize * 0.020),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Align(
                                                      alignment: const AlignmentDirectional(0, 1.0),
                                                      child: Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, rSize * 0.020),
                                                        child: SizedBox(
                                                          width: rSize * 0.140,
                                                          height: rSize * 0.115,
                                                          child: Stack(
                                                            alignment: const AlignmentDirectional(0, 1.0),
                                                            children: [
                                                              Container(
                                                                width: rSize * 0.100,
                                                                height: rSize * 0.100,
                                                                decoration: const BoxDecoration(
                                                                  color: Color(0x41FF5963),
                                                                ),
                                                                child: Icon(
                                                                  Icons.error_outline_rounded,
                                                                  color: FlutterFlowTheme.of(context).error,
                                                                  size: rSize * 0.050,
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: const AlignmentDirectional(1, -1.0),
                                                                child: Container(
                                                                  width: rSize * 0.040,
                                                                  height: rSize * 0.030,
                                                                  decoration: BoxDecoration(
                                                                    color: FlutterFlowTheme.of(context).error,
                                                                  ),
                                                                  alignment: const AlignmentDirectional(0, 0.0),
                                                                  child: Text(
                                                                    (int length) {
                                                                      return '$length${length <= 10 ? '' : '+'}';
                                                                    }(item.suitability!.listDetails?.length ?? 0),
                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                          fontFamily: 'Roboto',
                                                                          color: FlutterFlowTheme.of(context).info,
                                                                          fontSize: rSize * 0.016,
                                                                          letterSpacing: 0,
                                                                          fontWeight: FontWeight.w500,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      FFLocalizations.of(context).getText(
                                                        'ko88t7mf' /* MAJOR ISSUES */,
                                                      ),
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Roboto',
                                                            fontSize: rSize * 0.016,
                                                            letterSpacing: 0,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    },
                    SizedBox(
                      height: rSize * 0.005,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  CommonFunctions.navigate(context, Positions(item.id!));
                                },
                                child: AppWidgets.btn(
                                    context,
                                    bgColor: FlutterFlowTheme.of(context).customColor1,
                                    FFLocalizations.of(context).getText(
                                      'd8zszkbn' /* Positions */,
                                    ),))),
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
                                    ),
                                    bgColor: FlutterFlowTheme.of(context).customColor1))),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  RichText buildRichText(PortfolioModel item, BuildContext context, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${value.split(' ')[0]} ',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.of(context).customColor4,
                  fontSize: rSize * 0.016,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                ),
          ),
          TextSpan(
            text: value.split(' ')[1],
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: rSize * 0.016,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w800,
                ),
          ),
          if (value.split(' ').length > 2) ...{
            TextSpan(
              text: value.split(' ')[2],
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: rSize * 0.016,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          },
          if (value.split(' ').length > 3) ...{
            TextSpan(
              text: value.split(' ')[3],
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: rSize * 0.016,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          }
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
