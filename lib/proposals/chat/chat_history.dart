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
            size: 30.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
              size: 30.0,
            ),
          ),
        ),
        Icon(
          Icons.calendar_today_outlined,
          color: FlutterFlowTheme.of(context).primary,
          size: 30.0,
        ),
        const SizedBox(
          width: 15,
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
                        padding: const EdgeInsetsDirectional.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                                fontSize: 16.0,
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
                const SizedBox(
                  height: 15,
                ),
                Text(
                  item.sender?.name ?? '',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14.0,
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
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      item.comment ?? '',
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto',
                            color: Colors.black,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
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
                          fontSize: 14.0,
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

            return SizedBox();
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _notifier.msgController,
                decoration: AppStyles.inputDecoration(context,
                    focusColor: FlutterFlowTheme.of(context).alternate,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: 20,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    hint: FFLocalizations.of(context).getText(
                      '0lw6g9ud' /* Type new message */,
                    )),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                _notifier.sendMsg(context);
              },
              child: Icon(
                Icons.send_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: 24.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  String getdate(ChatHistoryModel item) => DateFormat('dd MMM yyyy').format(item.createdAt!);
}
