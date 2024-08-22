import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kleber_bank/documents/documents.dart';
import 'package:kleber_bank/utils/app_const.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../main.dart';
import '../portfolio/portfolio_model.dart';
import 'app_colors.dart';
import 'app_styles.dart';
import 'common_functions.dart';
import 'flutter_flow_theme.dart';

class AppWidgets {
  static Widget textFieldLabel(String label, {bool isRequired = true}) {
    if (isRequired) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppStyles.c656262W500S18,
          ),
        ],
      );
    }
    return Text(
      label,
      textAlign: TextAlign.start,
      style: AppStyles.c656262W500S18,
    );
  }

  static Container healthAlertElement(
      BuildContext context, String title, Color bgColor, IconData iconData, String label, Appropriateness model, TextStyle textStyle) {
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: rSize * 0.02, vertical: rSize * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                color: textStyle.color,
                size: 20,
              ),
              Expanded(
                  child: Text(
                title,
                style: textStyle,
              )),
              Text(
                model.listDetails!.length.toString(),
                style: textStyle,
              )
            ],
          ),
          if (label.isNotEmpty) ...{
            SizedBox(
              height: rSize * 0.01,
            ),
            Text(
              label,
              style: FlutterFlowTheme.of(context).displaySmall.override(
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              getStatus(model.status),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            SizedBox(
              height: rSize * 0.01,
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                          height: 8,
                          width: 8,
                        ),
                        SizedBox(
                          width: rSize * 0.015,
                        ),
                        Expanded(
                          child: Text(
                            model.listDetails![index],
                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                  fontFamily: 'Roboto',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                separatorBuilder: (context, index) => Container(
                      height: 0.2,
                      margin: EdgeInsets.symmetric(vertical: rSize * 0.01),
                      color: AppColors.kHint,
                    ),
                itemCount: model.listDetails!.length)
          }
        ],
      ),
    );
  }

  /*static void openDatePicker(BuildContext context, dynamic Function(Object?)? onSubmit, void Function()? onCancel,
      {DateRangePickerSelectionMode mode = DateRangePickerSelectionMode.range}) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Wrap(
          children: [
            SfDateRangePicker(
              view: DateRangePickerView.month,
              onSubmit: onSubmit,
              selectionMode: mode,
              monthViewSettings: DateRangePickerMonthViewSettings(
                firstDayOfWeek: 1,
              ),
              showActionButtons: true,
              onCancel: onCancel,
            ),
          ],
        ),
      ),
    );
  }*/

  static Container divider(BuildContext context) {
    return Container(
      color: FlutterFlowTheme.of(context).primaryText,
      height: 0.2,
    );
  }

  static Widget portfolioListElement(BuildContext context, String label, String value, {String middleValue = '',Widget? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context)
              .bodyMedium
              .override(
            fontFamily: 'Roboto',
            fontSize: 16.0,
            letterSpacing: 0.0,
          ),
        ),
        if (middleValue.isNotEmpty) ...{
          Text(
            middleValue,
            style: FlutterFlowTheme.of(context)
                .bodyMedium
                .override(
              fontFamily: 'Roboto',
              fontSize: 16.0,
              letterSpacing: 0.0,
            ),
          )
        },
        if (middleValue.isEmpty) ...{
          SizedBox(
            width: rSize * 0.015,
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),
            ),


          ),if(icon!=null)...{
            SizedBox(width: 10,),
    icon
    }
        } else ...{
          Text(
            value,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.normal,
                ),
          )
        },
      ],
    );
  }

  static Widget btn(BuildContext context, String label,
      {double? width, double horizontalPadding = 0, double? verticalPadding, Widget? widget, bool borderOnly = false, Color? bgColor}) {
    return Container(
      width: width,
      alignment: Alignment.center,
      decoration: gradiantDecoration(context, borderOnly: borderOnly, color: bgColor),
      padding: EdgeInsets.symmetric(vertical: verticalPadding ?? rSize * 0.012, horizontal: horizontalPadding),
      child: widget ??
          Text(
            label,
            style: borderOnly
                ? FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Roboto',
                      color: FlutterFlowTheme.of(context).primary,
                      letterSpacing: 0.0,
                    )
                : FlutterFlowTheme.of(context).displaySmall.override(
                      fontFamily: 'Roboto',
                      color: FlutterFlowTheme.of(context).info,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
          ),
    );
  }

  static Widget btnWithIcon(BuildContext context, String label, Color bgColor, Widget icon) {
    return Container(
      alignment: Alignment.center,
      decoration: gradiantDecoration(context, borderOnly: false, color: bgColor),
      padding: EdgeInsets.symmetric(vertical: rSize * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Text(
            label,
            style: FlutterFlowTheme.of(context).titleSmall.override(
              fontFamily: 'Roboto',
              color: FlutterFlowTheme.of(context).primaryText,
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    );
  }

  static BoxDecoration gradiantDecoration(BuildContext context, {bool borderOnly = false, Color? color}) {
    return BoxDecoration(
        color: borderOnly ? Colors.transparent : color ?? AppColors.kViolate,
        border: Border.all(color: color ?? FlutterFlowTheme.of(context).primary, width: 1),
        borderRadius: BorderRadius.circular(10));
  }

  static Expanded sheetElement(String img, String label, void Function()? onTap, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(rSize * 0.01),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: FlutterFlowTheme.of(context).primaryText, width: 1)),
                child: Image.asset(
                  'assets/$img',
                  scale: 25,
                  color: FlutterFlowTheme.of(context).primaryText,
                )),
            SizedBox(
              height: rSize * 0.01,
            ),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Roboto',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  static void openMediaSelectionBottomSheet(BuildContext context, {required void Function()? onFileClick, required void Function()? onCameraClick}) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          decoration:
              BoxDecoration(color: FlutterFlowTheme.of(context).secondaryBackground, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          height: rSize * 0.15,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppWidgets.sheetElement(
                'media.png',
                'Select File',
                onFileClick,
                context
              ),
              AppWidgets.sheetElement(
                'camera.png',
                'Capture Image',
                onCameraClick,
                context
              ),
            ],
          ),
        );
      },
    );
  }

  static AppBar appBar(BuildContext context, String title, {Widget? leading, List<Widget>? actions, bool centerTitle = false}) {
    return AppBar(
      elevation: 0,
      actions: actions,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      surfaceTintColor: Colors.transparent,
      leading: leading,
      title: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 1,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Roboto',
              color: FlutterFlowTheme.of(context).primary,
              fontSize: 30.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
      ),
      centerTitle: centerTitle,
    );
  }

  static Widget drawer(Function onItemClick) {
    List<String> titleList = ['Home', 'Portfolio', 'Market', 'Proposal', 'Documents', 'Profile'];
    return Container(
      color: AppColors.bg,
      width: rSize * 0.35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                height: rSize * 0.15,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: rSize * 0.015, vertical: rSize * 0.02),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 0, // how wide the shadow is spread
                    blurRadius: 3, // how blurry the shadow is
                    offset: Offset(0, 0),
                  ),
                ], color: AppColors.kViolate, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                child: Column(
                  children: [
                    SizedBox(
                      height: rSize * 0.015,
                    ),
                    Text(
                      'John Wick',
                      style: AppStyles.cFFFFFFW400S18,
                    ),
                    Text(
                      'johnwick@gmail.com',
                      style: AppStyles.cFFFFFFW400S18,
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 2,
                margin: EdgeInsets.only(
                  top: rSize * 0.01,
                  left: rSize * 0.015,
                  right: rSize * 0.015,
                ),
                color: Colors.white,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: titleList.length,
                  padding: EdgeInsets.only(
                    left: rSize * 0.015,
                    right: rSize * 0.015,
                    bottom: rSize * 0.015,
                    top: rSize * 0.04,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (titleList[index] == 'Documents') {
                          CommonFunctions.navigate(context, Documents());
                        }
                        if (titleList[index] == 'Profile') {
                          onItemClick(4);
                        } else {
                          onItemClick(index);
                        }
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/${titleList[index].toLowerCase()}.png',
                            scale: 25,
                            color: AppColors.kTextFieldInput,
                          ),
                          SizedBox(
                            width: rSize * 0.015,
                          ),
                          Expanded(
                            child: Text(
                              titleList[index],
                              style: AppStyles.c656262W500S18,
                            ),
                          ),
                          RotatedBox(
                              quarterTurns: 2,
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: AppColors.kTextFieldInput,
                                size: 15,
                              ))
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      color: AppColors.kTextFieldInput,
                      margin: EdgeInsets.symmetric(vertical: rSize * 0.01),
                      height: 0.5,
                    );
                  },
                ),
              ),
              Expanded(child: SizedBox()),
              Text(
                'Version 1.0.0',
                style: AppStyles.c656262W500S18,
              ),
              SizedBox(
                height: rSize * 0.015,
              )
            ],
          ),
          Positioned(
            top: rSize * 0.1,
            child: const CircleAvatar(
              child: Icon(Icons.face),
              radius: 40,
            ),
          ),
        ],
      ),
    );
  }

  static dropDownIcon() {
    return const Icon(
      Icons.keyboard_arrow_down_rounded,
      color: Color(0xff8B8B8B),
    );
  }

  static Widget dropDownHint(BuildContext context, String text) {
    return Text(
      textAlign: TextAlign.start,
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: FlutterFlowTheme.of(context).displaySmall.override(
            fontFamily: 'Roboto',
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 16.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  static showAlert(BuildContext context, String msg, String label1, String label2, void Function()? onTap1, void Function()? onTap2,
      {Color? btn1BgColor, Color? btn2BgColor}) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(rSize * 0.04),
            child: Wrap(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    child: Column(
                      children: [
                        SizedBox(
                          height: rSize * 0.02,
                        ),
                        Text(
                          msg,
                          style: FlutterFlowTheme.of(context).headlineMedium.override(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(onTap: onTap1, child: btn(context, label1, horizontalPadding: rSize * 0.02, bgColor: btn1BgColor)),
                            SizedBox(
                              width: rSize * 0.02,
                            ),
                            GestureDetector(onTap: onTap2, child: btn(context, label2, horizontalPadding: rSize * 0.02, bgColor: btn2BgColor)),
                          ],
                        ),
                        SizedBox(
                          height: rSize * 0.02,
                        )
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

  static void openDatePicker(BuildContext context, dynamic Function(Object?)? onSubmit, void Function()? onCancel,
      {DateRangePickerSelectionMode mode = DateRangePickerSelectionMode.range}) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Wrap(
          children: [
            SfDateRangePicker(
              view: DateRangePickerView.month,
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              onSubmit: onSubmit,
              rangeTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),
              selectionTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),
              cellBuilder: (context, cellDetails) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  height: 10,
                  width: 10,
                  alignment: Alignment.center,
                  child: Text(
                    cellDetails.date.day.toString(),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Roboto',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                );
              },
              selectionShape: DateRangePickerSelectionShape.circle,
              startRangeSelectionColor: FlutterFlowTheme.of(context).primary,
              endRangeSelectionColor: FlutterFlowTheme.of(context).primary,
              rangeSelectionColor: FlutterFlowTheme.of(context).primary,
              selectionMode: mode,headerStyle: DateRangePickerHeaderStyle(backgroundColor:FlutterFlowTheme.of(context).secondaryBackground,textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Roboto',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 16.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.normal,
            ), ),
              monthViewSettings: DateRangePickerMonthViewSettings(
                firstDayOfWeek: 1,
              ),
              showActionButtons: true,
              onCancel: onCancel,
            ),
          ],
        ),
      ),
    );
  }

  static String getStatus(String? status) {
    if (status == '-') {
      return 'Not checked';
    } else if (status == 'true') {
      return 'No issues have been detected';
    } else if (status == 'false') {
      return 'The following investment are not in line with your financial knowledge';
    }
    return '';
  }
}
