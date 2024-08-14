import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kleber_bank/proposals/proposal_controller.dart';
import 'package:kleber_bank/proposals/proposal_model.dart';
import 'package:kleber_bank/proposals/view_document.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../utils/api_calls.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/app_widgets.dart';

class Proposals extends StatefulWidget {
  const Proposals({super.key});

  @override
  State<Proposals> createState() => _ProposalsState();
}

class _ProposalsState extends State<Proposals> {
  late ProposalController _notifier;
  final PagingController<int, ProposalModel> _pagingController = PagingController(firstPageKey: 1);
  int _pageKey = 1;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPageActivity();
    });
    super.initState();
  }

  Future<void> _fetchPageActivity() async {
    ProposalController notifier = Provider.of(context, listen: false);
    notifier.getProposalTypes();
    List<ProposalModel> list = await ApiCalls.getProposalList(
        _pageKey, notifier.proposalName!, notifier.advisorName!, notifier.selectedProposalType, notifier.column, notifier.direction);
    final isLastPage = list.length < 10;
    if (isLastPage) {
      _pagingController.appendLastPage(list);
    } else {
      _pageKey++;
      _pagingController.appendPage(list, _pageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<ProposalController>(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: rSize * 0.05, vertical: rSize * 0.01),
            child: Row(
              children: [
                cell(
                  'filter.png',
                  '  FILTER',
                  () {
                    openFilterDialog();
                  },
                ),
                SizedBox(
                  width: rSize * 0.03,
                ),
                cell(
                  'sort.png',
                  '  SORT',
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
                _pagingController.refresh();
              },
              child: PagedListView<int, ProposalModel>(
                pagingController: _pagingController,
                // shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: rSize*0.015),
                builderDelegate: PagedChildBuilderDelegate<ProposalModel>(noItemsFoundIndicatorBuilder: (context) {
                  return const SizedBox();
                }, itemBuilder: (context, item, index) {
                  String date = DateFormat('yyyy-MM-dd HH:mm').format(item.updatedAt!);
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: rSize * 0.005),
                    color: Colors.white,
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(rSize * 0.015),
                      children: [
                        GestureDetector(
                          onTap: () => _notifier.selectTransactionIndex(index),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    item.name!,
                                    style: AppStyles.c656262W500S16,
                                  )),
                                  SizedBox(
                                    width: rSize * 0.015,
                                  ),
                                  RotatedBox(
                                      quarterTurns: _notifier.selectedIndex == index ? 1 : 3,
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: AppColors.kTextFieldInput,
                                        size: 15,
                                      )),
                                ],
                              ),
                              if (_notifier.selectedIndex == index) ...{
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: rSize * 0.5,
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      SizedBox(
                                        height: rSize * 0.01,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.kViolate.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        padding: EdgeInsets.all(rSize * 0.015),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AppWidgets.portfolioListElement(context,item.advisor?.name ?? '', ''),
                                            SizedBox(
                                              height: rSize * 0.005,
                                            ),
                                            AppWidgets.portfolioListElement(context,'Last Update', date),
                                            SizedBox(
                                              height: rSize * 0.01,
                                            ),
                                            GestureDetector(
                                                onTap: () => CommonFunctions.navigate(context, ViewDocument(item.documentId!)),
                                                child: AppWidgets.btn(context,'Read Proposal')),
                                            SizedBox(
                                              height: rSize * 0.01,
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Checkbox(
                                                  value: item.state != 'Pending' || item.isChecked,
                                                  onChanged: (value) {
                                                    if (item.state == 'Pending') {
                                                      item.isChecked = !item.isChecked;
                                                      setState(() {});
                                                    }
                                                  },
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'I read the document and agree to the terms of proposal',
                                                    style: AppStyles.c656262W500S14,
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
                                                    onTap: () => AppWidgets.showAlert(context, 'Decline Proposal ?', 'Cancel', 'Confirm', () {
                                                      Navigator.pop(context);
                                                    }, () {
                                                      _notifier.updateState('rejected', _pagingController, item.id, index, context);
                                                    }),
                                                    child: AppWidgets.btnWithIcon(context,
                                                        '  Decline',
                                                        Colors.red,
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
                                                    onTap: () => AppWidgets.showAlert(context, 'Accept Proposal ?', 'Cancel', 'Confirm', () {
                                                      Navigator.pop(context);
                                                    }, () {
                                                      _notifier.updateState('accepted', _pagingController, item.id, index, context);
                                                    }),
                                                    child: AppWidgets.btnWithIcon(context,
                                                        '  Accept',
                                                        Colors.green,
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
                                                  const Icon(Icons.done, color: Colors.green, size: 20),
                                                  Text(
                                                    '  Accepted at $date',
                                                    style: AppStyles.c3C496CW400S14.copyWith(color: Colors.green),
                                                  ),
                                                ],
                                              )
                                            } else ...{
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                  Text(
                                                    '  Rejected at $date',
                                                    style: AppStyles.c3C496CW400S14.copyWith(color: Colors.red),
                                                  ),
                                                ],
                                              )
                                            },
                                            SizedBox(
                                              height: rSize * 0.025,
                                            ),
                                            proposalElement('   Call your Advisor', Icons.call),
                                            SizedBox(
                                              height: rSize * 0.01,
                                            ),
                                            AppWidgets.divider(),
                                            SizedBox(
                                              height: rSize * 0.01,
                                            ),
                                            proposalElement('   Chat with your Advisor', Icons.chat_outlined),
                                            SizedBox(
                                              height: rSize * 0.01,
                                            ),
                                            AppWidgets.divider(),
                                            SizedBox(
                                              height: rSize * 0.01,
                                            ),
                                            proposalElement('   Schedule Appointment', Icons.calendar_month),
                                            SizedBox(
                                              height: rSize * 0.01,
                                            ),
                                            AppWidgets.divider(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              }
                            ],
                          ),
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
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Provider.of<ProposalController>(context,listen: false).getProposalTypes();
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
                          'Filter',
                          style: AppStyles.c3C496CW500S18.copyWith(fontSize: AppStyles.px22),
                        )),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: AppColors.kTextFieldInput,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: rSize * 0.02,
                    ),
                    TextFormField(
                      controller: advisorController,
                      onChanged: (value) {},
                      decoration: AppStyles.inputDecoration(context,label: 'Advisor'),
                    ),
                    SizedBox(
                      height: rSize * 0.02,
                    ),
                    TextFormField(
                      controller: proposalNameController,
                      onChanged: (value) {},
                      decoration: AppStyles.inputDecoration(context,label: 'Proposal Name'),
                    ),
                    SizedBox(
                      height: rSize * 0.02,
                    ),
                    DropdownButtonFormField(
                      decoration: AppStyles.dropDownInputDecoration(context,AppWidgets.textFieldLabel('Types')),
                      isExpanded: true,
                      icon: AppWidgets.dropDownIcon(),
                      style: AppStyles.c3C496CW500S18,
                      isDense: true,
                      value: selectedProposal,
                      onChanged: (value) {
                        selectedProposal = value;
                      },
                      items: _notifier.typesList
                          .map(
                            (String item) => DropdownMenuItem<String>(value: item, child: AppWidgets.dropDownHint(context,item)),
                          )
                          .toList(),
                    ),
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
                                _pagingController.refresh();
                                Navigator.pop(context);
                              },
                              child: AppWidgets.btn(context,'CLEAR', borderOnly: true)),
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
                                _notifier.selectedFilterList.removeWhere((element) => element.type==FilterTypes.ADVISOR.name || element.type==FilterTypes.PROPOSAL_NAME.name || element.type==FilterTypes.PROPOSAL_TYPE.name);
                                _notifier.selectedFilterList.add(FilterModel(_notifier.advisorName!,FilterTypes.ADVISOR.name ));
                                _notifier.selectedFilterList.add(FilterModel(_notifier.proposalName!,FilterTypes.PROPOSAL_NAME.name ));
                                _notifier.selectedFilterList.add(FilterModel(_notifier.selectedProposalType!,FilterTypes.PROPOSAL_TYPE.name ));
                                _pagingController.refresh();
                                Navigator.pop(context);
                              },
                              child: AppWidgets.btn(context,'APPLY')),
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
                      color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      Text(
                        'SORT',
                        style: AppStyles.c656262W500S20,
                      ),
                      Container(
                        height: 0.5,
                        margin: EdgeInsets.symmetric(vertical: rSize * 0.0075),
                        width: double.infinity,
                        color: AppColors.kHint,
                      ),
                      sortDialogElement(0, _notifier.sortList[0],context),
                      sortDialogElement(1, _notifier.sortList[1],context),
                      sortDialogElement(2, _notifier.sortList[2],context),
                      sortDialogElement(3, _notifier.sortList[3],context),
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
        Radio(
          value: value,
          groupValue: _notifier.selectedSortIndex,
          onChanged: (p0) {
            _notifier.selectedSortIndex=value;
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
            _notifier.selectedFilterList.removeWhere((element) => element.type==FilterTypes.SORT.name,);
            _notifier.selectedFilterList.add(FilterModel(_notifier.sortList[value],FilterTypes.SORT.name));
            _pageKey=1;
            _pagingController.refresh();
            Navigator.pop(context);
          },
        ),
        Expanded(
            child: Text(
          label,
          style: AppStyles.c656262W500S18,
        )),
      ],
    );
  }

  Widget proposalElement(String title, IconData iconData) {
    return Row(
      children: [
        Icon(
          iconData,
          color: AppColors.kTextFieldInput,
          size: 20,
        ),
        Expanded(
            child: Text(
          title,
          style: AppStyles.c656262W400S16,
        )),
        const RotatedBox(
            quarterTurns: 2,
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.kTextFieldInput,
              size: 15,
            ))
      ],
    );
  }

  Expanded cell(String img, String label, void Function()? onTap) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(rSize * 0.01),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.kTextFieldInput, width: 0.2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/$img',
              color: AppColors.kTextFieldInput,
              scale: 25,
            ),
            Text(
              label,
              style: AppStyles.c656262W500S14,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ));
  }
}
