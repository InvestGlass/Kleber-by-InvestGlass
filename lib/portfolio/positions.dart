import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kleber_bank/portfolio/portfolio_controller.dart';
import 'package:kleber_bank/portfolio/position_model.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class Positions extends StatefulWidget {
  final int id;
  const Positions(this.id,{super.key});

  @override
  State<Positions> createState() => _PositionsState();
}

class _PositionsState extends State<Positions> {
  late PortfolioController _notifier;
  final PagingController<int, PositionModel> _pagingController = PagingController(firstPageKey: 1);
  int _pageKey=1;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPageActivity();
    });
    super.initState();
  }

  Future<void> _fetchPageActivity() async {
    var notifier = Provider.of<PortfolioController>(context,listen: false);
    List<PositionModel> list=await ApiCalls.getPositionList(_pageKey,widget.id,notifier.column,notifier.direction);
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
      appBar: AppWidgets.appBar('Positions of 2024-08-02'),
      body: Padding(
        padding: EdgeInsets.all(rSize*0.015),
        child: Column(
          children: [
            DropdownButtonFormField(
                decoration: AppStyles.dropDownInputDecoration(AppWidgets.textFieldLabel('')),
                isExpanded: true,
                icon: AppWidgets.dropDownIcon(),
                style: AppStyles.c3C496CW500S18,
                isDense: true,
                value: _notifier.selectedPositionFilter,
                onChanged: (value) {
                  _notifier.selectPositionFilter(value!);
                  _pageKey=1;
                  _pagingController.refresh();
                },
                items: _notifier.positionsFilterTypeList
                    .map(
                      (String item) => DropdownMenuItem<String>(value: item, child: AppWidgets.dropDownHint(item)),
                )
                    .toList(),
                hint: AppWidgets.dropDownHint('Select Types')),
            SizedBox(height: rSize*0.015,),
            Flexible(
              child:
              RefreshIndicator(
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
                      margin: EdgeInsets.symmetric(vertical: rSize*0.005),
                      color: Colors.white,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(rSize*0.015),
                        children: [
                          GestureDetector(
                            onTap: () => _notifier.selectPositionIndex(index),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          item.referenceCurrency??'N/A',
                                          style: AppStyles.c656262W500S16,
                                        )),
                                    SizedBox(
                                      width: rSize * 0.015,
                                    ),
                                    RotatedBox(
                                        quarterTurns: _notifier.selectedPositionIndex == index ? 1 : 3,
                                        child: Icon(
                                          Icons.arrow_back_ios_new,
                                          color: AppColors.kTextFieldInput,
                                          size: 15,
                                        )),

                                  ],
                                ),
                                if (_notifier.selectedPositionIndex != index) ...{
                                  SizedBox(height: rSize*0.005,),
                                  AppWidgets.portfolioListElement(context,'Allocation', item.allocation??'N/A', middleValue: ''),
                                  AppWidgets.portfolioListElement(context,'ROI', item.roi!)
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
                                              AppWidgets.portfolioListElement(context,'Name', item.securityName??'N/A'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context,'ISIN', item.securityIsin??'N/A'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context,'Currency', item.referenceCurrency??'N/A'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context,'Last Price', item.lastPrice??'N/A'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context,'Cost Price', item.costPrice??'N/A'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context,'ROI', item.roi??'N/A'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context,'Quality', item.quantity??'N/A'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context,'FX Rate', item.fxRate??'N/A'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context,'Amount', item.amount??'N/A'),
                                              SizedBox(
                                                height: rSize * 0.005,
                                              ),
                                              AppWidgets.portfolioListElement(context,'Allocation', item.allocation??'N/A'),
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
}
