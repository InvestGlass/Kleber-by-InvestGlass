import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/common_functions.dart';

import 'home_news_model.dart';

class HomeController extends ChangeNotifier{
  CardSwiperController swipeableStackController= CardSwiperController();
  double buttonSize = 40.0;
  List<HomeNewsModel> popularNewsList=[];

  void getPopularNews(BuildContext context){
    CommonFunctions.showLoader(context);
    ApiCalls.getHomeNews().then((value) {
      CommonFunctions.dismissLoader(context);
      popularNewsList=value;
      notifyListeners();
    },);
  }
}