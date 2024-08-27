import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    _controller = Provider.of<LoginController>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: AppStyles.commonBg(context),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: rSize * 0.02),
          child: Column(
            children: [
              SizedBox(
                height: rSize * 0.05,
              ),
              Image.asset(
                Theme.of(context).brightness == Brightness.dark ? 'assets/white-investglass.png' : 'assets/logo.png',
                width: rSize * 0.17,
                height: rSize * 0.05,
                fit: BoxFit.contain,
              ),
              const Expanded(child: SizedBox()),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: rSize * 0.02),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                        'gs8awxej' /* Sign into */,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 30.0,
                            letterSpacing: 0.0,
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
                            fontFamily: 'Roboto',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 30.0,
                            letterSpacing: 0.0,lineHeight: 0,
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
                                  fontSize: 30,height: 0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',),
                            ),
                            Container(
                              color: FlutterFlowTheme.of(context).primary,
                              height: 5,
                              width: 110,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Form(
                  key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset('assets/logo.png',scale: 2,),
                      SizedBox(
                        height: rSize * 0.02,
                      ),
                      TextFormField(
                        controller: _controller.userNameController,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Roboto',
                              letterSpacing: 0.0,
                            ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                        },
                        decoration: AppStyles.inputDecoration(context,
                            label: 'Email or Username',
                            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                            labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.0,
                                ),
                            suffix: Icon(
                              Icons.account_circle_outlined,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 25.0,
                            )),
                      ),
                      SizedBox(
                        height: rSize * 0.02,
                      ),
                      TextFormField(
                        controller: _controller.pwdController,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Roboto',
                              letterSpacing: 0.0,
                            ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                        },
                        obscureText: _controller.hidePwd,
                        decoration: AppStyles.inputDecoration(context,
                            label: 'Password',
                            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                            labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.0,
                                ),
                            suffix: GestureDetector(
                                onTap: () {
                                  _controller.changeVisibility();
                                },
                                child: Icon(
                                  _controller.hidePwd ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                ))),
                      ),
                      SizedBox(
                        height: rSize * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FFButtonWidget(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_formKey.currentState!.validate()) {
                                _controller.doLogin(context);
                              }
                            },
                            text: 'Login',
                            options: FFButtonOptions(
                              width: MediaQuery.sizeOf(context).width * 0.5,
                              height: 50.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Roboto',
                                    color: FlutterFlowTheme.of(context).info,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                              elevation: 3.0,
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            showLoadingIndicator: false,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom + rSize * 0.025,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
