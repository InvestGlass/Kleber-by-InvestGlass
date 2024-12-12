import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:kleber_bank/portfolio/portfolio_model.dart';
import 'package:kleber_bank/utils/api_calls.dart';

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
      if (notify) {
        notifyListeners();
      }
    },);
    return portfolioList;
  }

  /*_______________________NEW TRADE_______________________________*/
  PortfolioModel? selectedPortfolio;
  List<PortfolioModel> portfolioList=[];

  void notify() {
    notifyListeners();
  }

}