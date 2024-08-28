import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kleber_bank/proposals/proposal_controller.dart';
import 'package:kleber_bank/proposals/proposal_model.dart';
import 'package:kleber_bank/proposals/view_document.dart';
import 'package:kleber_bank/proposals/view_proposal.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/searchable_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    },);
    ProposalController notifier = Provider.of<ProposalController>(context, listen: false);
    notifier.pagingController.addPageRequestListener((pageKey) {
      _fetchPageActivity(notifier);
    });
    super.initState();
  }

  Future<void> _fetchPageActivity(ProposalController notifier) async {
    notifier.getProposalTypes(context);
    List<ProposalModel> list = await ApiCalls.getProposalList(
        _pageKey, notifier.proposalName!, notifier.advisorName!, notifier.selectedProposalType, notifier.column, notifier.direction,context);
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
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: rSize * 0.05, right: rSize * 0.05, bottom: rSize * 0.02, top: MediaQuery.of(context).padding.top+10),
            child: Row(
              children: [
                cell(
                  'filter.png',
                  '  ${FFLocalizations.of(context).getText(
                    'filter' /* FILTER */,
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
                    'sort' /* Last update */,
                  )}',
                  () {
                    openSortBottomSheet();
                  },
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
                padding: EdgeInsets.symmetric(horizontal: rSize * 0.015),
                builderDelegate: PagedChildBuilderDelegate<ProposalModel>(noItemsFoundIndicatorBuilder: (context) {
                  return const SizedBox();
                }, itemBuilder: (context, item, index) {
                  String date = DateFormat('yyyy-MM-dd HH:mm').format(item.updatedAt!);
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: rSize * 0.005),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(rSize * 0.015),
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => _notifier.selectTransactionIndex(index),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    item.name!,
                                    style: FlutterFlowTheme.of(context).displaySmall.override(
                                          fontFamily: 'Roboto',
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  )),
                                  SizedBox(
                                    width: rSize * 0.015,
                                  ),
                                  if ((item.state ?? 'Pending') != 'Pending') ...{
                                    Icon(
                                      item.state == 'Accepted' ? Icons.done_rounded : Icons.close_rounded,
                                      color: item.state == 'Accepted'
                                          ? FlutterFlowTheme.of(context).customColor2
                                          : FlutterFlowTheme.of(context).customColor3,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: rSize * 0.015,
                                    ),
                                  },
                                  RotatedBox(
                                      quarterTurns: _notifier.selectedIndex == index ? 1 : 3,
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        size: 15,
                                      )),
                                ],
                              ),
                            ),
                            if (_notifier.selectedIndex == index) ...{
                              ListView(
                                shrinkWrap: true,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.advisor?.name ?? '',
                                        textAlign: TextAlign.end,
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Roboto',
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
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
                                          onTap: () => CommonFunctions.navigate(context, ViewProposal(item.documentId!,showAcceptReject: item.state == 'Pending',index: index,item: item,)),
                                          child: AppWidgets.btn(
                                              context,
                                              FFLocalizations.of(context).getText(
                                                'ke604v9b' /* Read proposal */,
                                              ),
                                              bgColor: FlutterFlowTheme.of(context).primary)),
                                      SizedBox(
                                        height: rSize * 0.01,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            value: item.state != 'Pending' || item.isChecked,
                                            activeColor: FlutterFlowTheme.of(context).primary,
                                            side: BorderSide(
                                              width: 2,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                            ),
                                            checkColor: !((item.state != 'Rejected') && (item.state != 'Accepted'))
                                                ? FlutterFlowTheme.of(context).secondaryBackground
                                                : FlutterFlowTheme.of(context).info,
                                            onChanged: (value) {
                                              if (item.state == 'Pending') {
                                                item.isChecked = !item.isChecked;
                                                setState(() {});
                                              }
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              FFLocalizations.of(context).getText(
                                                'prtogarh' /* I read the documents and agree... */,
                                              ),
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Roboto',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: rSize * 0.01,
                                      ),
                                      if (item.state == 'Pending') ...{
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: rSize * 0.02,
                                            ),
                                            Expanded(
                                                child: GestureDetector(
                                              onTap: () => AppWidgets.showAlert(
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
                                                _notifier.updateState('rejected',  item.id, index, context,);
                                              },
                                                  btn1BgColor: FlutterFlowTheme.of(context).customColor3,
                                                  btn2BgColor: FlutterFlowTheme.of(context).customColor2),
                                              child: AppWidgets.btnWithIcon(
                                                  context,
                                                  '  ${FFLocalizations.of(context).getText(
                                                    'j0hr735r' /* Decline*/,
                                                  )}',
                                                  FlutterFlowTheme.of(context).customColor3,
                                                  Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  )),
                                            )),
                                            SizedBox(
                                              width: rSize * 0.02,
                                            ),
                                            Expanded(
                                                child: GestureDetector(
                                              onTap: () => AppWidgets.showAlert(
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
                                                  btn2BgColor: FlutterFlowTheme.of(context).customColor2),
                                              child: AppWidgets.btnWithIcon(
                                                  context,
                                                  '  ${FFLocalizations.of(context).getText(
                                                    '3esw1ind' /* Accept */,
                                                  )}',
                                                  FlutterFlowTheme.of(context).customColor2,
                                                  Icon(
                                                    Icons.done,
                                                    color: Colors.white,
                                                  )),
                                            )),
                                            SizedBox(
                                              width: rSize * 0.02,
                                            ),
                                          ],
                                        )
                                      } else if (item.state == 'Accepted') ...{
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.done_rounded,
                                              color: FlutterFlowTheme.of(context)
                                                  .customColor2,
                                              size: 24.0,
                                            ),
                                            Text(
                                              '  ${FFLocalizations.of(context).getText(
                                                'c64nnx2a' /* Accepted at  */,
                                              )} $date',
                                              style: AppStyles.c3C496CW400S14.copyWith(color: Colors.green),
                                            ),
                                          ],
                                        )
                                      } else ...{
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.close_rounded,
                                              color: FlutterFlowTheme.of(context)
                                                  .customColor3,
                                              size: 24.0,
                                            ),
                                            Text(
                                              '  ${FFLocalizations.of(context).getText(
                                                '5tjloy3c' /* Rejected at */,
                                              )} $date',
                                              style: AppStyles.c3C496CW400S14.copyWith(color: Colors.red),
                                            ),
                                          ],
                                        )
                                      },
                                      SizedBox(
                                        height: rSize * 0.025,
                                      ),
                                      proposalElement('   ${FFLocalizations.of(context).getText(
                                        'fbk0uba7' /* Call your advisor */,
                                      )}', Icons.call,() async {
                                        await launchUrl(Uri(
                                          scheme: 'tel',
                                          path: item.advisor?.phoneOffice,
                                        ));
                                      },),
                                      /*SizedBox(
                                        height: rSize * 0.01,
                                      ),
                                      AppWidgets.divider(context),
                                      SizedBox(
                                        height: rSize * 0.01,
                                      ),
                                      proposalElement('   ${FFLocalizations.of(context).getText(
                                        'pkkj5rta' *//* Chat with your Advisor *//*,
                                      )}', Icons.chat_outlined,() {

                                      },),
                                      SizedBox(
                                        height: rSize * 0.01,
                                      ),
                                      AppWidgets.divider(context),
                                      SizedBox(
                                        height: rSize * 0.01,
                                      ),
                                      proposalElement('   ${FFLocalizations.of(context).getText(
                                        'lq59qmsn' ,
                                      )}', Icons.calendar_month,() {

                                      },),
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
          )
        ],
      ),
    );
  }

  void openFilterDialog() {
    String? selectedProposal = _notifier.selectedProposalType;
    TextEditingController advisorController = TextEditingController(text: _notifier.advisorName);
    TextEditingController proposalNameController = TextEditingController(text: _notifier.proposalName);
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Provider.of<ProposalController>(context, listen: false).getProposalTypes(context);
            _notifier = Provider.of<ProposalController>(context);
            return Wrap(
              children: [
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      left: rSize * 0.02, right: rSize * 0.02, top: rSize * 0.03, bottom: MediaQuery.of(context).viewInsets.bottom + rSize * 0.03),
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          FFLocalizations.of(context).getText(
                            'filter' /* Filter */,
                          ),
                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Roboto',
                                color: FlutterFlowTheme.of(context).primary,
                                fontSize: 26.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                        )),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: rSize * 0.02,
                    ),
                    Text(
                      FFLocalizations.of(context).getText(
                        'uvch601w' /* Advisor */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(
                      height: rSize * 0.01,
                    ),
                    TextFormField(
                      controller: advisorController,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Roboto',
                            letterSpacing: 0.0,
                          ),
                      decoration: AppStyles.inputDecoration(
                        context,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding: EdgeInsets.all(15),
                        labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                              fontFamily: 'Roboto',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: rSize * 0.02,
                    ),
                    Text(
                      FFLocalizations.of(context).getText(
                        'rvrrcr87' /* Proposal Name */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(
                      height: rSize * 0.01,
                    ),
                    TextFormField(
                      controller: proposalNameController,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Roboto',
                            letterSpacing: 0.0,
                          ),
                      decoration: AppStyles.inputDecoration(
                        context,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding: EdgeInsets.all(15),
                        labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                              fontFamily: 'Roboto',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: rSize * 0.02,
                    ),
                    Text(
                      FFLocalizations.of(context).getText(
                        '4n2ah71g' /* Types */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                      ),
                    ),
                    SizedBox(
                      height: rSize * 0.01,
                    ),
                    SearchableDropdown(selectedValue: selectedProposal, searchHint: '', onChanged: (p0) {
                      selectedProposal = p0;
                    }, items: _notifier.typesList
                        .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Roboto',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ))
                        .toList(), searchMatchFn: (item, searchValue) => CommonFunctions.compare(searchValue, item.value.toString()))
                    ,
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
                              child: AppWidgets.btn(context, FFLocalizations.of(context).getText(
                                'zw535eku' /* CLEAR */,
                              ), borderOnly: true)),
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
                                _notifier.selectedFilterList.removeWhere((element) =>
                                    element.type == FilterTypes.ADVISOR.name ||
                                    element.type == FilterTypes.PROPOSAL_NAME.name ||
                                    element.type == FilterTypes.PROPOSAL_TYPE.name);
                                _notifier.selectedFilterList.add(FilterModel(_notifier.advisorName!, FilterTypes.ADVISOR.name));
                                _notifier.selectedFilterList.add(FilterModel(_notifier.proposalName!, FilterTypes.PROPOSAL_NAME.name));
                                _notifier.selectedFilterList.add(FilterModel(_notifier.selectedProposalType!, FilterTypes.PROPOSAL_TYPE.name));
                                _notifier.pagingController.refresh();
                                Navigator.pop(context);
                              },
                              child: AppWidgets.btn(context, FFLocalizations.of(context).getText(
                                'r8wu2qe3' /* Apply */,
                              ),bgColor: FlutterFlowTheme.of(context).primary)),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            );
          },
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
                      color: FlutterFlowTheme.of(context).secondaryBackground, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          'sort' /* sort */,
                        ),
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Roboto',
                          color: FlutterFlowTheme.of(context).primary,
                          fontSize: 26.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Row sortDialogElement(int value, String label, BuildContext context) {
    return Row(
      children: [
        Theme(
          data: ThemeData(unselectedWidgetColor: FlutterFlowTheme.of(context).primaryText),
          child: Radio(
            activeColor: FlutterFlowTheme.of(context).primary,
            value: value,
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
        Expanded(
            child: Text(
          label,
              style: FlutterFlowTheme.of(context).displaySmall.override(
                fontFamily: 'Roboto',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
        )),
      ],
    );
  }

  Widget proposalElement(String title, IconData iconData,void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            iconData,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 20,
          ),
          Expanded(
              child: Text(
            title,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.normal,
                ),
          )),
          RotatedBox(
              quarterTurns: 2,
              child: Icon(
                Icons.arrow_back_ios_new,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 15,
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
        decoration: BoxDecoration(color: FlutterFlowTheme.of(context).primary, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/$img',
              color: FlutterFlowTheme.of(context).secondaryBackground,
              scale: 25,
            ),
            Text(
              label,
              style: FlutterFlowTheme.of(context).displaySmall.override(
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    fontSize: 14.0,
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
