import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/end_points.dart';

import '../market/market_list_model.dart';


class SecuritySelectionController extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  List<MarketListModel> marketList = [], assetClassList = [], industryList = [], currencyList = [];
  final PagingController<int, MarketListModel> pagingController = PagingController(firstPageKey: 1);
  int playingIndex = -1;
  MarketListModel? selectedAssetClass, selectedIndustry, selectedCurrency;
  MarketListModel? selectedSecurity;

  Future<void> getList(int pageKey) async {
    marketList.clear();
    await ApiCalls.getMarketList(
            pageKey,
        searchController.text,
        selectedAssetClass?.name ?? '',
        selectedIndustry?.name ?? '',
        selectedCurrency?.name ?? '')
        .then(
      (value) {
        marketList = value;
        notifyListeners();
      },
    );
  }

  Future<void> getFilterDropDown() async {
    if (industryList.isEmpty) {
      ApiCalls.getMarketFilterDropDownData(EndPoints.industries).then(
        (value) {
          industryList = value;
          notifyListeners();
        },
      );
    }
    if (currencyList.isEmpty) {
      ApiCalls.getMarketFilterDropDownData(EndPoints.currencies).then(
        (value) {
          currencyList = value;
          notifyListeners();
        },
      );
    }
    if (assetClassList.isEmpty) {
      ApiCalls.getMarketFilterDropDownData(EndPoints.assetClasses).then(
        (value) {
          assetClassList = value;
          notifyListeners();
        },
      );
    }
  }

  void onPlayStatusChanged(int index, bool isPlaying) {
    if (isPlaying) {
      playingIndex = index;
    } else if (playingIndex == index) {
      playingIndex = -1;
    }
    notifyListeners();
  }

  void refresh() {
    pagingController.refresh();
    notifyListeners();
  }

  void selectSecurity(MarketListModel data) {
    selectedSecurity=data;
    notifyListeners();
  }
}
