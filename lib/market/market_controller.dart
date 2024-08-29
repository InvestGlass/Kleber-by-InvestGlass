import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/market/transaction_type_model.dart';
import 'package:kleber_bank/portfolio/portfolio_model.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/end_points.dart';

import 'market_list_model.dart';

class MarketController extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  List<MarketListModel> marketList = [], assetClassList = [], industryList = [], currencyList = [];
  final PagingController<int, MarketListModel> pagingController = PagingController(firstPageKey: 1);
  int playingIndex = -1;
  MarketListModel? selectedAssetClass, selectedIndustry, selectedCurrency;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedDateTime;

  Future<void> getList(int pageKey) async {
    marketList.clear();
    await ApiCalls.getMarketList(
            pageKey, searchController.text, selectedAssetClass?.name ?? '', selectedIndustry?.name ?? '', selectedCurrency?.name ?? '')
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

  /*____________________________ADD TRANSACTION___________________________________*/
  MarketListModel? selectedSecurity;
  TransactionTypeModel? selectedSecurityType;
  TextEditingController limitPriceController=TextEditingController();
  TextEditingController qtyController=TextEditingController();
  double amount=0;
  List<TransactionTypeModel> transactionTypeList = [];

  void selectSecurity(MarketListModel? result) {
    selectedSecurity = result;
    notifyListeners();
  }

  void getTransactionTypes(BuildContext context) async {
    if (transactionTypeList.isNotEmpty) {
      CommonFunctions.showLoader(context);
      ApiCalls.getTransactionTypeList().then(
        (value) {
          CommonFunctions.dismissLoader(context);
          transactionTypeList = value;
          notifyListeners();
        },
      );
    }
  }

  void selectSecurityType(TransactionTypeModel p0) {
    selectedSecurityType = p0;
    notifyListeners();
  }

  void selectTime(BuildContext context) {
    // DateTime formatedTime=DateFormat('HH:mm a').parse(selectedTime!.hour.toString()+':'+selectedTime!.minute.toString());
    selectedDateTime = DateFormat('yyyy-MM-dd').format(selectedDate!) + ' ' + selectedTime!.hour.toString()+':'+selectedTime!.minute.toString();
    notifyListeners();
  }

  void updateAmount(String price) {
    double limitPrice=double.tryParse(limitPriceController.text)??0;
    double qty=double.tryParse(qtyController.text)??0;
    double currentPrice=double.tryParse(price)??0;
    if (limitPrice!=0) {
      amount=limitPrice*qty;
    }else{
      amount=currentPrice*qty;
    }
    notifyListeners();
  }

  Future<void> transmit(MarketListModel model, PortfolioModel? selectedPortfolio) async {
    /*Map<String, dynamic> map={};
    map['security']=model.toJson();
    map['create_transaction_type']
    map['portfolio_id']=selectedPortfolio!.title!;
    map['state']='0';
    map['transaction_type']=selectedSecurityType;
    map['destination_portfolio_id']='';
    map['transaction_datetime']=selectedDate;
    map['accounting_datetime']=;
    map['value_datetime']=;
    map['description']=;
    map['quantity']=;
    map['open_price']=;
    map['open_rate']=;
    map['amount']=;


    await ApiCalls.transmit(body);*/
  }
}
