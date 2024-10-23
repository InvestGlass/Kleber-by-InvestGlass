import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/market/transaction_type_model.dart';
import 'package:kleber_bank/portfolio/portfolio_model.dart';
import 'package:kleber_bank/proposals/proposal_controller.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/end_points.dart';

import '../utils/internationalization.dart';
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

  Future<void> getList(BuildContext context,int pageKey) async {
    marketList.clear();
    await ApiCalls.getMarketList(
            context,pageKey, searchController.text, selectedAssetClass?.name ?? '', selectedIndustry?.name ?? '', selectedCurrency?.name ?? '')
        .then(
      (value) {
        marketList = value;
        notifyListeners();
      },
    );
  }

  Future<void> getFilterDropDown(BuildContext context) async {
    if (industryList.isEmpty) {
      ApiCalls.getMarketFilterDropDownData(context,EndPoints.industries).then(
        (value) {
          industryList = value;
          notifyListeners();
        },
      );
    }
    if (currencyList.isEmpty) {
      ApiCalls.getMarketFilterDropDownData(context,EndPoints.currencies).then(
        (value) {
          currencyList = value;
          notifyListeners();
        },
      );
    }
    if (assetClassList.isEmpty) {
      ApiCalls.getMarketFilterDropDownData(context,EndPoints.assetClasses).then(
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
  TransactionTypeModel? selectedSecurityType;
  TextEditingController limitPriceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController orderType = TextEditingController();
  double amount = 0;
  List<TransactionTypeModel> transactionTypeList = [];

  void getTransactionTypes(BuildContext context) async {
    if (transactionTypeList.isEmpty) {
      CommonFunctions.showLoader(context);
      ApiCalls.getTransactionTypeList(context).then(
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
    selectedDateTime = DateFormat('yyyy-MM-dd').format(selectedDate!) + ' ' + selectedTime!.hour.toString() + ':' + selectedTime!.minute.toString();
    notifyListeners();
  }

  void updateAmount(String price) {
    double limitPrice = double.tryParse(limitPriceController.text) ?? 0;
    double qty = double.tryParse(qtyController.text) ?? 0;
    double currentPrice = double.tryParse(price) ?? 0;
    if (limitPrice != 0) {
      amount = limitPrice * qty;
    } else {
      amount = currentPrice * qty;
    }
    notifyListeners();
  }

  Future<void> transmit(MarketListModel model, PortfolioModel? selectedPortfolio, BuildContext context, ProposalController proposalController, MarketListModel marketModel) async {
    if(selectedPortfolio==null){
      CommonFunctions.showToast(FFLocalizations.of(context).getText(
        'portfolio_msg',
      ));
      return;
    }else if(limitPriceController.text.isEmpty){
      CommonFunctions.showToast(FFLocalizations.of(context).getText(
        'limit_price_msg',
      ));
      return;
    }
    Map<String, dynamic> map = {};
    Map<String, dynamic> map2 = {};
    map['security'] = model.toJson();
    map['create_transaction_type'] = 'Security';
    map['portfolio_id'] = selectedPortfolio.id!.toString();
    map['state'] = '0';
    map['transaction_type'] = selectedSecurityType?.id??'';
    map['destination_portfolio_id'] = '';
    map['transaction_datetime'] = selectedDateTime;
    map['accounting_datetime'] = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    map['value_datetime'] = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    map['description'] = descController.text;
    map['quantity'] = qtyController.text;
    map['open_price'] = limitPriceController.text;
    map['open_rate'] = '1.0';
    map['amount'] = amount;

    map2['transaction']=map;

    print(jsonEncode(map2));

    String msg ='${getText(context,'xn2nrgyp' /* Portfolio */)} : ${selectedPortfolio.title}\n'
        '${getText(context,'rumkikc1' /* Name, ISIN, FIGI or Ticket */)} : ${marketModel.name}\n'
        '${getText(context,'whkrwls1' /* Type */)} : ${selectedSecurityType?.name}\n'
        '${getText(context,'7fx237xy' /* Time In Force */)} : $selectedDateTime\n'
        '${getText(context,'2mpa9jiq' /* Notes */)} : ${descController.text.isEmpty?'':descController.text}\n'
        '${getText(context,'u7hyldvt' /* Order Type */)} : ${orderType.text.isEmpty?'':orderType.text}\n'
        '${getText(context,'2odrp5sn' /* Quantity */)} : ${qtyController.text.isEmpty?'':qtyController.text}\n'
        '${getText(context,'lz424u11' /* Current Price */)} : ${marketModel.price}\n'
        '${getText(context,'q9p7fv0r' /* Limit Price */)} : ${limitPriceController.text.isEmpty?'':limitPriceController.text}\n'
        '${getText(context,'4noemhfd' /* Amount */)} : ${amount==0?'':amount.toString()}\n'
    ;

    CommonFunctions.showLoader(context);
    await ApiCalls.transmit(context,map2).then(
      (value) {
        CommonFunctions.dismissLoader(context);
        if((value??{}).containsKey('id')){
          proposalController.sendMsg(context,msg: msg);
          CommonFunctions.showToast(FFLocalizations.of(context).getText('transaction_created'),success: true);
          Navigator.pop(context);
        }
        print('add transaction response $value');
      },
    );
  }

  getText(BuildContext context,String s) {
    return FFLocalizations.of(context).getText(
      s,
    );
  }
}
