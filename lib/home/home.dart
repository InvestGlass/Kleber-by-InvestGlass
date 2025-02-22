import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/documents/document_model.dart';
import 'package:kleber_bank/home/home_controller.dart';
import 'package:kleber_bank/home/home_news_model.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/proposals/view_document.dart';
import 'package:kleber_bank/utils/app_colors.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/end_points.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:video_player/video_player.dart';

import '../utils/flutter_flow_swipeable_stack.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import 'news_feed_swipe_card_widget.dart';

class Home extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  const Home(this.videoPlayerController,{super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  final List<SwipeItem> _swipeItems = [];
  final List<String> _names = ["Red", "Blue", "Green", "Yellow", "Orange"];
  final List<Color> _colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange];
  late HomeController _notifier;

  var formUrl = '${EndPoints.baseUrl}forms';

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
            if (kDebugMode) {
              print("Region $region");
            }
          }));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    c = context;
    _notifier = Provider.of<HomeController>(context);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: rSize * 0.015, vertical: rSize * 0.01),
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0.0, 0.0, rSize * 0.010),
            child: AppWidgets.title(
              context,
              FFLocalizations.of(context).getText(
                'insights',
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: SizedBox(
              height: rSize * 0.24,
              child: Skeletonizer(
                enabled: _notifier.isLoading,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: _notifier.isLoading ? 5 : _notifier.popularNewsList.length,
                  itemBuilder: (context, index) {
                    HomeNewsModel model = _notifier.isLoading ? HomeNewsModel() : _notifier.popularNewsList[index];
                    return AppWidgets.click(
                      onTap: () {
                        try {
                          nevigate(context, model.link ?? '', 'ran9xdwl');
                          // launchUrl(Uri.parse(model.link ?? ''));
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: listItem(context,
                          url: model.imageUrl ?? '', title: model.title ?? '', date: DateFormat('yyyy-MM-dd').format(model.date ?? DateTime.now())),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: rSize * 0.26,
            child: ListView.separated(
              itemCount: _notifier.insights.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: rSize * 0.01,
                );
              },
              itemBuilder: (context, index) {
                Map<String, String> item = _notifier.insights[index];
                return AppWidgets.click(
                  onTap: () {
                    nevigate(context, item['link']!, 'insights');
                  },
                  child: listItem(context,
                      url: item['image']!, title: item['title']!, desc: item['desc']!, date: item['date']!),
                );
                return AppWidgets.click(
                  onTap: () {
                    nevigate(context, item['link']!, 'insights');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        item['image']!,
                        height: rSize * 0.12,
                        width: rSize * 0.15,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: rSize * 0.01,
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['date']!,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(fontSize: rSize * 0.016, color: FlutterFlowTheme.of(context).customColor4, fontWeight: FontWeight.normal),
                          ),
                          SizedBox(height: rSize*0.005),
                          AppWidgets.label(context, item['title']!),
                          SizedBox(height: rSize*0.005),
                          Text(
                            item['desc']!,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontSize: rSize * 0.016,
                                  color: FlutterFlowTheme.of(context).customColor4,
                                  fontWeight: FontWeight.normal,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: rSize*0.005),
                          Row(
                            children: [
                              Text(
                                '${FFLocalizations.of(context).getText(
                                  'discover_key',
                                )}  ',
                                style: AppStyles.labelStyle(context).copyWith(color: FlutterFlowTheme.of(context).primary),
                              ),
                              Icon(
                                FontAwesomeIcons.arrowRight,
                                color: FlutterFlowTheme.of(context).primary,
                              )
                            ],
                          )
                        ],
                      ))
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, rSize * 0.015, 0.0, 0),
              child: AppWidgets.title(
                  context,
                  FFLocalizations.of(context).getText(
                    'success_journey',
                  ))),
          VideoPlayerScreen(videoPlayerController: widget.videoPlayerController),
          SizedBox(
            height: rSize * 0.01,
          ),
          Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, rSize * 0.010, 0.0, rSize * 0.010),
              child: AppWidgets.title(
                  context,
                  FFLocalizations.of(context).getText(
                    'more_products',
                  ))),
          if (!_notifier.refresh) ...{
            productView(
                Icon(
                  FontAwesomeIcons.chartSimple,
                  color: FlutterFlowTheme.of(context).customColor4,
                  size: rSize * 0.02,
                ),
                FFLocalizations.of(context).getText(
                  'vested_benefits',
                ),
                FFLocalizations.of(context).getText(
                  'vested_benefits_desc',
                ), () {
              nevigate(context, "$formUrl/46634dec-0e81-446d-ae3a-0b5131fda7a6", 'vested_benefits');
            }),
            productView(
                Icon(FontAwesomeIcons.shieldHeart, color: FlutterFlowTheme.of(context).customColor4, size: rSize * 0.02),
                FFLocalizations.of(context).getText(
                  'life_plus',
                ),
                FFLocalizations.of(context).getText(
                  'life_plus_desc',
                ), () {
              nevigate(context, "$formUrl/3c992c39-488d-4266-b4b7-2c8f79bc25f3", 'life_plus');
            }),
            productView(
                Icon(FontAwesomeIcons.home, color: FlutterFlowTheme.of(context).customColor4, size: rSize * 0.02),
                FFLocalizations.of(context).getText(
                  'mortgage',
                ),
                FFLocalizations.of(context).getText(
                  'mortgage_desc',
                ), () {
              nevigate(context, "$formUrl/324c7a2e-ab90-4e32-a872-0f36ff5a73d8", 'mortgage');
            }),

            Visibility(
              visible: false,
              child: Image.asset('assets/home_placeholder.png'),
            ),
            Visibility(
                visible: false,
                child: SizedBox(
                  height: rSize * 0.350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          'g2rxi1c1' /* Favourite selection */,
                        ),
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              color: FlutterFlowTheme.of(context).customColor4,
                              fontSize: rSize * 0.02,
                              letterSpacing: 0.0,
                            ),
                      ),
                      SizedBox(
                        height: rSize * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppWidgets.click(
                            onTap: () => _notifier.doRefresh(),
                            child: AppWidgets.btn(
                                context,
                                textColor: Colors.white,
                                FFLocalizations.of(context).getText(
                                  'yiyjkffh' /* Refresh */,
                                ),
                                horizontalPadding: rSize * 0.015),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          } else ...{
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: rSize * 0.45,
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
                          CommonFunctions.showToast(
                              FFLocalizations.of(context).getVariableText(
                                enText: 'Investment idea liked',
                                arText: 'أعجبتني هذه الفكرة الاستثمارية',
                                viText: 'Đã thích ý tưởng đầu tư này',
                              ),
                              success: true);
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
                            content: _notifier.swipeData[index]['content'],
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
                  padding: EdgeInsetsDirectional.fromSTEB(rSize * 0.020, 0.0, rSize * 0.020, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, rSize * 0.005),
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
                                  borderRadius: BorderRadius.circular(rSize * 0.070),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.swipe_left_rounded,
                                color: FlutterFlowTheme.of(context).customColor4,
                                size: rSize * 0.024,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(rSize * 0.005, 0.0, 0.0, 0.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    'yj6g8w9q' /* Swipe left */,
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        color: FlutterFlowTheme.of(context).customColor4,
                                        fontSize: rSize * 0.016,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, rSize * 0.005),
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
                                  borderRadius: BorderRadius.circular(rSize * 0.070),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, rSize * 0.005, 0.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    '35ozpi3w' /* Swipe right */,
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        color: FlutterFlowTheme.of(context).customColor4,
                                        fontSize: rSize * 0.016,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                              Icon(
                                Icons.swipe_right_rounded,
                                color: FlutterFlowTheme.of(context).customColor4,
                                size: rSize * 0.024,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: rSize * 0.05,
                )
              ],
            ),
          },
          SizedBox(
            height: rSize * 0.02,
          )
        ],
      ),
    );
  }

  Container listItem(
    BuildContext context, {
    required String url,
    required String title,
    String? desc,
    required String date,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground, boxShadow: AppStyles.shadow(), borderRadius: BorderRadius.circular(rSize * 0.01)),
      margin: EdgeInsets.only(right: rSize * 0.01, bottom: rSize * 0.01, left: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(rSize * 0.010), topRight: Radius.circular(rSize * 0.010)),
            child: Image.network(
              url,
              height: rSize * 0.15,
              width: rSize * 0.28,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/items_default.jpg', height: rSize * 0.15, width: rSize * 0.28, fit: BoxFit.cover);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(rSize * 0.005),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: rSize * 0.27,
                    margin: EdgeInsets.only(top: rSize * 0.005),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      maxLines: 2,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            color: FlutterFlowTheme.of(context).customColor4,
                            fontSize: rSize * 0.014,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            lineHeight: 1.2,
                          ),
                    )),
                Container(
                    width: rSize * 0.27,
                    margin: EdgeInsets.only(top: rSize * 0.005),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      desc??'',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            color: FlutterFlowTheme.of(context).customColor4,
                            fontSize: rSize * 0.014,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            lineHeight: 1.2,
                          ),
                    )),
                SizedBox(
                  height: rSize * 0.005,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).customColor1,
                    borderRadius: BorderRadius.circular(rSize * 0.024),
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(rSize * 0.010, rSize * 0.005, rSize * 0.010, rSize * 0.005),
                      child: Text(
                        date,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color: FlutterFlowTheme.of(context).info,
                              fontSize: rSize * 0.012,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              lineHeight: 1.0,
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
  }

  void nevigate(BuildContext context, String url, String title) {
    CommonFunctions.navigate(
        context,
        ViewDocument(
          item: Document(url: url),
          title: FFLocalizations.of(context).getText(
            title,
          ),
          showInitialLoader: true,
        ));
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

  productView(Widget icon, String title, String desc, void Function()? onTap) {
    return AppWidgets.click(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: AppStyles.shadow(),
            borderRadius: BorderRadius.circular(rSize * 0.01)),
        padding: EdgeInsets.all(rSize * 0.015),
        margin: EdgeInsets.only(bottom: rSize * 0.015),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: rSize * 0.01,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontSize: rSize * 0.016, color: FlutterFlowTheme.of(context).customColor4, fontWeight: FontWeight.w500, letterSpacing: 1),
                  ),
                  SizedBox(height: rSize * 0.005),
                  Text(
                    desc,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontSize: rSize * 0.014,
                          color: FlutterFlowTheme.of(context).customColor4,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ],
              ),
            ),
            Icon(FontAwesomeIcons.plus, color: FlutterFlowTheme.of(context).customColor4, size: rSize * 0.02)
          ],
        ),
      ),
    );
  }
}

class Content {
  final String text;
  final Color color;

  Content({this.text = '', this.color = Colors.white});
}

class VideoPlayerScreen extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const VideoPlayerScreen({super.key, required this.videoPlayerController});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: 16 / 9,
      allowFullScreen: true,
      allowMuting: true,
    );
    _chewieController?.setVolume(0);

  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: rSize * 0.28,
      child: Center(
        child: _chewieController != null ? Chewie(controller: _chewieController!) : const CircularProgressIndicator(),
      ),
    );
  }
}
