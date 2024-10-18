import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kleber_bank/market/video_player_widget.dart';
import 'package:kleber_bank/securitySelection/security_selection_controller.dart';
import 'package:kleber_bank/securitySelection/security_selection_list_item.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/searchable_dropdown.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../market/market_list_model.dart';
import '../utils/app_styles.dart';
import '../utils/app_widgets.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';

class SecuritySelection extends StatefulWidget {
  const SecuritySelection({super.key});

  @override
  State<SecuritySelection> createState() => _SecuritySelectionState();
}

class _SecuritySelectionState extends State<SecuritySelection> {
  Timer? _debounce;
  late SecuritySelectionController _notifier;
  int pageKey = 1;

  @override
  void dispose() {
    _debounce?.cancel();
    _notifier.selectedSecurity=null;
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<SecuritySelectionController>(context, listen: false).pagingController.addPageRequestListener((pageKey) {
      if (mounted) {
        _fetchPageActivity();
      }
    });
    super.initState();
  }

  Future<void> _fetchPageActivity() async {
    SecuritySelectionController provider = Provider.of<SecuritySelectionController>(context, listen: false);
    await provider.getList(context,pageKey);
    final isLastPage = provider.marketList.length < 10;
    if (isLastPage) {
      provider.pagingController.appendLastPage(provider.marketList);
    } else {
      pageKey++;
      provider.pagingController.appendPage(provider.marketList, pageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<SecuritySelectionController>(context);
    return Container(
      decoration: AppStyles.commonBg(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: rSize*0.040, vertical: rSize*0.02),
              color: FlutterFlowTheme.of(context).secondaryBackground,
              child: GestureDetector(
                onTap: () {
                  if (_notifier.selectedSecurity != null) {
                    Navigator.pop(context, _notifier.selectedSecurity);
                  }
                },
                child: AppWidgets.btn(
                    context,
                    FFLocalizations.of(context).getText(
                      'ogcb9xww' /* Select */,
                    ),
                    bgColor: _notifier.selectedSecurity != null ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).customColor4),
              ),
            ),
          ],
        ),
        appBar: AppWidgets.appBar(
            context,
            centerTitle: true,
            leading: AppWidgets.backArrow(context),
            FFLocalizations.of(context).getText(
              'k3na7l6v' /* Select Security */,
            )),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: rSize * 0.015,
            vertical: rSize * 0.015,
          ),
          child: Column(
            // padding: EdgeInsets.symmetric(horizontal: rSize*0.015,vertical: rSize*0.01),
            // physics: const NeverScrollableScrollPhysics(),
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => openFilterDialog(context),
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
                  SizedBox(
                    width: rSize * 0.010,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: AppStyles.shadow(),
                          borderRadius: BorderRadius.circular(rSize*0.01)
                      ),
                      child: TextField(
                        controller: _notifier.searchController,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(

                            fontWeight: FontWeight.w500,
                            color: FlutterFlowTheme.of(context).customColor4
                        ),
                        decoration: AppStyles.inputDecoration(context,hint: FFLocalizations.of(context).getText(
                          'wzls4zjf' /* Type security name */,
                        ),prefix: Padding(
                          padding: EdgeInsets.symmetric(horizontal: rSize*0.015),
                          child: Icon(Icons.search,size: rSize*0.025,color: FlutterFlowTheme.of(context).customColor4,),
                        ),contentPadding: EdgeInsets.symmetric(vertical: rSize*0.017,horizontal: 20),focusColor: Colors.transparent),
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce = Timer(const Duration(milliseconds: 500), () async {
                            pageKey = 1;
                            _notifier.refresh();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: rSize * 0.01,
              ),
              Flexible(
                child: RefreshIndicator(
                  onRefresh: () async {
                    pageKey = 1;
                    _notifier.pagingController.refresh();
                  },
                  child: PagedListView<int, MarketListModel>(
                    pagingController: _notifier.pagingController,
                    // shrinkWrap: true,
                    builderDelegate: PagedChildBuilderDelegate<MarketListModel>(noItemsFoundIndicatorBuilder: (context) {
                      return const SizedBox();
                    }, itemBuilder: (context, item, index) {
                      return MarketListItemWidget(
                        // key: Key('Keyery_${index}_of_${realLength}'),
                        data: item,
                        indexStr: '$index',
                        onItemTapCustom: (indexInList, data) async {
                          _notifier.selectSecurity(data);
                        },bgColor: _notifier.selectedSecurity==item?FlutterFlowTheme.of(context).customColor1:null,
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? displayFile(MarketListModel item, int index) {
    if (item.imageUrl == null && item.videoUrl == null) {
      return null;
    } else if (item.imageUrl != null) {
      return Image.network(
        item.imageUrl ?? '',
        fit: BoxFit.fitHeight,
        // width: double.infinity,
        // height: double.infinity,
      );
    } else {
      // return MainPage(item.videoUrl??'');
      return SizedBox(
        height: 150,
        child: VideoPlayerItem(
          item.videoUrl ?? '',
          /*onPlayStatusChanged: (isPlaying) {
            _notifier.onPlayStatusChanged(index, isPlaying);
          },*/
        ),
      );
    }
  }

  void openFilterDialog(BuildContext context,) {
    _notifier.getFilterDropDown(context);
    MarketListModel? selectedAssetClass, selectedIndustry, selectedCurrency;
    selectedAssetClass = _notifier.selectedAssetClass;
    selectedIndustry = _notifier.selectedIndustry;
    selectedCurrency = _notifier.selectedCurrency;
    showDialog(
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return Center(
          child: Wrap(
            children: [
              Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(rSize*0.01),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: rSize*0.015),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      _notifier = Provider.of<SecuritySelectionController>(context);
                      return Wrap(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                                left: rSize * 0.02, right: rSize * 0.02, top: rSize * 0.03, bottom: MediaQuery.of(context).viewInsets.bottom + rSize * 0.03),
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: AppWidgets.title(context,
                                        FFLocalizations.of(context).getText(
                                          'filter' /* Filter */,
                                        ))),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: rSize*0.025,
                                      color: FlutterFlowTheme.of(context).customColor4,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: rSize * 0.02,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, rSize*0.010),
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
                                items: _notifier.assetClassList
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item.name!,
                                            style: FlutterFlowTheme.of(context).bodySmall.override(

                                                  fontSize: rSize*0.014,
                                              color: FlutterFlowTheme.of(context).customColor4,
                                              fontWeight: FontWeight.w500,
                                                ),
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
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, rSize*0.010),
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
                                items: _notifier.industryList
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item.name!,
                                            style: FlutterFlowTheme.of(context).bodySmall.override(

                                                  fontSize: rSize*0.014,
                                              color: FlutterFlowTheme.of(context).customColor4,
                                              fontWeight: FontWeight.w500,
                                                ),
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
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, rSize*0.010),
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
                                items: _notifier.currencyList
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item.name!,
                                            style: FlutterFlowTheme.of(context).bodySmall.override(

                                                  fontSize: rSize*0.014,
                                              color: FlutterFlowTheme.of(context).customColor4,
                                              fontWeight: FontWeight.w500,
                                                ),
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
                                          _notifier.selectedAssetClass = null;
                                          _notifier.selectedCurrency = null;
                                          _notifier.selectedIndustry = null;
                                          pageKey = 1;
                                          _notifier.refresh();
                                          Navigator.pop(context);
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
                                          _notifier.selectedAssetClass = selectedAssetClass;
                                          _notifier.selectedCurrency = selectedCurrency;
                                          _notifier.selectedIndustry = selectedIndustry;
                                          pageKey = 1;
                                          _notifier.refresh();
                                          Navigator.pop(context);
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
