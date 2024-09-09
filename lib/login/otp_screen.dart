import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kleber_bank/login/user_info_model.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../main.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/app_widgets.dart';
import '../utils/button_widget.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import 'login_controller.dart';

class OTPScreen extends StatefulWidget {
  final Map<String, dynamic>? map;

  const OTPScreen(this.map, {super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late LoginController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late UserInfotModel model;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    model = AppConst.userModel!;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.otpController1.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<LoginController>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(),alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: ListView(
          shrinkWrap: true,
          children: [
            Card(
              color: FlutterFlowTheme.of(context).primaryBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.symmetric(vertical: rSize * 0.03, horizontal: rSize * 0.01),
              elevation: 2,
              child: Padding(
                padding:
                    EdgeInsets.only(left: rSize * 0.02, right: rSize * 0.02, top: rSize * 0.03, bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image.asset('assets/logo.png',scale: 2,),

                        Text(
                          FFLocalizations.of(context).getText(
                            '2gjb3gie' /* Login Verification */,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Roboto',
                                color: FlutterFlowTheme.of(context).primary,
                                fontSize: 26.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(
                          height: rSize * 0.02,
                        ),
                        if (model.verification != 'authentification' && widget.map != null && widget.map!.containsKey('location')) ...{
                          Text(
                            'An OTP code is sent to the ${widget.map!['location']}',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Roboto',
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                          )
                        },
                        SizedBox(
                          height: rSize * 0.01,
                        ),
                        if (model.verification != 'authentification')
                          Row(
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  '4odbxp9t' /* Please input the code to conti... */,
                                ),
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                        if (model.verification == 'authentification')
                          Text(
                            FFLocalizations.of(context).getText(
                              '4jp9h6pq' /* Please confirm that your authe... */,
                            ),
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Roboto',
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        SizedBox(
                          height: rSize * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                          child: PinCodeTextField(
                            autoDisposeControllers: false,
                            appContext: context,
                            length: 6,
                            textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.0,
                                ),
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            enableActiveFill: false,
                            autoFocus: true,
                            enablePinAutofill: false,
                            errorTextSpace: 1.0,
                            showCursor: true,
                            cursorColor: FlutterFlowTheme.of(context).primary,
                            obscureText: false,
                            hintCharacter: '●',
                            keyboardType: TextInputType.number,
                            pinTheme: PinTheme(
                              fieldHeight: 44.0,
                              fieldWidth: 44.0,
                              borderWidth: 2.0,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0),
                              ),
                              shape: PinCodeFieldShape.box,
                              activeColor: FlutterFlowTheme.of(context).primaryText,
                              inactiveColor: FlutterFlowTheme.of(context).alternate,
                              selectedColor: FlutterFlowTheme.of(context).primary,
                              activeFillColor: FlutterFlowTheme.of(context).primaryText,
                              inactiveFillColor: FlutterFlowTheme.of(context).alternate,
                              selectedFillColor: FlutterFlowTheme.of(context).primary,
                            ),
                            controller: _controller.otpController1,
                            onChanged: (_) {},
                            onCompleted: (_) {
                              _controller.verify(context, (key) {
                                showQR(key, () {
                                  Navigator.pop(context);
                                  _controller.otpController1.clear();
                                  model.verification = 'authentification';
                                  _controller.refresh();
                                });
                              });
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            // validator: _model.pinCodeControllerValidator
                            //     .asValidator(context),
                          ),
                        ),
                        SizedBox(
                          height: rSize * 0.01,
                        ),
                        if (model.verification != 'authentification') ...{
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'v5jx3zzx' /* Didn't receive any code? */,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Roboto',
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _controller.reSend(context);
                                  },
                                  child: Text(
                                    ' ${FFLocalizations.of(context).getText(
                                      'dumdc5yp' /* Resend */,
                                    )}',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Roboto',
                                          color: FlutterFlowTheme.of(context).primary,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  )),
                            ],
                          )
                        },
                        SizedBox(
                          height: rSize * 0.03,
                        ),
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget otpWidget(TextEditingController controller, FocusNode focusNode, void Function(String) onChanged) {
    return SizedBox(
      width: rSize * 0.05,
      height: rSize * 0.07,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        maxLength: 1,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        onChanged: onChanged,
        cursorColor: FlutterFlowTheme.of(context).primary,
        style: FlutterFlowTheme.of(context).bodyLarge.override(
              fontFamily: 'Roboto',
              letterSpacing: 0,
            ),
        validator: (value) {
          if ((value ?? '').isEmpty) {
            return '';
          }
        },
        keyboardType: TextInputType.number,
        decoration: AppStyles.inputDecoration(context, counterText: '', contentPadding: EdgeInsets.zero),
      ),
    );
  }

  void showQR(String key, Function onNextClick) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            return Future(
              () => false,
            );
          },
          child: Center(
            child: Wrap(
              children: [
                Card(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  child: Padding(
                    padding: EdgeInsets.all(rSize * 0.015),
                    child: Column(
                      children: [
                        SizedBox(
                          height: rSize * 0.01,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  '0em7xr1j' /* Scan  QR Code */,
                                ),
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context).headlineMedium.override(
                                      fontFamily: 'Roboto',
                                      color: FlutterFlowTheme.of(context).primary,
                                      fontSize: 26.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: rSize * 0.01,
                        ),
                        QrImageView(
                          data: 'otpauth://totp/InvestGlass?secret=$key&issuer=InvestGlass',
                          version: QrVersions.auto,
                          backgroundColor: Colors.transparent,
                          size: 200.0,
                          dataModuleStyle: QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                          eyeStyle: QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                        SizedBox(
                          height: rSize * 0.015,
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            '7gd5sfox' /* If you cannot scan, please ent... */,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Roboto',
                                color: FlutterFlowTheme.of(context).grayLight,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).grayLight,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 0.0, 10.0),
                                  child: Text(
                                    key,
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Roboto',
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(text: key));
                                },
                                child: Icon(
                                  Icons.file_copy_outlined,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 30.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: rSize * 0.02,
                        ),
                        FFButtonWidget(
                          onPressed: () async {
                            onNextClick();
                          },
                          text: FFLocalizations.of(context).getText(
                            'smq78s7m' /* Next */,
                          ),
                          options: FFButtonOptions(
                            width: MediaQuery.sizeOf(context).width * 0.5,
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                ),
                            elevation: 3.0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        SizedBox(
                          height: rSize * 0.01,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
