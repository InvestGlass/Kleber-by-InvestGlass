import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/src/core/paging_controller.dart';
import 'package:kleber_bank/proposals/proposal_model.dart';
import 'package:kleber_bank/utils/common_functions.dart';

import '../utils/api_calls.dart';
import '../utils/internationalization.dart';

class ProposalController extends ChangeNotifier {
  int selectedIndex = -1;

  int selectedSortIndex = -1;
  String? selectedProposalType, advisorName = '', proposalName = '';
  String direction = '', column = '';
  List<String> sortList = ['Newest', 'Oldest', 'A-Z', 'Z-A'];
  List<FilterModel> selectedFilterList = [];


  selectTransactionIndex(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
    } else {
      selectedIndex = -1;
    }
    notifyListeners();
  }

  void updateState(
    String state,
    PagingController<int, ProposalModel> pagingController,
    int? id,
    int index,
    BuildContext context,
  ) {
    if(!pagingController.itemList![index].isChecked){
      CommonFunctions.showToast(FFLocalizations.of(context).getText(
        'agree_checkbox',
      ));
      return;
    }
    CommonFunctions.showLoader(context);
    ApiCalls.updateProposalState(id!, state).then(
      (value) {
        CommonFunctions.dismissLoader(context);
        if (value != null) {
          pagingController.itemList![index] = value;
          Navigator.pop(context);
          notifyListeners();
        }
      },
    );
  }

  List<String> typesList = [];

  void getProposalTypes() {
    if (typesList.isEmpty) {
      ApiCalls.getProposalTypeList().then(
        (value) {
          typesList = value;
          notifyListeners();
        },
      );
    }
  }
}

class FilterModel {
  final String name, type;

  FilterModel(this.name, this.type);
}

enum FilterTypes{
SORT,
  ADVISOR,
  PROPOSAL_NAME,
  PROPOSAL_TYPE,
}