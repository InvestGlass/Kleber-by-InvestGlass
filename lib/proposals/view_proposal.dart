import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/documents/document_model.dart';
import 'package:kleber_bank/proposals/proposal_controller.dart';
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

class ViewProposal extends StatefulWidget {
  final String documentId;
  final String ext, url;
  ProposalModel? item;
  final int? index;

  ViewProposal(this.documentId, {this.ext = 'pdf', this.url = '', this.item, this.index, super.key});

  @override
  State<ViewProposal> createState() => _ViewProposalState();
}

class _ViewProposalState extends State<ViewProposal> {
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
  late ProposalController _notifier;

  @override
  void initState() {
    getPdfBytes();
    super.initState();
  }

  ///Get the PDF document as bytes
  void getPdfBytes() async {
    if (widget.url.isEmpty) {
      try {
        _documentBytes = await http.readBytes(Uri.parse('${EndPoints.apiBaseUrl}documents/${widget.documentId}'),
                  headers: {'Authorization': 'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'});
      } catch (e) {
        if(e.toString().contains(' 404')){
          _documentBytes=Uint8List(0);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    c=context;
    _notifier = Provider.of<ProposalController>(context);
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
      if(_documentBytes!.isEmpty){
        child=Center(child: AppWidgets.label(context,FFLocalizations.of(context).getText(
          'doc_not_found',
        ) ),);
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
            'mlj5814u' /* Proposal */,
          ),
          leading: AppWidgets.backArrow(context),
          centerTitle: true),
      body: child,
      bottomNavigationBar:Wrap(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: rSize*0.02),
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  child: getWidget(context),
                ),
              ],
            ),
    );
  }

  Widget getWidget(BuildContext context) {
    if (widget.item!.state == 'Pending' && widget.item!.requestProposalApproval!) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.scale(
                scale: isTablet?2:0.8,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    checkboxTheme: CheckboxThemeData(
                      splashRadius: 0, // Removes the splash effect
                      overlayColor: MaterialStateProperty.all(Colors.transparent), // Removes overlay color
                    ),
                  ),
                  child: Checkbox(
                    value: widget.item!.state != 'Pending' || widget.item!.isChecked,
                    activeColor: FlutterFlowTheme.of(context).primary,
                    side: BorderSide(
                      width: 2,
                      color: FlutterFlowTheme.of(context).customColor4,
                    ),
                    checkColor: !((widget.item!.state != 'Rejected') && (widget.item!.state != 'Accepted'))
                        ? FlutterFlowTheme.of(context).secondaryBackground
                        : FlutterFlowTheme.of(context).info,
                    onChanged: (value) {
                      if (widget.item!.state == 'Pending') {
                        // widget.item!.isChecked = !widget.item!.isChecked;
                        _notifier.updateCheckBox(widget.index!);
                        setState(() {});
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: isTablet?rSize*0.01:0,),
              Expanded(
                child: Text(
                  FFLocalizations.of(context).getText(
                    'prtogarh' /* I read the documents and agree... */,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: FlutterFlowTheme.of(context).customColor4,
                    fontSize: rSize * 0.016,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: rSize*0.01,),
          Row(
            children: [
              SizedBox(
                width: rSize * 0.02,
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  if(!widget.item!.isChecked){
                    CommonFunctions.showToast(FFLocalizations.of(context).getText(
                      'agree_checkbox',
                    ));
                    return;
                  }
                  AppWidgets.showAlert(
                      context,
                      FFLocalizations.of(context).getText(
                        'decline_proposal' /* Decline Proposal*/,
                      ),
                      FFLocalizations.of(context).getText(
                        's1jcpzx6' /*cancel*/,
                      ),
                      FFLocalizations.of(context).getText(
                        'bdc48oru' /*confirm*/,
                      ), () {
                    Navigator.pop(context);
                  }, () {
                    _notifier.updateState('rejected', widget.item!.id!, widget.index!, context, onUpdateStatus: (item) {
                      setState(() {
                        widget.item = item;
                      });
                    });
                  }, btn1BgColor: FlutterFlowTheme.of(context).customColor3, btn2BgColor: FlutterFlowTheme.of(context).customColor2);
                },
                child: AppWidgets.btnWithIcon(
                    context,
                    '  ${FFLocalizations.of(context).getText(
                      'j0hr735r' /* Decline*/,
                    )}',
                    FlutterFlowTheme.of(context).customColor3,
                    Icon(
                      Icons.close,
                      color: Colors.white,
                      size: rSize * 0.024,
                    )),
              )),
              SizedBox(
                width: rSize * 0.02,
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  if(!widget.item!.isChecked){
                    CommonFunctions.showToast(FFLocalizations.of(context).getText(
                      'agree_checkbox',
                    ));
                    return;
                  }
                  AppWidgets.showAlert(
                      context,
                      FFLocalizations.of(context).getText(
                        'accept_proposal' /* accept Proposal*/,
                      ),
                      FFLocalizations.of(context).getText(
                        's1jcpzx6' /*cancel*/,
                      ),
                      FFLocalizations.of(context).getText(
                        'bdc48oru' /*confirm*/,
                      ), () {
                    Navigator.pop(context);
                  }, () {
                    if(!widget.item!.isChecked){
                      CommonFunctions.showToast(FFLocalizations.of(context).getText(
                        'agree_checkbox',
                      ));
                      return;
                    }
                    _notifier.updateState('accepted', widget.item!.id, widget.index!, context, onUpdateStatus: (item) {
                      setState(() {
                        widget.item = item;
                      });
                    });
                  }, btn1BgColor: FlutterFlowTheme.of(context).customColor3, btn2BgColor: FlutterFlowTheme.of(context).customColor2);
                },
                child: AppWidgets.btnWithIcon(
                    context,
                    '  ${FFLocalizations.of(context).getText(
                      '3esw1ind' /* Accept */,
                    )}',
                    FlutterFlowTheme.of(context).customColor2,
                    Icon(
                      Icons.done,
                      color: Colors.white,
                      size: rSize * 0.024,
                    )),
              )),
              SizedBox(
                width: rSize * 0.02,
              ),
            ],
          ),
        ],
      );
    } else {
      if (widget.item?.state == 'Accepted') {
        return Center(
          child: Text(
            '${FFLocalizations.of(context).getText(
              'ktrsz8sp' /* Accepted at */,
            )} ${DateFormat('yyyy-MM-dd HH:mm').format(widget.item!.acceptedDate!)}',
            style: FlutterFlowTheme.of(context).bodyMedium.override(

                  color: FlutterFlowTheme.of(context).customColor2,
                  fontSize: rSize*0.016,
                  letterSpacing: 0.0,
                ),
          ),
        );
      }
      if (widget.item?.state == 'Rejected') {
        return Center(
          child: Text(
            '${FFLocalizations.of(context).getText(
              '5tjloy3c' /* Rejected at */,
            )} ${DateFormat('yyyy-MM-dd HH:mm').format(widget.item!.rejectedDate!)}',
            style: FlutterFlowTheme.of(context).bodyMedium.override(

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
