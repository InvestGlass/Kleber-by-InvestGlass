import 'package:flutter/cupertino.dart';
import 'package:kleber_bank/portfolio/portfolio_model.dart';
import 'package:kleber_bank/utils/api_calls.dart';

class PortfolioController extends ChangeNotifier{
  int selectedIndex=-1;
  int selectedPositionIndex=-1;
  int selectedTransactionIndex=-1;
  String selectedPositionFilter='Best Performance';

  var positionsFilterTypeList=['Best Performance','Worst Performance','A-Z','Z-A','Largest Weight','Smallest Weight',];
  String column='roi',direction='desc';

  selectIndex(int index) {
    if (selectedIndex!=index) {
      selectedIndex=index;
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

  Future<List<PortfolioModel>> getPortfolioList(int pageKey,{bool notify=false}) async {
    await ApiCalls.getPortfolioList(pageKey).then((value) {
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