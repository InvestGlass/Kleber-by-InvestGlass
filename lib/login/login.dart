import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kleber_bank/documents/document_model.dart';
import 'package:kleber_bank/login/signup.dart';
import 'package:kleber_bank/proposals/view_document.dart';
import 'package:kleber_bank/utils/common_functions.dart';
import 'package:kleber_bank/utils/end_points.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/app_widgets.dart';
import '../utils/button_widget.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import 'login_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late LoginController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    c = context;
    _controller = Provider.of<LoginController>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: AppStyles.commonBg(context),
        padding: EdgeInsets.only(
            left: rSize * 0.02, right: rSize * 0.02, bottom: rSize * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10 + MediaQuery.of(context).padding.top,
            ),
            Center(
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/white-investglass.png'
                    : 'assets/logo.png',
                width: rSize * 0.17,
                height: rSize * 0.05,
                fit: BoxFit.contain,
              ),
            ),
            const Expanded(child: SizedBox()),
            Text(
              FFLocalizations.of(context).getText(
                'gs8awxej' /* Sign into */,
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: rSize * 0.03,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${FFLocalizations.of(context).getText(
                    'zlksaikw' /* your */,
                  )} ',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: rSize * 0.03,
                        letterSpacing: 0.0,
                        lineHeight: 0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                        'e9zrlew0' /* account */,
                      ),
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: rSize * 0.030,
                        height: 0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      color: FlutterFlowTheme.of(context).primary,
                      height: rSize * 0.005,
                      width: rSize * 0.110,
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: rSize * 0.01,
            ),
            Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image.asset('assets/logo.png',scale: 2,),
                    SizedBox(
                      height: rSize * 0.02,
                    ),
                    TextFormField(
                      controller: _controller.userNameController,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            letterSpacing: 0.0,
                          ),
                      onChanged: (value) {
                        _controller.clearValidations(true, 0);
                      },
                      decoration: AppStyles.inputDecoration(context,
                          label: FFLocalizations.of(context).getText(
                            'cais5tw0' /* Email or password */,
                          ),
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          labelStyle:
                              FlutterFlowTheme.of(context).labelLarge.override(
                                    letterSpacing: 0.0,
                                  ),
                          suffix: Padding(
                            padding: EdgeInsets.all(rSize * 0.01),
                            child: Icon(
                              Icons.account_circle_outlined,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: rSize * 0.025,
                            ),
                          )),
                    ),
                    if (_controller.warning != null) ...{
                      SizedBox(
                        height: rSize * 0.005,
                      ),
                      Text('     Required',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontSize: rSize * 0.016,
                                    color: FlutterFlowTheme.of(context).error,
                                    fontWeight: FontWeight.w500,
                                  ))
                    },
                    SizedBox(
                      height: rSize * 0.02,
                    ),
                    TextFormField(
                      controller: _controller.pwdController,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            letterSpacing: 0.0,
                          ),
                      onChanged: (value) {
                        _controller.clearValidations(true, 1);
                      },
                      obscureText: _controller.hidePwd,
                      decoration: AppStyles.inputDecoration(context,
                          label: FFLocalizations.of(context).getText(
                            'g143uz7d' /* Password */,
                          ),
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          labelStyle:
                              FlutterFlowTheme.of(context).labelLarge.override(
                                    letterSpacing: 0.0,
                                  ),
                          suffix: AppWidgets.click(
                              onTap: () {
                                _controller.changeVisibility();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: rSize * 0.01),
                                child: Icon(
                                  _controller.hidePwd
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: rSize * 0.025,
                                ),
                              ))),
                    ),
                    if (_controller.warning2 != null) ...{
                      SizedBox(
                        height: rSize * 0.005,
                      ),
                      Text('     Required',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontSize: rSize * 0.016,
                                    color: FlutterFlowTheme.of(context).error,
                                    fontWeight: FontWeight.w500,
                                  ))
                    },
                    SizedBox(
                      height: rSize * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppWidgets.click(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (_controller
                                    .userNameController.text.isNotEmpty &&
                                _controller.pwdController.text.isNotEmpty) {
                              _controller.doLogin(context);
                            } else {
                              _controller.clearValidations(false, -1);
                            }
                          },
                          child: AppWidgets.btn(
                              context,
                              FFLocalizations.of(context).getText(
                                'rf7r2nk0' /* login */,
                              ),
                              horizontalPadding: rSize * 0.08),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: rSize * 0.025,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: AppWidgets.click(
                        onTap: () => CommonFunctions.navigate(
                            context,
                            ViewDocument(
                              item: Document(
                                url:
                                    '${EndPoints.baseUrl}forms/a2178090-1962-44de-af4a-a0689da63696?from=kleber',
                              ),
                              title: 'Sign Up',
                            )),
                        child: RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Click here to',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                        color: FlutterFlowTheme.of(context)
                                            .customColor4,
                                        fontWeight: FontWeight.w400,
                                        fontSize: rSize * 0.016),
                              ),
                              TextSpan(
                                text: ' Signup',
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                    fontWeight: FontWeight.w500,
                                    fontSize: rSize * 0.016),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom +
                          rSize * 0.01,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
