import '../main.dart';
import '../utils/button_widget.dart';
import '../utils/common_functions.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import 'package:flutter/material.dart';

class NewsFeedSwipeCardWidget extends StatefulWidget {
  const NewsFeedSwipeCardWidget({
    super.key,
    required this.image,
    required this.type,
    required this.title,
    required this.content,
  });

  final String? image;
  final String? type;
  final String? title;
  final String? content;

  @override
  State<NewsFeedSwipeCardWidget> createState() =>
      _NewsFeedSwipeCardWidgetState();
}

class _NewsFeedSwipeCardWidgetState extends State<NewsFeedSwipeCardWidget> {

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
    return SizedBox(
      width: double.infinity,
      height: rSize*0.5,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              widget.image!,
              width: double.infinity,
              height: rSize*0.5,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width * 1.0,
            height: MediaQuery.sizeOf(context).height * 1.0,
            decoration: BoxDecoration(
              color: const Color(0x51000000),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(rSize*0.015, 0.0, rSize*0.015, rSize*0.020),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).customColor1,
                        borderRadius: BorderRadius.circular(rSize*0.024),
                      ),
                      margin: EdgeInsets.symmetric(vertical: rSize*0.005),
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              rSize*0.010, rSize*0.005, rSize*0.010, rSize*0.005),
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: Text(
                              widget.type!,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Roboto',
                                    color: FlutterFlowTheme.of(context).info,
                                    fontSize: rSize*0.016,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.title!,
                  maxLines: 2,
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Roboto',
                        fontSize: rSize*0.025,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: rSize*0.005,),
                FFButtonWidget(
                  onPressed: () async {
                    /*context.pushNamed(
                      'NewDetailPage',
                      queryParameters: {
                        'image': serializeParam(
                          widget.image,
                          ParamType.String,
                        ),
                        'title': serializeParam(
                          widget.title,
                          ParamType.String,
                        ),
                        'type': serializeParam(
                          widget.type,
                          ParamType.String,
                        ),
                        'content': serializeParam(
                          widget.content,
                          ParamType.String,
                        ),
                      }.withoutNulls,
                    );*/
                  },
                  text: FFLocalizations.of(context).getText(
                    '5tqbxl7s' /* Read */,
                  ),
                  options: FFButtonOptions(
                    height: rSize*0.04,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(rSize*0.024, 0.0, rSize*0.024, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).customColor1,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                    elevation: 3.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(rSize*0.008),
                  ),
                ),
              ]),
            ),
        ],
      ),
    );
  }
}
