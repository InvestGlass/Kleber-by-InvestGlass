import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../main.dart';
import '../portfolio/portfolio_model.dart';
import 'app_colors.dart';
import 'flutter_flow_theme.dart';
import 'internationalization.dart';

class AppWidgets {
  static void showSignDialog(BuildContext context, {required Function onReject, required Function onAccept}) {
    AppWidgets.showAlert(
        context,
        FFLocalizations.of(context).getText(
          'apuqhrbh' /* please confirm */,
        ),
        FFLocalizations.of(context).getText(
          'c4m8fcp2' /* reject */,
        ),
        FFLocalizations.of(context).getText(
          'e1wyk8ql' /* accept */,
        ), () {
      onReject();
    }, () {
      onAccept();
    }, btn1BgColor: FlutterFlowTheme.of(context).customColor3, btn2BgColor: FlutterFlowTheme.of(context).customColor2);
  }

  static Container healthAlertElement(
      BuildContext context, String title, Color bgColor, IconData iconData, String label, Appropriateness model, TextStyle textStyle) {
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(rSize * 0.010), boxShadow: AppStyles.shadow()),
      padding: EdgeInsets.symmetric(horizontal: rSize * 0.02, vertical: rSize * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                color: textStyle.color,
                size: rSize * 0.020,
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
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: rSize * 0.016,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              getStatus(model.status,context),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: rSize * 0.016,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            SizedBox(
              height: rSize * 0.01,
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                          height: rSize * 0.008,
                          width: rSize * 0.008,
                        ),
                        SizedBox(
                          width: rSize * 0.015,
                        ),
                        Expanded(
                          child: Text(
                            model.listDetails![index],
                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: rSize * 0.016,
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
                      color: FlutterFlowTheme.of(context).customColor2,
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

  static Widget portfolioListElement(BuildContext context, String label, String value, {String middleValue = '', Widget? icon, Widget? richText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontSize: rSize * 0.016,
                color: FlutterFlowTheme.of(context).customColor4,
              ),
        ),
        if (middleValue.isNotEmpty) ...{
          if (isAmount(middleValue)) ...{
            buildRichText(context, middleValue)
          } else ...{
            Text(
              middleValue,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontSize: rSize * 0.016,
                  ),
            )
          }
        },
        if (middleValue.isEmpty) ...{
          SizedBox(
            width: rSize * 0.015,
          ),
          if (richText != null) ...{
            const Expanded(
              child: SizedBox(),
            ),
            richText
          } else ...{
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: FlutterFlowTheme.of(context).customColor4,
                      fontSize: rSize * 0.016,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            )
          },
          if (icon != null) ...{
            const SizedBox(
              width: 10,
            ),
            icon
          }
        } else ...{
          Text(
            value,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: rSize * 0.016,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.normal,
                ),
          )
        },
      ],
    );
  }

  static bool isAmount(String middleValue) => middleValue.contains(' ') && middleValue.contains('.');

  static emptyView(String msg, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.list_alt,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 120.0,
        ),
        Text(
          msg,
          style: FlutterFlowTheme.of(context).bodyLarge.override(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: rSize * 0.02,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }

  static Widget btn(BuildContext context, String label,
      {double? width,
      double horizontalPadding = 0,
      Widget? widget,
      bool borderOnly = false,
      Color? bgColor,
      EdgeInsetsGeometry? margin,
      Color? textColor}) {
    return Container(
      width: width,
      height: btnHeight,
      alignment: Alignment.center,
      margin: margin,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: gradiantDecoration(context, borderOnly: borderOnly, color: bgColor),
      child: widget ??
          Text(
            label,
            style: borderOnly
                ? FlutterFlowTheme.of(context).titleSmall.override(
                      fontSize: rSize * 0.014,
                      color: borderOnly?FlutterFlowTheme.of(context).customColor4:FlutterFlowTheme.of(context).primary,
                    )
                : FlutterFlowTheme.of(context).titleSmall.override(
                      color: textColor ?? Colors.white,
                      fontSize: rSize * 0.014,
                    ),
          ),
    );
  }

  static Widget btnWithoutGradiant(BuildContext context, String label, Color bgColor,
      {double? width, double horizontalPadding = 0, EdgeInsetsGeometry? margin, Color? textColor}) {
    return Container(
      width: width,
      height: btnHeight,
      alignment: Alignment.center,
      margin: margin,
      decoration: BoxDecoration(color: bgColor, border: Border.all(color: bgColor, width: 1), borderRadius: BorderRadius.circular(rSize * 0.010)),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Text(
        label,
        style: FlutterFlowTheme.of(context).titleSmall.override(
              color: Colors.white,
              fontSize: rSize * 0.014,
            ),
      ),
    );
  }

  static label(BuildContext context, String text) {
    return Text(
      text,
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontSize: rSize * 0.016,
            color: FlutterFlowTheme.of(context).customColor4,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  static title(BuildContext context, String text,{bool center=false}) {
    return Text(
      text,
      textAlign: center?TextAlign.center:null,
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            color: FlutterFlowTheme.of(context).customColor4,
            fontSize: rSize * 0.025,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  static Widget btnWithIcon(BuildContext context, String label, Color bgColor, Widget icon) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(rSize * 0.010)),
      height: btnHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Text(
            label,
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }

  static BoxDecoration gradiantDecoration(BuildContext context, {bool borderOnly = false, Color? color}) {
    if (borderOnly) {
      return BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: color ?? FlutterFlowTheme.of(context).customColor4, width: 1),
          borderRadius: BorderRadius.circular(rSize * 0.010));
    }
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [
              FlutterFlowTheme.of(context).customColor1,
              color ?? FlutterFlowTheme.of(context).primary,
            ],
            begin: Alignment.centerLeft,
            // Gradient starts from the left
            end: Alignment.centerRight,
            // Gradient ends on the right
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        boxShadow: AppStyles.shadow(),
        borderRadius: BorderRadius.circular(rSize * 0.008));
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
                    borderRadius: BorderRadius.all(Radius.circular(rSize * 0.020)),
                    border: Border.all(color: FlutterFlowTheme.of(context).primaryText, width: 1)),
                child: Image.asset(
                  'assets/$img',
                  height: rSize * 0.025,
                  width: rSize * 0.025,
                  color: FlutterFlowTheme.of(context).primaryText,
                )),
            SizedBox(
              height: rSize * 0.01,
            ),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: rSize * 0.016,
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
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(rSize * 0.020), topRight: Radius.circular(rSize * 0.020))),
          height: rSize * 0.15,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppWidgets.sheetElement(
                  'media.png',
                  FFLocalizations.of(context).getText(
                    "select_file",
                  ),
                  onFileClick,
                  context),
              AppWidgets.sheetElement(
                  'camera.png',
                  FFLocalizations.of(context).getText(
                    "capture_image",
                  ),
                  onCameraClick,
                  context),
            ],
          ),
        );
      },
    );
  }

  static doubleBack(BuildContext context) {
    return Image.asset(
      'assets/double_arrow.png',
      height: rSize * 0.02,
      color: FlutterFlowTheme.of(context).customColor4,
    );
  }

  static backArrow(BuildContext context, {void Function()? onTap}) {
    return AppStyles.iconBg(context, data: Icons.arrow_back, size: rSize * 0.025,color:FlutterFlowTheme.of(context).customColor4,onTap: () {
      if (onTap != null) {
        onTap();
      } else {
        Navigator.pop(context);
      }
    },);
  }

  static PreferredSize appBar(BuildContext context, String title, {Widget? leading, List<Widget>? actions, bool centerTitle = false}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(rSize * 0.06),
      child: /*!isTablet
          ? Container(
              color: FlutterFlowTheme.of(context).primaryBackground,
              padding: EdgeInsets.symmetric(horizontal: rSize * 0.015),
              child: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  appbar_(context, title, leading: leading, actions: actions, centerTitle: centerTitle),
                  const Expanded(child: SizedBox()),
                ],
              ),
            )
          : */appbar_(context, title, leading: leading, actions: actions, centerTitle: centerTitle),
    );
  }

  static AppBar appbar_(BuildContext context, String txt, {Widget? leading, List<Widget>? actions, bool centerTitle = false}) {
    return AppBar(
      elevation: 0,
      actions: actions,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      toolbarHeight: rSize * 0.08,
      surfaceTintColor: Colors.transparent,
      leading: leading,
      leadingWidth: rSize*0.06,
      title: title(context, txt),
      centerTitle: true,
    );
  }

  static RichText buildRichText(BuildContext context, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: (value.split(' ')[1]).split('.')[0],
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: rSize * 0.016,
                  fontWeight: FontWeight.w800,
                ),
          ),
          TextSpan(
            text: '.${(value.split(' ')[1]).split('.')[1]}',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: FlutterFlowTheme.of(context).customColor4,
                  fontSize: rSize * 0.016,
                  fontWeight: FontWeight.w800,
                ),
          ),
          TextSpan(
            text: ' ${value.split(' ')[0]}',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: FlutterFlowTheme.of(context).customColor4,
                  fontSize: rSize * 0.016,
                  fontWeight: FontWeight.normal,
                ),
          ),
          if (value.split(' ').length > 2) ...{
            TextSpan(
              text: ' ${value.split(' ')[2]}',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: rSize * 0.016,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          },
          if (value.split(' ').length > 3) ...{
            TextSpan(
              text: value.split(' ')[3],
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: rSize * 0.016,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          }
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
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: rSize * 0.016,
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
                  borderRadius: BorderRadius.circular(rSize * 0.01),
                  child: Material(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: rSize * 0.015),
                      child: Column(
                        children: [
                          SizedBox(
                            height: rSize * 0.02,
                          ),
                          Text(
                            msg,
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context).headlineMedium.override(
                                  color: FlutterFlowTheme.of(context).customColor4,
                                  fontSize: rSize * 0.026,
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
                              GestureDetector(
                                  onTap: onTap1,
                                  child: btnWithoutGradiant(
                                    context,
                                    label1,
                                    btn1BgColor!,
                                    horizontalPadding: rSize * 0.02,
                                  )),
                              SizedBox(
                                width: rSize * 0.02,
                              ),
                              GestureDetector(
                                  onTap: onTap2,
                                  child: btnWithoutGradiant(
                                    context,
                                    label2,
                                    btn2BgColor!,
                                    horizontalPadding: rSize * 0.02,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: rSize * 0.02,
                          )
                        ],
                      ),
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
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(rSize * 0.015), color: FlutterFlowTheme.of(context).secondaryBackground),
              padding: EdgeInsets.all(rSize * 0.010),
              margin: EdgeInsets.all(rSize * 0.015),
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                backgroundColor: Colors.transparent,
                onSubmit: onSubmit,
                rangeTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: FlutterFlowTheme.of(context).customColor4,
                      fontSize: rSize * 0.016,
                      fontWeight: FontWeight.normal,
                    ),
                selectionTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: FlutterFlowTheme.of(context).customColor4,
                      fontSize: rSize * 0.016,
                      fontWeight: FontWeight.normal,
                    ),
                cellBuilder: (context, cellDetails) {
                  return Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    height: rSize * 0.010,
                    width: rSize * 0.010,
                    alignment: Alignment.center,
                    child: Text(
                      cellDetails.date.day.toString(),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            color: FlutterFlowTheme.of(context).customColor4,
                            fontSize: rSize * 0.016,
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
                selectionMode: mode,
                headerStyle: DateRangePickerHeaderStyle(
                  backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: rSize * 0.016,
                        fontWeight: FontWeight.normal,
                      ),
                ),
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  firstDayOfWeek: 1,
                ),
                showActionButtons: true,
                onCancel: onCancel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String getStatus(String? status, BuildContext context) {
    if (status == '-') {
      return FFLocalizations.of(context).getText('834hxg71'/*not checked*/);
    } else if (status == 'true') {
      return FFLocalizations.of(context).getText('zz2ivcgu' /* No issues have been detected */);
    } else if (status == 'false') {
      return FFLocalizations.of(context).getText('bwcpcgd0' /* The following investment are no.. */);
    }
    return '';
  }
}
