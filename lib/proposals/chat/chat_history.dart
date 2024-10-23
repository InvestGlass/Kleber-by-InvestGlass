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
    ProposalController notifier =
        Provider.of<ProposalController>(context, listen: false);
    notifier.chatHistoryPagingController.addPageRequestListener((pageKey) {
      _fetchPageActivity(notifier);
    });
    super.initState();
  }

  Future<void> _fetchPageActivity(ProposalController notifier) async {
    notifier.getProposalTypes(context);
    List<ChatHistoryModel> list =
        await ApiCalls.getChatHistory(context, _pageKey);
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
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppWidgets.appBar(context, widget.model.advisor?.name ?? '',
          leading: AppWidgets.backArrow(context),
          actions: [
            AppStyles.iconBg(
              context,
              margin: EdgeInsets.only(
                top: rSize * 0.008,
                bottom: rSize * 0.008,
              ),
              color: FlutterFlowTheme.of(context).customColor4,
              data: Icons.refresh_rounded,
              onTap: () async {
                _pageKey = 1;
                _notifier.chatHistoryPagingController.refresh();
              },
              size: rSize * 0.025,
            ),
            AppStyles.iconBg(
              context,
              margin: EdgeInsets.only(
                top: rSize * 0.008,
                bottom: rSize * 0.008,
                left: rSize * 0.01,
              ),
              data: Icons.call_outlined,
              color: FlutterFlowTheme.of(context).customColor4,
              onTap: () async {
                await launchUrl(Uri(
                  scheme: 'tel',
                  path: widget.model.advisor?.phoneOffice,
                ));
              },
              size: rSize * 0.025,
            ),
            /*
        Icon(
          Icons.calendar_today_outlined,
          color: FlutterFlowTheme.of(context).primary,
          size: 30.0,
        ),*/
            SizedBox(
              width: rSize * 0.01,
            )
          ]),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(border: Border()),
        child: PagedListView<int, ChatHistoryModel>.separated(
          pagingController: _notifier.chatHistoryPagingController,
          reverse: true,
          padding: EdgeInsets.only(bottom: rSize*0.01),
          builderDelegate: PagedChildBuilderDelegate<ChatHistoryModel>(
              itemBuilder:
                  (BuildContext context, ChatHistoryModel item, int index) {
            bool isLast =
                (item == _notifier.chatHistoryPagingController.itemList!.last);
            return Column(
              crossAxisAlignment: isMe(item)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (isLast ||
                    (!isLast &&
                        getdate(item) !=
                            getdate(_notifier.chatHistoryPagingController
                                .itemList![index + 1]))) ...{
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1.0,
                          decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).customColor4,
                              boxShadow: AppStyles.shadow()),
                        ),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.all(rSize * 0.010),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(rSize * 0.020),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).customColor4,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          getdate(item),
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                color:
                                    FlutterFlowTheme.of(context).customColor4,
                                fontSize: rSize * 0.016,
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
                  height: rSize * 0.015,
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.9,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: rSize * 0.01),
                  decoration: BoxDecoration(
                    color: isMe(item)
                        ? FlutterFlowTheme.of(context).info
                        : FlutterFlowTheme.of(context)
                            .secondary
                            .withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(rSize * 0.008),
                      bottomRight: Radius.circular(rSize * 0.008),
                      topLeft: const Radius.circular(0.0),
                      topRight: Radius.circular(rSize * 0.008),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(rSize * 0.012),
                    child: Text(
                      item.comment!,
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            color: FlutterFlowTheme.of(context).customColor4,
                            fontWeight: FontWeight.w500,
                            fontSize: rSize * 0.016,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      rSize * 0.01, rSize * 0.005, rSize * 0.01, 0.0),
                  child: Text(
                    CommonFunctions.dateTimeFormat(
                      'HH:mm',
                      DateTime.fromMillisecondsSinceEpoch(
                          item.createdAt!.millisecondsSinceEpoch,
                          isUtc: true),
                      locale: FFLocalizations.of(context).languageCode,
                    ),
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          color: isMe(item)
                              ? FlutterFlowTheme.of(context).customColor4
                              : FlutterFlowTheme.of(context).secondaryText,
                          fontSize: rSize * 0.012,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
              ],
            );
          }),
          separatorBuilder: (BuildContext context, int index) {
            ChatHistoryModel item =
                _notifier.chatHistoryPagingController.itemList![index];

            return const SizedBox();
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        padding: EdgeInsets.only(
            left: rSize * 0.015, right: rSize * 0.015,top: rSize*0.01,bottom: MediaQuery.of(context).padding.bottom),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: AppStyles.shadow(),
                    borderRadius: BorderRadius.circular(rSize * 0.01)),
                child: TextFormField(
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontSize: rSize * 0.018,
                        color: FlutterFlowTheme.of(context).customColor4,
                        fontWeight: FontWeight.w500,
                      ),
                  controller: _notifier.msgController,
                  decoration: AppStyles.inputDecoration(context,
                      focusColor: Colors.transparent,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: rSize * 0.015, horizontal: rSize * 0.020),
                      hint: FFLocalizations.of(context).getText(
                        '0lw6g9ud' /* Type new message */,
                      )),
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  _notifier.sendMsg(context);
                },
                child: Wrap(
                  children: [
                    AppStyles.iconBg(
                      context,
                      data: Icons.send_rounded,
                      color: FlutterFlowTheme.of(context).customColor4,
                      size: rSize * 0.024,
                      margin: EdgeInsets.only(
                        top: rSize * 0.009,
                        bottom: rSize * 0.009,
                        left: rSize * 0.01,
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  bool isMe(ChatHistoryModel item) =>
      item.sender?.id == SharedPrefUtils.instance.getUserData().user?.id;

  String getdate(ChatHistoryModel item) =>
      DateFormat('dd MMM yyyy').format(item.createdAt!);
}
