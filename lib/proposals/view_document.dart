import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kleber_bank/proposals/proposal_model.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../utils/app_widgets.dart';
import '../utils/end_points.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import '../utils/shared_pref_utils.dart';

class ViewDocument extends StatefulWidget {
  final String documentId;
  final bool isProposal;
  const ViewDocument(this.documentId,this.isProposal,{super.key});

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
    _documentBytes = await http.readBytes(Uri.parse(
        '${EndPoints.baseUrl}documents/${widget.documentId}'), headers: {'Authorization': 'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const Center(child: CircularProgressIndicator());
    if (_documentBytes != null) {
        child = SfPdfViewer.memory(
          _documentBytes!,
        );
    }
    return Scaffold(
      appBar: AppWidgets.appBar(context,FFLocalizations.of(context).getText(
        !widget.isProposal?'dlgf18jl' /* Document */:'mlj5814u' /* Proposal */,
      ),leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back,color: FlutterFlowTheme.of(context).primary,)),centerTitle: true),
      body: child,
    );
  }

}
