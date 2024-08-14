import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kleber_bank/login/user_info_model.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
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

  @override
  void initState() {
    model = AppConst.userModel!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller = Provider.of<LoginController>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: FlutterFlowTheme.of(context).primaryBackground,
              margin: EdgeInsets.symmetric(vertical: rSize * 0.03, horizontal: rSize * 0.01),
              elevation: 2,
              child: Padding(
                padding:
                    EdgeInsets.only(left: rSize * 0.02, right: rSize * 0.02, top: rSize * 0.03, bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        if(widget.map!=null && widget.map!.containsKey('location'))...{
                        Text(
                          'An OTP code is sent to the ${widget.map!['location']}',
                          textAlign: TextAlign.start,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontFamily: 'Roboto',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                          ),
                        )},
                        SizedBox(
                          height: rSize * 0.01,
                        ),
                        if (model.verification != 'authentification')
                        Text(
                          FFLocalizations.of(context).getText(
                            '4odbxp9t' /* Please input the code to conti... */,
                          ),
                          textAlign: TextAlign.start,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                            fontFamily: 'Roboto',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                          ),
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
                        Wrap(
                          spacing: rSize * 0.01,
                          children: [
                            otpWidget(
                              _controller.otpController1,
                              _controller.focusNode1,
                              (p0) {
                                if (p0.length == 1) {
                                  FocusScope.of(context).requestFocus(_controller.focusNode2);
                                }
                              },
                            ),
                            otpWidget(
                              _controller.otpController2,
                              _controller.focusNode2,
                              (p0) {
                                if (p0.length == 1) {
                                  FocusScope.of(context).requestFocus(_controller.focusNode3);
                                }else{
                                  FocusScope.of(context).requestFocus(_controller.focusNode1);
                                }
                              },
                            ),
                            otpWidget(
                              _controller.otpController3,
                              _controller.focusNode3,
                              (p0) {
                                if (p0.length == 1) {
                                  FocusScope.of(context).requestFocus(_controller.focusNode4);
                                }else{
                                  FocusScope.of(context).requestFocus(_controller.focusNode2);
                                }
                              },
                            ),
                            otpWidget(
                              _controller.otpController4,
                              _controller.focusNode4,
                              (p0) {
                                if (p0.length == 1) {
                                  FocusScope.of(context).requestFocus(_controller.focusNode5);
                                }else{
                                  FocusScope.of(context).requestFocus(_controller.focusNode3);
                                }
                              },
                            ),
                            otpWidget(
                              _controller.otpController5,
                              _controller.focusNode5,
                              (p0) {
                                if (p0.length == 1) {
                                  FocusScope.of(context).requestFocus(_controller.focusNode6);
                                }else{
                                  FocusScope.of(context).requestFocus(_controller.focusNode5);
                                }
                              },
                            ),
                            otpWidget(
                              _controller.otpController6,
                              _controller.focusNode6,
                              (p0) {
                                if (p0.length == 1) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    _controller.verify(context, (key) {
                                      showQR(key, () {
                                        Navigator.pop(context);
                                        model.verification = 'authentification';
                                        _controller.refresh();
                                      });
                                    });
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: rSize * 0.01,
                        ),
                        if(model.verification != 'authentification')...{
                        Row(
                          children: [Text(
                            FFLocalizations.of(context).getText(
                              'v5jx3zzx' /* Didn't receive any code? */,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
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
                                child:Text(' ${FFLocalizations.of(context).getText(
                                    'dumdc5yp' /* Resend */,
                                  )}',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Roboto',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ) ),
                          ],
                        )},
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
        style: FlutterFlowTheme.of(context)
            .bodyLarge
            .override(
          fontFamily: 'Roboto',
          letterSpacing: 0,
        ),
        validator: (value) {
          if ((value ?? '').isEmpty) {
            return '';
          }
        },
        keyboardType: TextInputType.number,
        decoration: AppStyles.inputDecoration(context, counterText: '',contentPadding: EdgeInsets.zero),
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
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
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
                          version: QrVersions.auto,backgroundColor: Colors.transparent,
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10.0, 10.0, 0.0, 10.0),
                                  child: Text(
                                    key,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: 'Roboto',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: key));
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
                        SizedBox(height: rSize*0.02,),
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
                            padding:
                            const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                            iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
