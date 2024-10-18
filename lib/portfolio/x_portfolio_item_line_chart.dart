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
    this.sectionName = '',
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
      enable: true,builder: (context, trackballDetails) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: rSize*0.02,vertical: rSize*0.002),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
          color: FlutterFlowTheme.of(context).primary),
          child: label(context, '${widget.xLabels[trackballDetails.pointIndex!]} : ${widget.additionPercents[trackballDetails.pointIndex!]}%'),);
      },
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

                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: rSize * 0.016,
                      letterSpacing: 0,
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
          x: widget.xLabels[i],
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

                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: rSize * 0.014,
                    letterSpacing: 0,
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

                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: rSize * 0.014,
                    letterSpacing: 0,
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
          const SizedBox(width: 2),
          Icon(
            Icons.chevron_right_rounded,
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
      child: widget.xLabels.isEmpty
          ? Image.asset('assets/empty_chart.png')
          : !isPerformance(context)
              ? circularChart()
              : buildSFLineChart(),
    );
  }

  bool isPerformance(BuildContext context) {
    return widget.sectionName ==
            FFLocalizations.of(context).getText(
              'zomhasya' /* Performance */,
            ) ||
        widget.sectionName == null;
  }

  circularChart() {
    List<ChartModel> list = List<ChartModel>.generate(
      widget.listY.length,
      (index) => ChartModel(widget.listY[index]<=0?0:widget.listY[index], widget.xLabels[index], widget.listAmount.isEmpty ? 0 : widget.listAmount[index]),
    );
    list.sort((a, b) => a.percentage.compareTo(b.percentage));
      return SfCircularChart(
          tooltipBehavior: _tooltip,
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.scroll,
            position: LegendPosition.right,
            legendItemBuilder: (legendText, series, point, seriesIndex) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: rSize*0.13,minWidth:rSize*0.13 ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: getColor(list[seriesIndex].percentage,widget.listY.reduce((a, b) => a > b ? a : b),widget.listY.reduce((a, b) => a < b ? a : b))
                        color: colorList[seriesIndex]
                      ),
                      height: rSize*0.02,
                      width: rSize*0.02,
                      margin: EdgeInsets.only(right: rSize*0.01),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            legendText,maxLines: 1,overflow: TextOverflow.ellipsis,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(

                                  fontSize: rSize * 0.014,
                                  color: FlutterFlowTheme.of(context).customColor4,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            '(${list[seriesIndex].percentage}%)',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(

                                  fontSize: rSize * 0.012,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.normal,
                                ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          series: <CircularSeries>[
            DoughnutSeries<ChartModel, String>(
                dataSource: list,
                innerRadius: '70%',
                xValueMapper: (ChartModel data, _) => list[_].label,explode: true,
                yValueMapper: (ChartModel data, _) => list[_].percentage < 0 ? 0 : list[_].percentage,
                pointColorMapper: (ChartModel data, _) {
                  // Get the color based on the sales value
                  // return getColor(data.percentage,widget.listY.reduce((a, b) => a > b ? a : b),widget.listY.reduce((a, b) => a < b ? a : b));
                  return colorList[_];
                },
                emptyPointSettings: EmptyPointSettings(),
                dataLabelMapper: (datum, _) => '${list[_].percentage < 0 ? 0 : list[_].percentage}%',
                // pointColorMapper: (datum, index) => FlutterFlowTheme.of(context).primary.withOpacity(),
                dataLabelSettings: DataLabelSettings(
                  textStyle: FlutterFlowTheme.of(context).displaySmall.override(

                        fontSize: rSize * 0.014,
                        fontWeight: FontWeight.normal,
                      ),
                  isVisible: false,
                  overflowMode: OverflowMode.shift,
                ),
                enableTooltip: true,
                name: 'Gold')
          ]);
  }

  label(BuildContext context, String s) {
    return Text(
      s,
      style: FlutterFlowTheme.of(context).bodyMedium.override(

        fontSize: rSize*0.012,
        color: FlutterFlowTheme.of(context).customColor4,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Color getColor(double value, double minValue, double maxValue) {
    double ratio = (value - minValue) / (maxValue - minValue);
    Color darkBlue = Color(0xFF001F3F); // Darker blue
    Color lightBlue = Color(0xFF7FDBFF); // Lighter blue
    int r = (darkBlue.red + (lightBlue.red - darkBlue.red) * ratio).round();
    int g = (darkBlue.green + (lightBlue.green - darkBlue.green) * ratio).round();
    int b = (darkBlue.blue + (lightBlue.blue - darkBlue.blue) * ratio).round();
    return Color.fromARGB(255, r, g, b);
  }
}

class ChartModel {
  double percentage;
  String label;
  double amount;

  ChartModel(this.percentage, this.label, this.amount);
}

const colorList=[
  Color(0XFF00008B),
Color(0XFF0000CD),
Color(0XFF0000FF),
Color(0XFF1E90FF),
Color(0XFF00BFFF),
Color(0XFF87CEEB),
Color(0XFF00CED1),
Color(0XFF48D1CC),
Color(0XFF40E0D0),
Color(0XFF5F9EA0),
Color(0XFF4682B4),
Color(0XFF1C6E8E),
Color(0XFFB0E0E6),
Color(0XFFADD8E6),
Color(0XFF87CEFA),
Color(0XFFB0E0E6),
Color(0XFFE0FFFF),
Color(0XFFAFEEEE),
Color(0XFF00FFFF),
Color(0XFF66CDAA),
Color(0XFF40E0D0),
Color(0XFF20B2AA),
Color(0XFF00FA9A),
Color(0XFF98FB98),
Color(0XFF00FF7F),
Color(0XFF3CB371),
Color(0XFF2E8B57),
Color(0XFF228B22),
Color(0XFF008000),
Color(0XFF006400)];
