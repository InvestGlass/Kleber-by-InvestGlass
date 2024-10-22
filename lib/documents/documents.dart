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
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
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

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  late DocumentsController _notifier, _notifier2;

  int _pageKey = 1;

  @override
  void initState() {
    _notifier2 = Provider.of<DocumentsController>(context, listen: false);
    _notifier2.pagingController.addPageRequestListener((pageKey) {
      if (mounted) {
        _fetchPageActivity(context);
      }
    });
    super.initState();
  }

  Future<void> _fetchPageActivity(
    BuildContext context,
  ) async {
    await ApiCalls.getDocumentList(context, _pageKey, _notifier.selectedAccount?.id?.toString() ?? '', _notifier.searchedFile, _notifier.selectedType,
            _notifier.range, _notifier.ancestryFolderList, _notifier.folderPathList, _notifier.orderDirection, _notifier.orderColumn)
        .then(
      (value) {
        List<Document> list = value?.folders ?? [];
        final isLastPage = list.length < 10;
        if (isLastPage) {
          _notifier2.pagingController.appendLastPage(list);
        } else {
          _pageKey++;
          _notifier2.pagingController.appendPage(list, _pageKey);
        }
      },
    );
  }

  @override
  void dispose() {
    _notifier.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                _pageKey = 1;
                _notifier.pagingController.refresh();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          centerTitle: true),
      body: Container(
        decoration: AppStyles.commonBg(context),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: rSize * 0.03, right: rSize * 0.03, top: rSize * 0.01, bottom: rSize * 0.01),
              child: Row(
                children: [
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
                  _pageKey = 1;
                  _notifier.pagingController.refresh();
                },
                child: PagedListView<int, Document>(
                  pagingController: _notifier.pagingController,
                  // shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: rSize * 0.015),
                  builderDelegate: PagedChildBuilderDelegate<Document>(noItemsFoundIndicatorBuilder: (context) {
                    return AppWidgets.emptyView(
                        FFLocalizations.of(context).getText(
                          'no_doc_found',
                        ),
                        context);
                  }, itemBuilder: (context, item, index) {
                    return GestureDetector(
                      onTap: () {
                        if (item.documentType == null) {
                          // _notifier.selectedFilterList.add(FilterModel(item.id.toString(), FilterTypes.ANCESTRY_FOLDER.name));
                          _notifier.openFolder(item);
                          _pageKey = 1;
                          _notifier.pagingController.refresh();
                        }else{
                          CommonFunctions.navigate(
                              context,
                              ViewDocument(
                                showSignButton: item.requestProposalApproval != null && item.requestProposalApproval!,
                                item: item,
                                index: index,
                              ));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground.withOpacity(item.freezed! ? 0.1 : 1),
                            boxShadow: AppStyles.shadow(),
                            borderRadius: BorderRadius.circular(rSize * 0.01)),
                        margin: EdgeInsetsDirectional.symmetric(vertical: rSize * 0.005),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: rSize * 0.01, horizontal: rSize * 0.015),
                          child: Row(children: [
                            getTypeName(item.documentType),
                            SizedBox(
                              width: rSize * 0.01,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (item.documentType != null?'${item.id!} ~ ':'')+item.folderName!,
                                  maxLines: 2,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        color: item.freezed! ? FlutterFlowTheme.of(context).secondaryText : FlutterFlowTheme.of(context).customColor4,
                                        fontSize: rSize * 0.016,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Text(
                                  DateFormat('yyyy-MM-dd HH:mm').format(item.updatedAt!),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(

                                        color: FlutterFlowTheme.of(context).secondaryText,
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
                                        color: FlutterFlowTheme.of(context).customColor2,
                                        size: rSize * 0.024,
                                      ),
                                      Text(
                                        '${FFLocalizations.of(context).getText(
                                          'ktrsz8sp' /* Accepted at */,
                                        )} ${DateFormat(
                                          'yyyy-MM-dd HH:mm',
                                          FFLocalizations.of(context).languageCode,
                                        ).format(item.approvedAt!)}',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(

                                              color: FlutterFlowTheme.of(context).customColor2,
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
                                        color: FlutterFlowTheme.of(context).customColor3,
                                        size: rSize * 0.024,
                                      ),
                                      Text(
                                        '${FFLocalizations.of(context).getText(
                                          '5tjloy3c' /* Rejected at */,
                                        )} ${DateFormat(
                                          'yyyy-MM-dd HH:mm',
                                          FFLocalizations.of(context).languageCode,
                                        ).format(item.disapprovedAt!)}',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(

                                              color: FlutterFlowTheme.of(context).customColor3,
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

  Expanded cell(String img, String label, void Function()? onTap, double size) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: rSize * 0.038,
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
          Provider.of<DocumentsController>(context, listen: false).getAccountList(context);
        });
        return Center(
          child: Wrap(
            children: [
              Material(
                color: Colors.transparent,
                child: Container(
                  decoration:
                      BoxDecoration(color: FlutterFlowTheme.of(context).primaryBackground, borderRadius: BorderRadius.circular(rSize * 0.010)),
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
                                bottom: MediaQuery.of(context).viewInsets.bottom + rSize * 0.03),
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
                                      size: rSize * 0.025,
                                      color: FlutterFlowTheme.of(context).customColor4,
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
                                            style: FlutterFlowTheme.of(context).bodySmall.override(

                                                  color: FlutterFlowTheme.of(context).customColor4,
                                                  fontSize: rSize * 0.014,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (p0) {
                                  selectedAccount = p0;
                                },
                                searchMatchFn: (item, searchValue) {
                                  return CommonFunctions.compare(searchValue, item.value.name.toString());
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
                                controller: TextEditingController(text: searchedFileName),
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    color:FlutterFlowTheme.of(context).customColor4
                                    ),
                                onChanged: (value) {
                                  searchedFileName = value;
                                },
                                decoration: AppStyles.inputDecoration(
                                  context,
                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  focusColor: FlutterFlowTheme.of(context).alternate,
                                  contentPadding: EdgeInsets.all(rSize * 0.015),
                                  labelStyle: FlutterFlowTheme.of(context).labelLarge.override(

                                      color:FlutterFlowTheme.of(context).customColor4
                                      ),
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
                                            style: FlutterFlowTheme.of(context).bodySmall.override(

                                                  color: FlutterFlowTheme.of(context).customColor4,
                                                  fontSize: rSize * 0.014,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),
                                        ))
                                    .toList(),
                                searchMatchFn: (item, searchValue) {
                                  return CommonFunctions.compare(searchValue, item.value.toString());
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
                                style: FlutterFlowTheme.of(context).bodyLarge.override(

                                    color:FlutterFlowTheme.of(context).customColor4
                                    ),
                                onTap: () {
                                  AppWidgets.openDatePicker(
                                    context,
                                    (value) {
                                      if (value is PickerDateRange) {
                                        final String startDate = CommonFunctions.getYYYYMMDD(value.startDate!);
                                        final String endDate = CommonFunctions.getYYYYMMDD(value.endDate!);
                                        range = '$startDate  TO  $endDate';
                                        Navigator.pop(context);
                                        setState(() {});
                                      }
                                    },
                                    () {
                                      _notifier.setDate('');
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  );
                                },
                                decoration: AppStyles.inputDecoration(
                                  context,
                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  focusColor: FlutterFlowTheme.of(context).alternate,
                                  contentPadding: EdgeInsets.all(rSize * 0.015),
                                  labelStyle: FlutterFlowTheme.of(context).labelLarge.override(

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
                                          _notifier.selectedType = null;
                                          _notifier.range = '';
                                          _pageKey = 1;
                                          _notifier.pagingController.refresh();
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
                                          _notifier.selectedAccount = selectedAccount;
                                          _notifier.searchedFile = searchedFileName;
                                          _notifier.selectedType = selectedType;
                                          _notifier.range = range;
                                          _pageKey = 1;
                                          _notifier.notify();
                                          /*_notifier.selectedFilterList.removeWhere((element) =>
                                              element.type == FilterTypes.ACCOUNT.name ||
                                              element.type == FilterTypes.FILE_NAME.name ||
                                              element.type == FilterTypes.DATE_RANGE.name ||
                                              element.type == FilterTypes.TYPE.name);
                                          _notifier.selectedFilterList.add(FilterModel(_notifier.selectedAccount, FilterTypes.ACCOUNT.name));
                                          _notifier.selectedFilterList.add(FilterModel(_notifier.searchedFile, FilterTypes.FILE_NAME.name));
                                          _notifier.selectedFilterList.add(FilterModel(_notifier.selectedType, FilterTypes.TYPE.name));
                                          _notifier.selectedFilterList.add(FilterModel(_notifier.range, FilterTypes.DATE_RANGE.name));*/
                                          _notifier.pagingController.refresh();
                                          Navigator.pop(context);
                                        },
                                        child: AppWidgets.btn(
                                            context,
                                            textColor: Colors.white,
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

  void openSortBottomSheet() {
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: rSize * 0.015),
                  decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(rSize * 0.020), topRight: Radius.circular(rSize * 0.020))),
                  child: Column(
                    children: [
                      AppWidgets.title(context,
                        FFLocalizations.of(context).getText(
                          'sort' /* sort */,
                        )),
                      Container(
                        height: 0.5,
                        margin: EdgeInsets.symmetric(vertical: rSize * 0.0075),
                        width: double.infinity,
                        color: AppColors.kHint,
                      ),
                      sortDialogElement(0, _notifier.sortList[0]),
                      sortDialogElement(1, _notifier.sortList[1]),
                      sortDialogElement(2, _notifier.sortList[2]),
                      sortDialogElement(3, _notifier.sortList[3]),
                      SizedBox(
                        height: rSize * 0.005,
                      )
                    ],
                  ),
                ),
              ],
            );
          },
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
                fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return FlutterFlowTheme.of(context).customColor4;
                  }
                  return FlutterFlowTheme.of(context).customColor4;
                }),
                value: value,
                groupValue: _notifier.sortRadioGroupValue,
                onChanged: (p0) {
                  _pageKey = 1;
                  _notifier.setSortRadioGroupValue(value, label);
                  _notifier.pagingController.refresh();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          SizedBox(
            width: isTablet ? rSize * 0.01 : 0,
          ),
          Expanded(
              child: AppWidgets.label(context,FFLocalizations.of(context).getText(
              label,
            )
                )),
        ],
      ),
    );
  }

  popupMenu(Document item, int index) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      // surfaceTintColor: Colors.white,
      position: PopupMenuPosition.under,
      color: FlutterFlowTheme.of(context).alternate,
      itemBuilder: (context) => [
        popupMenuItem(
            1,
        item.documentType == 'form'?FFLocalizations.of(context).getText(
          'fill_in',
        ):FFLocalizations.of(context).getText(
              'preview',
            ),
            Icon(
              item.documentType == 'form'?Icons.edit:Icons.remove_red_eye,
              size: rSize * 0.025,
              color: FlutterFlowTheme.of(context).customColor4,
            ), () {
          CommonFunctions.navigate(
              context,
              ViewDocument(
                showSignButton: item.requestProposalApproval != null && item.requestProposalApproval!,
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
        if (index==4 && item.requestProposalApproval! && item.documentStatus == null)
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
      child: Icon(
        Icons.more_vert,
        size: rSize * 0.025,
        color: FlutterFlowTheme.of(context).customColor4,
      ),
    );
  }

  void updateStatus(Document item, BuildContext context, String status, int index) {
    _notifier.updateDocumentStatus(item, status, index, context);
  }

  PopupMenuItem<int> popupMenuItem(int value, String label, Widget icon, void Function()? onTap) {
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
        .readBytes(Uri.parse('${EndPoints.documents}/${item.id}'), headers: {'Authorization': 'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'});
    await CommonFunctions.downloadAndSavePdf(bytes, item.originalFilename!, context).then(
      (value) {
        CommonFunctions.dismissLoader(context);
        if (value.isNotEmpty) {
          CommonFunctions.showToast('$value\nDownloaded successfully', success: true);
        }
      },
    );
  }

  getTypeName(String? documentType) {
    if (documentType == 'form') {
      return SvgPicture.asset(
        Theme.of(context).brightness == Brightness.dark ? 'assets/form-svgrepo-com-dark-theme.svg' : 'assets/form-svgrepo-com.svg',
        color: FlutterFlowTheme.of(context).customColor4,
        height: rSize * 0.035,
      );
    } else if (documentType == 'document' || documentType == 'package') {
      return FaIcon(
        FontAwesomeIcons.file,
        color: FlutterFlowTheme.of(context).customColor4,
        size: rSize * 0.030,
      );
    }

    return Icon(Icons.folder_outlined, color: FlutterFlowTheme.of(context).customColor4, size: rSize * 0.030);
  }
}
