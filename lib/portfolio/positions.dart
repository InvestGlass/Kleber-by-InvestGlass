import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/portfolio/portfolio_controller.dart';
import 'package:kleber_bank/portfolio/position_model.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/common_functions.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';

class Positions extends StatefulWidget {
  final int id;

  const Positions(this.id, {super.key});

  @override
  State<Positions> createState() => _PositionsState();
}

class _PositionsState extends State<Positions> {
  late PortfolioController _notifier;
  final PagingController<int, PositionModel> _pagingController = PagingController(firstPageKey: 1);
  int _pageKey = 1;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPageActivity();
    });
    super.initState();
  }

  Future<void> _fetchPageActivity() async {
    var notifier = Provider.of<PortfolioController>(context, listen: false);
    List<PositionModel> list = await ApiCalls.getPositionList(_pageKey, widget.id, notifier.column, notifier.direction);
    final isLastPage = list.length < 10;
    if (isLastPage) {
      _pagingController.appendLastPage(list);
    } else {
      _pageKey++;
      _pagingController.appendPage(list, _pageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<PortfolioController>(context);
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: Padding(
        padding: EdgeInsets.only(left:rSize * 0.015,right: rSize * 0.015,top: rSize * 0.03),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        FFLocalizations.of(context).getText(
                          'qhszshsn' /* Position as of */,
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
            SizedBox(height: rSize*0.02,),
            DropdownButtonFormField(
                decoration: AppStyles.dropDownInputDecoration(context, AppWidgets.textFieldLabel(''),focusedBorderColor: FlutterFlowTheme.of(context)
                    .alternate,prefix: Icon(
                  Icons.sort_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                )),
                isExpanded: true,
                icon: AppWidgets.dropDownIcon(),
                style: FlutterFlowTheme.of(context).displaySmall.override(
                      fontFamily: 'Roboto',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                isDense: true,
                value: _notifier.selectedPositionFilter,
                onChanged: (value) {
                  _notifier.selectPositionFilter(value!);
                  _pageKey = 1;
                  _pagingController.refresh();
                },dropdownColor: FlutterFlowTheme.of(context).secondaryText,
                items: _notifier.positionsFilterTypeList
                    .map(
                      (String item) => DropdownMenuItem<String>(value: item, child: AppWidgets.dropDownHint(context, item)),
                    )
                    .toList(),
                hint: AppWidgets.dropDownHint(context, 'Select Types')),
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
                  builderDelegate: PagedChildBuilderDelegate<PositionModel>(noItemsFoundIndicatorBuilder: (context) {
                    return const SizedBox();
                  }, itemBuilder: (context, item, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: rSize * 0.005),
                      elevation: 2,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(rSize * 0.015),
                        children: [
                          GestureDetector(
                            onTap: () => _notifier.selectPositionIndex(index),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      item.securityName ?? '-',
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
                                        quarterTurns: _notifier.selectedPositionIndex == index ? 1 : 3,
                                        child: Icon(
                                          Icons.arrow_back_ios_new,
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          size: 15,
                                        )),
                                  ],
                                ),
                                if (_notifier.selectedPositionIndex != index) ...{
                                  SizedBox(
                                    height: rSize * 0.005,
                                  ),
                                  AppWidgets.portfolioListElement(context, FFLocalizations.of(context).getText(
                                    'tea2m5lq' /* Allocation */,
                                  ), item.allocation?.toString().replaceAll(' ', '') ?? '-', middleValue: CommonFunctions.formatDoubleWithThousandSeperator('${item.amount}', (double.tryParse(item.amount!)??0) == 0, 2)),
                                  AppWidgets.portfolioListElement(context, FFLocalizations.of(context).getText(
                                    'e0dy1vxx' /* ROI */,
                                  ), item.roi!+(item.roi!='-'?'%':''),icon: getIcon(double.tryParse(item.roi!)??0))
                                },
                                if (_notifier.selectedPositionIndex == index) ...{
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
                                              AppWidgets.portfolioListElement(context, FFLocalizations.of(context).getText(
                                                '4kttzprb' /* Name */,
                                              ), item.securityName ?? '-'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context, FFLocalizations.of(context).getText(
                                                '6thwwafn' /* ISIN */,
                                              ), item.securityIsin ?? '-'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context, FFLocalizations.of(context).getText(
                                                'ivu9tdzj' /* Currency */,
                                              ), item.referenceCurrency ?? '-'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context, FFLocalizations.of(context).getText(
                                                'fbgy82bc' /* Last Price */,
                                              ), item.lastPrice ?? '-'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context, FFLocalizations.of(context).getText(
                                                'swv2ctiz' /* Cost Price */,
                                              ), item.costPrice ?? '-'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context, FFLocalizations.of(context).getText(
                                                'cdklrlbv' /* ROI */,
                                              ), item.roi!+(item.roi!='-'?'%':''),icon: getIcon(double.tryParse(item.roi!)??0)),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context, FFLocalizations.of(context).getText(
                                                'ox3fj6xq' /* Quantity */,
                                              ), item.quantity ?? '-'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context, 'FX Rate', item.fxRate ?? '-'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context, FFLocalizations.of(context).getText(
                                                'juhk5a4f' /* Amount */,
                                              ), CommonFunctions.formatDoubleWithThousandSeperator('${item.amount}', (double.tryParse(item.amount!)??0) == 0, 2)),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context, FFLocalizations.of(context).getText(
                                                'xai3n31z' /* Allocation */,
                                              ), item.allocation?.toString().replaceAll(' ', '') ?? '-'),
                                              SizedBox(
                                                height: rSize * 0.015,
                                              ),
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
            )
          ],
        ),
      ),
    );
  }

  getIcon(double d) {
    if(d==0){
      return SizedBox();
    }else if(d>0){
      return FaIcon(
        FontAwesomeIcons.caretUp,
        color: FlutterFlowTheme.of(context)
            .customColor2,
        size: 24.0,
      );
    }else{
      return FaIcon(
        FontAwesomeIcons.caretDown,
        color: FlutterFlowTheme.of(context)
            .customColor3,
        size: 24.0,
      );
    }
  }
}
