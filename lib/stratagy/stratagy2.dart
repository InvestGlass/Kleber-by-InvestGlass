import 'package:flutter/material.dart';
import 'package:kleber_bank/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/app_styles.dart';
import '../utils/app_widgets.dart';

class ChartsColumnScreen extends StatelessWidget {
  const ChartsColumnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(context, 'Strategy', leading: AppWidgets.backArrow(context)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Asset Classes"),
            buildBarChart([
              ChartData("Other", 50, 30, 70, Colors.blue),
              ChartData("Equity", 10, 5, 20, Colors.orange),
              ChartData("Future", 5, 3, 10, Colors.red),
              ChartData("Crypto", 5, 2, 8, Colors.purple),
            ], context),
            const Text("Countries"),
            buildBarChart([
              ChartData("No Country", 30, 10, 80, Colors.blue),
              ChartData("Switzerland", 30, 15, 70, Colors.orange),
              ChartData("UK", 20, 5, 60, Colors.green),
              ChartData("USA", 20, 10, 50, Colors.pink),
            ], context),
            const Text("Currencies"),
            buildBarChart([
              ChartData("USD", 30, 10, 90, Colors.blue),
              ChartData("AED", 25, 5, 70, Colors.orange),
              ChartData("CHF", 15, 8, 50, Colors.green),
            ], context),
            const Text("Industries"),
            buildBarChart([
              ChartData("No Industry", 40, 15, 85, Colors.blue),
              ChartData("Basic Materials", 30, 10, 75, Colors.orange),
              ChartData("Oil & Gas", 20, 5, 60, Colors.green),
              ChartData("Consumer Services", 10, 2, 50, Colors.pink),
            ], context),
          ],
        ),
      ),
    );
  }

  /// Function to create a bar chart with triangle markers
  Widget buildBarChart(List<ChartData> data, BuildContext context) {
    return SizedBox(
      height: rSize * 0.3,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelStyle: AppStyles.inputTextStyle(context),
          isVisible: true,
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}%',
          labelStyle: AppStyles.inputTextStyle(context),
        ),
        legend: const Legend(isVisible: true), // Show legend
        series: <CartesianSeries>[
          // Bar chart (Column Series)
          ColumnSeries<ChartData, String>(
            name: "Target Allocation",
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.value,
            pointColorMapper: (ChartData data, _) => data.color,
            dataLabelSettings:
                DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside, textStyle: AppStyles.inputTextStyle(context)),
          ),
          // Scatter Series for Min Triangle
          ScatterSeries<ChartData, String>(
            name: "Min",
            dataSource: data,
            dataLabelSettings: DataLabelSettings(
              textStyle: AppStyles.inputTextStyle(context),
            ),
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.minValue,
            pointColorMapper: (ChartData data, _) => Colors.brown,
            markerSettings: const MarkerSettings(
              shape: DataMarkerType.triangle, // Min Triangle
              color: Colors.brown,
              width: 10,
              height: 10,
            ),
          ),
          // Scatter Series for Max Triangle
          ScatterSeries<ChartData, String>(
            name: "Max",
            dataSource: data,
            dataLabelSettings: DataLabelSettings(
              textStyle: AppStyles.inputTextStyle(context),
            ),
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.maxValue,
            pointColorMapper: (ChartData data, _) => Colors.yellow,
            markerSettings: const MarkerSettings(
              shape: DataMarkerType.triangle, // Max Triangle
              color: Colors.yellow,
              width: 10,
              height: 10,
            ),
          ),
        ],
      ),
    );
  }
}

/// Chart Data Model
class ChartData {
  final String category;
  final double value; // Bar height
  final double minValue; // Min triangle
  final double maxValue; // Max triangle
  final Color color;

  ChartData(this.category, this.value, this.minValue, this.maxValue, this.color);
}
