import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
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
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Container(
        decoration: AppStyles.commonBg(context),
        child: Column(

          children: [
            AppBar(backgroundColor: Colors.transparent,),
            Material(
              color: Colors.transparent,
              child: TabBar(
                  onTap: (value) {},
                  indicatorWeight: 0.1,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: FlutterFlowTheme.of(context).titleMedium.override(

                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                  // labelPadding: labelPadding,
                  unselectedLabelStyle: const TextStyle(),
                  labelColor: FlutterFlowTheme.of(context).info,
                  unselectedLabelColor:
                  FlutterFlowTheme.of(context).secondaryText,
                  indicatorColor: FlutterFlowTheme.of(context).info,
                  tabs: List.generate(
                    _controller.tabLabelList.length,
                        (index) {
                      return Tab(text: FFLocalizations.of(context).getText(
                        _controller.tabLabelList[index],
                      ));
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
                              const EdgeInsets.symmetric(horizontal: 16, vertical: rSize*0.02),
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
              color: FlutterFlowTheme.of(context).secondaryBackground,
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        activeColor: FlutterFlowTheme.of(context).primary,
                        side: BorderSide(
                          width: 2,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        checkColor: !_controller.accepted?FlutterFlowTheme.of(context).secondaryBackground
                            : FlutterFlowTheme.of(context).info,
                        value: _controller.accepted, onChanged: (value) {
                        _controller.changeAcceptance(context);
                      },),
                      Expanded(
                        child: RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: FFLocalizations.of(context).getText(
                                  'l6rxib8x' /* I've read and agree to the  */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(

                                  color: FlutterFlowTheme.of(context)
                                      .primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              TextSpan(
                                text: FFLocalizations.of(context).getText(
                                  'zfszy2xl' /* Term of Service */,
                                ),
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: FFLocalizations.of(context).getText(
                                  'x0c3ht3x' /*  and  */,
                                ),
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryText,
                                ),
                              ),
                              TextSpan(
                                text: FFLocalizations.of(context).getText(
                                  'lnywo5pe' /* Privacy Policy */,
                                ),
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(

                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40,bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        if (_controller.accepted) {
                          _controller.accept(context);
                        }
                      },
                      child: AppWidgets.btn(context, FFLocalizations.of(context).getText(
                        '3esw1ind' /* Accept */,
                      ),bgColor: _controller.accepted?FlutterFlowTheme.of(context).primary:AppColors.kHint),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
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

