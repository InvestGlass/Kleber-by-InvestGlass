import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/documents/document_model.dart';
import 'package:kleber_bank/proposals/proposal_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../documents/documents_controller.dart';
import '../main.dart';
import '../utils/api_calls.dart';
import '../utils/app_widgets.dart';
import '../utils/common_functions.dart';
import '../utils/end_points.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import '../utils/shared_pref_utils.dart';

class ViewDocument extends StatefulWidget {
  bool? showSignButton;
  Document? item;
  String? title;
  final int? index;
  final bool showInitialLoader;

  ViewDocument(
      {this.title,
      this.showSignButton = false,
      this.item,
      this.index,
      this.showInitialLoader = false,
      super.key});

  @override
  State<ViewDocument> createState() => _ViewDocumentState();
}

class _ViewDocumentState extends State<ViewDocument> {
  Uint8List? list;

  /*@override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // Provider.of<DocumentsListController>(context,listen: false).viewDoc(context,widget.docId);
      list=await http.readBytes(Uri.parse(
        // '${EndPoints.documents}/${widget.docId}?content=true',
        'https://staging.investglass.com/api/v1/documents/31827?content=true'
      ), headers: {'Authorization': 'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'});
      setState(() {

      });
    },);

    super.initState();
  }*/
  Uint8List? _documentBytes;
  late DocumentsController _notifier;
  bool is1stTime = true;
  StreamController<double> _controller=StreamController();

  @override
  void initState() {
    /*if (widget.showInitialLoader) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          CommonFunctions.showLoader(context);
        },
      );
    }*/
    fetchWebData();
    super.initState();
  }

  ///Get the PDF document as bytes
  void getPdfBytes() async {
    if ((widget.item?.url ?? '').isEmpty) {
      _documentBytes = await http.readBytes(
          Uri.parse('${EndPoints.apiBaseUrl}documents/${widget.item!.id}'),
          headers: {
            'Authorization':
                'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'
          });
    }
    setState(() {});
  }

  Future<void> fetchWebData() async {
    if ((widget.item?.url ?? '').isEmpty) {
      final request = http.Request('GET', Uri.parse('${EndPoints.apiBaseUrl}documents/${widget.item!.id}'),);
      request.headers.addAll({
        'Authorization':
        'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'
      });
      final client = http.Client();
      final response = await client.send(request);

      final contentLength = response.contentLength;
      final List<int> bytes = [];
      int downloadedBytes = 0;

      final completer = Completer<void>();

      response.stream.listen(
            (chunk) {
          bytes.addAll(chunk);
          downloadedBytes += chunk.length;

          // Update progress
          _controller.add(downloadedBytes / contentLength!);
          /*setState(() {
          _progress = (downloadedBytes / contentLength!);
        });*/
        },
        onDone: () {
          setState(() {
            _documentBytes = Uint8List.fromList(bytes);
          });
          completer.complete();
        },
        onError: (error) {
          print("Error: $error");
          completer.completeError(error);
        },
        cancelOnError: true,
      );

      await completer.future;
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    c = context;
    _notifier = Provider.of<DocumentsController>(context);
    Widget child = SizedBox();
    if (_documentBytes != null) {
      if (widget.item!.originalFilename!.split('.').last.toLowerCase() ==
              'pdf' ||
          widget.item!.originalFilename!.toLowerCase() == 'txt') {
        child = SfPdfViewer.memory(
          _documentBytes!,
        );
      } else {
        child = Image.memory(
          _documentBytes!,
        );
      }
    }
    if ((widget.item?.url ?? '').isNotEmpty) {
      child = WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  print('progress $progress');
                  _controller.add(progress.toDouble()/100);
                },
                onPageStarted: (String url) {},
                onPageFinished: (String url) {
                  if (is1stTime) {
                    is1stTime = false;
                    // CommonFunctions.dismissLoader(context);
                  }
                },
                onHttpError: (HttpResponseError error) {},
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse(widget.item?.url ?? '')));
    }
    return Scaffold(
      appBar: AppWidgets.appBar(
          context,
          widget.title ??
              FFLocalizations.of(context).getText(
                '1vddbh59' /* Document */,
              ),
          leading: AppWidgets.backArrow(context),
          centerTitle: true),
      body: Stack(
        children: [
          child,
          Center(
            child:Padding(
              padding: EdgeInsets.symmetric(horizontal: rSize*0.05),
              child: StreamBuilder(stream: _controller.stream, builder: (context, snapshot) {
                print('cents : ${(snapshot.data??0)}');
                return Visibility(
                  visible:  (snapshot.data??0)!=1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(
                        value: snapshot.data??0.0,
                        backgroundColor: FlutterFlowTheme.of(context).customColor4,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        minHeight: 10,
                        color: Colors.blue,
                      ),
                      SizedBox(height: rSize*0.01,),
                      Text(
                        'Loading...',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontSize: rSize * 0.018,
                          color: FlutterFlowTheme.of(context).customColor4,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                );
              },),
            )
          )


        ],
      ),
      bottomNavigationBar:Wrap(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: rSize * 0.02),
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  child: getWidget(context),
                ),
              ],
            ),
    );
  }

  Widget getWidget(BuildContext context) {
    if (widget.showSignButton!) {
      return GestureDetector(
        onTap: () {
          AppWidgets.showSignDialog(context, onAccept: () {
            _notifier.updateDocumentStatus(
                widget.item!, 'approve', widget.index!, context,
                onUpdateStatus: (item) {
              setState(() {
                widget.item = item;
                widget.showSignButton = false;
              });
            });
          }, onReject: () {
            _notifier.updateDocumentStatus(
                widget.item!, 'reject', widget.index!, context,
                onUpdateStatus: (item) {
              setState(() {
                widget.item = item;
                widget.showSignButton = false;
              });
            });
          });
        },
        child: AppWidgets.btn(
            context,
            FFLocalizations.of(context).getText(
              'mg8sso38' /* Sign */,
            ),
            textColor: Colors.white,
            bgColor: FlutterFlowTheme.of(context).primary),
      );
    } else {
      if (widget.item?.documentStatus == 'Approved') {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.done_rounded,
              color: FlutterFlowTheme.of(context)
                  .customColor2,
              size: rSize * 0.024,
            ),
            Text(
              '${FFLocalizations.of(context).getText(
                'ktrsz8sp' /* Accepted at */,
              )} ${DateFormat(
                'yyyy-MM-dd HH:mm',
                FFLocalizations.of(context).languageCode,
              ).format(widget.item!.approvedAt!)}',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: FlutterFlowTheme.of(context).customColor2,
                    fontSize: rSize * 0.016,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        );
      }
      if (widget.item?.documentStatus == 'Rejected') {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.close_rounded,
              color: FlutterFlowTheme.of(context)
                  .customColor3,
              size: rSize * 0.024,
            ),
            Text(
              '${FFLocalizations.of(context).getText(
                '5tjloy3c' /* Rejected at */,
              )} ${DateFormat(
                'yyyy-MM-dd HH:mm',
                FFLocalizations.of(context).languageCode,
              ).format(widget.item!.disapprovedAt!)}',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: FlutterFlowTheme.of(context).customColor3,
                    fontSize: rSize * 0.016,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        );
      }
    }
    return SizedBox();
  }
}
