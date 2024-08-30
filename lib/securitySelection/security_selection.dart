import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kleber_bank/market/video_player_widget.dart';
import 'package:kleber_bank/securitySelection/security_selection_controller.dart';
import 'package:kleber_bank/securitySelection/security_selection_list_item.dart';
import 'package:kleber_bank/utils/app_colors.dart';
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
      _fetchPageActivity();
    });
    super.initState();
  }

  Future<void> _fetchPageActivity() async {
    SecuritySelectionController provider = Provider.of<SecuritySelectionController>(context, listen: false);
    await provider.getList(pageKey);
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
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                    onTap: () => openFilterDialog(),
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(color: FlutterFlowTheme.of(context).primary, borderRadius: BorderRadius.circular(8)),
                      child: Icon(
                        Icons.filter_alt_outlined,
                        size: 25,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _notifier.searchController,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto',
                            letterSpacing: 0.0,
                          ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.transparent, width: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.transparent, width: 1)),
                          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                          filled: true,
                          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                fontFamily: 'Roboto',
                                letterSpacing: 0.0,
                              ),
                          hintText: FFLocalizations.of(context).getText(
                            'wzls4zjf' /* Type security name */,
                          ),
                          prefixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(vertical: 10)),
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce?.cancel();
                        _debounce = Timer(const Duration(milliseconds: 500), () async {
                          pageKey = 1;
                          _notifier.refresh();
                        });
                      },
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

  void openFilterDialog() {
    _notifier.getFilterDropDown();
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
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 15),
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
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          'filter' /* Filter */,
                                        ),
                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                      fontFamily: 'Roboto',
                                      color: FlutterFlowTheme.of(context).primary,
                                      fontSize: 26.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: AppColors.kTextFieldInput,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: rSize * 0.02,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    '1p01lh7n' /* Asset Class */,
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Roboto',
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                      ),
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
                                                  fontFamily: 'Roboto',
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
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
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    'zfneqwjq' /* Industry */,
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Roboto',
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                      ),
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
                                                  fontFamily: 'Roboto',
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
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
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    'nkjefkra' /* Currency */,
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Roboto',
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                      ),
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
                                                  fontFamily: 'Roboto',
                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
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
                                              'zw535eku' /* CLEAR */,
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
                                              'r8wu2qe3' /* Apply */,
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
