import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import 'app_colors.dart';
import 'app_widgets.dart';
import 'flutter_flow_theme.dart';

class AppStyles {
  static double px15 = rSize * 0.015;
  static double px16 = rSize * 0.016;
  static double px22 = rSize * 0.0205;
  static double px28 = rSize * 0.027;

  static double px12 = rSize * 0.012;
  static double px8 = rSize * 0.008;
  static double px14 = rSize * 0.014;
  static double px18 = rSize * 0.018;
  static double px20 = rSize * 0.020;

  // static TextStyle c333333W400S12 = GoogleFonts.rubik(fontWeight: FontWeight.w400, fontSize: px12, color: AppColors.kDateTimeColor);
  static TextStyle c656262W500S18 = GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: px18, color: AppColors.kTextFieldInput);
  static TextStyle c656262W400S16 = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: px16, color: AppColors.kTextFieldInput);
  static TextStyle c656262W200S16 = GoogleFonts.poppins(fontWeight: FontWeight.w200, fontSize: px16, color: AppColors.kTextFieldInput);
  static TextStyle c656262W200S14 = GoogleFonts.poppins(fontWeight: FontWeight.w200, fontSize: px14, color: AppColors.kTextFieldInput);
  static TextStyle c656262W400S18 = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: px18, color: AppColors.kTextFieldInput);
  static TextStyle c656262W400S20 = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: px20, color: AppColors.kTextFieldInput);
  static TextStyle c656262W500S16 = GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: px16, color: AppColors.kTextFieldInput);
  static TextStyle c656262W500S20 = GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: px20, color: AppColors.kTextFieldInput);
  static TextStyle c3C496CW500S18 = GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: px18, color: AppColors.kViolate);
  static TextStyle c3C496CW500S16 = GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: px16, color: AppColors.kViolate);
  static TextStyle c3C496CW400S14 = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: px14, color: AppColors.kViolate);
  static TextStyle c656262W500S14 = GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: px14, color: AppColors.kTextFieldInput);
  static TextStyle c929292W500S14 = GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: px14, color: AppColors.kHint);
  static TextStyle cFFFFFFW400S18 = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: px18, color: Colors.white);
  static TextStyle cFFFFFFW400S16 = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: px16, color: Colors.white);
  static TextStyle cRedW400S18 = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: px18, color: Colors.redAccent);
  static TextStyle errorStyle = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: px14, color: AppColors.kErrorBorderColor, height: 1);
  static TextStyle errorStyle16 = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: px16, color: AppColors.kErrorBorderColor);

  static InputDecoration dropDownInputDecoration(BuildContext context, Widget? label, {Color? focusedBorderColor,Widget? prefix}) {
    return InputDecoration(
      label: label,
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      errorStyle: AppStyles.cRedW400S18,
      prefixIcon: prefix,filled: true,
      hintStyle: AppStyles.c656262W500S18,
      contentPadding: EdgeInsets.all(15.0),
      // Inside box padding
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      labelStyle: FlutterFlowTheme.of(context).displaySmall.override(
            fontFamily: 'Roboto',
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 16.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
          ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: focusedBorderColor ?? FlutterFlowTheme.of(context).primary,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  static Decoration commonBg(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
        ],
        stops: const [0.0, 0.4],
        begin: const AlignmentDirectional(0.0, -1.0),
        end: const AlignmentDirectional(0, 1.0),
      ),
    );
  }

  static InputDecoration inputDecoration(BuildContext context,
      {String? hint,
      String? label,
      String? counterText,
      Widget? prefix,
      Widget? suffix,
      String? preffixText,
      // TextStyle? hintStyle,
        double borderWidth=2,
      TextStyle? labelStyle,
      Color? fillColor,
      EdgeInsetsGeometry? contentPadding,
      Color? focusColor}) {
    return InputDecoration(
      labelText: label,
      labelStyle: labelStyle,hintText: hint,
      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
            fontFamily: 'Roboto',
            letterSpacing: 0.0,
          ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: focusColor??FlutterFlowTheme.of(context).alternate,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: focusColor??focusColor??FlutterFlowTheme.of(context).primary,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: focusColor??FlutterFlowTheme.of(context).alternate,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      filled: true,prefixIcon: prefix,
      fillColor: fillColor?? FlutterFlowTheme.of(context).secondaryBackground,counterText: counterText,
      contentPadding: contentPadding ?? const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 0.0, 24.0),
      suffixIcon: suffix,
    );
  }
}
