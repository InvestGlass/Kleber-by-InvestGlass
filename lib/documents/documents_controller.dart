import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/src/core/paging_controller.dart';
import 'package:kleber_bank/documents/document_model.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/common_functions.dart';

import '../utils/internationalization.dart';
import 'accounts_model.dart';

class DocumentsController extends ChangeNotifier {
  String _selectedType = 'All';

  List<String> typesList(BuildContext context) => [
        FFLocalizations.of(context).getText(
          'n93guv4x' /* All */,
        ),
        FFLocalizations.of(context).getText(
          'dlgf18jl' /* Document */,
        ),
        FFLocalizations.of(context).getText(
          '6ihgprib' /* Form */,
        ),
        FFLocalizations.of(context).getText(
          'lhntzq4q' /* Package */,
        )
      ];
  List<String> sortList = [
    'wdlmnbeh' /*'Newest'*/,
    'gxc8dzyc' /*'Oldest'*/,
    't7tz8m1x' /*'A-Z'*/,
    'lkq0botg' /*'Z-A'*/,
    'largest',
    'smallest'
  ];
  String range = '';
  String searchedFile = '';
  String? selectedType = 'All';
  AccountsModel? selectedAccount;
  List<String> ancestryFolderList = [], folderPathList = [];
  int sortRadioGroupValue = -1, tempSortRadioGroupValue = -1;
  String selectedAncestryFolder = '',
      selectedPath = '',
      startDate = '',
      endDate = '',
      orderColumn = 'created_at',
      orderDirection = 'desc';

  // List<FilterModel> appliedFilters = [];
  String filterName = 'filterName',
      filterType = 'filterType',
      filterDate = 'filterDate',
      path = 'path',
      sortType = 'sortType';
  List<FilterModel> selectedFilterList = [FilterModel('All', 'type')];
  List<AccountsModel> accountList = [];
  List<AccountsModel> accountModelList = [];
  final PagingController<int, Document> pagingController =
      PagingController(firstPageKey: 1);
  bool isGridMode = false;
  List<Document> documentList = [];
  int pageKey = 1;
  bool hasMore = true,isLoading = false;

  Future<void> fetchDocuments(BuildContext context) async {
    if (isLoading || !hasMore) return;
    isLoading=true;
    notifyListeners();
    await ApiCalls.getDocumentList(
            context,
            pageKey,
            selectedAccount?.id?.toString() ?? '',
            searchedFile,
            selectedType,
            range,
            ancestryFolderList,
            folderPathList,
            orderDirection,
            orderColumn)
        .then(
      (value) {
        isLoading=false;
        documentList.addAll(value?.folders ?? []);
        print('calling ${documentList.length}');
        if ((value?.folders ?? []).length >= 10) {
          hasMore = true;
          pageKey++;
        } else {
          hasMore = false;
        }
        notifyListeners();
      },
    );
  }

  void setSortRadioGroupValue(int value, String label) {
    sortRadioGroupValue = value;
    if (value == 0 || value == 1) {
      orderColumn = 'created_at';
    } else {
      orderColumn = 'name';
    }

    if (value == 0 || value == 3) {
      orderDirection = 'desc';
    } else {
      orderDirection = 'asc';
    }
    notifyListeners();
  }

  void changeMode() {
    isGridMode = !isGridMode;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  void setTempSortRadioGroupValue(int value) {
    tempSortRadioGroupValue = value;
    notifyListeners();
  }

  void setDate(String date) {
    range = '';
    startDate = '';
    endDate = '';
    notifyListeners();
  }

  Future<void> getAccountList(BuildContext context) async {
    if (accountList.isNotEmpty) {
      return;
    }
    CommonFunctions.showLoader(context);
    await ApiCalls.getAccountsList(context).then(
      (value) {
        CommonFunctions.dismissLoader(context);
        accountList = value;
        accountList.insert(
            0,
            AccountsModel(
                name: FFLocalizations.of(context).getText(
              'n93guv4x' /* All */,
            )));
        accountModelList = value;
        notifyListeners();
      },
    );
  }

  /*________________________________________________UPLOAD DOCUMENT____________________________________*/
  XFile? image;
  TextEditingController descController = TextEditingController();
  bool shared = false;
  TextEditingController expiryDateController = TextEditingController();
  String errorMsg = '';

  void selectImage(XFile? image) {
    this.image = image;
    notifyListeners();
  }

  void removeSelectedImage() {
    image = null;
    notifyListeners();
  }

  void uploadDoc(BuildContext context) {
    CommonFunctions.showLoader(context);
    ApiCalls.uploadDoc(image!, descController.text).then(
      (value) {
        CommonFunctions.dismissLoader(context);
        if (value != null) {
          if (value.containsKey('error') && value.containsKey('message')) {
            errorMsg = FFLocalizations.of(context).getText(
              'acceptable_formats',
            );
            CommonFunctions.showToast('Invalid format');
          }
          if (value.containsKey('company_id')) {
            CommonFunctions.showToast('Uploaded successfully', success: true);
            Navigator.pop(context);
          }
        }
        notifyListeners();
      },
    );
  }

  void updateDocumentStatus(
      Document item, String status, int index, BuildContext context,
      {Function? onUpdateStatus}) {
    CommonFunctions.showLoader(context);
    ApiCalls.updateDocumentStatus(context, item.id!, status).then(
      (value) {
        CommonFunctions.dismissLoader(context);
        Navigator.pop(context);
        if (value != null) {
          if (onUpdateStatus != null) {
            onUpdateStatus(value);
          }
          pagingController.itemList![index] = value;
          documentList[index] = value;
          notifyListeners();
        }
      },
    );
  }

  void goToPreviousFolder() {
    ancestryFolderList.removeLast();
    folderPathList.removeLast();
    notifyListeners();
  }

  void openFolder(Document item) {
    folderPathList.add("${item.folderName!}/");
    ancestryFolderList.add(item.id.toString());
    notifyListeners();
  }

  void clearAll() {
    folderPathList.clear();
    ancestryFolderList.clear();
    selectedAccount = null;
    searchedFile = '';
    selectedType = '';
    range = '';
    orderColumn = 'created_at';
    orderDirection = 'desc';
    // notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}

class FilterModel {
  String? name;
  String type;

  FilterModel(this.name, this.type);
}
