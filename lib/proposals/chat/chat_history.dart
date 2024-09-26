import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/proposals/chat/chat_history_model.dart';
import 'package:kleber_bank/proposals/proposal_model.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../utils/api_calls.dart';
import '../../utils/flutter_flow_theme.dart';
import '../../utils/internationalization.dart';
import '../proposal_controller.dart';

class ChatHistory extends StatefulWidget {
  final ProposalModel model;
  const ChatHistory(this.model, {super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  int _pageKey = 1;
  late ProposalController _notifier;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
    ProposalController notifier = Provider.of<ProposalController>(context, listen: false);
    notifier.chatHistoryPagingController.addPageRequestListener((pageKey) {
      _fetchPageActivity(notifier);
    });
    super.initState();
  }

  Future<void> _fetchPageActivity(ProposalController notifier) async {
    notifier.getProposalTypes(context);
    List<ChatHistoryModel> list = await ApiCalls.getChatHistory(context, _pageKey);
    final isLastPage = list.length < 10;
    if (isLastPage) {
      notifier.chatHistoryPagingController.appendLastPage(list);
    } else {
      _pageKey++;
      notifier.chatHistoryPagingController.appendPage(list, _pageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<ProposalController>(context);
    return Scaffold(
      appBar: AppWidgets.appBar(context, widget.model.advisor?.name??'', leading: AppWidgets.backArrow(context), actions: [
        GestureDetector(
          onTap: () {
            _pageKey = 1;
            _notifier.chatHistoryPagingController.refresh();
          },
          child: Icon(
            Icons.refresh_rounded,
            color: FlutterFlowTheme.of(context).primary,
            size: rSize*0.030,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: rSize*0.005),
          child: GestureDetector(
            onTap: () async {
              await launchUrl(Uri(
                scheme: 'tel',
                path: widget.model.advisor?.phoneOffice,
              ));
            },
            child: Icon(
              Icons.call_outlined,
              color: FlutterFlowTheme.of(context).primary,
              size: rSize*0.030,
            ),
          ),
        ),/*
        Icon(
          Icons.calendar_today_outlined,
          color: FlutterFlowTheme.of(context).primary,
          size: 30.0,
        ),*/
        SizedBox(
          width: rSize*0.01,
        )
      ]),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(color: FlutterFlowTheme.of(context).primaryText, width: 1),
          bottom: BorderSide(color: FlutterFlowTheme.of(context).primaryText, width: 1),
        )),
        child: PagedListView<int, ChatHistoryModel>.separated(
          pagingController: _notifier.chatHistoryPagingController,
          reverse: true,
          builderDelegate: PagedChildBuilderDelegate<ChatHistoryModel>(itemBuilder: (BuildContext context, ChatHistoryModel item, int index) {
            bool isLast = (item == _notifier.chatHistoryPagingController.itemList!.last);
            return Column(
              crossAxisAlignment:
                  item.sender?.id == SharedPrefUtils.instance.getUserData().user?.id ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (isLast || (!isLast && getdate(item) != getdate(_notifier.chatHistoryPagingController.itemList![index + 1]))) ...{
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).customColor4,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.all(rSize*0.010),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(rSize*0.020),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).customColor4,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          getdate(item),
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Roboto',
                                fontSize: rSize*0.016,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).customColor4,
                          ),
                        ),
                      ),
                    ],
                  )
                },
                SizedBox(
                  height: rSize*0.015,
                ),
                Text(
                  item.sender?.name ?? '',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: rSize*0.014,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).info,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(rSize*0.012),
                      bottomRight: Radius.circular(rSize*0.012),
                      topLeft: const Radius.circular(0.0),
                      topRight: Radius.circular(rSize*0.012),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(rSize*0.012),
                    child: Text(
                      item.comment ?? '',
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto',
                            color: Colors.black,
                            fontSize: rSize*0.016,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, rSize*0.005, 0.0, 0.0),
                  child: Text(
                    CommonFunctions.dateTimeFormat(
                      'yyyy-MM-dd HH:mm',
                      DateTime.fromMillisecondsSinceEpoch(item.createdAt!.millisecondsSinceEpoch, isUtc: true),
                      locale: FFLocalizations.of(context).languageCode,
                    ),
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Roboto',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: rSize*0.014,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            );
          }),
          separatorBuilder: (BuildContext context, int index) {
            ChatHistoryModel item = _notifier.chatHistoryPagingController.itemList![index];

            return const SizedBox();
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        padding: EdgeInsets.symmetric(horizontal: rSize*0.015, vertical: rSize*0.01),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.of(context).info,
                  fontSize: rSize*0.018,
                  letterSpacing: 0.0,
                ),
                controller: _notifier.msgController,
                decoration: AppStyles.inputDecoration(context,
                    focusColor: FlutterFlowTheme.of(context).alternate,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: rSize*0.020,
                    contentPadding: EdgeInsets.symmetric(vertical: rSize*0.012, horizontal: rSize*0.020),
                    hint: FFLocalizations.of(context).getText(
                      '0lw6g9ud' /* Type new message */,
                    )),
              ),
            ),
            SizedBox(
              width: rSize*0.020,
            ),
            GestureDetector(
              onTap: () {
                _notifier.sendMsg(context);
              },
              child: Icon(
                Icons.send_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: rSize*0.024,
              ),
            )
          ],
        ),
      ),
    );
  }

  String getdate(ChatHistoryModel item) => DateFormat('dd MMM yyyy').format(item.createdAt!);
}
