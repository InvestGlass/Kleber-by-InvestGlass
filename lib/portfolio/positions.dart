import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/portfolio/portfolio_controller.dart';
import 'package:kleber_bank/portfolio/portfolio_model.dart';
import 'package:kleber_bank/portfolio/position_model.dart';
import 'package:kleber_bank/proposals/chat/chat_history.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/searchable_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../main.dart';
import '../market/market_list_model.dart';
import '../market/new_trade.dart';
import '../proposals/proposal_model.dart';
import '../utils/app_styles.dart';
import '../utils/common_functions.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import '../utils/shared_pref_utils.dart';

class Positions extends StatefulWidget {
  final int id;

  const Positions(this.id, {super.key});

  @override
  State<Positions> createState() => _PositionsState();
}

class _PositionsState extends State<Positions> {
  late PortfolioController _notifier;
  final PagingController<int, PositionModel> _pagingController =
      PagingController(firstPageKey: 1);
  int _pageKey = 1;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPageActivity(context);
    });
    super.initState();
  }

  Future<void> _fetchPageActivity(
    BuildContext context,
  ) async {
    var notifier = Provider.of<PortfolioController>(context, listen: false);
    List<PositionModel> list = await ApiCalls.getPositionList(
        context, _pageKey, widget.id, notifier.column, notifier.direction);
    final isLastPage = list.length < 10;
    if (isLastPage) {
      _pagingController.appendLastPage(list);
    } else {
      _pageKey++;
      _pagingController.appendPage(list, _pageKey);
    }
    if (notifier.column == 'roi' && notifier.direction == 'asc') {
      _pagingController.itemList!
          .sort((a, b) => double.parse(a.roi!).compareTo(double.parse(b.roi!)));
    } else if (notifier.column == 'roi' && notifier.direction == 'desc') {
      _pagingController.itemList!
          .sort((a, b) => double.parse(b.roi!).compareTo(double.parse(a.roi!)));
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
            'd8zszkbn' /* Position*/,
          ),
          leading: AppWidgets.backArrow(context)),
      body: Padding(
        padding: EdgeInsets.only(top: rSize * 0.015),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: rSize * 0.015,
                ),
                Expanded(
                  child: SearchableDropdown(
                    selectedValue: _notifier.selectedPositionFilter,
                    isSearchable: false,
                    searchHint: 'Select Types',
                    onChanged: (p0) {
                      _notifier.selectPositionFilter(p0);
                      _pageKey = 1;
                      _pagingController.refresh();
                    },
                    items: _notifier.positionsFilterTypeList
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
                      return _notifier.positionsFilterTypeList.map((item) {
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
                SizedBox(
                  width: rSize * 0.015,
                ),
              ],
            ),
            SizedBox(
              height: rSize * 0.015,
            ),
            Flexible(
              child: RefreshIndicator(
                onRefresh: () async {
                  _pageKey = 1;
                  _pagingController.refresh();
                },
                child: PagedListView<int, PositionModel>(
                  pagingController: _pagingController,
                  // shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  builderDelegate: PagedChildBuilderDelegate<PositionModel>(
                      noItemsFoundIndicatorBuilder: (context) {
                    return AppWidgets.emptyView('No Positions Found', context);
                  }, firstPageProgressIndicatorBuilder: (context) {
                    return skaleton();
                  }, itemBuilder: (context, item, index) {
                    String currency = item.referenceCurrency ?? '-';
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(), children: [
                          slideOption(context,'Buy',FontAwesomeIcons.plus,Colors.green,(){
                            CommonFunctions.navigate(context, AddTransaction(MarketListModel(id: item.security!.noItem!.id,name: item.security!.noItem!.name,price: item.security!.noItem!.price,),PortfolioModel(id: item.portfolioId)));
                          }),
                          slideOption(context,'Sell',FontAwesomeIcons.minus,FlutterFlowTheme.of(context).error,(){
                            CommonFunctions.navigate(context, AddTransaction(MarketListModel(id: item.security!.noItem!.id,name: item.security!.noItem!.name,price: item.security!.noItem!.price,),PortfolioModel(id: item.portfolioId)));
                          }),
                          slideOption(context,'Chat',FontAwesomeIcons.message,FlutterFlowTheme.of(context).primary,(){
                            CommonFunctions.navigate(context, ChatHistory(ProposalModel(
                                advisor: Advisor(
                                    name: SharedPrefUtils.instance
                                        .getUserData()
                                        .user!
                                        .advisor!
                                        .name
                                        .toString(),
                                    phoneOffice: '+41763358815'))));
                          })
                      ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).secondaryBackground,
                            boxShadow: AppStyles.shadow(),
                            borderRadius: BorderRadius.circular(rSize * 0.01)),
                        margin: EdgeInsets.symmetric(
                            vertical: rSize * 0.005, horizontal: rSize * 0.015),
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(rSize * 0.015),
                          children: [
                            AppWidgets.click(
                              onTap: () => _notifier.selectPositionIndex(index),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        item.securityName ?? '-',
                                        style: FlutterFlowTheme.of(context)
                                            .displaySmall
                                            .override(
                                              color: FlutterFlowTheme.of(context)
                                                  .primaryText,
                                              fontSize: rSize * 0.016,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      )),
                                      SizedBox(
                                        width: rSize * 0.015,
                                      ),
                                      AnimatedRotation(
                                          turns:
                                              _notifier.selectedPositionIndex ==
                                                      index
                                                  ? 0.75
                                                  : 0.5,
                                          duration: Duration(milliseconds: 300),
                                          child: AppWidgets.doubleBack(context)),
                                    ],
                                  ),
                                  if (_notifier.selectedPositionIndex !=
                                      index) ...{
                                    SizedBox(
                                      height: rSize * 0.005,
                                    ),
                                    AppWidgets.portfolioListElement(
                                        context,
                                        FFLocalizations.of(context).getText(
                                          'tea2m5lq' /* Allocation */,
                                        ),
                                        '${item.allocation ?? '0.00'}%',
                                        middleValue:
                                            '$currency ${getSeparatorFormat(item.amount!)}'),
                                    AppWidgets.portfolioListElement(
                                        context,
                                        '${FFLocalizations.of(context).getText(
                                          'e0dy1vxx' /* ROI */,
                                        )} ($currency)',
                                        buildRoi(item)! +
                                            (item.roi != '-' ? '%' : ''),
                                        icon: getIcon(
                                            double.tryParse(item.roi!) ?? 0))
                                  },
                                  if (_notifier.selectedPositionIndex ==
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
                                                    '4kttzprb' /* Name */,
                                                  ),
                                                  item.securityName ?? '-'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(
                                                  context,
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    '6thwwafn' /* ISIN */,
                                                  ),
                                                  item.securityIsin ?? '-'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(
                                                  context,
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'ivu9tdzj' /* Currency */,
                                                  ),
                                                  currency),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(
                                                  context,
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'fbgy82bc' /* Last Price */,
                                                  ),
                                                  '$currency ${getSeparatorFormat(item.lastPrice!, i: 3)}',
                                                  richText: AppWidgets.buildRichText(
                                                      context,
                                                      '$currency ${getSeparatorFormat(item.lastPrice!, i: 3)}')),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(
                                                  context,
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'swv2ctiz' /* Cost Price */,
                                                  ),
                                                  '$currency ${getSeparatorFormat(item.costPrice!, i: 3)}',
                                                  richText: AppWidgets.buildRichText(
                                                      context,
                                                      '$currency ${getSeparatorFormat(item.costPrice!, i: 3)}')),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(
                                                  context,
                                                  '${FFLocalizations.of(context).getText(
                                                    'e0dy1vxx' /* ROI */,
                                                  )} ($currency)',
                                                  buildRoi(item)! +
                                                      (item.roi != '-'
                                                          ? '%'
                                                          : ''),
                                                  icon: getIcon(double.tryParse(
                                                          item.roi!) ??
                                                      0)),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(
                                                  context,
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'ox3fj6xq' /* Quantity */,
                                                  ),
                                                  getSeparatorFormat(
                                                      item.quantity!)),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(
                                                  context,
                                                  'FX Rate',
                                                  getSeparatorFormat(item.fxRate!,
                                                      i: 6)),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(
                                                  context,
                                                  FFLocalizations.of(context)
                                                      .getText(
                                                    'juhk5a4f' /* Amount */,
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
                                                    'xai3n31z' /* Allocation */,
                                                  ),
                                                  '${item.allocation ?? '0.00'}%'),
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
                      ),
                    );
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget slideOption(BuildContext context, String label, IconData icon, Color color,void Function() onTap) {
    return AppWidgets.click(
      onTap: onTap,
      child: Container(
                            color: color,
                            width: rSize*0.065,
                            margin: EdgeInsets.symmetric(vertical: rSize*0.005),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(icon,color: FlutterFlowTheme.of(context).info,),
                                Text(label,style: AppStyles.inputTextStyle(context).copyWith(color: FlutterFlowTheme.of(context).info))
                              ],
                            ),
                          ),
    );
  }

  String? buildRoi(PositionModel item) {
    print('roi value ${item.roi!}');
    if (item.roi != '-') {
      return getSeparatorFormat(double.parse(item.roi!));
    }
    return item.roi;
  }

  String getSeparatorFormat(double item, {int i = 2}) =>
      CommonFunctions.formatDoubleWithThousandSeperator(
          item.toString(), item == 0, i);

  getIcon(double d) {
    if (d == 0) {
      return null;
    } else if (d > 0) {
      return FaIcon(
        FontAwesomeIcons.caretUp,
        color: FlutterFlowTheme.of(context).customColor2,
        size: rSize * 0.024,
      );
    } else {
      return FaIcon(
        FontAwesomeIcons.caretDown,
        color: FlutterFlowTheme.of(context).customColor3,
        size: rSize * 0.024,
      );
    }
  }

  Widget skaleton() {
    return Expanded(
      child: Skeletonizer(
        enabled: true,
        child: Column(
          children: [
            container(),
            container(),
            container(),
            container(),
            container(),
            container(),
          ],
        ),
      ),
    );
  }

  Container container() {
    return Container(
      padding: EdgeInsets.all(rSize*0.015),
      margin: EdgeInsets.only(bottom: rSize*0.015,left: rSize*0.015,right: rSize*0.015,),
            decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: AppStyles.shadow(),
                borderRadius: BorderRadius.circular(rSize * 0.01)),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          'Cert XBT Provider 2017-open end on Ethereum (38627714)',
                          style: FlutterFlowTheme.of(context).displaySmall.override(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: rSize * 0.016,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    SizedBox(
                      width: rSize * 0.015,
                    ),
                    AnimatedRotation(
                        turns:  0.5,
                        duration: const Duration(milliseconds: 300),
                        child: AppWidgets.doubleBack(context)),
                  ],
                ),
                AppWidgets.portfolioListElement(
                    context,
                    FFLocalizations.of(context).getText(
                      'tea2m5lq' /* Allocation */,
                    ),
                    '102%',
                    middleValue:"3333,126 USD",),
                SizedBox(
                  height: rSize * 0.005,
                ),
                AppWidgets.portfolioListElement(
                    context,
                    FFLocalizations.of(context).getText(
                      'tea2m5lq' /* Allocation */,
                    ),
                    '2.00%',
                    middleValue:
                    "3333,126 USD"),
                AppWidgets.portfolioListElement(
                    context,
                    '${FFLocalizations.of(context).getText(
                      'e0dy1vxx' /* ROI */,
                    )} (USD)',
                    '15.00',
                    icon: getIcon(-1))
              ],
            ),
          );
  }
}
