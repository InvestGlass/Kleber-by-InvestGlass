import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kleber_bank/proposals/proposal_model.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  final String ext,url;
  const ViewDocument(this.documentId,this.isProposal,{this.showSignButton=false,this.ext='pdf',this.url='',super.key});

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
  @override
  void initState() {
      getPdfBytes();
    super.initState();
  }

  ///Get the PDF document as bytes
  void getPdfBytes() async {
    if (widget.url.isEmpty) {
      _documentBytes = await http.readBytes(Uri.parse(
              '${EndPoints.baseUrl}documents/${widget.documentId}'), headers: {'Authorization': 'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const Center(child: CircularProgressIndicator());
    if (_documentBytes != null) {
    if (widget.ext.toLowerCase()=='pdf' || widget.ext.toLowerCase()=='txt') {
      child = SfPdfViewer.memory(
        _documentBytes!,
      );
    }else{
      child = Image.memory(
        _documentBytes!,
      );
    }


    }if(widget.url.isNotEmpty){
      child=WebViewWidget(controller: WebViewController()
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
      appBar: AppWidgets.appBar(context,FFLocalizations.of(context).getText(
        !widget.isProposal?'dlgf18jl' /* Document */:'mlj5814u' /* Proposal */,
      ),leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back,color: FlutterFlowTheme.of(context).primary,)),centerTitle: true),
      body: child,
      /*bottomNavigationBar:widget.showSignButton!? Wrap(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40,vertical: 20),
            color: FlutterFlowTheme.of(context).primaryBackground,
            child: GestureDetector(
              onTap: () {
                AppWidgets.showSignDialog(context,onAccept: (){
                  CommonFunctions.showLoader(context);
                  ApiCalls.updateDocumentStatus(int.parse(widget.documentId), 'approve').then((value) {
                    CommonFunctions.dismissLoader(context);
                    Navigator.pop(context);
                    Navigator.pop(context,true);
                  },);
                },onReject: (){

                });
              },
              child: AppWidgets.btn(context, FFLocalizations.of(context).getText(
                'mg8sso38' *//* Sign *//*,
              ),bgColor: FlutterFlowTheme.of(context).primary),
            ),
          ),
        ],
      ):null,*/
    );
  }

}
