import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/proposals/chat/chat_history.dart';
import 'package:kleber_bank/proposals/proposal_controller.dart';
import 'package:kleber_bank/proposals/proposal_model.dart';
import 'package:kleber_bank/proposals/view_proposal.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/searchable_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../utils/api_calls.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/app_widgets.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';

class Proposals extends StatefulWidget {
  const Proposals({super.key});

  @override
  State<Proposals> createState() => _ProposalsState();
}

class _ProposalsState extends State<Proposals> with AutomaticKeepAliveClientMixin {
  late ProposalController _notifier;
  int _pageKey = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
    ProposalController notifier = Provider.of<ProposalController>(context, listen: false);
    notifier.pagingController.addPageRequestListener((pageKey) {
      _fetchPageActivity(notifier);
    });
    super.initState();
  }

  Future<void> _fetchPageActivity(ProposalController notifier) async {
    notifier.getProposalTypes(context);
    List<ProposalModel> list = await ApiCalls.getProposalList(
        _pageKey, notifier.proposalName!, notifier.advisorName!, notifier.selectedProposalType, notifier.column, notifier.direction, context);
    final isLastPage = list.length < 10;
    if (isLastPage) {
      notifier.pagingController.appendLastPage(list);
    } else {
      _pageKey++;
      notifier.pagingController.appendPage(list, _pageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<ProposalController>(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: isPortraitMode?rSize * 0.35:rSize*0.25,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/proposal_bg.png',
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top + rSize * 0.01,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: rSize * 0.015),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(rSize * 0.01),
                        child: Image.asset(
                          'assets/advisor.png',
                          height: rSize * 0.07,
                          width: rSize * 0.07,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: rSize * 0.015),
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'hello',
                        ),
                        style: FlutterFlowTheme.of(context).displaySmall.override(

                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: rSize * 0.018,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: rSize * 0.05, right: rSize * 0.05),
                      child: Row(
                        children: [
                          cell(
                            'filter.png',
                            '  ${FFLocalizations.of(context).getText(
                              'filter',
                            )}',
                            () {
                              openFilterDialog();
                            },
                          ),
                          SizedBox(
                            width: rSize * 0.03,
                          ),
                          cell(
                            'sort.png',
                            '  ${FFLocalizations.of(context).getText(
                              'sort',
                            )}',
                            () {
                              openSortBottomSheet();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: RefreshIndicator(
              onRefresh: () async {
                _pageKey = 1;
                _notifier.pagingController.refresh();
              },
              child: PagedListView<int, ProposalModel>(
                pagingController: _notifier.pagingController,
                // shrinkWrap: true,
                padding: EdgeInsets.only(left: rSize * 0.015, right: rSize * 0.015, bottom: 80, top: rSize * 0.015),
                builderDelegate: PagedChildBuilderDelegate<ProposalModel>(noItemsFoundIndicatorBuilder: (context) {
                  return AppWidgets.emptyView(
                      FFLocalizations.of(context).getText(
                        'no_proposals_found',
                      ),
                      context);
                }, itemBuilder: (context, item, index) {
                  String date = DateFormat('yyyy-MM-dd HH:mm').format(item.updatedAt!);

                  return Container(
                    decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: AppStyles.shadow(),
                        borderRadius: BorderRadius.circular(rSize * 0.01)),
                    margin: EdgeInsets.symmetric(vertical: rSize * 0.005),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(rSize * 0.015),
                      children: [
                        Column(
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () => _notifier.selectTransactionIndex(index),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    item.name!,
                                    style: FlutterFlowTheme.of(context).displaySmall.override(
                                          color: FlutterFlowTheme.of(context).customColor4,
                                          fontSize: rSize * 0.016,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  )),
                                  SizedBox(
                                    width: rSize * 0.015,
                                  ),
                                  Icon(
                                    item.state == 'Accepted'
                                        ? Icons.done_rounded
                                        : item.state == 'Rejected'
                                            ? Icons.close_rounded
                                            : null,
                                    color: item.state == 'Accepted'
                                        ? FlutterFlowTheme.of(context).customColor2
                                        : FlutterFlowTheme.of(context).customColor3,
                                    size: rSize * 0.020,
                                  ),
                                  SizedBox(
                                    width: rSize * 0.015,
                                  ),
                                  RotatedBox(quarterTurns: _notifier.selectedIndex == index ? 3 : 2, child: AppWidgets.doubleBack(context)),
                                ],
                              ),
                            ),
                            if (_notifier.selectedIndex == index) ...{
                              ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(top: rSize * 0.015),
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.advisor?.name ?? '',
                                        textAlign: TextAlign.end,
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              fontSize: rSize * 0.016,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      SizedBox(
                                        height: rSize * 0.005,
                                      ),
                                      AppWidgets.portfolioListElement(
                                          context,
                                          FFLocalizations.of(context).getText(
                                            '99qsbuko' /* Last update */,
                                          ),
                                          date),
                                      SizedBox(
                                        height: rSize * 0.01,
                                      ),
                                      GestureDetector(
                                          onTap: () => CommonFunctions.navigate(
                                              context,
                                              ViewProposal(
                                                item.documentId!,
                                                index: index,
                                                item: item,
                                              )),
                                          child: AppWidgets.btn(
                                              context,
                                              FFLocalizations.of(context).getText(
                                                'ke604v9b' /* Read proposal */,
                                              ),
                                              bgColor: FlutterFlowTheme.of(context).primary)),
                                      SizedBox(
                                        height: rSize * 0.01,
                                      ),
                                      if (item.requestProposalApproval!) ...{
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Transform.scale(
                                              scale: isTablet?2:0.8,
                                              child: Checkbox(
                                                value: item.state != 'Pending' || item.isChecked,
                                                activeColor: FlutterFlowTheme.of(context).primary,
                                                side: BorderSide(
                                                  width: 2,
                                                  color: FlutterFlowTheme.of(context).customColor4,
                                                ),
                                                checkColor: !((item.state != 'Rejected') && (item.state != 'Accepted'))
                                                    ? FlutterFlowTheme.of(context).secondaryBackground
                                                    : FlutterFlowTheme.of(context).customColor4,
                                                onChanged: (value) {
                                                  if (item.state == 'Pending') {
                                                    item.isChecked = !item.isChecked;
                                                    setState(() {});
                                                  }
                                                },
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
                                        SizedBox(
                                          height: rSize * 0.01,
                                        )
                                      },
                                      // if (item.requestProposalApproval!) ...{
                                      if (item.state == 'Rejected') ...{
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.close_rounded,
                                              color: FlutterFlowTheme.of(context).customColor3,
                                              size: rSize * 0.024,
                                            ),
                                            Text(
                                              '  ${FFLocalizations.of(context).getText(
                                                'rejected',
                                              )}',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(

                                                    color: FlutterFlowTheme.of(context).customColor3,
                                                    fontSize: rSize * 0.016,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          ],
                                        )
                                      } else if (item.state == 'Accepted') ...{
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.done_rounded,
                                              color: FlutterFlowTheme.of(context).customColor2,
                                              size: rSize * 0.024,
                                            ),
                                            Text(
                                              '  ${FFLocalizations.of(context).getText(
                                                'c64nnx2a' /* Accepted at  */,
                                              )} ${DateFormat('yyyy-MM-dd HH:mm').format(item.acceptedDate!)}',
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(

                                                    color: FlutterFlowTheme.of(context).customColor2,
                                                    fontSize: rSize * 0.016,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          ],
                                        )
                                      } else if (item.requestProposalApproval! && item.state == 'Pending') ...{
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: rSize * 0.02,
                                            ),
                                            Expanded(
                                                child: GestureDetector(
                                              onTap: ()
                                              {
                                                if(!item.isChecked){
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
                                                  _notifier.updateState(
                                                    'rejected',
                                                    item.id,
                                                    index,
                                                    context,
                                                  );
                                                },
                                                    btn1BgColor: FlutterFlowTheme.of(context).customColor3,
                                                    btn2BgColor: FlutterFlowTheme.of(context).customColor2);
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
                                              onTap: ()
                                              {
                                                if(!item.isChecked){
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
                                                  _notifier.updateState('accepted', item.id, index, context);
                                                },
                                                    btn1BgColor: FlutterFlowTheme.of(context).customColor3,
                                                    btn2BgColor: FlutterFlowTheme.of(context).customColor2);
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
                                        )
                                      },
                                      // },
                                      SizedBox(
                                        height: rSize * 0.025,
                                      ),
                                      if((item.advisor?.phoneOffice??'').isNotEmpty)...{
                                        proposalElement(
                                          '   ${FFLocalizations.of(context).getText(
                                            'fbk0uba7' /* Call your advisor */,
                                          )}',
                                          Icons.call,
                                              () async {
                                            await launchUrl(Uri(
                                              scheme: 'tel',
                                              path: item.advisor?.phoneOffice,
                                            ));
                                          },
                                        ),
                                        SizedBox(
                                          height: rSize * 0.01,
                                        ),
                                        AppWidgets.divider(context)
                                      }
                                      ,
                                      SizedBox(
                                        height: rSize * 0.01,
                                      ),
                                      proposalElement(
                                        '   ${FFLocalizations.of(context).getText(
                                          'pkkj5rta' /* Chat with your Advisor */,
                                        )}',
                                        Icons.chat_outlined,
                                        () {
                                          CommonFunctions.navigate(context, ChatHistory(item));
                                        },
                                      ),
                                      SizedBox(
                                        height: rSize * 0.01,
                                      ),
                                      /*AppWidgets.divider(context),
                                          SizedBox(
                                            height: rSize * 0.01,
                                          ),
                                          proposalElement(
                                            '   ${FFLocalizations.of(context).getText(
                                              'lq59qmsn',
                                            )}',
                                            Icons.calendar_month,
                                            () {},
                                          ),
                                          SizedBox(
                                            height: rSize * 0.01,
                                          ),
                                          AppWidgets.divider(context),*/
                                    ],
                                  ),
                                ],
                              ),
                            }
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openFilterDialog() {
    String? selectedProposal = _notifier.selectedProposalType;
    TextEditingController advisorController = TextEditingController(text: _notifier.advisorName);
    TextEditingController proposalNameController = TextEditingController(text: _notifier.proposalName);

    showDialog(
      useRootNavigator: true,
      // isScrollControlled: true,
      context: context,
      // backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      builder: (context) {
        return Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(color: FlutterFlowTheme.of(context).primaryBackground, borderRadius: BorderRadius.circular(rSize*0.01)),
                  margin: EdgeInsets.symmetric(horizontal: rSize * 0.015),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      Provider.of<ProposalController>(context, listen: false).getProposalTypes(context);
                      _notifier = Provider.of<ProposalController>(context);
                      return Wrap(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                                left: rSize * 0.02,
                                right: rSize * 0.02,
                                top: rSize * 0.03,
                                bottom: MediaQuery.of(context).viewInsets.bottom + rSize * 0.03),
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: AppWidgets.title(context,
                                    FFLocalizations.of(context).getText(
                                      'filter' /* Filter */,
                                    ))),
                                  GestureDetector(
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
                              AppWidgets.label(
                                  context,
                                  FFLocalizations.of(context).getText(
                                    'uvch601w' /* Advisor */,
                                  )),
                              SizedBox(
                                height: rSize * 0.01,
                              ),
                              TextFormField(
                                controller: advisorController,
                                style: AppStyles.inputTextStyle(context),
                                decoration: AppStyles.inputDecoration(
                                  context,
                                  focusColor: FlutterFlowTheme.of(context).alternate,
                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  contentPadding: EdgeInsets.all(rSize * 0.015),
                                  labelStyle: FlutterFlowTheme.of(context).labelLarge.override(

                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: rSize * 0.02,
                              ),
                              AppWidgets.label(
                                  context,
                                  FFLocalizations.of(context).getText(
                                    'rvrrcr87' /* Proposal Name */,
                                  )),
                              SizedBox(
                                height: rSize * 0.01,
                              ),
                              TextFormField(
                                controller: proposalNameController,
                                style: AppStyles.inputTextStyle(context),
                                decoration: AppStyles.inputDecoration(
                                  context,
                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  focusColor: FlutterFlowTheme.of(context).alternate,
                                  contentPadding: EdgeInsets.all(rSize * 0.015),
                                  labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: rSize * 0.02,
                              ),
                              AppWidgets.label(
                                  context,
                                  FFLocalizations.of(context).getText(
                                    '4n2ah71g' /* Types */,
                                  )),
                              SizedBox(
                                height: rSize * 0.01,
                              ),
                              SearchableDropdown(
                                  selectedValue: selectedProposal,
                                  searchHint: FFLocalizations.of(context).getText(
                                    'i76kvnmi' /* Search for ... */,
                                  ),
                                  onChanged: (p0) {
                                    selectedProposal = p0;
                                  },
                                  items: _notifier.typesList
                                      .map((item) => DropdownMenuItem(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: AppStyles.inputTextStyle(context),
                                            ),
                                          ))
                                      .toList(),
                                  searchMatchFn: (item, searchValue) => CommonFunctions.compare(searchValue, item.value.toString())),
                              SizedBox(
                                height: rSize * 0.02,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                        onTap: () async {
                                          _notifier.advisorName = '';
                                          _notifier.proposalName = '';
                                          _notifier.selectedProposalType = null;
                                          _pageKey = 1;
                                          _notifier.pagingController.refresh();
                                          Navigator.pop(context);
                                        },
                                        child: AppWidgets.btn(
                                            context,
                                            FFLocalizations.of(context).getText(
                                              'g7rr5vmv' /* CLEAR */,
                                            ),
                                            borderOnly: true)),
                                  ),
                                  SizedBox(
                                    width: rSize * 0.02,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                        onTap: () async {
                                          _notifier.advisorName = advisorController.text;
                                          _notifier.proposalName = proposalNameController.text;
                                          _notifier.selectedProposalType = selectedProposal;
                                          _pageKey = 1;
                                          /*_notifier.selectedFilterList.removeWhere((element) =>
                                              element.type == FilterTypes.ADVISOR.name ||
                                              element.type == FilterTypes.PROPOSAL_NAME.name ||
                                              element.type == FilterTypes.PROPOSAL_TYPE.name);
                                          _notifier.selectedFilterList.add(FilterModel(_notifier.advisorName!, FilterTypes.ADVISOR.name));
                                          _notifier.selectedFilterList.add(FilterModel(_notifier.proposalName!, FilterTypes.PROPOSAL_NAME.name));
                                          _notifier.selectedFilterList.add(FilterModel(_notifier.selectedProposalType!, FilterTypes.PROPOSAL_TYPE.name));*/
                                          _notifier.pagingController.refresh();
                                          Navigator.pop(context);
                                        },
                                        child: AppWidgets.btn(
                                            context,
                                            FFLocalizations.of(context).getText(
                                              'lmndaaco' /* Apply */,
                                            ),
                                            bgColor: FlutterFlowTheme.of(context).primary)),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void openSortBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Wrap(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: rSize * 0.015),
                  decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(rSize * 0.020), topRight: Radius.circular(rSize * 0.020))),
                  child: Column(
                    children: [
                      AppWidgets.title(context,
                        FFLocalizations.of(context).getText(
                          'sort' /* sort */,
                        )),
                      Container(
                        height: 0.5,
                        margin: EdgeInsets.symmetric(vertical: rSize * 0.0075),
                        width: double.infinity,
                        color: AppColors.kHint,
                      ),
                      sortDialogElement(0, _notifier.sortList[0], context),
                      sortDialogElement(1, _notifier.sortList[1], context),
                      sortDialogElement(2, _notifier.sortList[2], context),
                      sortDialogElement(3, _notifier.sortList[3], context),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget sortDialogElement(int value, String label, BuildContext context) {
    final bool isTablet = (MediaQuery.of(context).size.width > 600);
    return SizedBox(
      height: rSize * 0.050,
      child: Row(
        children: [
          SizedBox(
            width: isTablet ? rSize * 0.015 : 0,
          ),
          Theme(
            data: ThemeData(unselectedWidgetColor: FlutterFlowTheme.of(context).customColor4),
            child: Transform.scale(
              scale: rSize * 0.0012,
              child: Radio(
                activeColor: FlutterFlowTheme.of(context).customColor4,
                value: value,
                fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return FlutterFlowTheme.of(context).customColor4;
                  }
                  return FlutterFlowTheme.of(context).customColor4;
                }),
                groupValue: _notifier.selectedSortIndex,
                onChanged: (p0) {
                  _notifier.selectedSortIndex = value;
                  if (value == 0) {
                    _notifier.direction = 'desc';
                    _notifier.column = 'created_at';
                  } else if (value == 1) {
                    _notifier.direction = 'asc';
                    _notifier.column = 'created_at';
                  } else if (value == 2) {
                    _notifier.direction = 'asc';
                    _notifier.column = 'name';
                  } else if (value == 3) {
                    _notifier.direction = 'desc';
                    _notifier.column = 'name';
                  }
                  _notifier.selectedFilterList.removeWhere(
                    (element) => element.type == FilterTypes.SORT.name,
                  );
                  _notifier.selectedFilterList.add(FilterModel(_notifier.sortList[value], FilterTypes.SORT.name));
                  _pageKey = 1;
                  _notifier.pagingController.refresh();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          SizedBox(
            width: isTablet ? rSize * 0.01 : 0,
          ),
          Expanded(
              child: AppWidgets.label(
                  context,
                  label,
                  )),
        ],
      ),
    );
  }

  Widget proposalElement(String title, IconData iconData, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            iconData,
            color: FlutterFlowTheme.of(context).customColor4,
            size: rSize * 0.02,
          ),
          Expanded(
              child: Text(
            title,
            style: FlutterFlowTheme.of(context).bodyMedium.override(

                  color: FlutterFlowTheme.of(context).customColor4,
                  fontSize: rSize * 0.016,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.normal,
                ),
          )),
          RotatedBox(
              quarterTurns: 2,
              child: Icon(
                Icons.arrow_back_ios_new,
                color: FlutterFlowTheme.of(context).customColor4,
                size: rSize * 0.015,
              ))
        ],
      ),
    );
  }

  Expanded cell(String img, String label, void Function()? onTap) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(rSize * 0.01),
        decoration: AppWidgets.gradiantDecoration(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/$img',
              color: FlutterFlowTheme.of(context).secondaryBackground,
              height: rSize * 0.02,
              width: rSize * 0.02,
            ),
            Text(
              label,
              style: FlutterFlowTheme.of(context).displaySmall.override(

                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    fontSize: rSize * 0.014,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
