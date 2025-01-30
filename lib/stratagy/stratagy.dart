import 'package:flutter/material.dart';
import 'package:kleber_bank/main.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/app_widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/flutter_flow_theme.dart';

class Strategy extends StatelessWidget {
  const Strategy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(context, 'Strategy',
          leading: AppWidgets.backArrow(context)),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: rSize * 0.01, vertical: rSize * 0.01),
        children: [
          AppWidgets.label(context, 'Allocations'),
          SizedBox(height: rSize * 0.3, child: CustomChart()),
          AppWidgets.label(context, 'Countries'),
          Container(
              margin: EdgeInsets.only(top: rSize * 0.01),
              height: rSize * 0.3,
              child: ColumnChart2()),
          AppWidgets.label(context, 'Currencies'),
          SizedBox(height: rSize * 0.3, child: CustomScatterChart()),
          AppWidgets.label(context, 'Industries'),
          Container(
              margin: EdgeInsets.only(top: rSize * 0.01),
              height: rSize * 0.3,
              child: ColumnChart2()),
        ],
      ),
    );
  }
}

class CustomChart extends StatelessWidget {
  final List<ChartData> chartData = [
    ChartData('Other', 80, min: 0, max: 100),
    ChartData('Crypto', 20, min: 10, max: 90),
    ChartData('Equity', 50, min: 5, max: 80),
    ChartData('Fixed\nIncome', 65, min: 5, max: 75),
    ChartData('Cash', 70, min: 30, max: 60),
    ChartData('Other', 20, min: 15, max: 50),
    ChartData('Alt Inv.', 30, min: 25, max: 45),
  ];

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        labelStyle: AppStyles.inputTextStyle(context),
        isVisible: true,
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}%',
        labelStyle: AppStyles.inputTextStyle(context),
        minimum: 0,
        maximum: 120,
      ),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
        // Column Series
        ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          name: 'Value',
          color: FlutterFlowTheme.of(context).primary,
          dataLabelSettings: DataLabelSettings(
              isVisible: true,labelPosition: ChartDataLabelPosition.outside,
              textStyle: AppStyles.inputTextStyle(context)),
        ),
        // Min Points (Scatter)
        ScatterSeries<ChartData, String>(
          dataSource: chartData,
          dataLabelSettings: DataLabelSettings(
            textStyle: AppStyles.inputTextStyle(context),
          ),
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.min,
          name: 'Min',
          markerSettings: const MarkerSettings(
            shape: DataMarkerType.triangle,
            width: 10,
            height: 10,
            color: Colors.red,
          ),
        ),
        // Max Points (Scatter)
        ScatterSeries<ChartData, String>(
          dataSource: chartData,
          dataLabelSettings: DataLabelSettings(
            textStyle: AppStyles.inputTextStyle(context),
          ),
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.max,
          name: 'Max',
          markerSettings: const MarkerSettings(
            shape: DataMarkerType.diamond,
            width: 10,
            height: 10,
            color: Colors.yellow,
          ),
        ),
      ],
    );
  }
}

class ChartData {
  final String category;
  final double value;
  final double min;
  final double max;

  ChartData(this.category, this.value, {required this.min, required this.max});
}

class CustomScatterChart extends StatelessWidget {
  final List<ChartData2> chartData = [
    ChartData2('USD', min: 40, max: 100),
    ChartData2('EUR', min: 60, max: 70),
    ChartData2('CHF', min: 10, max: 85),
    ChartData2('JPY', min: 25, max: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,isVisible: true,
      ),
      primaryYAxis: const NumericAxis(
        minimum: 0,
        maximum: 120,
        labelFormat: '{value}%',isVisible: true,
      ),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ScatterSeries<ChartData2, String>>[
        // Min Points
        ScatterSeries<ChartData2, String>(
          dataSource: chartData,
          xValueMapper: (ChartData2 data, _) => data.category,
          yValueMapper: (ChartData2 data, _) => data.min,
          name: 'Min',
          dataLabelSettings: DataLabelSettings(
              textStyle: AppStyles.inputTextStyle(context), isVisible: true),
          markerSettings: MarkerSettings(
            shape: DataMarkerType.triangle,
            color: FlutterFlowTheme.of(context).error,
            width: 12,
            height: 12,
          ),
        ),
        // Max Points
        ScatterSeries<ChartData2, String>(
          dataSource: chartData,
          xValueMapper: (ChartData2 data, _) => data.category,
          yValueMapper: (ChartData2 data, _) => data.max,
          name: 'Max',
          markerSettings: const MarkerSettings(
            shape: DataMarkerType.diamond,
            color: Colors.yellow,
            width: 12,
            height: 12,
          ),
        ),
      ],
    );
  }
}

class ChartData2 {
  final String category;
  final double min;
  final double max;

  ChartData2(this.category, {required this.min, required this.max});
}

class ColumnChart2 extends StatelessWidget {
  final List<ChartData3> chartData = [
    ChartData3('Country', 100),
  ];

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        labelStyle: AppStyles.inputTextStyle(context),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 120, // Allows space above 100% for labels
        labelFormat: '{value}%',
        labelStyle: AppStyles.inputTextStyle(context),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
        ColumnSeries<ChartData3, String>(
          dataSource: chartData,
          xValueMapper: (ChartData3 data, _) => data.category,
          yValueMapper: (ChartData3 data, _) => data.value,
          name: 'Percentage',
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: AppStyles.inputTextStyle(context)
                  .copyWith(color: FlutterFlowTheme.of(context).info)),
          color: Colors.blue,
        ),
      ],
    );
  }
}

class ChartData3 {
  final String category;
  final double value;

  ChartData3(this.category, this.value);
}
