import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import 'login_controller.dart';

class TermsAndPrivacy extends StatefulWidget {
  const TermsAndPrivacy({super.key});

  @override
  State<TermsAndPrivacy> createState() => _TermsAndPrivacyState();
}

class _TermsAndPrivacyState extends State<TermsAndPrivacy>  with TickerProviderStateMixin{
  late LoginController _controller;
  late TabController _tabController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LoginController>(context,listen: false).termOfService(context);
    },);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<LoginController>(context);
    _tabController = TabController(
      length: _controller.tabLabelList.length,
      vsync: this,
    );
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Column(
        children: [
          Material(
            color: Colors.white,
            child: TabBar(
                indicatorColor: AppColors.kViolate,
                onTap: (value) {},
                indicatorWeight: 0.1,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: AppStyles.c3C496CW500S18,
                // labelPadding: labelPadding,
                unselectedLabelStyle: AppStyles.c656262W500S16,
                tabs: List.generate(
                  _controller.tabLabelList.length,
                      (index) {
                    return Tab(text: _controller.tabLabelList[index]);
                  },
                ),
                controller: _tabController,tabAlignment: TabAlignment.center,
                physics: const BouncingScrollPhysics(),
                isScrollable: true),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(_controller.tabLabelList.length, (index) {
                if (index==0) {
                  return Page(_controller.termOfServiceContent['term_of_service']);
                }
                return Page(_controller.termOfServiceContent['privacy_policy']);
                /*return SingleChildScrollView(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Column(
                          children: [
                            CommonShadowWidget(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        'Unrealized P&L',
                                        style: TextStyle(
                                          fontSize: SizeConfig.normalfontSize,
                                          color: ColorResources.darkGreyColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      trailing: Text(
                                        '₹ ${index == 0 ? _getTotalUnrealizedTradeData(_finalTradesList) : _getTotalUnrealizedTradeData(_finalPositionsList)}',
                                        style: TextStyle(
                                          fontSize: SizeConfig.extraSmallfontSize,
                                          color: ColorResources.darkGreyColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        'Net P&L',
                                        style: TextStyle(
                                          fontSize: SizeConfig.normalfontSize,
                                          color: ColorResources.darkGreyColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      trailing: Text(
                                        '₹ ${index == 0 ?
                                        setDecimals(((double.tryParse(_getTotalUnrealizedTradeData(_finalTradesList)) ?? 0) + (double.tryParse(_getTotalRealizedTradeData(_finalTradesList)) ?? 0)).toString(), '2')
                                            : setDecimals(((double.tryParse(_getTotalUnrealizedTradeData(_finalPositionsList)) ?? 0) + (double.tryParse(_getTotalRealizedTradeData(_finalPositionsList)) ?? 0)).toString(), '2')}',
                                        style: TextStyle(
                                          fontSize: SizeConfig.extraSmallfontSize,
                                          color: ColorResources.darkGreyColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            heightBox(20),
                            CommonShadowWidget(
                              child: SearchTextFieldWidget(
                                controller: _searchController,
                                hintText: "Search Positions",
                              ),
                            ),
                            heightBox(20),
                            if (index == 0)...{
                              TodayTradeView()
                            }else...{
                              PositionTradeView()}
                            // _buildPositionListWidget(),
                          ],
                        ),
                      );*/
              }),
            ),
          ),
          Card(
            elevation: 2,
            child: Row(
              children: [
                Checkbox(value: _controller.accepted, onChanged: (value) {
                  _controller.changeAcceptance(context);
                },),
                Text('I Accept',style: AppStyles.c3C496CW500S16,)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Page extends StatelessWidget {
  final String htmlData;
  const Page(this.htmlData,{super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Html(
          data: htmlData,
        ),
      ),
    );
  }
}

