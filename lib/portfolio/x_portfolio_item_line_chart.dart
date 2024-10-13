// Automatic FlutterFlow imports
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kleber_bank/utils/app_widgets.dart';

// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'dart:math';

import '../main.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';
import '../utils/shared_pref_utils.dart';

class XPortfolioItemLineChart extends StatefulWidget {
  const XPortfolioItemLineChart({
    super.key,
    this.width,
    this.height,
    this.customWidth,
    this.xLabels = const [],
    this.listY = const [],
    this.listAmount = const [],
    this.additionPercents = const [],
    this.sectionName='',
  });

  final double? width;
  final double? height;
  final double? customWidth;
  final List<String> xLabels;
  final List<double> listY;
  final List<double> listAmount;
  final List<double> additionPercents;
  final String? sectionName;

  @override
  State<XPortfolioItemLineChart> createState() => _XPortfolioItemLineChartState();
}

class _XPortfolioItemLineChartState extends State<XPortfolioItemLineChart> {
  final barWidth = rSize * 0.030;
  final barsSpace = rSize * 0.010;
  final groupsSpace = rSize * 0.100;
  final leftTitleReservedSize = rSize * 0.046;
  final columnStart = rSize * 0.099;

  late double touchedValue;
  final color = Color(0xFF3D51A2);

  bool fitInsideBottomTitle = true;
  bool fitInsideLeftTitle = false;

  TrackballBehavior? _trackballBehavior;

  // late List<String> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    touchedValue = -1;
    super.initState();
    _tooltip = TooltipBehavior(enable: true);
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'),
    );
  }

  final initialVisibleMaximum = 2.5;

  double getMinY() {
    var minY = widget.listY.reduce((a, b) => a < b ? a : b);
    // final numberOfLines = minY ~/ getYAxisInterval();
    // if (minY > numberOfLines * getYAxisInterval()) {
    //   minY = numberOfLines * getYAxisInterval();
    // }
    return minY;
  }

  double getYAxisInterval() {
    return 1.0;
  }

  List<CartesianChartAnnotation> getAnnotations() {
    final length = widget.xLabels.length;
    final additionalValue = getYAxisInterval() / 2;
    List<CartesianChartAnnotation> annotations = [];
    for (int i = 0; i < length; i++) {
      final additionPercent = widget.additionPercents[i];
      final valueToShow = double.tryParse('${additionPercent}') ?? 0;
      final valueToShowStr = valueToShow == valueToShow.roundToDouble() ? '${valueToShow.round()}' : '$additionPercent';
      annotations.add(
        CartesianChartAnnotation(
          region: AnnotationRegion.plotArea,
          widget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$valueToShowStr%',
                style: FlutterFlowTheme.of(context).displaySmall.override(
                      fontFamily: 'Roboto',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: rSize * 0.016,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              if (additionPercent != 0)
                Icon(
                  additionPercent > 0 ? FontAwesomeIcons.caretUp : FontAwesomeIcons.caretDown,
                  color: additionPercent > 0 ? FlutterFlowTheme.of(context).customColor2 : FlutterFlowTheme.of(context).customColor3,
                  size: rSize * 0.018,
                ),
            ],
          ),
          coordinateUnit: CoordinateUnit.point,
          x: getDate(i),
          y: columnStart + additionPercent + (additionPercent > 0 ? additionalValue : -additionalValue),
        ),
      );
    }
    return annotations;
  }

  List<CartesianSeries> _getSampleLineSeries() {
    return <CartesianSeries>[
      RangeColumnSeries<String, String>(
        dataSource: widget.xLabels,
        xValueMapper: (String label, _) => label,
        highValueMapper: (String label, int index) {
          final additionPercent = widget.additionPercents[index];
          if (additionPercent < 0) {
            return columnStart;
          }
          return columnStart + additionPercent;
        },
        lowValueMapper: (String label, int index) {
          final additionPercent = widget.additionPercents[index];
          if (additionPercent >= 0) {
            return columnStart;
          }
          return columnStart + additionPercent;
        },
        pointColorMapper: (String label, int index) => FlutterFlowTheme.of(context).primary,
        initialIsVisible: true,
        name: 'RangeColumnSeries',
        color: Colors.white,
        // FlutterFlowTheme.of(context).alternate,
        enableTooltip: false,
      ),
      LineSeries<String, String>(
        dataSource: widget.xLabels,
        initialIsVisible: true,
        xValueMapper: (String label, _) => label,
        yValueMapper: (String label, index) => widget.listY[index],
        width: 2,
        markerSettings: const MarkerSettings(isVisible: true),
        color: FlutterFlowTheme.of(context).customColor1,
        name: 'LineSeries',
      ),
    ];
  }

  Widget buildSFLineChart() {
    final isAr = (SharedPrefUtils.instance.getString(SELECTED_LANGUAGE) == 'ar');
    final overIntialVisible = widget.xLabels.length > (initialVisibleMaximum.floor() + 1);
    return Row(
      children: [
        Expanded(
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            // title: ChartTitle(
            //   text: 'syncfusion_flutter_charts\nline & spline',
            //   textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            // ),
            primaryXAxis: CategoryAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              tickPosition: TickPosition.inside,
              majorGridLines: const MajorGridLines(width: 0),
              axisLine: AxisLine(color: FlutterFlowTheme.of(context).primaryText, width: 0.5),
              labelRotation: 45,
              labelStyle: FlutterFlowTheme.of(context).displaySmall.override(
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.of(context).customColor4,
                    fontSize: rSize * 0.014,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),
              initialVisibleMaximum: initialVisibleMaximum,
              labelIntersectAction: AxisLabelIntersectAction.none,
              isInversed: isAr,
            ),
            primaryYAxis: NumericAxis(
              labelFormat: '{value}%',
              axisLine: AxisLine(color: FlutterFlowTheme.of(context).primaryText, width: 0.5),
              interval: getYAxisInterval(),
              majorGridLines: MajorGridLines(
                color: Colors.grey.withOpacity(0.5), // Color of horizontal grid lines
                width: 0.5, // Width of horizontal grid lines
              ),
              opposedPosition: isAr,
              labelStyle: FlutterFlowTheme.of(context).displaySmall.override(
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.of(context).customColor4,
                    fontSize: rSize * 0.014,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
            ),
            series: _getSampleLineSeries(),
            // tooltipBehavior:
            //     TooltipBehavior(enable: true, header: '', canShowMarker: false),
            trackballBehavior: _trackballBehavior,
            annotations: getAnnotations(),
            onTrackballPositionChanging: (TrackballArgs args) {
              // Storing series in a variable to access its elements.
              ChartSeriesRenderer<dynamic, dynamic> seriesRender = args.chartPointInfo.series;

              // Checking if the series name is equal to name of the range column series.
              if (seriesRender.name == 'RangeColumnSeries') {
                args.chartPointInfo.header = '';
                args.chartPointInfo.label = '';
              }
            },
          ),
        ),
        if (overIntialVisible) ...[
          SizedBox(width: rSize * 0.002),
          Icon(
            Icons.chevron_right_rounded,
            size: rSize * 0.025,
            color: Color(0xFF8C8C8C),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: widget.customWidth,
      height: widget.height,
      child: widget.xLabels.isEmpty ? null : circularChart() /*buildSFLineChart()*/,
    );
  }

  circularChart() {/*
    widget.listY.removeAt(0);
    widget.listY.removeAt(0);
    widget.listY.insert(0,20);
    widget.listY.insert(0,50);*/
    if(widget.sectionName==FFLocalizations.of(context).getText(
      '7h0zeqv0' /* Asset Class */,
    )){
      return SfCircularChart(tooltipBehavior: _tooltip,
          legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.scroll,position:LegendPosition.right,legendItemBuilder: (legendText, series, point, seriesIndex) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      legendText,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        fontSize: rSize*0.014,
                        color: FlutterFlowTheme.of(context).customColor4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '(${widget.listY[seriesIndex]}%)',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        fontSize: rSize*0.012,
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                )
              ],
            );
          }, ),
          series: <CircularSeries<String, String>>[
            DoughnutSeries<String, String>(
                dataSource: widget.xLabels,innerRadius: '70%',
                xValueMapper: (String data, _) => getDate(_),
                yValueMapper: (String data, _) => widget.listY[_]<0?0:widget.listY[_],emptyPointSettings: EmptyPointSettings(),
                dataLabelMapper: (datum, _) => '${widget.listY[_]<0?0:widget.listY[_]}%',
                // pointColorMapper: (datum, index) => FlutterFlowTheme.of(context).primary.withOpacity(),
                dataLabelSettings: DataLabelSettings(
                  textStyle: FlutterFlowTheme.of(context).displaySmall.override(
                    fontFamily: 'Roboto',
                    fontSize: rSize * 0.014,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),isVisible: false,overflowMode:OverflowMode.shift, ),enableTooltip: true,
                name: 'Gold')
          ]);
    }if(widget.sectionName==FFLocalizations.of(context).getText(
      'o00oeypg' /* Currency */,
    )){
      return SfCircularChart(tooltipBehavior: _tooltip,
          legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.scroll,position:LegendPosition.right,legendItemBuilder: (legendText, series, point, seriesIndex) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      legendText,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        fontSize: rSize*0.014,
                        color: FlutterFlowTheme.of(context).customColor4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '(${widget.listY[seriesIndex]}%)',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Roboto',
                        fontSize: rSize*0.012,
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                )
              ],
            );
          }, ),
          series: <CircularSeries<String, String>>[
            DoughnutSeries<String, String>(
                dataSource: widget.xLabels,innerRadius: '70%',
                xValueMapper: (String data, _) => getDate(_),
                yValueMapper: (String data, _) => widget.listY[_],emptyPointSettings: EmptyPointSettings(),
                dataLabelMapper: (datum, _) => '${widget.listY[_]}%\n(${widget.listAmount[_]})',
                dataLabelSettings: DataLabelSettings(
                  textStyle: FlutterFlowTheme.of(context).displaySmall.override(
                    fontFamily: 'Roboto',
                    fontSize: rSize * 0.014,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),isVisible: false,overflowMode:OverflowMode.shift, ),enableTooltip: true,
                name: 'Gold')
          ]);
    }
    return SfCircularChart(tooltipBehavior: _tooltip,
        legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.scroll,position:LegendPosition.right,legendItemBuilder: (legendText, series, point, seriesIndex) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    legendText,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Roboto',
                      fontSize: rSize*0.014,
                      color: FlutterFlowTheme.of(context).customColor4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '(${widget.listY[seriesIndex]}%)',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Roboto',
                      fontSize: rSize*0.012,
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              )
            ],
          );
        }, ),
        series: <CircularSeries<String, String>>[
      DoughnutSeries<String, String>(
          dataSource: widget.xLabels,innerRadius: '70%',
          xValueMapper: (String data, _) => getDate(_),
          yValueMapper: (String data, _) => widget.listY[_],emptyPointSettings: EmptyPointSettings(),
          dataLabelMapper: (datum, _) => '${widget.listY[_]}%\n(${getDate(_)})',
          dataLabelSettings: DataLabelSettings(
              textStyle: FlutterFlowTheme.of(context).displaySmall.override(
                    fontFamily: 'Roboto',
                    fontSize: rSize * 0.014,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),isVisible: false,overflowMode:OverflowMode.shift, ),enableTooltip: true,
          name: 'Gold')
    ]);
  }

  String getDate(int _) => widget.xLabels[_];
}
