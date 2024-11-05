import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

import '../market/new_trade.dart';
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(
                              item.title ?? '',
                              style: FlutterFlowTheme.of(context).displaySmall.override(
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
                                        color: FlutterFlowTheme.of(context).customColor4,
                                        fontSize: rSize * 0.014,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                SizedBox(
                                  height: rSize * 0.005,
                                ),
                                if (_notifier.selectedIndex != index) ...{AppWidgets.buildRichText(context, item.netValue!)},
                              ],
                            ),
                            SizedBox(
                              width: rSize * 0.015,
                            ),
                            RotatedBox(quarterTurns: _notifier.selectedIndex == index ? 3 : 2, child: AppWidgets.doubleBack(context))
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
                                      richText: AppWidgets.buildRichText(context, item.netValue ?? '')),
                                  SizedBox(
                                    height: rSize * 0.005,
                                  ),
                                  AppWidgets.portfolioListElement(
                                      context,
                                      FFLocalizations.of(context).getText(
                                        'y6z0kvbz' /* Portfolio Value */,
                                      ),
                                      item.portfolioValue ?? '',
                                      richText: AppWidgets.buildRichText(context, item.portfolioValue ?? '')),
                                  SizedBox(
                                    height: rSize * 0.005,
                                  ),
                                  AppWidgets.portfolioListElement(
                                      context,
                                      FFLocalizations.of(context).getText(
                                        '57fz6g1m' /* Amount Invested */,
                                      ),
                                      item.amountInvested ?? '',
                                      richText: AppWidgets.buildRichText(context, item.amountInvested ?? '')),
                                  SizedBox(
                                    height: rSize * 0.005,
                                  ),
                                  AppWidgets.portfolioListElement(
                                      context,
                                      FFLocalizations.of(context).getText(
                                        'rpfp7xvs' /* Cash Available */,
                                      ),
                                      item.cashAvailable ?? '',
                                      richText: AppWidgets.buildRichText(context, (item.cashAvailable ?? '').replaceAll('(', '').replaceAll(')', ''))),
                                  SizedBox(
                                    height: rSize * 0.015,
                                  ),
                                  AppWidgets.divider(context),
                                  SizedBox(
                                    height: rSize * 0.015,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            FFLocalizations.of(context).getText(
                                              'group_By',
                                            ),
                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                              color: FlutterFlowTheme.of(context).customColor4,
                                              fontSize: rSize * 0.016,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            ' ${item.sectionName ?? FFLocalizations.of(context).getText(
                                                  'zomhasya' /* Performance */,
                                                )}',
                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  fontSize: rSize * 0.016,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                      popupMenu(ontap: (i) {
                                        pagingController.itemList![index].sectionName = getName(context, i);
                                        setState(() {});
                                      })
                                    ],
                                  ),
                                  SizedBox(
                                    height: rSize * 0.01,
                                  ),
                                  Visibility(
                                    visible: pagingController.itemList![index].sectionName == null ||
                                        pagingController.itemList![index].sectionName ==
                                            FFLocalizations.of(context).getText(
                                              'zomhasya' /* Performance */,
                                            ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${FFLocalizations.of(context).getText(
                                                'hdgv1exn' /* Date */,
                                              )} : ',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontSize: rSize * 0.016,
                                                    color: FlutterFlowTheme.of(context).customColor4,
                                                  ),
                                            ),
                                            Text(
                                              DateFormat('MMM dd yyyy').format(DateTime.now()),
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontSize: rSize * 0.016,
                                                    color: FlutterFlowTheme.of(context).primary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: rSize * 0.01,
                                        ),
                                        XPortfolioItemLineChart(
                                          width: MediaQuery.sizeOf(context).width * 1,
                                          height: rSize * 0.300,
                                          xLabels: item.performanceChart!.map((e) => DateFormat('MMM dd, yyyy').format(e.date!)).toList(),
                                          listY: item.performanceChart!.map((e) => e.amount!).toList(),
                                          customWidth: item.performanceChart!.map((e) => e.amount).toList().length * 100,
                                          additionPercents: item.performanceChart!.map((e) => e.twrPercentage ?? 0.0).toList(),
                                          sectionName: item.sectionName ??
                                              FFLocalizations.of(context).getText(
                                                'zomhasya' /* Performance */,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: pagingController.itemList![index].sectionName ==
                                        FFLocalizations.of(context).getText(
                                          '7h0zeqv0' /* Asset Class */,
                                        ),
                                    child: XPortfolioItemLineChart(
                                      width: MediaQuery.sizeOf(context).width * 1,
                                      height: rSize * 0.300,
                                      item: item,
                                      xLabels: item.assetClassChart!.map((e) => e.assetClass ?? '').toList(),
                                      listY: item.assetClassChart!.map((e) => e.amount1!).toList(),
                                      listAmount: item.assetClassChart!.map((e) => e.amount3!).toList(),
                                      sectionName: FFLocalizations.of(context).getText(
                                        '7h0zeqv0' /* Asset Class */,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: pagingController.itemList![index].sectionName ==
                                        FFLocalizations.of(context).getText(
                                          'o00oeypg' /* Currency */,
                                        ),
                                    child: XPortfolioItemLineChart(
                                      width: MediaQuery.sizeOf(context).width * 1,
                                      height: rSize * 0.300,
                                      item: item,
                                      xLabels: item.currenciesChart!.map((e) => e.assetClass ?? '').toList(),
                                      listY: item.currenciesChart!.map((e) => e.amount1!).toList(),
                                      listAmount: item.currenciesChart!.map((e) => e.amount3!).toList(),
                                      sectionName: FFLocalizations.of(context).getText(
                                        'o00oeypg' /* Currency */,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: pagingController.itemList![index].sectionName ==
                                        FFLocalizations.of(context).getText(
                                          '6u2u1x9z' /* Health Alerts */,
                                        ),
                                    child: healthAlertSection(context, item),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              CommonFunctions.navigate(context, Positions(item.id!));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppStyles.iconBg(context,
                                    color: FlutterFlowTheme.of(context).customColor4,
                                    data: FontAwesomeIcons.shoppingBasket,
                                    size: rSize * 0.020,
                                    padding: EdgeInsets.all(rSize * 0.015)),
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'position',
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontSize: rSize * 0.016,
                                        color: FlutterFlowTheme.of(context).customColor4,
                                        fontWeight: FontWeight.w600,
                                      ),
                                )
                              ],
                            )),
                        GestureDetector(
                            onTap: () => CommonFunctions.navigate(context, Transactions(item.title!)),
                            child: Row(
                              children: [
                                SizedBox(width: rSize*0.02),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppStyles.iconBg(context,
                                        color: FlutterFlowTheme.of(context).customColor4,
                                        data: FontAwesomeIcons.dollarSign,
                                        size: rSize * 0.020,
                                        padding: EdgeInsets.all(rSize * 0.015)),
                                    Text(
                                        FFLocalizations.of(context).getText(
                                          'eg1yw963' /* Transactions */,
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontSize: rSize * 0.016,
                                              color: FlutterFlowTheme.of(context).customColor4,
                                              fontWeight: FontWeight.w600,
                                            ))
                                  ],
                                ),
                              ],
                            )),
                        GestureDetector(
                            onTap: () => CommonFunctions.navigate(context, AddTransaction(null,item)),
                            child: Column(
                              children: [
                                AppStyles.iconBg(context,
                                    color: FlutterFlowTheme.of(context).customColor4,
                                    data: FontAwesomeIcons.dollarSign, size: rSize * 0.020, padding: EdgeInsets.all(rSize * 0.015)),
                                Text(FFLocalizations.of(context).getText(
                                  'new_transaction',
                                ),style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontSize: rSize * 0.016,
                                  color: FlutterFlowTheme.of(context).customColor4,
                                  fontWeight: FontWeight.w600,
                                ))
                              ],
                            )),
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

  GestureDetector healthAlertSection(BuildContext context, PortfolioModel item) {
    return GestureDetector(
      onTap: () => CommonFunctions.navigate(context, HealthCheck(item.appropriateness, item.suitability)),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      boxShadow: AppStyles.shadow(),
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
                                        boxShadow: AppStyles.shadow(),
                                      ),
                                      alignment: const AlignmentDirectional(0, 0.0),
                                      child: Text(
                                        (int length) {
                                          return '$length${length <= 10 ? '' : '+'}';
                                        }(item.appropriateness!.listDetails?.length ?? 0),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                                  fontSize: rSize * 0.016,
                                  letterSpacing: 0,
                                  color: FlutterFlowTheme.of(context).customColor4,
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
                      boxShadow: AppStyles.shadow(),
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
                                          boxShadow: AppStyles.shadow(),
                                        ),
                                        alignment: const AlignmentDirectional(0, 0.0),
                                        child: Text(
                                          (int length) {
                                            return '$length${length <= 10 ? '' : '+'}';
                                          }(item.suitability!.listDetails?.length ?? 0),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                color: FlutterFlowTheme.of(context).info,
                                                fontSize: rSize * 0.016,
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
                                  fontSize: rSize * 0.016,
                                  color: FlutterFlowTheme.of(context).customColor4,
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
        ],
      ),
    );
  }

  String getName(BuildContext context, int i) {
    if (i == 1) {
      return FFLocalizations.of(context).getText(
        'zomhasya' /* Performance */,
      );
    } else if (i == 2) {
      return FFLocalizations.of(context).getText(
        '7h0zeqv0' /* Asset Class */,
      );
    } else if (i == 3) {
      return FFLocalizations.of(context).getText(
        'nkjefkra' /* Currency */,
      );
    } else {
      return FFLocalizations.of(context).getText(
        '6u2u1x9z' /* Health Alerts */,
      );
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  popupMenu({required Function ontap}) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      position: PopupMenuPosition.under,
      constraints: BoxConstraints(maxWidth: rSize*015),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rSize*0.01),
      ),clipBehavior: Clip.hardEdge,
      color: FlutterFlowTheme.of(context).primaryBackground,
      itemBuilder: (context) => [
        popupMenuItem(
            1,
            FFLocalizations.of(context).getText(
              'zomhasya' /* Performance */,
            ), () {
          ontap(1);
        }),
        popupMenuItem(
            2,
            FFLocalizations.of(context).getText(
              '7h0zeqv0' /* Asset Class */,
            ), () {
          ontap(2);
        }),
        popupMenuItem(
            3,
            FFLocalizations.of(context).getText(
              'nkjefkra' /* Currency */,
            ), () {
          ontap(3);
        }),
        popupMenuItem(
            4,
            FFLocalizations.of(context).getText(
              '6u2u1x9z' /* Health Alerts */,
            ), () {
          ontap(4);
        }),
      ],
      offset: const Offset(-5, 10),
      shadowColor: Colors.black,
      elevation: 2,
      tooltip: '',
      child: AppStyles.iconBg(
        context,
        customIcon: Image.asset(
          'assets/360-degree.png',
          color: FlutterFlowTheme.of(context).customColor4,
        ),
        padding: EdgeInsets.all(rSize * 0.008),
        data: FontAwesomeIcons.chartBar,
        color: FlutterFlowTheme.of(context).customColor4,
        size: rSize * 0.02,
        margin: EdgeInsets.symmetric(horizontal: rSize * 0.008),
      ),
    );
  }

  PopupMenuItem<int> popupMenuItem(int value, String label, void Function()? onTap) {
    return PopupMenuItem(
        value: value,
        onTap: onTap,
        height: rSize * 0.04,
        // padding: EdgeInsets.all(rSize * 0.01),
        // row has two child icon and text.
        child: Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                color: FlutterFlowTheme.of(context).customColor4,
                fontSize: rSize * 0.016,
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
              ),
        ));
  }
}
