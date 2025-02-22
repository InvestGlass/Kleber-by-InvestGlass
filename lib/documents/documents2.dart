import 'dart:typed_data';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kleber_bank/documents/document_model.dart';
import 'package:kleber_bank/documents/documents_controller.dart';
import 'package:kleber_bank/documents/upload_document.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../main.dart';
import '../proposals/view_document.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/common_functions.dart';
import '../utils/end_points.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import '../utils/searchable_dropdown.dart';
import '../utils/shared_pref_utils.dart';
import 'accounts_model.dart';

class Documents2 extends StatefulWidget {
  const Documents2({super.key});

  @override
  State<Documents2> createState() => _Documents2State();
}

class _Documents2State extends State<Documents2> {
  late DocumentsController _notifier, _notifier2;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _notifier2 = Provider.of<DocumentsController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await _notifier.fetchDocuments(context);

        // Add scroll listener
        _scrollController.addListener(() {
          if (_scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent &&
              !_notifier2.isLoading &&
              _notifier2.hasMore) {
            _notifier2.fetchDocuments(context);
          }
        });
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _notifier.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    c = context;
    _notifier = Provider.of<DocumentsController>(context);
    return Scaffold(
      appBar: AppWidgets.appBar(
          context,
          _notifier.folderPathList.isNotEmpty
              ? _notifier.folderPathList.last.replaceAll('/', '')
              : FFLocalizations.of(context).getText(
                  '1vddbh59' /* Document */,
                ),
          leading: AppWidgets.backArrow(
            context,
            onTap: () {
              if (_notifier.ancestryFolderList.isNotEmpty) {
                _notifier.goToPreviousFolder();
                refreshList();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: rSize * 0.015,
                right: rSize * 0.015,
                top: rSize * 0.01,
                bottom: rSize * 0.01),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: AppWidgets.click(
                    onTap: () {
                      _notifier.changeMode();
                    },
                    child: Container(
                      height: btnHeight,
                      decoration: AppWidgets.gradiantDecoration(context),
                      child: Icon(
                        _notifier.isGridMode ? Icons.grid_view : Icons.list,
                        color: FlutterFlowTheme.of(context).info,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: rSize * 0.015,
                ),
                cell(
                    'filter.png',
                    '  ${FFLocalizations.of(context).getText(
                      'filter' /* Filter */,
                    )}', () {
                  openFilterDialog();
                }, rSize * 0.020),
                SizedBox(
                  width: rSize * 0.015,
                ),
                cell(
                    'sort.png',
                    '  ${FFLocalizations.of(context).getText(
                      'sort' /* sort */,
                    )}', () {
                  openSortBottomSheet();
                }, rSize * 0.020),
                SizedBox(
                  width: rSize * 0.015,
                ),
                cell(
                    'plus.png',
                    '  ${FFLocalizations.of(context).getText(
                      't2nv4kvj' /* upload */,
                    )}', () {
                  CommonFunctions.navigate(context, UploadDocument());
                }, rSize * 0.013),
              ],
            ),
          ),
          Flexible(
            child: RefreshIndicator(
              onRefresh: () async {
                refreshList();
              },
              child: _notifier.isGridMode ? buildGridView() : buildListView(),
            ),
          )
        ],
      ),
    );
  }

  Widget buildListView() {
    if (_notifier.isLoading && _notifier.pageKey == 1) {
      return skeleton();
    }
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: rSize * 0.015),
      itemCount: _notifier.documentList.length + (_notifier.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _notifier.documentList.length) {
          return Center(child: CircularProgressIndicator());
        }
        Document item = _notifier.documentList[index];
        return Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0 ||
                CommonFunctions.getYYYYMMDD(item.createdAt!) !=
                    CommonFunctions.getYYYYMMDD(
                        _notifier.documentList[index - 1].createdAt!)) ...{
              header(context, CommonFunctions.getYYYYMMDD(item.createdAt!))
            },
            AppWidgets.click(
              onTap: () {
                if (item.freezed!) {
                  return;
                }
                if (item.documentType == null) {
                  // _notifier.selectedFilterList.add(FilterModel(item.id.toString(), FilterTypes.ANCESTRY_FOLDER.name));
                  _notifier.documentList.clear();
                  _notifier.openFolder(item);
                  _notifier.pageKey = 1;
                  _notifier.fetchDocuments(context);
                } else {
                  CommonFunctions.navigate(
                      context,
                      ViewDocument(
                        showSignButton: item.requestProposalApproval != null &&
                            item.requestProposalApproval!,
                        item: item,
                        index: index,
                      ));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .secondaryBackground
                        .withOpacity(item.freezed! ? 0.1 : 1),
                    // boxShadow: AppStyles.shadow(),
                    borderRadius: BorderRadius.circular(rSize * 0.01)),
                margin:
                    EdgeInsetsDirectional.symmetric(vertical: rSize * 0.005),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: rSize * 0.01, horizontal: rSize * 0.015),
                  child: Row(children: [
                    getTypeName(item),
                    SizedBox(
                      width: rSize * 0.01,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (item.documentType != null ? '${item.id!} ~ ' : '') +
                              item.folderName!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                color: item.freezed!
                                    ? FlutterFlowTheme.of(context).secondaryText
                                    : FlutterFlowTheme.of(context).customColor4,
                                fontSize: rSize * 0.016,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd HH:mm')
                              .format(item.createdAt!),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: rSize * 0.014,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        if (item.documentStatus == 'Approved') ...{
                          Row(
                            children: [
                              Icon(
                                Icons.done_rounded,
                                color:
                                    FlutterFlowTheme.of(context).customColor2,
                                size: rSize * 0.024,
                              ),
                              Text(
                                '${FFLocalizations.of(context).getText(
                                  'ktrsz8sp' /* Accepted at */,
                                )} ${DateFormat(
                                  'yyyy-MM-dd HH:mm',
                                  FFLocalizations.of(context).languageCode,
                                ).format(item.approvedAt!)}',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      color: FlutterFlowTheme.of(context)
                                          .customColor2,
                                      fontSize: rSize * 0.016,
                                      letterSpacing: 0.0,
                                    ),
                              )
                            ],
                          )
                        },
                        if (item.documentStatus == 'Rejected') ...{
                          Row(
                            children: [
                              Icon(
                                Icons.close_rounded,
                                color:
                                    FlutterFlowTheme.of(context).customColor3,
                                size: rSize * 0.024,
                              ),
                              Text(
                                '${FFLocalizations.of(context).getText(
                                  '5tjloy3c' /* Rejected at */,
                                )} ${DateFormat(
                                  'yyyy-MM-dd HH:mm',
                                  FFLocalizations.of(context).languageCode,
                                ).format(item.disapprovedAt!)}',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      color: FlutterFlowTheme.of(context)
                                          .customColor3,
                                      fontSize: rSize * 0.016,
                                      letterSpacing: 0.0,
                                    ),
                              )
                            ],
                          )
                        },
                      ],
                    )),
                    if (item.documentType != null && !item.freezed!) ...{
                      popupMenu(item, index),
                    } else if (item.freezed!) ...{
                      Icon(
                        Icons.lock,
                        size: rSize * 0.025,
                        color: FlutterFlowTheme.of(context).customColor4,
                      )
                    },
                    /*const RotatedBox(
                                quarterTurns: 2,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColors.kTextFieldInput,
                                  size: 15,
                                ))*/
                  ]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Padding header(BuildContext context, String date) {
    return Padding(
      padding: EdgeInsets.only(top: rSize * 0.015, bottom: rSize * 0.005),
      child: AppWidgets.label(context, date),
    );
  }

  Widget buildGridView() {
    if (_notifier.pageKey == 1 && _notifier.isLoading) {
      return gridSkeleton();
    }
    return Column(
      children: [
        Flexible(
          child: GridView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.only(
              left: rSize * 0.015,
              right: rSize * 0.015,
              bottom: _notifier.isLoading ? rSize * 0.03 : rSize * 0.015,
            ),
            itemCount:
                _notifier.documentList.length + (_notifier.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _notifier.documentList.length) {
                return SizedBox();
                return Center(child: CircularProgressIndicator());
              }
              Document item = _notifier.documentList[index];
              return AppWidgets.click(
                onTap: () {
                  if (item.freezed!) {
                    return;
                  }
                  if (item.documentType == null) {
                    // _notifier.selectedFilterList.add(FilterModel(item.id.toString(), FilterTypes.ANCESTRY_FOLDER.name));
                    _notifier.documentList.clear();
                    _notifier.openFolder(item);
                    _notifier.pageKey = 1;
                    _notifier.fetchDocuments(context);
                  } else {
                    CommonFunctions.navigate(
                        context,
                        ViewDocument(
                          showSignButton:
                              item.requestProposalApproval != null &&
                                  item.requestProposalApproval!,
                          item: item,
                          index: index,
                        ));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .secondaryBackground
                          .withOpacity(item.freezed! ? 0.1 : 1),
                      // boxShadow: AppStyles.shadow(),
                      borderRadius: BorderRadius.circular(rSize * 0.01)),
                  margin:
                      EdgeInsetsDirectional.symmetric(vertical: rSize * 0.005),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: rSize * 0.01, horizontal: rSize * 0.015),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 2,
                              ),
                              getTypeName(item, multiplier: 2.6),
                              if (item.documentType != null &&
                                  !item.freezed!) ...{
                                popupMenu(item, index),
                              } else if (item.freezed!) ...{
                                Icon(
                                  Icons.lock,
                                  size: rSize * 0.025,
                                  color:
                                      FlutterFlowTheme.of(context).customColor4,
                                )
                              } else ...{
                                const SizedBox(
                                  width: 2,
                                )
                              }
                            ],
                          ),
                          SizedBox(
                            height: rSize * 0.005,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (item.documentType != null
                                        ? '${item.id!} ~ '
                                        : '') +
                                    item.folderName!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      color: item.freezed!
                                          ? FlutterFlowTheme.of(context)
                                              .secondaryText
                                          : FlutterFlowTheme.of(context)
                                              .customColor4,
                                      fontSize: rSize * 0.016,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              SizedBox(
                                height: rSize * 0.005,
                              ),
                              Center(
                                child: Text(
                                  DateFormat('yyyy-MM-dd HH:mm')
                                      .format(item.createdAt!),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: rSize * 0.014,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: rSize * 0.005,
                              ),
                              if (item.documentStatus == 'Approved') ...{
                                Row(
                                  children: [
                                    Icon(
                                      Icons.done_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .customColor2,
                                      size: rSize * 0.024,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${FFLocalizations.of(context).getText(
                                          'ktrsz8sp' /* Accepted at */,
                                        )} ${DateFormat(
                                          'yyyy-MM-dd HH:mm',
                                          FFLocalizations.of(context)
                                              .languageCode,
                                        ).format(item.approvedAt!)}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .customColor2,
                                              fontSize: rSize * 0.016,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    )
                                  ],
                                )
                              },
                              if (item.documentStatus == 'Rejected') ...{
                                Row(
                                  children: [
                                    Icon(
                                      Icons.close_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .customColor3,
                                      size: rSize * 0.024,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${FFLocalizations.of(context).getText(
                                          '5tjloy3c' /* Rejected at */,
                                        )} ${DateFormat(
                                          'yyyy-MM-dd HH:mm',
                                          FFLocalizations.of(context)
                                              .languageCode,
                                        ).format(item.disapprovedAt!)}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .customColor3,
                                              fontSize: rSize * 0.016,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    )
                                  ],
                                )
                              },
                            ],
                          ),
                        ]),
                  ),
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: rSize * 0.01,
                childAspectRatio: 0.9),
          ),
        ),
        if (_notifier.isLoading) ...{Center(child: CircularProgressIndicator())}
      ],
    );
  }

  Expanded cell(String img, String label, void Function()? onTap, double size) {
    return Expanded(
        flex: 2,
        child: AppWidgets.click(
          onTap: onTap,
          child: Container(
            height: btnHeight,
            decoration: AppWidgets.gradiantDecoration(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/$img',
                  color: Colors.white,
                  height: size,
                  width: size,
                ),
                Text(
                  label,
                  style: FlutterFlowTheme.of(context).displaySmall.override(
                        color: Colors.white,
                        fontSize: rSize * 0.014,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ));
  }

  void openFilterDialog() {
    String searchedFileName = _notifier.searchedFile;
    String? selectedType = _notifier.selectedType;
    AccountsModel? selectedAccount = _notifier.selectedAccount;
    String range = _notifier.range;

    showDialog(
      useRootNavigator: true,
      context: context,
      builder: (context) {
        _notifier = Provider.of<DocumentsController>(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<DocumentsController>(context, listen: false)
              .getAccountList(context);
        });
        return Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(rSize * 0.010)),
                  margin: EdgeInsets.symmetric(horizontal: rSize * 0.015),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Wrap(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                                left: rSize * 0.02,
                                right: rSize * 0.02,
                                top: rSize * 0.03,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        rSize * 0.03),
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: AppWidgets.title(
                                          context,
                                          FFLocalizations.of(context).getText(
                                            'filter' /* Filter */,
                                          ))),
                                  AppWidgets.click(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: rSize * 0.025,
                                      color: FlutterFlowTheme.of(context)
                                          .customColor4,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: rSize * 0.02,
                              ),
                              AppWidgets.label(
                                  context,
                                  FFLocalizations.of(context).getText(
                                    'xccshnlg' /* Accounts */,
                                  )),
                              SizedBox(
                                height: rSize * 0.005,
                              ),
                              SearchableDropdown(
                                searchHint: FFLocalizations.of(context).getText(
                                  'ip67vees' /* Search for an account */,
                                ),
                                selectedValue: selectedAccount,
                                items: _notifier.accountList
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item.name!,
                                            style: AppStyles.inputTextStyle(
                                                context),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (p0) {
                                  selectedAccount = p0;
                                },
                                searchMatchFn: (item, searchValue) {
                                  return CommonFunctions.compare(
                                      searchValue, item.value.name.toString());
                                },
                              ),
                              SizedBox(
                                height: rSize * 0.02,
                              ),
                              AppWidgets.label(
                                  context,
                                  FFLocalizations.of(context).getText(
                                    'bzc91fwt' /* File Name */,
                                  )),
                              SizedBox(
                                height: rSize * 0.005,
                              ),
                              TextFormField(
                                controller: TextEditingController(
                                    text: searchedFileName),
                                style: AppStyles.inputTextStyle(context),
                                onChanged: (value) {
                                  searchedFileName = value;
                                },
                                decoration: AppStyles.inputDecoration(
                                  context,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  focusColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  contentPadding: EdgeInsets.all(rSize * 0.015),
                                ),
                              ),
                              SizedBox(
                                height: rSize * 0.015,
                              ),
                              AppWidgets.label(
                                  context,
                                  FFLocalizations.of(context).getText(
                                    '4n2ah71g' /* Types */,
                                  )),
                              SizedBox(
                                height: rSize * 0.01,
                              ),
                              SearchableDropdown(
                                searchHint: '',
                                selectedValue: selectedType,
                                onChanged: (p0) {
                                  selectedType = p0;
                                },
                                isSearchable: false,
                                items: _notifier
                                    .typesList(context)
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: AppStyles.inputTextStyle(
                                                context),
                                          ),
                                        ))
                                    .toList(),
                                searchMatchFn: (item, searchValue) {
                                  return CommonFunctions.compare(
                                      searchValue, item.value.toString());
                                },
                              ),
                              SizedBox(
                                height: rSize * 0.02,
                              ),
                              AppWidgets.label(
                                  context,
                                  FFLocalizations.of(context).getText(
                                    'date_in_range' /* date_in_range */,
                                  )),
                              SizedBox(
                                height: rSize * 0.01,
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: TextEditingController(text: range),
                                style: AppStyles.inputTextStyle(context),
                                onTap: () {
                                  AppWidgets.openDatePicker(
                                    context,
                                    (value) {
                                      if (value is DateTimeRange &&
                                          value.start != null &&
                                          value.end != null) {
                                        final String startDate =
                                            CommonFunctions.getYYYYMMDD(
                                                value.start!);
                                        final String endDate =
                                            CommonFunctions.getYYYYMMDD(
                                                value.end!);
                                        range = '$startDate  TO  $endDate';
                                        // Navigator.pop(context);
                                        setState(() {});
                                      }
                                    },
                                    onCancel: () {
                                      _notifier.setDate('');
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  );
                                },
                                decoration: AppStyles.inputDecoration(
                                  context,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  focusColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  contentPadding: EdgeInsets.all(rSize * 0.015),
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .override(
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: rSize * 0.02,
                              ),
                              SizedBox(
                                height: rSize * 0.03,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                        onTap: () async {
                                          _notifier.selectedAccount = null;
                                          _notifier.searchedFile = '';
                                          _notifier.selectedType = 'All';
                                          _notifier.range = '';
                                          _notifier.pageKey = 1;
                                          _notifier.selectedFilterList = [
                                            FilterModel(selectedType, 'type')
                                          ];
                                          refreshList();
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
                                          _notifier.selectedAccount =
                                              selectedAccount;
                                          _notifier.searchedFile =
                                              searchedFileName;
                                          _notifier.selectedType = selectedType;
                                          _notifier.range = range;
                                          _notifier.pageKey = 1;
                                          _notifier.notify();
                                          _notifier.selectedFilterList.clear();
                                          _notifier.selectedFilterList.add(
                                              FilterModel(
                                                  selectedType, 'type'));
                                          if (searchedFileName.isNotEmpty) {
                                            _notifier.selectedFilterList.add(
                                                FilterModel(searchedFileName,
                                                    'searched_name'));
                                          }
                                          if (range.isNotEmpty) {
                                            _notifier.selectedFilterList.add(
                                                FilterModel(range, 'range'));
                                          }
                                          refreshList();
                                          Navigator.pop(context);
                                        },
                                        child: AppWidgets.btn(
                                            context,
                                            textColor: Colors.white,
                                            FFLocalizations.of(context).getText(
                                              'lmndaaco' /* Apply */,
                                            ),
                                            bgColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary)),
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

  void openSortBottomSheet() {
    _notifier.tempSortRadioGroupValue = _notifier.sortRadioGroupValue;
    showDialog(
      useRootNavigator: true,
      context: context,
      builder: (context) {
        _notifier = Provider.of<DocumentsController>(context);
        return Center(
          child: Wrap(
            children: [
              Material(
                color: Colors.transparent,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(rSize * 0.015),
                          padding: EdgeInsets.only(
                              left: rSize * 0.02,
                              right: rSize * 0.02,
                              top: rSize * 0.03,
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  rSize * 0.03),
                          decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius:
                                  BorderRadius.circular(rSize * 0.015)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: AppWidgets.title(
                                          context,
                                          FFLocalizations.of(context).getText(
                                            'sort' /* sort */,
                                          ))),
                                  AppWidgets.click(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: rSize * 0.025,
                                      color: FlutterFlowTheme.of(context)
                                          .customColor4,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: rSize * 0.01,
                              ),
                              sortDialogElement(0, _notifier.sortList[0]),
                              sortDialogElement(1, _notifier.sortList[1]),
                              sortDialogElement(2, _notifier.sortList[2]),
                              sortDialogElement(3, _notifier.sortList[3]),
                              sortDialogElement(4, _notifier.sortList[4]),
                              sortDialogElement(5, _notifier.sortList[5]),
                              SizedBox(
                                height: rSize * 0.005,
                              ),
                              AppWidgets.click(
                                onTap: () {
                                  _notifier.pageKey = 1;
                                  _notifier.setSortRadioGroupValue(
                                      _notifier.tempSortRadioGroupValue,
                                      _notifier.sortList[
                                          _notifier.tempSortRadioGroupValue]);
                                  refreshList();
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppWidgets.btn(
                                        context,
                                        horizontalPadding: rSize * 0.06,
                                        FFLocalizations.of(context).getText(
                                          'lmndaaco' /* Apply */,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget sortDialogElement(int value, String label) {
    return SizedBox(
      height: rSize * 0.050,
      child: Row(
        children: [
          SizedBox(
            width: isTablet ? rSize * 0.015 : 0,
          ),
          Theme(
            data: ThemeData(
              unselectedWidgetColor: FlutterFlowTheme.of(context).customColor4,
            ),
            child: Transform.scale(
              scale: rSize * 0.0012,
              child: Radio(
                activeColor: FlutterFlowTheme.of(context).primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                fillColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return FlutterFlowTheme.of(context).customColor4;
                  }
                  return FlutterFlowTheme.of(context).customColor4;
                }),
                value: value,
                groupValue: _notifier.tempSortRadioGroupValue,
                onChanged: (p0) {
                  _notifier.setTempSortRadioGroupValue(value);
                },
              ),
            ),
          ),
          SizedBox(
            width: isTablet ? rSize * 0.01 : 0,
          ),
          Expanded(
              child: AppWidgets.label(
                  context,
                  FFLocalizations.of(context).getText(
                    label,
                  ))),
        ],
      ),
    );
  }

  popupMenu(Document item, int index) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      // surfaceTintColor: Colors.white,
      position: PopupMenuPosition.under,
      constraints: BoxConstraints(maxWidth: rSize * 0.14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rSize * 0.01),
      ),
      clipBehavior: Clip.hardEdge,
      itemBuilder: (context) => [
        popupMenuItem(
            1,
            item.documentType == 'form'
                ? FFLocalizations.of(context).getText(
                    'fill_in',
                  )
                : FFLocalizations.of(context).getText(
                    'preview',
                  ),
            Icon(
              item.documentType == 'form' ? Icons.edit : Icons.remove_red_eye,
              size: rSize * 0.025,
              color: FlutterFlowTheme.of(context).customColor4,
            ), () {
          CommonFunctions.navigate(
              context,
              ViewDocument(
                showSignButton: item.requestProposalApproval != null &&
                    item.requestProposalApproval!,
                item: item,
                index: index,
              ));
        }),
        if (item.documentType == 'document')
          popupMenuItem(
              2,
              FFLocalizations.of(context).getText(
                'download',
              ),
              Icon(
                Icons.cloud_download_outlined,
                size: rSize * 0.025,
                color: FlutterFlowTheme.of(context).customColor4,
              ), () {
            downloadDoc(item);
          }),
        if (index == 4 &&
            item.requestProposalApproval! &&
            item.documentStatus == null)
          popupMenuItem(
              3,
              FFLocalizations.of(context).getText(
                'signature',
              ),
              SvgPicture.asset(
                'assets/signature-icon.svg',
                width: rSize * 0.025,
                height: rSize * 0.025,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  FlutterFlowTheme.of(context).customColor4,
                  BlendMode.srcIn,
                ),
              ), () {
            AppWidgets.showSignDialog(context, onAccept: () {
              updateStatus(item, context, 'approve', index);
            }, onReject: () {
              updateStatus(item, context, 'reject', index);
            });
          }),
      ],
      offset: const Offset(0, 0),
      elevation: 2,
      tooltip: '',
      child: Icon(
        Icons.more_vert,
        size: rSize * 0.025,
        color: FlutterFlowTheme.of(context).customColor4,
      ),
    );
  }

  void updateStatus(
      Document item, BuildContext context, String status, int index) {
    _notifier.updateDocumentStatus(item, status, index, context);
  }

  PopupMenuItem<int> popupMenuItem(
      int value, String label, Widget icon, void Function()? onTap) {
    return PopupMenuItem(
      value: value,
      onTap: onTap,
      height: rSize * 0.04,
      padding: EdgeInsets.all(rSize * 0.01),
      // row has two child icon and text.
      child: Row(
        children: [
          icon,
          SizedBox(
            // sized box with width 10
            width: rSize * 0.010,
          ),
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: FlutterFlowTheme.of(context).customColor4,
                  fontSize: rSize * 0.016,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
          )
        ],
      ),
    );
  }

  Future<void> downloadDoc(Document item) async {
    CommonFunctions.showLoader(context);
    Uint8List bytes = await http
        .readBytes(Uri.parse('${EndPoints.documents}/${item.id}'), headers: {
      'Authorization': 'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'
    });
    await CommonFunctions.downloadAndSavePdf(
            bytes, item.originalFilename!, context)
        .then(
      (value) {
        CommonFunctions.dismissLoader(context);
        if (value.isNotEmpty) {
          CommonFunctions.showToast('$value\nDownloaded successfully',
              success: true);
        }
      },
    );
  }

  getTypeName(Document? item, {double multiplier = 1}) {
    if (item?.documentType == 'form') {
      return SvgPicture.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'assets/form-svgrepo-com-dark-theme.svg'
            : 'assets/form-svgrepo-com.svg',
        color: FlutterFlowTheme.of(context).customColor4,
        height: rSize * 0.035 * multiplier,
      );
    } else if (item?.documentType == 'document' ||
        item?.documentType == 'package') {
      return Container(
        alignment: Alignment.center,
        height: rSize * 0.035 * multiplier,
        width: rSize * 0.035 * multiplier,
        child: item!.bytes == null
            ? FutureBuilder<Uint8List>(
                future: getBytes(item!.id!),
                builder: (context, snapshot) {
                  item.bytes = snapshot.data;
                  return getPreviewer(item, multiplier: multiplier);
                })
            : getPreviewer(item, multiplier: multiplier),
      );
    }

    return Icon(Icons.folder_outlined,
        color: FlutterFlowTheme.of(context).customColor4,
        size: rSize * 0.030 * multiplier);
  }

  Widget getPreviewer(Document? item, {double multiplier = 1}) {
    if (item!.bytes != null) {
      if (item.originalFilename!.split('.').last.toLowerCase() == 'pdf' ||
          item.originalFilename!.split('.').last.toLowerCase() == 'txt') {
        return SfPdfViewer.memory(
          item!.bytes!,
          canShowScrollHead: false,
        );
      } else {
        return Image.memory(
          item!.bytes!,
          errorBuilder: (context, error, stackTrace) {
            return FaIcon(
              FontAwesomeIcons.file,
              color: FlutterFlowTheme.of(context).customColor4,
              size: rSize * 0.030 * multiplier,
            );
          },
        );
      }
    } else {
      return FaIcon(
        FontAwesomeIcons.file,
        color: FlutterFlowTheme.of(context).customColor4,
        size: rSize * 0.030 * multiplier,
      );
    }
  }

  Future<Uint8List> getBytes(int id) async {
    Uint8List bytes = await http
        .readBytes(Uri.parse('${EndPoints.documents}/$id'), headers: {
      'Authorization': 'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'
    });
    return bytes;
  }

  void refreshList() {
    _notifier.pageKey = 1;
    _notifier.hasMore = true;
    _notifier.documentList.clear();
    _notifier.fetchDocuments(context);
  }

  Widget skeleton() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            header(context, 'yyyy-MM-dd'),
            container(),
            container(),
            container(),
            container(),
            header(context, 'yyyy-MM-dd'),
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
      decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          // boxShadow: AppStyles.shadow(),
          borderRadius: BorderRadius.circular(rSize * 0.01)),
      margin: EdgeInsetsDirectional.symmetric(
          vertical: rSize * 0.005, horizontal: rSize * 0.015),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: rSize * 0.01, horizontal: rSize * 0.015),
        child: Row(children: [
          Icon(Icons.folder_outlined,
              color: FlutterFlowTheme.of(context).customColor4,
              size: rSize * 0.030),
          SizedBox(
            width: rSize * 0.01,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '434343 ~ asdc fvfderder deedd rfrfr fgf dg tfh gthgthgght',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: FlutterFlowTheme.of(context).customColor4,
                      fontSize: rSize * 0.016,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                'yyyy-MM-dd HH:mm',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: rSize * 0.014,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                '  ${FFLocalizations.of(context).getText(
                  'ktrsz8sp' /* Accepted at */,
                )} yyyy-MM-dd HH:mm',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: FlutterFlowTheme.of(context).customColor2,
                      fontSize: rSize * 0.016,
                      letterSpacing: 0.0,
                    ),
              )
            ],
          )),
          Icon(
            Icons.lock,
            size: rSize * 0.025,
            color: FlutterFlowTheme.of(context).customColor4,
          ),
        ]),
      ),
    );
  }

  Widget gridContainer() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            // boxShadow: AppStyles.shadow(),
            borderRadius: BorderRadius.circular(rSize * 0.01)),
        margin: EdgeInsetsDirectional.only(
            top: rSize * 0.015, start: rSize * 0.015),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: rSize * 0.01, horizontal: rSize * 0.015),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              color: FlutterFlowTheme.of(context).customColor4,
              width: double.infinity,
              height: rSize * 0.1,
            ),
            SizedBox(
              height: rSize * 0.005,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '121212 ~ Ptoposal afewfewf',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).customColor4,
                        fontSize: rSize * 0.016,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(
                  height: rSize * 0.005,
                ),
                Text(
                  'yyyy-MM-dd HH:mm',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: rSize * 0.014,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(
                  height: rSize * 0.005,
                ),
                Text(
                  '${FFLocalizations.of(context).getText(
                    'ktrsz8sp' /* Accepted at */,
                  )}  yyyy-MM-dd HH:mm',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).customColor2,
                        fontSize: rSize * 0.016,
                        letterSpacing: 0.0,
                      ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget gridSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                gridContainer(),
                gridContainer(),
                SizedBox(width: rSize * 0.015),
              ],
            ),
            Row(
              children: [
                gridContainer(),
                gridContainer(),
                SizedBox(width: rSize * 0.015),
              ],
            ),
            Row(
              children: [
                gridContainer(),
                gridContainer(),
                SizedBox(width: rSize * 0.015),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
