import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/proposals/chat/chat_history_model.dart';
import 'package:kleber_bank/proposals/proposal_model.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../login/user_info_model.dart';
import '../../main.dart';
import '../../utils/api_calls.dart';
import '../../utils/flutter_flow_theme.dart';
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
  User? user;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
    user = SharedPrefUtils.instance.getUserData().user!;
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
  void dispose() {
    _notifier.chatHistoryPagingController.itemList?.clear();
    _notifier.chatHistoryPagingController = PagingController(firstPageKey: 1);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    c = context;
    _notifier = Provider.of<ProposalController>(context);
    return Scaffold(
      appBar: AppWidgets.appBar(context, widget.model.advisor?.name ?? '',
          leading: AppWidgets.backArrow(context),
          subTitle: "Relationship manager",
          actions: [
            AppWidgets.click(
                onTap: () {},
                child: Icon(
                  FontAwesomeIcons.user,
                  size: rSize * 0.02,
                  color: FlutterFlowTheme.of(context).customColor4,
                )),
            SizedBox(
              width: rSize * 0.015,
            )
          ]),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(border: Border()),
        child: Column(
          children: [
            AppWidgets.click(
              onTap: () {
                showLanguageDialog(context);
              },
              child: Container(
                margin:
                    EdgeInsets.only(top: rSize * 0.01, bottom: rSize * 0.01),
                padding: EdgeInsets.all(rSize * 0.007),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(rSize * 0.02),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      height: rSize * 0.02,
                      width: rSize * 0.02,
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'icons/flags/png100px/${getLanguageList()[_notifier.selectedCountryIndex]['code']}.png',
                        package: 'country_icons',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      ' ${getLanguageList()[_notifier.selectedCountryIndex]['name']}',
                      style: AppStyles.inputTextStyle(context),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: PagedListView<int, ChatHistoryModel>.separated(
                pagingController: _notifier.chatHistoryPagingController,
                reverse: true,
                padding: EdgeInsets.only(bottom: rSize * 0.01),
                builderDelegate: PagedChildBuilderDelegate<ChatHistoryModel>(
                    noItemsFoundIndicatorBuilder: (context) => SizedBox(),
                    firstPageProgressIndicatorBuilder: (context) => skeleton(),
                    itemBuilder: (BuildContext context, ChatHistoryModel item,
                        int index) {
                      bool isLast = (item ==
                          _notifier.chatHistoryPagingController.itemList!.last);
                      return chatListItem(
                          isLast,
                          context,
                          isMe(item),
                          item.createdAt!,
                          isLast ||
                              (!isLast &&
                                  getdate(item.createdAt!) !=
                                      getdate(_notifier
                                          .chatHistoryPagingController
                                          .itemList![index + 1]
                                          .createdAt!)),
                          item.comment!);
                    }),
                separatorBuilder: (BuildContext context, int index) {
                  ChatHistoryModel item =
                      _notifier.chatHistoryPagingController.itemList![index];

                  return const SizedBox();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: rSize * 0.01, right: rSize * 0.01, top: rSize * 0.01),
              decoration: BoxDecoration(
                  color: _notifier.isDialogOpen()
                      ? FlutterFlowTheme.of(context).primaryBackground
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(rSize * 0.010)),
              child: Column(
                children: [
                  if (_notifier.isAttachmentClicked) ...{
                    cell(context, FontAwesomeIcons.paperclip, 'Take photo', () {
                      _notifier.takePhoto();
                    }),
                    divider(context),
                    cell(context, FontAwesomeIcons.paperclip, 'Select photo',
                        () {
                      _notifier.selectPhoto();
                    }),
                    divider(context),
                    cell(context, FontAwesomeIcons.paperclip, 'Select file',
                        () {
                      _notifier.selectFile();
                    }),
                  } else if (_notifier.isAddClicked) ...{
                    cell(context, FontAwesomeIcons.reply, 'Reply', () {}),
                    divider(context),
                    cell(context, FontAwesomeIcons.pencil, 'Edit last message',
                        () {}),
                    divider(context),
                    cell(context, FontAwesomeIcons.microphone,
                        'Tap & hold to send an audio message', () {}),
                    divider(context),
                    cell(context, FontAwesomeIcons.noteSticky,
                        'New contact report', () {}),
                    divider(context),
                    cell(context, FontAwesomeIcons.tasks, 'New task', () {}),
                    divider(context),
                    cell(context, FontAwesomeIcons.desktop,
                        'Look up for an helpdesk article', () {}),
                  },
                  SizedBox(
                    height: rSize * 0.01,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildContainer(
                        context,
                        FontAwesomeIcons.plus,
                        () {
                          _notifier.openPlusOptions();
                        },
                      ),
                      buildContainer(
                        context,
                        FontAwesomeIcons.paperclip,
                        () {
                          _notifier.openAttachmentOptions();
                        },
                      ),
                      Expanded(
                        child: Container(
                          height: rSize * 0.04,
                          margin: EdgeInsets.only(bottom: padding.bottom),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: AppStyles.shadow(),
                              borderRadius:
                                  BorderRadius.circular(rSize * 0.025)),
                          child: TextField(
                            controller: _notifier.msgController,
                            style: AppStyles.inputTextStyle(context),
                            decoration: AppStyles.inputDecoration(context,
                                hint: 'Write something...',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: rSize * 0.01,
                                    horizontal: rSize * 0.020),
                                focusColor: Colors.transparent),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                      AppWidgets.click(
                        onTap: () => _notifier.sendMsg(context),
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: padding.bottom, left: rSize * 0.01),
                          child: Icon(Icons.send_rounded,
                              color: FlutterFlowTheme.of(context).customColor4),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column chatListItem(bool isLast, BuildContext context, bool isMe,
      DateTime dateTime, bool showGroupingDate, String message) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (showGroupingDate) ...{
          Align(
            alignment: Alignment.center,
            child: AppWidgets.label(context, getdate(dateTime)),
          )
        },
        SizedBox(
          height: rSize * 0.015,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...{
              SizedBox(width: rSize * 0.005),
              photo(
                  isMe,
                  isMe
                      ? (user?.avatar ?? '')
                      : (widget.model.advisor?.avatar ?? '')),
            },
            if (!isMe) ...{
              SizedBox(width: rSize * 0.005),
            } else ...{
              SizedBox(width: rSize * 0.015),
            },
            Expanded(
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                      isMe
                          ? user!.client!.pseudonym!
                          : widget.model.advisor?.name ?? '',
                      style: AppStyles.inputTextStyle(context)),
                  Container(
                    padding: EdgeInsets.all(rSize * 0.005),
                    decoration: BoxDecoration(
                        color: !isMe
                            ? FlutterFlowTheme.of(context).alternate
                            : Color(0XFF1b88fb),
                        borderRadius: BorderRadius.circular(rSize * 0.008)),
                    child: Column(
                      children: [
                        Text(
                          message,
                          textAlign: TextAlign.start,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                color: !isMe
                                    ? FlutterFlowTheme.of(context).customColor4
                                    : FlutterFlowTheme.of(context).info,
                                fontWeight: FontWeight.w500,
                                fontSize: rSize * 0.016,
                              ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (!isMe) ...{
              SizedBox(width: rSize * 0.015),
            } else ...{
              SizedBox(width: rSize * 0.005),
            },
            if (isMe) ...{
              photo(
                  isMe,
                  isMe
                      ? (user?.avatar ?? '')
                      : (widget.model.advisor?.avatar ?? '')),
            },
          ],
        )
      ],
    );
  }

  List<Map<String, String>> getLanguageList() =>
      _notifier.filteredCountryNames.isNotEmpty
          ? _notifier.filteredCountryNames
          : _notifier.countryNames;

  Container divider(BuildContext context) {
    return Container(
      height: 0.3,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: rSize * 0.007),
      color: FlutterFlowTheme.of(context).customColor4,
    );
  }

  Widget buildContainer(
      BuildContext context, IconData iconData, void Function() onTap) {
    return AppWidgets.click(
      onTap: onTap,
      child: Container(
        height: rSize * 0.04,
        padding: EdgeInsets.all(rSize * 0.01),
        margin: EdgeInsets.only(bottom: padding.bottom, right: rSize * 0.01),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppStyles.shadow(),
            color: FlutterFlowTheme.of(context).info),
        child: Icon(
          iconData,
          color: FlutterFlowTheme.of(context).customColor4,
          size: rSize * 0.015,
        ),
      ),
    );
  }

  cell(BuildContext context, IconData iconData, String label,
      void Function() onTap) {
    return AppWidgets.click(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: FlutterFlowTheme.of(context).customColor4,
            size: rSize * 0.015,
          ),
          Expanded(child: AppWidgets.label(context, '   $label')),
          SizedBox(
            height: rSize * 0.035,
          )
        ],
      ),
    );
  }

  bool isMe(ChatHistoryModel item) =>
      item.sender?.id == SharedPrefUtils.instance.getUserData().user?.id;

  String getdate(DateTime createdAt) =>
      DateFormat('dd MMM yyyy').format(createdAt);

  Container photo(bool isMe, String url) {
    return Container(
      height: rSize * 0.04,
      width: rSize * 0.04,
      margin: EdgeInsets.only(
          left: !isMe ? rSize * 0.005 : 0,
          right: !isMe ? rSize * 0 : rSize * 0.005),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: FlutterFlowTheme.of(context).alternate),
      child: Image.network(
        url,
        errorBuilder: (context, error, stackTrace) => Icon(
          FontAwesomeIcons.user,
          color: FlutterFlowTheme.of(context).customColor4,
          size: rSize * 0.02,
        ),
      ),
    );
  }

  Future<void> showLanguageDialog(BuildContext context) async {
    _notifier.filteredCountryNames = [];
    _notifier.filteredCountryNames.addAll(_notifier.countryNames);
    await showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        _notifier = Provider.of<ProposalController>(context);
        return Container(
          margin: EdgeInsets.only(top: padding.top),
          padding: EdgeInsets.only(
            left: rSize * 0.015,
            right: rSize * 0.015,
            top: rSize * 0.02,
          ),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(rSize * 0.010)),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: AppWidgets.title(context, 'LANGUAGES')),
                    AppWidgets.click(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: rSize * 0.025,
                        color: FlutterFlowTheme.of(context).customColor4,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: rSize * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: AppStyles.shadow(),
                      borderRadius: BorderRadius.circular(rSize * 0.01)),
                  child: TextField(
                    style: AppStyles.inputTextStyle(context),
                    decoration: AppStyles.inputDecoration(context,
                        hint: 'Search...',
                        prefix: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: rSize * 0.015),
                          child: Icon(
                            Icons.search,
                            size: rSize * 0.025,
                            color: FlutterFlowTheme.of(context).customColor4,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: rSize * 0.017, horizontal: rSize * 0.020),
                        focusColor: Colors.transparent),
                    onChanged: (value) {
                      _notifier.search(value);
                    },
                  ),
                ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: rSize * 0.01),
                    separatorBuilder: (BuildContext context, int index) =>
                        Container(
                      height: rSize * 0.01,
                    ),
                    itemBuilder: (context, index) {
                      return AppWidgets.click(
                        onTap: () => _notifier.selectCountry(index, context),
                        child: Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              height: rSize * 0.02,
                              width: rSize * 0.02,
                              clipBehavior: Clip.hardEdge,
                              child: Image.asset(
                                'icons/flags/png100px/${_notifier.filteredCountryNames[index]['code']}.png',
                                package: 'country_icons',
                                fit: BoxFit.cover,
                              ),
                            ),
                            AppWidgets.label(context,
                                '  ${_notifier.filteredCountryNames[index]['name']}')
                          ],
                        ),
                      );
                    },
                    itemCount: _notifier.filteredCountryNames.length,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget skeleton() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          chatListItem(false, context, true, DateTime.now(), true,
              'asfe fgserg rd hgr thdt rhdrt htdr'),
          chatListItem(false, context, false, DateTime.now(), false,
              'asfe fgserg rd hgr thdt rhdrt htdr'),
          chatListItem(
              false, context, true, DateTime.now(), false, 'asfe fgserg rd '),
          chatListItem(false, context, true, DateTime.now(), false, 'asfe '),
          chatListItem(false, context, true, DateTime.now(), false,
              'asfe fgserg rd hgr thdt rhdrt htdr'),
          chatListItem(false, context, true, DateTime.now(), false,
              'asfe fgserg rd hgr thdt rhdrt htdr'),
          chatListItem(false, context, true, DateTime.now(), false, 'asfe fg'),
          chatListItem(false, context, true, DateTime.now(), false,
              'asfe fgserg rd hgr thdt '),
          chatListItem(
              true, context, true, DateTime.now(), false, 'asfe fgserg rd hgr'),
        ],
      ),
    );
  }
}
