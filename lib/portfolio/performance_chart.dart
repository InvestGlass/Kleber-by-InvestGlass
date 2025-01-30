import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';


class ChartPage extends StatelessWidget {
  final List<ChartData> chartData = [
    ChartData(DateTime(2024, 1, 1), 100.0, 1.3),
    ChartData(DateTime(2024, 2, 1), 101.3, -1.02),
    ChartData(DateTime(2024, 3, 1), 100.28, -0.49),
    ChartData(DateTime(2024, 4, 1), 99.79, -0.29),
    ChartData(DateTime(2024, 5, 1), 99.5, -0.86),
    ChartData(DateTime(2024, 6, 1), 98.64, 0.13),
    ChartData(DateTime(2024, 7, 1), 98.77, 0.72),
    ChartData(DateTime(2024, 8, 1), 99.49, -0.33),
    ChartData(DateTime(2024, 9, 1), 99.16, 0.02),
    ChartData(DateTime(2024, 10, 1), 99.18, -2.2),
    ChartData(DateTime(2024, 11, 1), 96.98, -0.37),
    ChartData(DateTime(2024, 12, 1), 96.61, -1.45),
    ChartData(DateTime(2024, 12, 31), 95.16, 0),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scroll
      child: Container(
        width: 800, // Adjust based on data length
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType.months,
            dateFormat: DateFormat.MMM(),
            majorGridLines: MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          primaryYAxis: NumericAxis(
            name: 'TWR%',
            labelFormat: '{value}%',
            minimum: -2.5,
            maximum: 1.5,
            opposedPosition: false, // Keeps the Y-axis fixed
          ),
          axes: <NumericAxis>[
            NumericAxis(
              name: 'Amount',
              opposedPosition: true, // Places this Y-axis on the right
              minimum: 95,
              maximum: 102,
            ),
          ],
          series: <CartesianSeries>[
            ColumnSeries<ChartData, DateTime>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.date,
              yValueMapper: (ChartData data, _) => data.twrPercentage,
              width: 0.5,
              spacing: 0.2,
              color: Colors.blue,
              yAxisName: 'TWR%',
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
            LineSeries<ChartData, DateTime>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.date,
              yValueMapper: (ChartData data, _) => data.amount,
              markerSettings: MarkerSettings(isVisible: true),
              color: Colors.black,
              yAxisName: 'Amount',
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final DateTime date;
  final double amount;
  final double twrPercentage;

  ChartData(this.date, this.amount, this.twrPercentage);
}

class PortfolioChart extends StatelessWidget {
final List<ChartData> chartData = [
  ChartData(DateTime(2024, 1, 1), 100.0, 1.3),
  ChartData(DateTime(2024, 2, 1), 101.3, -1.02),
  ChartData(DateTime(2024, 3, 1), 100.28, -0.49),
  ChartData(DateTime(2024, 4, 1), 99.79, -0.29),
  ChartData(DateTime(2024, 5, 1), 99.5, -0.86),
  ChartData(DateTime(2024, 6, 1), 98.64, 0.13),
  ChartData(DateTime(2024, 7, 1), 98.77, 0.72),
  ChartData(DateTime(2024, 8, 1), 99.49, -0.33),
  ChartData(DateTime(2024, 9, 1), 99.16, 0.02),
  ChartData(DateTime(2024, 10, 1), 99.18, -2.2),
  ChartData(DateTime(2024, 11, 1), 96.98, -0.37),
  ChartData(DateTime(2024, 12, 1), 96.61, -1.45),
  ChartData(DateTime(2024, 12, 31), 95.16, 0),
];

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.months,
          dateFormat: DateFormat.MMM(), // Jan, Feb, etc.
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0),
        ),
        series: <CartesianSeries>[
          // **Gradient Blue Shadow Effect**
          SplineAreaSeries<ChartData, DateTime>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.date,
            yValueMapper: (ChartData data, _) => data.amount,
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.4),
                Colors.blue.withOpacity(0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          // **Main Line Chart**
          SplineSeries<ChartData, DateTime>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.date,
            yValueMapper: (ChartData data, _) => data.amount,
            markerSettings: MarkerSettings(isVisible: true),
            color: Colors.blueAccent,
            width: 3,
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    ),
  );
}
}
