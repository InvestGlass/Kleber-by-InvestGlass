import 'dart:typed_data';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
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
  late DocumentsController _notifier;

  final PagingController<int, Document> _pagingController = PagingController(firstPageKey: 1);
  int _pageKey = 1;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPageActivity();
    });
    super.initState();
  }

  Future<void> _fetchPageActivity() async {
    await ApiCalls.getDocumentList(_pageKey, _notifier.selectedAccount, _notifier.searchedFile, _notifier.selectedType, _notifier.range,
            _notifier.ancestryFolderList, _notifier.folderPathList,_notifier.orderDirection,_notifier.orderColumn)
        .then(
      (value) {
        List<Document> list = value?.folders ?? [];
        final isLastPage = list.length < 10;
        if (isLastPage) {
          _pagingController.appendLastPage(list);
        } else {
          _pageKey++;
          _pagingController.appendPage(list, _pageKey);
        }
      },
    );
  }

  @override
  void dispose() {
    _notifier.folderPathList.clear();
    _notifier.ancestryFolderList.clear();
    _notifier.selectedAccount=null;
    _notifier.searchedFile='';
    _notifier.selectedType='';
    _notifier.range='';
    _notifier.orderColumn='created_at';
    _notifier.orderDirection = 'desc';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<DocumentsController>(context);
    return Scaffold(
      appBar: AppWidgets.appBar(
          context,
          _notifier.folderPathList.isNotEmpty?_notifier.folderPathList.last.replaceAll('/', ''):FFLocalizations.of(context).getText(
            'dlgf18jl' /* Document */,
          ),
          leading: GestureDetector(
              onTap: () {
                if(_notifier.ancestryFolderList.isNotEmpty){
                  _notifier.goToPreviousFolder();
                  _pageKey=1;
                  _pagingController.refresh();
                }else{
                  Navigator.pop(context);
                }
              },
              child: Icon(
                Icons.arrow_back,
                color: FlutterFlowTheme.of(context).primary,
              )),
          centerTitle: true),
      floatingActionButton: FloatingActionButton(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        onPressed: () {
          CommonFunctions.navigate(context, UploadDocument());
        },
        child: Icon(
          Icons.add,
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
      ),
      body: Container(
        decoration: AppStyles.commonBg(context),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: rSize * 0.05, vertical: rSize * 0.01),
              child: Row(
                children: [
                  cell(
                    'filter.png',
                    '  ${FFLocalizations.of(context).getText(
                      'filter' /* Filter */,
                    )}',
                    () {
                      openFilterDialog();
                    },
                  ),
                  SizedBox(
                    width: rSize * 0.03,
                  ),
                  cell(
                    'sort.png',
                    '  ${FFLocalizations.of(context).getText(
                      'sort' /* sort */,
                    )}',
                    () {
                      openSortBottomSheet();
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              child: Card(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _pageKey = 1;
                    _pagingController.refresh();
                  },
                  child: PagedListView<int, Document>(
                    pagingController: _pagingController,
                    // shrinkWrap: true,
                    builderDelegate: PagedChildBuilderDelegate<Document>(noItemsFoundIndicatorBuilder: (context) {
                      return const SizedBox();
                    }, itemBuilder: (context, item, index) {
                      return GestureDetector(
                        onTap: () {
                          if (item.documentType == null) {
                            // _notifier.selectedFilterList.add(FilterModel(item.id.toString(), FilterTypes.ANCESTRY_FOLDER.name));
                            _notifier.openFolder(item);
                            _pageKey = 1;
                            _pagingController.refresh();
                          }
                        },
                        child: Card(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
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
                                    item.folderName ?? '',
                                    maxLines: 2,
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Roboto',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Text(
                                    DateFormat('yyyy-MM-dd HH:mm').format(item.updatedAt!),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Roboto',
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  if (item.documentStatus == 'Accepted') ...{
                                    Text(
                                      'Accepted at ${DateFormat(
                                        'yyyy-MM-dd HH:mm',
                                        FFLocalizations.of(context).languageCode,
                                      ).format(item.disapprovedAt!)}',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Roboto',
                                            color: FlutterFlowTheme.of(context).customColor2,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                          ),
                                    )
                                  },
                                  if (item.documentStatus == 'Rejected') ...{
                                    Text(
                                      'Rejected at ${DateFormat(
                                        'yyyy-MM-dd HH:mm',
                                        FFLocalizations.of(context).languageCode,
                                      ).format(item.disapprovedAt!)}',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Roboto',
                                            color: FlutterFlowTheme.of(context).customColor3,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                          ),
                                    )
                                  },
                                ],
                              )),
                              if (item.documentType != null) ...{
                                popupMenu(item),
                              }
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Expanded cell(String img, String label, void Function()? onTap) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(rSize * 0.01),
        decoration: BoxDecoration(color: FlutterFlowTheme.of(context).primary, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/$img',
              color: FlutterFlowTheme.of(context).secondaryBackground,
              scale: 25,
            ),
            Text(
              label,
              style: FlutterFlowTheme.of(context).displaySmall.override(
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    fontSize: 14.0,
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
    String _searchedFileName = _notifier.searchedFile;
    String? _selectedType = _notifier.selectedType;
    String? _selectedAccount = _notifier.selectedAccount;
    String _selecteStartDate = _notifier.startDate;
    String _selecteEndDate = _notifier.endDate;
    String _range = _notifier.range;

    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      context: context,
      builder: (context) {
        _notifier=Provider.of<DocumentsController>(context);
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          Provider.of<DocumentsController>(context, listen: false).getAccountList(context);
        });
        return StatefulBuilder(
          builder: (context, setState) {
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
                          'Filter',
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
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: rSize * 0.02,
                    ),
                    Text(
                      FFLocalizations.of(context).getText(
                        'xccshnlg' /* Accounts */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(
                      height: rSize * 0.005,
                    ),
                    SearchableDropdown(
                      searchHint: FFLocalizations.of(context).getText(
                        'ip67vees' /* Search for an account */,
                      ),
                      selectedValue: _selectedAccount,
                      list: _notifier.accountList,
                      onChanged: (p0) {
                        _selectedAccount = p0;
                      },
                    ),
                    SizedBox(
                      height: rSize * 0.02,
                    ),
                    Text(
                      FFLocalizations.of(context).getText(
                        'bzc91fwt' /* File Name */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(
                      height: rSize * 0.005,
                    ),
                    TextFormField(
                      controller: TextEditingController(text: _searchedFileName),
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Roboto',
                            letterSpacing: 0.0,
                          ),
                      onChanged: (value) {
                        _searchedFileName = value;
                      },
                      decoration: AppStyles.inputDecoration(
                        context,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding: EdgeInsets.all(15),
                        labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                              fontFamily: 'Roboto',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: rSize * 0.015,
                    ),
                    Text(
                      FFLocalizations.of(context).getText(
                        '4n2ah71g' /* Types */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(
                      height: rSize * 0.01,
                    ),
                    SearchableDropdown(
                      searchHint: '',
                      selectedValue: _selectedType,
                      list: _notifier.typesList,
                      onChanged: (p0) {
                        _selectedType = p0;
                      },
                      isSearchable: false,
                    ),
                    SizedBox(
                      height: rSize * 0.02,
                    ),
                    Text(
                      FFLocalizations.of(context).getText(
                        'date_in_range' /* date_in_range */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(
                      height: rSize * 0.005,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: TextEditingController(text: _range),
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Roboto',
                            letterSpacing: 0.0,
                          ),
                      onTap: () {
                        AppWidgets.openDatePicker(
                          context,
                          (value) {
                            if (value is PickerDateRange) {
                                final String startDate = CommonFunctions.getYYYYMMDD(value.startDate!);
                                final String endDate = CommonFunctions.getYYYYMMDD(value.endDate!);
                              _range = '$startDate  TO  $endDate';
                              if (_range.isNotEmpty) {
                                _selecteStartDate = _range.split('  TO  ')[0];
                                _selecteEndDate = _range.split('  TO  ')[1];
                              } else {
                                _range = '';
                                _selecteStartDate = '';
                                _selecteEndDate = '';
                              }
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
                        contentPadding: EdgeInsets.all(15),
                        labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                              fontFamily: 'Roboto',
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
                                _pagingController.refresh();
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
                                _notifier.selectedAccount = _selectedAccount;
                                _notifier.searchedFile = _searchedFileName;
                                _notifier.selectedType = _selectedType;
                                _notifier.range = _range;
                                _pageKey = 1;
                                /*_notifier.selectedFilterList.removeWhere((element) =>
                                    element.type == FilterTypes.ACCOUNT.name ||
                                    element.type == FilterTypes.FILE_NAME.name ||
                                    element.type == FilterTypes.DATE_RANGE.name ||
                                    element.type == FilterTypes.TYPE.name);
                                _notifier.selectedFilterList.add(FilterModel(_notifier.selectedAccount, FilterTypes.ACCOUNT.name));
                                _notifier.selectedFilterList.add(FilterModel(_notifier.searchedFile, FilterTypes.FILE_NAME.name));
                                _notifier.selectedFilterList.add(FilterModel(_notifier.selectedType, FilterTypes.TYPE.name));
                                _notifier.selectedFilterList.add(FilterModel(_notifier.range, FilterTypes.DATE_RANGE.name));*/
                                _pagingController.refresh();
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
        );
      },
    );
  }

  void openSortBottomSheet() {
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Wrap(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: rSize * 0.015),
                  decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          'sort' /* sort */,
                        ),
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                              fontFamily: 'Roboto',
                              color: FlutterFlowTheme.of(context).primary,
                              fontSize: 26.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
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

  Row sortDialogElement(int value, String label) {
    return Row(
      children: [
        Theme(
          data: ThemeData(unselectedWidgetColor: FlutterFlowTheme.of(context).primaryText),
          child: Radio(
            activeColor: FlutterFlowTheme.of(context).primary,
            value: value,
            groupValue: _notifier.sortRadioGroupValue,
            onChanged: (p0) {
              _pageKey = 1;
              _notifier.setSortRadioGroupValue(value, label);
              _pagingController.refresh();
              Navigator.pop(context);
            },
          ),
        ),
        Expanded(
            child: Text(
          FFLocalizations.of(context).getText(
            label,
          ),
          style: FlutterFlowTheme.of(context).displaySmall.override(
                fontFamily: 'Roboto',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
        )),
      ],
    );
  }

  popupMenu(Document item) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      // surfaceTintColor: Colors.white,
      position: PopupMenuPosition.under,
      color: FlutterFlowTheme.of(context).secondaryText,
      itemBuilder: (context) => [
        popupMenuItem(
            1,
            FFLocalizations.of(context).getText(
              'preview',
            ),
            Icon(
              Icons.remove_red_eye,
              color: FlutterFlowTheme.of(context).primary,
            ), () {
          CommonFunctions.navigate(context, ViewDocument(item.id.toString(), false));
        }),
        if (item.documentType == 'document')
          popupMenuItem(
              2,
              FFLocalizations.of(context).getText(
                'download',
              ),
              Icon(
                Icons.cloud_download_outlined,
                color: FlutterFlowTheme.of(context).primary,
              ), () {
            downloadDoc(item);
          }),
        if (item.documentType == 'document' && item.documentStatus == null)
          popupMenuItem(
              3,
              FFLocalizations.of(context).getText(
                'signature',
              ),
              SvgPicture.asset(
                'assets/signature-icon.svg',
                width: 25,
                height: 25,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  FlutterFlowTheme.of(context).primary,
                  BlendMode.srcIn,
                ),
              ), () {
            AppWidgets.showAlert(
                context,
                FFLocalizations.of(context).getText(
                  'apuqhrbh' /* please confirm */,
                ),
                FFLocalizations.of(context).getText(
                  'c4m8fcp2' /* reject */,
                ),
                FFLocalizations.of(context).getText(
                  'e1wyk8ql' /* accept */,
                ), () {
              updateStatus(item, context, 'rejected');
            }, () {
              updateStatus(item, context, 'accepted');
            }, btn1BgColor: FlutterFlowTheme.of(context).customColor3, btn2BgColor: FlutterFlowTheme.of(context).customColor2);
          }),
      ],
      offset: const Offset(0, 0),
      elevation: 2,
      child: Icon(
        Icons.more_vert,
        color: FlutterFlowTheme.of(context).primary,
      ),
    );
  }

  void updateStatus(Document item, BuildContext context, String status) {
    _notifier.updateDocumentStatus(item, status, _pagingController, _pagingController.itemList!.indexOf(item), context);
  }

  PopupMenuItem<int> popupMenuItem(int value, String label, Widget icon, void Function()? onTap) {
    return PopupMenuItem(
      value: value, onTap: onTap,
      // row has two child icon and text.
      child: Row(
        children: [
          icon,
          SizedBox(
            // sized box with width 10
            width: 10,
          ),
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 16,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
          )
        ],
      ),
    );
  }

  Future<void> downloadDoc(Document item) async {
    try {
      CommonFunctions.showLoader(context);
      Uint8List bytes = await http.readBytes(Uri.parse('${EndPoints.documents}/${item.id}'),
          headers: {'Authorization': 'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'});
      await CommonFunctions.downloadAndSavePdf(bytes, item.folderName!).then(
        (value) {
          if (value.isNotEmpty) {
            CommonFunctions.showToast('$value\nDownloaded successfully', success: true);
          }
        },
      );
    } catch (e) {
      print(e);
    } finally {
      CommonFunctions.dismissLoader(context);
    }
  }

  getTypeName(String? documentType) {
    if (documentType == 'form') {
      return SvgPicture.asset(
          Theme.of(context).brightness == Brightness.dark ? 'assets/form-svgrepo-com-dark-theme.svg' : 'assets/form-svgrepo-com.svg');
    } else if (documentType == 'document') {
      return FaIcon(
        FontAwesomeIcons.file,
        color: FlutterFlowTheme.of(context).primary,
        size: 30.0,
      );
    }

    return Icon(Icons.folder_outlined, color: FlutterFlowTheme.of(context).primary, size: 30.0);
  }
}
