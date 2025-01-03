import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:kleber_bank/portfolio/portfolio_model.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/common_functions.dart';

import 'data_model.dart';

class PortfolioController extends ChangeNotifier{
  int selectedIndex=-1;
  int selectedPositionIndex=-1;
  int selectedTransactionIndex=-1;
  String selectedPositionFilter='Best Performance',selectedTransactionFilter='Largest Amount';

  var positionsFilterTypeList=['Best Performance','Worst Performance','A-Z','Z-A','Largest Weight','Smallest Weight',];
  var transactionFilterTypeList=['Largest Amount','Smallest Amount','A-Z','Z-A'];
  String column='roi',direction='desc';
  String tranColumn='amount',tranDirection='desc';
  late Stream<PortfolioModel?> stream;
  List<String> typeList=['Cash Deposit','Withdrawal','Buy to Open','Sell to Close'];
  List<String> dateList=['Today','Tomorrow'];
  List<String> amountList=['123456.4001 CHF','123456.4001 EUR','123456.4001 JPY','123456.4001 GBP'];
  String selectedAmount='123456.4001 CHF',selectedType='Cash Deposit',selectedStatus='Fulfilled',selectedExecutionDate='Today';

  Stream<PortfolioModel?> getPortfolioData(BuildContext context, PortfolioModel item) async* {
    yield await ApiCalls.getPortfolioData(context, item.id!);
  }

  selectIndex(int index, PortfolioModel item, BuildContext context) {
    if (selectedIndex!=index) {
      selectedIndex=index;
      stream=getPortfolioData(context, item);
    }else{
      selectedIndex=-1;
    }
    notifyListeners();
  }

  selectPositionIndex(int index) {
    if (selectedPositionIndex!=index) {
      selectedPositionIndex=index;
    }else{
      selectedPositionIndex=-1;
    }
    notifyListeners();
  }

  selectTransactionIndex(int index) {
    if (selectedTransactionIndex!=index) {
      selectedTransactionIndex=index;
    }else{
      selectedTransactionIndex=-1;
    }
    notifyListeners();
  }

  void selectPositionFilter(String value) {
    selectedPositionFilter=value;
    int index=positionsFilterTypeList.indexOf(value);
    if(index==0){
      column='roi';
      direction='desc';
    }else if(index==1){
      column='roi';
      direction='asc';
    }else if(index==2){
      column='name';
      direction='asc';
    }else if(index==3){
      column='name';
      direction='desc';
    }else if(index==4){
      column='allocations';
      direction='desc';
    }else if(index==5){
      column='allocations';
      direction='asc';
    }
    notifyListeners();
  }

  void selectTransactionFilter(String value) {
    selectedTransactionFilter=value;
    int index=transactionFilterTypeList.indexOf(value);
    if(index==0){
      tranColumn='amount';
      tranDirection='desc';
    }else if(index==1){
      tranColumn='amount';
      tranDirection='asc';
    }else if(index==2){
      tranColumn='security_name';
      tranDirection='asc';
    }else if(index==3){
      tranColumn='security_name';
      tranDirection='desc';
    }
    notifyListeners();
  }

  Future<List<PortfolioModel>> getPortfolioList(BuildContext context,int pageKey,{bool notify=false, bool isCreateTransaction=false}) async {
    await ApiCalls.getPortfolioList(context,pageKey).then((value) {

      portfolioList=value;

      if(pageKey==1 && value.isNotEmpty){
        selectedIndex=0;
        stream=getPortfolioData(context,value[0]);
        stream.asBroadcastStream();
      }

      if (notify) {
        notifyListeners();
      }
    },);
    return portfolioList;
  }

  /*_______________________Security TRANSACTION_______________________________*/
  PortfolioModel? selectedPortfolio;
  List<PortfolioModel> portfolioList=[];

  void notify() {
    notifyListeners();
  }

  String selectedDate='';
  void setDate(String date) {
    selectedDate=date;
    notifyListeners();
  }

/*_______________________CASH TRANSACTION_______________________________*/

  List<Datum> cashTransactionTypeList=[],currencyList=[],statusList=[];
  Datum? selectedCurrency;
  TextEditingController openRateController=TextEditingController(),amountController=TextEditingController(),usdController=TextEditingController();

  Future<void> fetchDropDownData(BuildContext context,String type) async {
    await ApiCalls.fetchCashTransactionDropDowns(context, type).then((value) {
      if(type=='transaction_type'){
        cashTransactionTypeList=value;
      }else if(type=='currency'){
        currencyList=value;
      }else if(type=='transaction_status'){
        statusList=value;
      }
      notifyListeners();
    },);
  }

  void selectPortfolio(p0) {
    selectedPortfolio = p0;
    selectedCurrency=currencyList.singleWhere((element) => element.name==selectedPortfolio?.referenceCurrency,);
    notifyListeners();
  }
  void selectCurrency(BuildContext context,p0) {
    selectedCurrency=p0;
    CommonFunctions.showLoader(context);
    ApiCalls.calculateOpenRate(context, selectedPortfolio!.id!, selectedCurrency?.name??'').then((value) {
      CommonFunctions.dismissLoader(context);
      openRateController.text=value;
      notifyListeners();
    },);


  }

  void calculate(String value) {
    usdController.text=((double.tryParse(value)??0)*(double.tryParse(openRateController.text)??0)).toStringAsFixed(2);
    notifyListeners();
  }

}