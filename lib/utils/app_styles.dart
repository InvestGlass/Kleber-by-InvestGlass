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
  /*static TextStyle c656262W500S18 = GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: px18, color: AppColors.kTextFieldInput);
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
  static TextStyle errorStyle16 = GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: px16, color: AppColors.kErrorBorderColor);*/

  /*static InputDecoration dropDownInputDecoration(BuildContext context, Widget? label, {Color? focusedBorderColor,Widget? prefix}) {
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

            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: rSize*0.016,
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
  }*/

  static Decoration commonBg(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).brightness == Brightness.dark
              ? FlutterFlowTheme.of(context).bgTopGradient
              : FlutterFlowTheme.of(context).primaryBackground,
          FlutterFlowTheme.of(context).primaryBackground
        ],
        stops: const [0.0, 0.4],
        begin: const AlignmentDirectional(0.0, -1.0),
        end: const AlignmentDirectional(0, 1.0),
      ),
    );
  }

  static List<BoxShadow> shadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        spreadRadius: 0, // how wide the shadow is spread
        blurRadius: 3, // how blurry the shadow is
        offset: Offset(0, 0),
      ),
    ];
  }

  static iconBg(BuildContext context,{EdgeInsetsGeometry? margin,required IconData data,required double size,EdgeInsetsGeometry? padding,void Function()? onTap,Widget? customIcon,Color? color}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin??EdgeInsets.all(rSize*0.010),
        padding: padding,
        height: rSize*0.05,
        width: rSize*0.05,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(rSize*0.008),
          color: FlutterFlowTheme.of(context).secondaryBackground,
          gradient:LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
            colors: [
              FlutterFlowTheme
                  .of(context).customColor6,
              FlutterFlowTheme.of(context).secondaryBackground,
              FlutterFlowTheme
                  .of(context)
              .customColor6,
            ],
          ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 3, // how wide the shadow is spread
                blurRadius: 6, // how blurry the shadow is
                offset: Offset(0, 0),
              ),
            ],
        ),
        child: customIcon??Icon(
          data,
          size: size,
          color: color??FlutterFlowTheme.of(context).primary,
        ),
    ));
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
        double? borderRadius,
      TextStyle? labelStyle,
      Color? fillColor,
      EdgeInsetsGeometry? contentPadding,
      Color? focusColor}) {
    return InputDecoration(
      labelText: label,
      labelStyle: labelStyle,hintText: hint,
      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(

            fontWeight: FontWeight.w200,
        color: FlutterFlowTheme.of(context).customColor4
          ),errorStyle: FlutterFlowTheme.of(context).labelMedium.override(

        fontWeight: FontWeight.w200,
        color: FlutterFlowTheme.of(context).error
    ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: focusColor??FlutterFlowTheme.of(context).alternate,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius??rSize*0.012),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: focusColor??focusColor??FlutterFlowTheme.of(context).primary,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius??rSize*0.012),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius??rSize*0.012),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: focusColor??FlutterFlowTheme.of(context).alternate,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius??rSize*0.012),
      ),
      filled: true,prefixIcon: prefix,
      fillColor: fillColor?? FlutterFlowTheme.of(context).secondaryBackground,counterText: counterText,
      contentPadding: contentPadding ?? EdgeInsetsDirectional.fromSTEB(rSize*0.024, rSize*0.024, 0.0, rSize*0.024),
      suffixIcon: suffix,
    );
  }
}
