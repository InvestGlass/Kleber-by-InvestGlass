// Automatic FlutterFlow imports

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kleber_bank/utils/app_colors.dart';
import 'package:kleber_bank/utils/common_functions.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/flutter_flow_theme.dart';

class XPortfoliItemBarChart extends StatefulWidget {
  const XPortfoliItemBarChart({
    super.key,
    this.width,
    this.height,
    this.xLabels = const [],
    this.listY1 = const [],
    this.listY2 = const [],
    this.listY3 = const [],
    this.showPercentageWithUpDownArrowOnTopOfBar = false,
    this.showAmountWhenClickOnBar = false,
  });

  final double? width;
  final double? height;
  final List<String> xLabels;
  final List<double> listY1;
  final List<double> listY2;
  final List<double> listY3;
  final bool? showPercentageWithUpDownArrowOnTopOfBar;
  final bool? showAmountWhenClickOnBar;

  @override
  State<XPortfoliItemBarChart> createState() => _XPortfoliItemBarChartState();
}

class _XPortfoliItemBarChartState extends State<XPortfoliItemBarChart> {
  final barWidth = 30.0;
  final barsSpace = 10.0;
  final groupsSpace = 70.0;
  final leftTitleReservedSize = 46.0;
  // TooltipBehavior? _tooltipBehavior;
  TrackballBehavior? _trackballBehavior;

  @override
  void initState() {
    super.initState();
    // _tooltipBehavior =
    //     TooltipBehavior(enable: true, header: '', canShowMarker: false);
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'),
      builder: widget.showAmountWhenClickOnBar == true ? buildTrackBall : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final width = calculateWidth();
    // debugPrint('width of column chart: $width');
    return Container(
      height: widget.height,
      child: widget.xLabels.isEmpty ? null : buildColumnChart(),
    );
  }

  Widget buildTrackBall(
      BuildContext context, TrackballDetails trackballDetails) {
    final point = trackballDetails.point;
    final index = trackballDetails.pointIndex;
    final seriesIndex = trackballDetails.seriesIndex;
    final markerSize = 10.0;
    final amountValue = index == null ? null : widget.listY3[index];
    final amountString = amountValue == null
        ? ''
        : CommonFunctions.formatDoubleWithThousandSeperator(
            '$amountValue', amountValue == 0, 2);
    return Container(
      // height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF), //FlutterFlowTheme.of(context).alternate,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: markerSize,
            width: markerSize,
            decoration: BoxDecoration(
              color: seriesIndex == 0
                  ? Color(0xFFC8C8C8)
                  : AppColors.kViolate,
              borderRadius: BorderRadius.all(Radius.circular(markerSize)),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            '${point?.x?.toString() ?? ''} : ',
            style: FlutterFlowTheme.of(context).displaySmall.override(
              fontFamily: 'Roboto',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 12.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            amountString,
            style: FlutterFlowTheme.of(context).displaySmall.override(
              fontFamily: 'Roboto',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 12.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildColumnChart() {
    final isAr = false/*true if current language is arebic*/;
    final initialVisibleMaximum = checkShowSecondColumn() ? 1.5 : 2.5;
    final overIntialVisible =
        widget.xLabels.length > (initialVisibleMaximum.floor() + 1);
    return Row(
      children: [
        Expanded(
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            backgroundColor: Colors.transparent,
            borderWidth: 0.5,
            primaryXAxis: CategoryAxis(
              axisLine: AxisLine(color: FlutterFlowTheme.of(context).primaryText,width: 0.5),
              majorGridLines: const MajorGridLines(width: 0),
              labelRotation: 45,labelStyle: FlutterFlowTheme.of(context).displaySmall.override(
              fontFamily: 'Roboto',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 14.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.normal,
            ),
              isInversed: isAr,isVisible: true,
              initialVisibleMaximum: initialVisibleMaximum,
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: MajorGridLines(
                color: Colors.grey.withOpacity(0.5), // Color of horizontal grid lines
                width: 0.5, // Width of horizontal grid lines
              ),
            axisLine: AxisLine(color: FlutterFlowTheme.of(context).primaryText,width: 0.5),
              labelFormat: '{value}%',isVisible: true,labelStyle: FlutterFlowTheme.of(context).displaySmall.override(
              fontFamily: 'Roboto',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 14.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.normal,
            ),
              majorTickLines: const MajorTickLines(size: 0),
              interval: getYAxisInterval(),
              opposedPosition: isAr,
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
            ),
            series: _getDefaultColumnSeries(),
            // tooltipBehavior: _tooltipBehavior,
            trackballBehavior: _trackballBehavior,
            annotations: getAnnotations(),
          ),
        ),
        if (overIntialVisible) ...[
          const SizedBox(width: 2),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.kTextFieldInput,
          ),
        ],
      ],
    );
  }

  CartesianChartAnnotation buildSingleAnnotation(
      String x, double y, ChartAlignment horizontalAlignment) {
    final additionValue = getYAxisInterval() / 3;
    final value = double.tryParse('${y}') ?? 0;
    final valueStr =
        value == value.roundToDouble() ? '${value.round()}' : '$value';
    return CartesianChartAnnotation(
      region: AnnotationRegion.plotArea,
      horizontalAlignment: horizontalAlignment,
      widget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$valueStr%', style: FlutterFlowTheme.of(context).displaySmall.override(
        fontFamily: 'Roboto',
        color: FlutterFlowTheme.of(context).primaryText,
        fontSize: 12.0,
        letterSpacing: 0.0,
        fontWeight: FontWeight.w500,
      ),),
          if (value != 0)
            Icon(
              value > 0 ? FontAwesomeIcons.caretUp : FontAwesomeIcons.caretDown,
              color: value > 0
                  ? FlutterFlowTheme.of(context).customColor2
                  : FlutterFlowTheme.of(context).customColor3,
              size: 18,
            ),
        ],
      ),
      coordinateUnit: CoordinateUnit.point,
      x: x,
      y: value + (value >= 0 ? additionValue : -additionValue),
    );
  }

  List<CartesianChartAnnotation> getAnnotations() {
    final length = widget.xLabels.length;
    List<CartesianChartAnnotation> annotations = [];
    final showSecondColumn = checkShowSecondColumn();
    for (int i = 0; i < length; i++) {
      final x = widget.xLabels[i];
      if (showSecondColumn) {
        annotations.add(
            buildSingleAnnotation(x, widget.listY1[i], ChartAlignment.far));
        annotations.add(
            buildSingleAnnotation(x, widget.listY2[i], ChartAlignment.near));
      } else {
        annotations.add(
            buildSingleAnnotation(x, widget.listY1[i], ChartAlignment.center));
      }
    }
    return annotations;
  }

  /// Get default column series
  List<CartesianSeries> _getDefaultColumnSeries() {
    return <CartesianSeries>[
      ColumnSeries<String, String>(
        dataSource: widget.xLabels,
        xValueMapper: (String label, _) => label,
        yValueMapper: (String label, int index) => widget.listY1[index],
        pointColorMapper: (String label, int index) => Color(0xFFC8C8C8),
        width: 0.8,
        name: 'ColumnSeries',
        color: Colors.white,
      ),
      if (checkShowSecondColumn())
        ColumnSeries<String, String>(
          dataSource: widget.xLabels,
          xValueMapper: (String label, _) => label,
          yValueMapper: (String label, int index) => widget.listY2[index],
          pointColorMapper: (String label, int index) =>
              AppColors.kViolate,
          width: 0.8,
          name: 'ColumnSeries',
          color: Colors.white, //FlutterFlowTheme.of(context).alternate,
        ),
    ];
  }

  bool checkShowSecondColumn() {
    int countDifferentFrom0 = 0;
    widget.listY2.forEach((e) {
      if (e > 0) {
        countDifferentFrom0++;
      }
    });
    return countDifferentFrom0 > 0;
  }

  double calculateWidth() {
    final barGroupSpace = barWidth * 2 + barsSpace;
    final length = widget.xLabels.length;
    const bonusSpace = 50.0;
    return barGroupSpace * (length) +
        groupsSpace * (length - 1) +
        leftTitleReservedSize +
        bonusSpace;
  }

  double getMaxY() {
    final maxY1 = widget.listY1.reduce((a, b) => a > b ? a : b);
    final maxY2 = widget.listY2.reduce((a, b) => a > b ? a : b);
    final maxY12 = max(maxY1, maxY2);
    var maxY = maxY12 < 100 ? 100 : maxY12;
    final numberOfLines = maxY ~/ 20;
    if (numberOfLines * 20 < maxY) {
      maxY = (numberOfLines + 1) * 20;
    }
    return maxY.toDouble();
  }

  double getminY() {
    final minY1 = widget.listY1.reduce((a, b) => a < b ? a : b);
    final minY2 = widget.listY2.reduce((a, b) => a < b ? a : b);
    var minY = min(minY1, minY2);
    final numberOfLines = minY ~/ 20;
    if (minY < 0 && minY < numberOfLines * 20) {
      minY = numberOfLines * 20;
    }
    return minY;
  }

  double getYAxisInterval() {
    // final minY = getminY();
    // final maxY = getMaxY();
    // final fullRange = minY < 0 ? (maxY - minY) : (maxY + minY);
    return 20;
  }
}