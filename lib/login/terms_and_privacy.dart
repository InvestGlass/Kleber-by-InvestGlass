import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kleber_bank/main.dart';
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

class _TermsAndPrivacyState extends State<TermsAndPrivacy> with TickerProviderStateMixin {
  late LoginController _controller;
  late PageController _pageController;
  int _selectedIndex=0;
  String txt = '<!DOCTYPE html><html><head><title>Page Title</title></head><body><h1>My First Heading</h1><p>My New Zealand is an island country in the southwestern Pacific Ocean. It consists of two main landmasses—the North Island and the South Island —and over 700 smaller islands.</p></body></html>';
  String txt2 = '<!DOCTYPE html><html><head><title>Page Title</title></head><body><h1>My Second Heading</h1><p>My New Zealand is an island country in the southwestern Pacific Ocean. It consists of two main landmasses—the North Island and the South Island —and over 700 smaller islands.</p></body></html>';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<LoginController>(context, listen: false).termOfService(context);
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.accepted=false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<LoginController>(context);
    _pageController = PageController();
    return Scaffold(
      appBar: AppWidgets.appBar(context, '', leading: AppWidgets.backArrow(context)),
      body: Container(
        decoration: AppStyles.commonBg(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(rSize * 0.03), color: FlutterFlowTheme.of(context).customColor4.withOpacity(0.3)),
                  margin: EdgeInsets.only(bottom: rSize*0.005),
                  padding: EdgeInsets.all(rSize * 0.002),
                  child: Row(
                    children: [
                      tabCell(
                          context,
                          FFLocalizations.of(context).getText(
                            'ovw4ksp4' /* terms... */,
                          ),
                        _selectedIndex==0,() {
                            _pageController.animateToPage(0,duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                            setState(() {
                              _selectedIndex=0;
                            });
                          },),
                      tabCell(
                          context,
                          FFLocalizations.of(context).getText(
                            'sb815feb' /* privacy... */,
                          ),
                        _selectedIndex==1,() {
                        _pageController.animateToPage(1,duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
                        setState(() {
                          _selectedIndex=1;
                        });
                          },),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: PageView(controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Page(/*_controller.termOfServiceContent['term_of_service']*/txt),
                  Page(/*_controller.termOfServiceContent['privacy_policy']*/txt2)
                ],
              ),
            ),
            Card(
              elevation: 2,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              child: Column(
                children: [
                  Row(
                    children: [
                      Transform.scale(
                        scale: isTablet?2:0.8,
                        child: Checkbox(
                          activeColor: FlutterFlowTheme.of(context).primary,
                          side: BorderSide(
                            width: 2,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          checkColor: !_controller.accepted ? FlutterFlowTheme.of(context).secondaryBackground : FlutterFlowTheme.of(context).info,
                          value: _controller.accepted,
                          onChanged: (value) {
                            _controller.changeAcceptance(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: FFLocalizations.of(context).getText(
                                  'l6rxib8x' /* I've read and agree to the  */,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      fontSize: rSize * 0.014,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              TextSpan(
                                text: FFLocalizations.of(context).getText(
                                  'zfszy2xl' /* Term of Service */,
                                ),
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: rSize * 0.014,
                                ),
                              ),
                              TextSpan(
                                text: FFLocalizations.of(context).getText(
                                  'x0c3ht3x' /*  and  */,
                                ),
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: rSize * 0.014,
                                ),
                              ),
                              TextSpan(
                                text: FFLocalizations.of(context).getText(
                                  'lnywo5pe' /* Privacy Policy */,
                                ),
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: rSize * 0.014,
                                ),
                              )
                            ],
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontSize: rSize * 0.014,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: rSize * 0.04, right: rSize * 0.04, bottom: rSize * 0.01),
                    child: GestureDetector(
                      onTap: () {
                        if (_controller.accepted) {
                          _controller.accept(context);
                        }
                      },
                      child: getBtn(FFLocalizations.of(context).getText(
                        '3esw1ind' /* Accept */,
                      )),
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

  Widget tabCell(BuildContext context, String text, bool isSelected,void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: rSize*0.02,vertical: rSize*0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(rSize * 0.03), color: isSelected ? FlutterFlowTheme.of(context).info : Colors.transparent),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? FlutterFlowTheme.of(context).customColor4 : FlutterFlowTheme.of(context).primaryText,
            fontSize: rSize * 0.016,
            height: 0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  getBtn(String s) {
    if(_controller.accepted){
      return AppWidgets.btn(context, s);
    }else{
      return AppWidgets.btnWithoutGradiant(context, s, FlutterFlowTheme.of(context).customColor4);
    }
  }
}

class Page extends StatelessWidget {
  final String htmlData;

  const Page(this.htmlData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Html(
          data: htmlData,
        ),
      ),
    );
  }
}
