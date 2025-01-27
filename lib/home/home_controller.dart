import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:kleber_bank/utils/api_calls.dart';
import 'package:kleber_bank/utils/common_functions.dart';

import '../main.dart';
import 'home_news_model.dart';

class HomeController extends ChangeNotifier{
  CardSwiperController swipeableStackController= CardSwiperController();
  double buttonSize = rSize*0.045;
  List<HomeNewsModel> popularNewsList=[];
  bool refresh=false;
  int swipeCount=0;
  bool isLoading=true;
  var swipeData=[
    {'image':
          'https://assets.bwbx.io/images/users/iqjWHBFdfxIU/iZzEbn3d5iqk/v1/1200x799.jpg',
      'type': 'Technology',
      'title': 'Nvidia Delivers on AI Hype, Igniting \$140 Billion Stock Rally',
      'content':
          'Nvidia Corp., the chipmaker at the center of an artificial intelligence boom, gained in late trading after a bullish sales forecast showed that AI computing spending remains strong.  Second-quarter revenue will be about \$28 billion, the company said Wednesday, topping the \$26.8 billion predicted by analysts. Results in the fiscal first quarter, which ended April 28, also beat projections — lifted by growth in Nvidia’s data-center division.  The big question heading into the earnings report was whether Nvidia’s latest numbers could justify the dizzying run-up in its stock. The shares had gained 92% this year through Wednesday’s close, fueled by investor hopes that the company would continue to shatter expectations.',
      'id': '0',},
    {'image':
          'https://assets.bwbx.io/images/users/iqjWHBFdfxIU/iPczF8CaKibg/v1/1200x800.jpg',
      'type': 'Technology',
      'title': 'South Korea Sets Aside Record \$19 Billion to Fuel Chipmaking',
      'content':
          'South Korea has unveiled a \$19 billion package of incentives to bolster its chip sector, a boon to Samsung Electronics Co. and SK Hynix Inc. as they race to stay ahead in an increasingly competitive industry.  The 26 trillion won program includes 17 trillion won of financial support for certain investments as well as tax incentives, the presidential office said in a statement. The total is more than double the 10 trillion won Finance Minister Choi Sang-mok had proposed',
      'id': '1',},
    {'image':
          'https://assets.bwbx.io/images/users/iqjWHBFdfxIU/i7jO77lnCPLs/v1/1200x800.jpg',
      'type': 'AI',
      'title': 'OpenAI Inks Deal With Wall Street Journal Publisher News Corp.',
      'content':
          'News Corp. announced an agreement with OpenAI to let the company use content from more than a dozen of its publications in the ChatGPT-maker’s products.  As part of the deal, OpenAI’s services will be able to display news from the Wall Street Journal, Barron’s, MarketWatch and other News Corp. publications. The agreement comes as OpenAI has been striking several deals with high-profile media companies in the US and Europe in recent weeks, including The Financial Times, Dotdash Meredith and social media firm Reddit, to display and license content.',
      'id': '2',},
  ];

  void getPopularNews(BuildContext context){
    isLoading=true;
    notifyListeners();
    ApiCalls.getHomeNews(context).then((value) {
      isLoading=false;
      popularNewsList=value;
      notifyListeners();
    },);
  }

  void doRefresh(){
    refresh=!refresh;
    notifyListeners();
  }

  void increaseSwipeCount() {
    swipeCount++;
    if(swipeCount==swipeData.length){
      swipeCount=0;
      doRefresh();
    }
  }
}