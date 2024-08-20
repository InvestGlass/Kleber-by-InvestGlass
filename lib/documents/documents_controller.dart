import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/src/core/paging_controller.dart';
import 'package:kleber_bank/documents/document_model.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/common_functions.dart';

class DocumentsController extends ChangeNotifier {
  String _selectedType = 'All';
  List<String> typesList = ['All', 'Document', 'Form', 'Package'];
  List<String> sortList = ['wdlmnbeh'/*'Newest'*/, 'gxc8dzyc'/*'Oldest'*/, 'gedmceci'/*'A-Z'*/, 'qdw51x3q'/*'Z-A'*/];
  String range = '';
  String searchedFile = '';
  String? selectedType = 'All';
  String? selectedAccount = 'All';
  int sortRadioGroupValue = -1;
  String selectedAncestryFolder = '', selectedPath = '', startDate = '', endDate = '', orderColumn = 'created_at', orderDirection = 'desc';
  List<FilterModel> appliedFilters = [];
  String filterName = 'filterName', filterType = 'filterType', filterDate = 'filterDate', path = 'path', sortType = 'sortType';
  List<FilterModel> selectedFilterList = [];

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
    appliedFilters.removeWhere(
      (element) => element.type == sortType,
    );
    appliedFilters.insert(0, FilterModel(label, sortType));
    notifyListeners();
  }

  void setDate(String date) {
    range = '';
    startDate = '';
    endDate = '';
    notifyListeners();
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
            errorMsg=value['error']+' :- '+value['message'];
            CommonFunctions.showToast('Invalid format');
          }
          if(value.containsKey('company_id')){
            CommonFunctions.showToast('Uploaded successfully',success: true);
            Navigator.pop(context);
          }
        }
        notifyListeners();
      },
    );
  }

  void updateDocumentStatus(Document item, String status, PagingController<int, Document> pagingController, int index, BuildContext context){
    CommonFunctions.showLoader(context);
    ApiCalls.updateDocumentStatus(item.id!, status).then((value) {
      CommonFunctions.dismissLoader(context);
      if (value!=null) {
        pagingController.itemList![index]=value;
        notifyListeners();
      }
    },);
  }
}

enum FilterTypes{
  ACCOUNT,
  FILE_NAME,
  TYPE,
  DATE_RANGE,
}

class FilterModel {
  String? name;
  String type;

  FilterModel(this.name, this.type);
}
