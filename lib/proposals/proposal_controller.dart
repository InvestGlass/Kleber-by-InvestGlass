import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/src/core/paging_controller.dart';
import 'package:kleber_bank/proposals/chat/chat_history_model.dart';
import 'package:kleber_bank/proposals/proposal_model.dart';
import 'package:kleber_bank/utils/common_functions.dart';

import '../utils/api_calls.dart';
import '../utils/internationalization.dart';

class ProposalController extends ChangeNotifier {
  int selectedIndex = -1;

  int selectedSortIndex = 0;
  String? selectedProposalType, advisorName = '', proposalName = '';
  String direction = 'desc', column = 'created_at';
  List<String> sortList = ['Newest', 'Oldest', 'A-Z', 'Z-A'];
  List<FilterModel> selectedFilterList = [];
  final PagingController<int, ProposalModel> pagingController = PagingController(firstPageKey: 1);


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
    int? id,
    int index,
    BuildContext context,
      {Function? onUpdateStatus}) {
    if(!pagingController.itemList![index].isChecked){
      CommonFunctions.showToast(FFLocalizations.of(context).getText(
        'agree_checkbox',
      ));
      return;
    }
    CommonFunctions.showLoader(context);
    ApiCalls.updateProposalState(context,id!, state).then(
      (value) {
        CommonFunctions.dismissLoader(context);
        Navigator.pop(context);
        if (value != null) {
          if (onUpdateStatus!=null) {
            onUpdateStatus(value);
          }
          pagingController.itemList![index] = value;
          notifyListeners();
        }
      },
    );
  }

  List<String> typesList = [];

  void getProposalTypes(BuildContext context) {
    if (typesList.isEmpty) {
      ApiCalls.getProposalTypeList(context).then(
        (value) {
          typesList = value;
          typesList.insert(0,FFLocalizations.of(context).getText(
            'n93guv4x' /* All */,
          ));
          notifyListeners();
        },
      );
    }
  }

  /*----------------------------------------CHAT-----------------------------------------------------*/

  final PagingController<int, ChatHistoryModel> chatHistoryPagingController = PagingController(firstPageKey: 1);

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


