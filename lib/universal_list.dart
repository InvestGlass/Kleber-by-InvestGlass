import 'package:flutter/material.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/flutter_flow_theme.dart';
import 'package:kleber_bank/utils/internationalization.dart';
import 'package:kleber_bank/utils/searchable_dropdown.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'market/market_controller.dart';
import 'market/market_list_item_widget.dart';
import 'market/market_list_model.dart';

class UniversalList extends StatelessWidget {
  
  static late MarketController _marketNotifier;
  const UniversalList({super.key});

  @override
  Widget build(BuildContext context) {
    _marketNotifier = Provider.of<MarketController>(context);
    return Scaffold(
      appBar: AppWidgets.appBar(
          context,
          centerTitle: true,
          leading: AppWidgets.backArrow(context),
          FFLocalizations.of(context).getText(
            'universe_list',
          )),
      body: Column(
        children: [
          SizedBox(height: rSize*0.005,),
          Row(
            children: [
              SizedBox(width: rSize * 0.015),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: AppStyles.shadow(),
                      borderRadius: BorderRadius.circular(rSize*0.01)
                  ),
                  child: TextField(
                    style: FlutterFlowTheme.of(context).bodyMedium.override(

                        fontWeight: FontWeight.w500,
                        color: FlutterFlowTheme.of(context).customColor4
                    ),
                    decoration: AppStyles.inputDecoration(context,hint: FFLocalizations.of(context).getText(
                      'wzls4zjf' /* Type security name */,
                    ),prefix: Padding(
                      padding: EdgeInsets.symmetric(horizontal: rSize*0.015),
                      child: Icon(Icons.search,size: rSize*0.025,color: FlutterFlowTheme.of(context).customColor4,),
                    ),contentPadding: EdgeInsets.symmetric(vertical: rSize*0.017,horizontal: rSize*0.020),focusColor: Colors.transparent),
                    onChanged: (value) {},
                  ),
                ),
              ),
              SizedBox(
                width: rSize * 0.010,
              ),
              AppWidgets.click(
                onTap: () {
                  openFilterDialog(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: AppStyles.shadow(),
                      borderRadius: BorderRadius.circular(rSize*0.01)
                  ),
                  height: rSize * 0.05,
                  width: rSize * 0.05,
                  child: Icon(
                    Icons.filter_alt_outlined,
                    size: rSize * 0.025,
                    color: FlutterFlowTheme.of(context).customColor4,
                  ),
                ),
              ),
              SizedBox(width: rSize * 0.015),
            ],
          ),
          SizedBox(
            height: rSize * 0.01,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return MarketListItemWidget(
                  // key: Key('Keyery_${index}_of_${realLength}'),
                  data: MarketListModel(assetClassName: '',name: ''),
                );
            },),
          ),
        ],
      ),
    );
  }

  void openFilterDialog(BuildContext context) {
    _marketNotifier.getFilterDropDown(context);
    MarketListModel? selectedAssetClass, selectedIndustry, selectedCurrency;
    selectedAssetClass = _marketNotifier.selectedAssetClass;
    selectedIndustry = _marketNotifier.selectedIndustry;
    selectedCurrency = _marketNotifier.selectedCurrency;
    showDialog(
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      boxShadow: AppStyles.shadow(),
                      borderRadius: BorderRadius.circular(rSize*0.01)
                  ),
                  margin: EdgeInsets.symmetric(horizontal: rSize * 0.015),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      _marketNotifier = Provider.of<MarketController>(context);
                      return Wrap(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                                left: rSize * 0.02,
                                right: rSize * 0.02,
                                top: rSize * 0.03,
                                bottom: MediaQuery.of(context).viewInsets.bottom + rSize * 0.03),
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: AppWidgets.title(context,
                                          FFLocalizations.of(context).getText(
                                            'filter' /* Filter */,
                                          ))),
                                  AppWidgets.click(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size:rSize*0.025,
                                      color: FlutterFlowTheme.of(context).customColor4,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: rSize * 0.02,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, rSize * 0.010),
                                child: AppWidgets.label(context,FFLocalizations.of(context).getText(
                                  '1p01lh7n' /* Asset Class */,
                                )
                                ),
                              ),
                              SearchableDropdown(
                                selectedValue: selectedAssetClass,
                                searchHint: FFLocalizations.of(context).getText(
                                  'sotc1ho8' /* Search for an asset class */,
                                ),
                                onChanged: (p0) {
                                  selectedAssetClass = p0;
                                },
                                items: _marketNotifier.assetClassList
                                    .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item.name!,
                                    style: AppStyles.inputTextStyle(context),
                                  ),
                                ))
                                    .toList(),
                                searchMatchFn: (item, searchValue) {
                                  return CommonFunctions.compare(searchValue, item.value.name.toString());
                                },
                              ),
                              SizedBox(
                                height: rSize * 0.015,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, rSize * 0.010),
                                child: AppWidgets.label(context,FFLocalizations.of(context).getText(
                                  'zfneqwjq' /* Industry */,
                                )
                                ),
                              ),
                              SearchableDropdown(
                                selectedValue: selectedIndustry,
                                searchHint: FFLocalizations.of(context).getText(
                                  '8ltvrr9u' /* Search for an industry */,
                                ),
                                onChanged: (p0) {
                                  selectedIndustry = p0;
                                },
                                items: _marketNotifier.industryList
                                    .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item.name!,
                                    style: AppStyles.inputTextStyle(context),
                                  ),
                                ))
                                    .toList(),
                                searchMatchFn: (item, searchValue) {
                                  return CommonFunctions.compare(searchValue, item.value.name.toString());
                                },
                              ),
                              SizedBox(
                                height: rSize * 0.015,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, rSize * 0.010),
                                child: AppWidgets.label(context,FFLocalizations.of(context).getText(
                                  'nkjefkra' /* Currency */,
                                )
                                ),
                              ),
                              SearchableDropdown(
                                selectedValue: selectedCurrency,
                                searchHint: FFLocalizations.of(context).getText(
                                  'ng4uvnyc' /* Search for a currency */,
                                ),
                                onChanged: (p0) {
                                  selectedCurrency = p0;
                                },
                                items: _marketNotifier.currencyList
                                    .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item.name!,
                                    style: AppStyles.inputTextStyle(context),
                                  ),
                                ))
                                    .toList(),
                                searchMatchFn: (item, searchValue) {
                                  return CommonFunctions.compare(searchValue, item.value.name.toString());
                                },
                              ),
                              SizedBox(
                                height: rSize * 0.015,
                              ),
                              SizedBox(
                                height: rSize * 0.02,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                        onTap: () async {

                                        },
                                        child: AppWidgets.btn(
                                            context,
                                            FFLocalizations.of(context).getText(
                                              'g7rr5vmv' /* CLEAR */,
                                            ),
                                            borderOnly: true)),
                                  ),
                                  SizedBox(
                                    width: rSize * 0.02,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                        onTap: () async {

                                        },
                                        child: AppWidgets.btn(
                                            context,
                                            FFLocalizations.of(context).getText(
                                              'lmndaaco' /* Apply */,
                                            ),
                                            bgColor: FlutterFlowTheme.of(context).primary)),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
