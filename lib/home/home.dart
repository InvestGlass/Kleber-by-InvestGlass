import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/home/home_controller.dart';
import 'package:kleber_bank/home/home_news_model.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/utils/app_colors.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../utils/flutter_flow_swipeable_stack.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import 'news_feed_swipe_card_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<String> _names = ["Red", "Blue", "Green", "Yellow", "Orange"];
  List<Color> _colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange];
  late HomeController _notifier;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<HomeController>(context, listen: false).getPopularNews(context);
      },
    );
    for (int i = 0; i < _names.length; i++) {
      _swipeItems.add(SwipeItem(
          content: Content(text: _names[i], color: _colors[i]),
          likeAction: () {},
          nopeAction: () {},
          superlikeAction: () {},
          onSlideUpdate: (SlideRegion? region) async {
            print("Region $region");
          }));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<HomeController>(context);
    return Scaffold(
      body: Container(
        decoration: AppStyles.commonBg(context),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: rSize * 0.015, vertical: rSize * 0.02),
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(15.0, 20.0, 0.0, 10.0),
              child: Text(
                FFLocalizations.of(context).getText(
                  'ran9xdwl' /* Popular */,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Roboto',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 24.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
            SizedBox(
              height: rSize * 0.25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: _notifier.popularNewsList.length,
                itemBuilder: (context, index) {
                  HomeNewsModel model = _notifier.popularNewsList[index];
                  return Card(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          child: Image.network(
                            model.imageUrl ?? '',
                            height: rSize * 0.15,
                            width: rSize * 0.28,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/items_default.jpg', height: rSize * 0.15, width: rSize * 0.28, fit: BoxFit.cover);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: rSize * 0.27,
                                  margin: EdgeInsets.only(top: rSize * 0.005),
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText(
                                    model.title ?? '',
                                    maxLines: 2,
                                    minFontSize: 12.0,
                                    style: FlutterFlowTheme.of(context).titleMedium.override(
                                          fontFamily: 'Roboto',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          lineHeight: 1.2,
                                        ),
                                  )),
                              SizedBox(
                                height: rSize * 0.01,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).customColor1,
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: Align(
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
                                    child: Container(
                                      height: 12.0,
                                      decoration: const BoxDecoration(),
                                      child: AutoSizeText(
                                        DateFormat('yyyy-MM-dd').format(model.date ?? DateTime.now()),
                                        minFontSize: 1.0,
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Roboto',
                                              color: FlutterFlowTheme.of(context).info,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              lineHeight: 1.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                child: Text(
                  FFLocalizations.of(context).getText(
                    'gln3vyrv' /* Recomended */,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 24.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                      ),
                )),
            if (!_notifier.refresh) ...{
              SizedBox(
                height: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                        'g2rxi1c1' /* Favourite selection */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Roboto',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _notifier.doRefresh(),
                          child: AppWidgets.btn(
                              context,
                              FFLocalizations.of(context).getText(
                                'yiyjkffh' /* Refresh */,
                              ),
                              horizontalPadding: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            } else ...{
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 400.0,
                    margin: EdgeInsets.only(bottom: rSize * 0.01),
                    decoration: const BoxDecoration(),
                    child: Builder(
                      builder: (context) {
                        // final recomendedNewsList = _notifier
                        //     .recomendedListToRender
                        //     .toList();

                        return FlutterFlowSwipeableStack(
                          onSwipeFn: (index) async {
                            _notifier.increaseSwipeCount();
                          },
                          onLeftSwipe: (index) async {
                            CommonFunctions.showToast(FFLocalizations.of(context).getVariableText(
                              enText: 'Investment idea disliked',
                              arText: 'فكرة الاستثمار لم تعجبك',
                              viText: 'Ý tưởng đầu tư không được ưa chuộng',
                            ));
                          },
                          onRightSwipe: (index) async {
                            CommonFunctions.showToast(FFLocalizations.of(context).getVariableText(
                              enText: 'Investment idea liked',
                              arText: 'أعجبتني هذه الفكرة الاستثمارية',
                              viText: 'Đã thích ý tưởng đầu tư này',
                            ),success: true);
                          },
                          onUpSwipe: (index) async {},
                          onDownSwipe: (index) async {},
                          itemBuilder: (context, index) {
                            // final recomendedNewsListItem =
                            // recomendedNewsList[
                            // recomendedNewsListIndex];
                            return NewsFeedSwipeCardWidget(
                              key: Key('Keylei_${index}_of_}'),
                              image: _notifier.swipeData[index]['image'],
                              type: _notifier.swipeData[index]['type'],
                              title: _notifier.swipeData[index]['title'],
                              content:_notifier.swipeData[index]['content'],
                            );
                          },
                          itemCount: _notifier.swipeData.length,
                          controller: _notifier.swipeableStackController,
                          loop: false,
                          cardDisplayCount: 2,
                          scale: 1.0,
                          maxAngle: 45.0,
                          cardPadding: const EdgeInsets.all(0.0),
                          backCardOffset: const Offset(0.0, 0.0),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  _notifier.swipeableStackController.swipe(CardSwiperDirection.left);
                                },
                                child: Container(
                                  width: _notifier.buttonSize,
                                  height: _notifier.buttonSize,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).error,
                                    borderRadius: BorderRadius.circular(70.0),
                                  ),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: _notifier.buttonSize / 2,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.swipe_left_rounded,
                                  color: FlutterFlowTheme.of(context).customColor4,
                                  size: 24.0,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      'yj6g8w9q' /* Swipe left */,
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Roboto',
                                          color: FlutterFlowTheme.of(context).customColor4,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  _notifier.swipeableStackController.swipe(CardSwiperDirection.right);
                                },
                                child: Container(
                                  width: _notifier.buttonSize,
                                  height: _notifier.buttonSize,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).success,
                                    borderRadius: BorderRadius.circular(70.0),
                                  ),
                                  child: Icon(
                                    Icons.done_rounded,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: _notifier.buttonSize / 2,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      '35ozpi3w' /* Swipe right */,
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Roboto',
                                          color: FlutterFlowTheme.of(context).customColor4,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                                Icon(
                                  Icons.swipe_right_rounded,
                                  color: FlutterFlowTheme.of(context).customColor4,
                                  size: 24.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            },
            SizedBox(
              height: rSize * 0.02,
            )
          ],
        ),
      ),
    );
  }

  Widget swipeIcon(String img, String text) {
    return Column(
      children: [
        Container(
            height: rSize * 0.06,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.kTextFieldInput, width: 1)),
            child: Image.asset(img, scale: 15, color: AppColors.kTextFieldInput)),
        Text(text),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Content {
  final String text;
  final Color color;

  Content({this.text = '', this.color = Colors.white});
}
