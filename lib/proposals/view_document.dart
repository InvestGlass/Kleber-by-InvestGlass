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
  final String documentId;
  final bool isProposal;
  final bool? showSignButton;
  final String ext, url;
  Document? item;
  final int? index;

  ViewDocument(this.documentId, this.isProposal, {this.showSignButton = false, this.ext = 'pdf', this.url = '', this.item, this.index, super.key});

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

  @override
  void initState() {
    getPdfBytes();
    super.initState();
  }

  ///Get the PDF document as bytes
  void getPdfBytes() async {
    if (widget.url.isEmpty) {
      _documentBytes = await http.readBytes(Uri.parse('${EndPoints.baseUrl}documents/${widget.documentId}'),
          headers: {'Authorization': 'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<DocumentsController>(context);
    Widget child = const Center(child: CircularProgressIndicator());
    if (_documentBytes != null) {
      if (widget.ext.toLowerCase() == 'pdf' || widget.ext.toLowerCase() == 'txt') {
        child = SfPdfViewer.memory(
          _documentBytes!,
        );
      } else {
        child = Image.memory(
          _documentBytes!,
        );
      }
    }
    if (widget.url.isNotEmpty) {
      child = WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  // Update loading bar.
                },
                onPageStarted: (String url) {},
                onPageFinished: (String url) {},
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
            ..loadRequest(Uri.parse(widget.url)));
    }
    return Scaffold(
      appBar: AppWidgets.appBar(
          context,
          FFLocalizations.of(context).getText(
            !widget.isProposal ? 'dlgf18jl' /* Document */ : 'mlj5814u' /* Proposal */,
          ),
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                size: rSize*0.025,
                color: FlutterFlowTheme.of(context).primary,
              )),
          centerTitle: true),
      body: child,
      bottomNavigationBar: (widget.item?.requestProposalApproval??false)
          ? Wrap(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: rSize*0.02),
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  child: getWidget(context),
                ),
              ],
            )
          : null,
    );
  }

  Widget getWidget(BuildContext context) {
    if (widget.item?.documentStatus == null) {
      return GestureDetector(
        onTap: () {
          AppWidgets.showSignDialog(context, onAccept: () {
            _notifier.updateDocumentStatus(widget.item!, 'approve', widget.index!, context, onUpdateStatus: (item) {
              setState(() {
                widget.item = item;
              });
            });
          }, onReject: () {
            _notifier.updateDocumentStatus(widget.item!, 'reject', widget.index!, context, onUpdateStatus: (item) {
              setState(() {
                widget.item = item;
              });
            });
          });
        },
        child: AppWidgets.btn(
            context,
            FFLocalizations.of(context).getText(
              'mg8sso38' /* Sign */,
            ),textColor: Colors.white,
            bgColor: FlutterFlowTheme.of(context).primary),
      );
    } else {
      if (widget.item?.documentStatus == 'Approved') {
        return Center(
          child: Text(
            '${FFLocalizations.of(context).getText(
              'ktrsz8sp' /* Accepted at */,
            )} ${DateFormat(
              'yyyy-MM-dd HH:mm',
              FFLocalizations.of(context).languageCode,
            ).format(widget.item!.approvedAt!)}',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.of(context).customColor2,
                  fontSize: rSize*0.016,
                  letterSpacing: 0.0,
                ),
          ),
        );
      }
      if (widget.item?.documentStatus == 'Rejected') {
        return Center(
          child: Text(
            '${FFLocalizations.of(context).getText(
              '5tjloy3c' /* Rejected at */,
            )} ${DateFormat(
              'yyyy-MM-dd HH:mm',
              FFLocalizations.of(context).languageCode,
            ).format(widget.item!.disapprovedAt!)}',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.of(context).customColor3,
                  fontSize: rSize*0.016,
                  letterSpacing: 0.0,
                ),
          ),
        );
      }
    }
    return SizedBox();
  }
}
