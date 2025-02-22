import 'package:kleber_bank/market/new_trade.dart';
import 'package:kleber_bank/market/market_list_model.dart';

import 'package:flutter/material.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../market/flutter_flow_video_player.dart';
import '../utils/app_styles.dart';
import '../utils/button_widget.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';

class MarketListItemWidget extends StatefulWidget {
  const MarketListItemWidget({
    super.key,
    String? securityName,
    this.securityID,
    this.backgroundUrl,
    String? assetClassName,
    String? formUrl,
    this.assetClassColor,
    required this.data,
    this.videoUrl,
    this.onItemTapCustom,
    String? indexStr,
    this.bgColor,
  })  : securityName = securityName ?? '',
        assetClassName = assetClassName ?? '',
        formUrl = formUrl ?? '',
        indexStr = indexStr ?? '-1';

  final String securityName;
  final int? securityID;
  final String? backgroundUrl;
  final String assetClassName;
  final String formUrl;
  final Color? assetClassColor;
  final MarketListModel? data;
  final String? videoUrl;
  final Future Function(int index, MarketListModel data)? onItemTapCustom;
  final String indexStr;
  final Color? bgColor;

  @override
  State<MarketListItemWidget> createState() => _MarketListItemWidgetState();
}

class _MarketListItemWidgetState extends State<MarketListItemWidget> {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    c = context;

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        await widget.onItemTapCustom?.call(
          int.tryParse(widget.indexStr) ?? -1,
          widget.data!,
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: widget.bgColor ?? FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: AppStyles.shadow(),
            borderRadius: BorderRadius.circular(rSize * 0.01)),
        margin: EdgeInsets.only(bottom: rSize * 0.01),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: rSize * 0.250,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).alternate,
              ),
              child: SizedBox(
                height: rSize * 0.250,
                child: Stack(
                  children: [
                    if (widget.data?.videoUrl != null && widget.data?.videoUrl != '')
                      Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: FlutterFlowVideoPlayer(
                          path: widget.data!.videoUrl!,
                          videoType: VideoType.network,
                          width: double.infinity,
                          height: rSize * 0.250,
                          autoPlay: false,
                          looping: false,
                          showControls: true,
                          allowFullScreen: true,
                          allowPlaybackSpeedMenu: true,
                          lazyLoad: false,
                        ),
                      ),
                    if (widget.data?.videoUrl == null || widget.data?.videoUrl == '')
                      Stack(
                        children: [
                          if (widget.data?.imageUrl == null || widget.data?.imageUrl == '')
                            Image.asset(
                              Theme.of(context).brightness == Brightness.dark ? 'assets/items_default.jpg' : 'assets/items_default.jpg',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          if (widget.data?.imageUrl != null && widget.data?.imageUrl != '')
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Image.network(
                                widget.data!.imageUrl!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                    Align(
                      alignment: const AlignmentDirectional(1.0, -1.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, rSize * 0.015, 0.0, 0.0),
                        child: Container(
                          color: getColor(widget.data!.assetClassName!),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(rSize * 0.010, rSize * 0.005, rSize * 0.015, rSize * 0.005),
                            child: Text(
                              widget.data!.assetClassName!,
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    color: FlutterFlowTheme.of(context).info,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(rSize * 0.015, 0.0, rSize * 0.015, rSize * 0.015),
              child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, rSize * 0.015, 0.0, 0.0),
                  child: Text(
                    widget.data!.name!,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          color: widget.bgColor == null ? FlutterFlowTheme.of(context).customColor4 : FlutterFlowTheme.of(context).info,
                          fontSize: rSize * 0.018,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                if (widget.data?.isin != null && widget.data?.isin != '')
                  Text(
                    widget.data!.isin!,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          color: widget.bgColor == null ? FlutterFlowTheme.of(context).customColor4 : FlutterFlowTheme.of(context).info,
                          fontSize: rSize * 0.018,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      widget.data!.currencyName!,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            color: widget.bgColor == null ? FlutterFlowTheme.of(context).customColor4 : FlutterFlowTheme.of(context).info,
                            fontSize: rSize * 0.018,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(
                      width: rSize * 0.005,
                    ),
                    Expanded(
                      child: Text(
                        widget.data?.price != null && widget.data?.price != ''
                            ? CommonFunctions.formatDoubleWithThousandSeperator(widget.data!.price!, false, 2)
                            : 'N/A',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              color: widget.bgColor == null ? FlutterFlowTheme.of(context).customColor4 : FlutterFlowTheme.of(context).info,
                              fontSize: rSize * 0.018,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Color getColor(String className) {
    if (className == 'alternative') {
      return const Color(0XFF8fc700);
    } else if (className == 'bond') {
      return const Color(0XFF1e7145);
    } else if (className == 'collectible') {
      return const Color(0XFF59630d);
    } else if (className == 'commodity') {
      return const Color(0XFFd8b674);
    } else if (className == 'crypto') {
      return const Color(0XFF8844ff);
    } else if (className == 'forex') {
      return const Color(0XFF50c);
    } else if (className == 'derivative') {
      return const Color(0XFF6ad79d);
    } else if (className == 'equity') {
      return const Color(0XFF2b5797);
    } else if (className == 'fixed-interest') {
      return const Color(0XFFd874ce);
    } else if (className == 'fund') {
      return const Color(0XFF972b2b);
    } else if (className == 'index') {
      return const Color(0XFF33aaff);
    } else if (className == 'top-flop') {
      return const Color(0XFF33aaff);
    } else if (className == 'real-estate') {
      return const Color(0XFF802b97);
    } else if (className == 'unlisted-equity') {
      return const Color(0XFF749cd8);
    } else {
      return const Color(0XFF003f5);
    }
  }
}
