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
    _notifier.confirmNewPwdController.text = '';
    _notifier.showCurrentPwd = false;
    _notifier.showNewPwd = false;
    _notifier.showConfirmNewPwd = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _notifier = Provider.of<ProfileController>(context);
    return Scaffold(
      appBar: AppWidgets.appBar(
          context,
          FFLocalizations.of(context).getText(
            'afxtmzhw' /* Change Password */,
          ),
          leading: AppWidgets.backArrow(context)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: rSize * 0.02, horizontal: rSize * 0.015),
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, rSize * 0.010),
              child: AppWidgets.label(
                  context,
                  FFLocalizations.of(context).getText(
                    '510yg9y6' /* Current password */,
                  )),
            ),
            TextFormField(
              controller: _notifier.currentPwdController,
              style: AppStyles.inputTextStyle(context),
              obscureText: !_notifier.showCurrentPwd,
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
                focusColor: FlutterFlowTheme.of(context).alternate,
                suffix: eyeIcon(context, _notifier.showCurrentPwd, () {
                  _notifier.changeCurrentPwdVisibilityStatus();
                }),
                contentPadding: EdgeInsets.symmetric(horizontal: rSize * 0.015, vertical: rSize * 0.018),
                labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, rSize * 0.025, 0.0, rSize * 0.010),
              child: AppWidgets.label(
                  context,
                  FFLocalizations.of(context).getText(
                    '2l6qayo4' /* New password */,
                  )),
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
              style: AppStyles.inputTextStyle(context),
              obscureText: !_notifier.showNewPwd,
              decoration: AppStyles.inputDecoration(
                context,
                hint: FFLocalizations.of(context).getText(
                  '2l6qayo4' /* New password */,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: rSize * 0.015, vertical: rSize * 0.018),
                suffix: eyeIcon(context, _notifier.showNewPwd, () {
                  _notifier.changeNewPwdVisibilityStatus();
                }),
                focusColor: FlutterFlowTheme.of(context).alternate,
                labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, rSize * 0.025, 0.0, rSize * 0.010),
              child: AppWidgets.label(
                  context,
                  FFLocalizations.of(context).getText(
                    'lz5cj3qp' /* Confirm new password */,
                  )),
            ),
            TextFormField(
              controller: _notifier.confirmNewPwdController,
              style: AppStyles.inputTextStyle(context),validator: (value) {
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
                  contentPadding: EdgeInsets.symmetric(horizontal: rSize * 0.015, vertical: rSize * 0.018),
                  hint: FFLocalizations.of(context).getText(
                    'lz5cj3qp' /* Confirm new password */,
                  ),
                  focusColor: FlutterFlowTheme.of(context).alternate,
                  suffix: eyeIcon(context, _notifier.showConfirmNewPwd, () {
                    _notifier.changeConfirmNewPwdVisibilityStatus();
                  })),
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
                          'afxtmzhw' /* Change password */,
                        ),
                        textColor: Colors.white,
                        horizontalPadding: rSize * 0.025,
                        bgColor: FlutterFlowTheme.of(context).primary)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget eyeIcon(BuildContext context, bool showPwd, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: rSize * 0.008),
        child: Icon(
          showPwd ? Icons.visibility : Icons.visibility_off,
          color: FlutterFlowTheme.of(context).primaryText,
          size: rSize * 0.025,
        ),
      ),
    );
  }
}
