// Automatic FlutterFlow imports
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!


import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'dart:math';

class XPortfolioItemLineChart extends StatefulWidget {
  const XPortfolioItemLineChart({
    super.key,
    this.width,
    this.height,
    this.customWidth,
    this.xLabels = const [],
    this.listY = const [],
    this.additionPercents = const [],
  });

  final double? width;
  final double? height;
  final double? customWidth;
  final List<String> xLabels;
  final List<double> listY;
  final List<double> additionPercents;

  @override
  State<XPortfolioItemLineChart> createState() =>
      _XPortfolioItemLineChartState();
}

class _XPortfolioItemLineChartState extends State<XPortfolioItemLineChart> {
  final barWidth = 30.0;
  final barsSpace = 10.0;
  final groupsSpace = 100.0;
  final leftTitleReservedSize = 46.0;
  final columnStart = 99.0;

  late double touchedValue;
  final color = Color(0xFF3D51A2);

  bool fitInsideBottomTitle = true;
  bool fitInsideLeftTitle = false;

  TrackballBehavior? _trackballBehavior;

  @override
  void initState() {
    touchedValue = -1;
    super.initState();

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
      final valueToShowStr = valueToShow == valueToShow.roundToDouble()
          ? '${valueToShow.round()}'
          : '$additionPercent';
      annotations.add(
        CartesianChartAnnotation(
          region: AnnotationRegion.plotArea,
          widget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$valueToShowStr%', style: TextStyle(fontSize: 12)),
              if (additionPercent != 0)
                Icon(
                  additionPercent > 0
                      ? Icons.arrow_circle_up
                      : Icons.arrow_circle_down,
                  color: additionPercent > 0
                      ? Colors.green
                      : Colors.red,
                  size: 18,
                ),
            ],
          ),
          coordinateUnit: CoordinateUnit.point,
          x: widget.xLabels[i],
          y: columnStart +
              additionPercent +
              (additionPercent > 0 ? additionalValue : -additionalValue),
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
        pointColorMapper: (String label, int index) =>
        Colors.green,
        name: 'RangeColumnSeries',
        color: Colors.white, // FlutterFlowTheme.of(context).alternate,
        enableTooltip: false,
      ),
      LineSeries<String, String>(
        dataSource: widget.xLabels,
        xValueMapper: (String label, _) => label,
        yValueMapper: (String label, index) => widget.listY[index],
        width: 2,
        markerSettings: const MarkerSettings(isVisible: true),
        color: Colors.yellow,
        name: 'LineSeries',
      ),
    ];
  }

  Widget buildSFLineChart() {
    final isAr=false; /*true ie current language is arebic*/
    final overIntialVisible =
        widget.xLabels.length > (initialVisibleMaximum.floor() + 1);
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
              majorGridLines: const MajorGridLines(width: 0),
              labelRotation: 45,
              initialVisibleMaximum: initialVisibleMaximum,
              labelIntersectAction: AxisLabelIntersectAction.none,
              isInversed: isAr,
            ),
            primaryYAxis: NumericAxis(
              labelFormat: '{value}%',
              interval: getYAxisInterval(),
              opposedPosition: isAr,
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
              ChartSeriesRenderer<dynamic, dynamic> seriesRender =
                  args.chartPointInfo.series;

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
      child: widget.xLabels.isEmpty ? null : buildSFLineChart(),
    );
  }
}
