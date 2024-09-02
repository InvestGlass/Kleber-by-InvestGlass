import 'package:flutter/material.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/profile/profile_controller.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:provider/provider.dart';

import '../utils/app_styles.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late ProfileController _notifier;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _notifier.currentPwdController.text = '';
    _notifier.newPwdController.text = '';
    _notifier.currentPwdController.text = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<ProfileController>(context);
    return Scaffold(
      appBar: AppWidgets.appBar(context, FFLocalizations.of(context).getText(
        'afxtmzhw' /* Change Password */,
      ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
          )),
      body: Container(
        decoration: AppStyles.commonBg(context),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: rSize * 0.02, horizontal: rSize * 0.015),
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                child: Text(
                  FFLocalizations.of(context).getText(
                    '510yg9y6' /* Current password */,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              TextFormField(
                controller: _notifier.currentPwdController,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Roboto',
                      letterSpacing: 0.0,
                    ),obscureText:!_notifier.showCurrentPwd,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                },
                decoration: AppStyles.inputDecoration(
                  context,
                  hint: FFLocalizations.of(context).getText(
                    '729kp7ui' /* Your current password */,
                  ),
                  suffix: GestureDetector(
                      onTap: () {
                        _notifier.changeCurrentPwdVisibilityStatus();
                      },
                      child:
                          Icon(_notifier.showCurrentPwd ? Icons.visibility : Icons.visibility_off, color: FlutterFlowTheme.of(context).primaryText)),
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 18),
                  labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: 'Roboto',
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, rSize * 0.025, 0.0, 10.0),
                child: Text(
                  FFLocalizations.of(context).getText(
                    '2l6qayo4' /* New password */,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              TextFormField(
                controller: _notifier.newPwdController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  } else if (value.length < 6) {
                    return FFLocalizations.of(context).getText(
                      'gtihat6e' /* New password needs at least... */,
                    );
                  }
                },
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Roboto',
                      letterSpacing: 0.0,
                    ),
                obscureText: !_notifier.showNewPwd,
                decoration: AppStyles.inputDecoration(
                  context,hint: FFLocalizations.of(context).getText(
                  '2l6qayo4' /* New password */,
                ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 18),
                  suffix: GestureDetector(
                      onTap: () {
                        _notifier.changeNewPwdVisibilityStatus();
                      },
                      child: Icon(_notifier.showNewPwd ? Icons.visibility : Icons.visibility_off, color: FlutterFlowTheme.of(context).primaryText)),
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                        fontFamily: 'Roboto',
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, rSize * 0.025, 0.0, 10.0),
                child: Text(
                  FFLocalizations.of(context).getText(
                    'lz5cj3qp' /* Confirm new password */,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              TextFormField(
                controller: _notifier.confirmNewPwdController,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Roboto',
                      letterSpacing: 0.0,
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  } else if (_notifier.newPwdController.text != value) {
                    return FFLocalizations.of(context).getText(
                      'y6byl3gh' /* Confirm new password must... */,
                    );
                  }
                },
                obscureText: !_notifier.showConfirmNewPwd,
                decoration: AppStyles.inputDecoration(context,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 18),
                    hint: FFLocalizations.of(context).getText(
                      'lz5cj3qp' /* Confirm new password */,
                    ),
                    suffix: GestureDetector(
                        onTap: () {
                          _notifier.changeConfirmNewPwdVisibilityStatus();
                        },
                        child: Icon(_notifier.showConfirmNewPwd ? Icons.visibility : Icons.visibility_off,
                            color: FlutterFlowTheme.of(context).primaryText))),
              ),
              SizedBox(
                height: rSize * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _notifier.changePassword(context);
                        }
                      },
                      child: AppWidgets.btn(
                          context,
                          FFLocalizations.of(context).getText(
                            'iy4dy5qk' /* Change password */,
                          ),textColor: Colors.white,
                          horizontalPadding: rSize * 0.025,
                          bgColor: FlutterFlowTheme.of(context).primary)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
