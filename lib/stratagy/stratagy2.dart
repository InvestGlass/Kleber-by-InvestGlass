import 'package:flutter/material.dart';
import 'package:kleber_bank/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/app_styles.dart';
import '../utils/app_widgets.dart';
import '../utils/flutter_flow_theme.dart';
import '../utils/internationalization.dart';

class ChartsColumnScreen extends StatelessWidget {
  const ChartsColumnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var colorList = [
      const Color(0XFFE3F2FD),
      const Color(0XFFBBDEFB),
      const Color(0XFF90CAF9),
      const Color(0XFF64B5F6),
      const Color(0XFF42A5F5),
      const Color(0XFF2196F3),
      const Color(0XFF1E88E5),
      const Color(0XFF1976D2),
      const Color(0XFF1565C0),
      const Color(0XFF0D47A1),
    ];
    return Scaffold(
      appBar: AppWidgets.appBar(context, 'Strategy', leading: AppWidgets.backArrow(context)),
      body: SingleChildScrollView(
        child: Column(
          children: [
             title(context,FFLocalizations.of(context).getText(
               '7h0zeqv0' /* Asset Class */,
             ),is1st: true),
            buildBarChart([
              ChartData("Fixed Income", 50, 30, 70, colorList[0]),
              ChartData("Equity", 10, 5, 20, colorList[1]),
              ChartData("Future", 5, 3, 10, colorList[2]),
              ChartData("Crypto", 5, 2, 8, colorList[2]),
            ], context),
            title(context,FFLocalizations.of(context).getText(
              'countries',
            )),
            buildBarChart([
              ChartData("China", 30, 10, 80, colorList[0]),
              ChartData("Switzerland", 30, 15, 70, colorList[0]),
              ChartData("UK", 20, 5, 60, colorList[1]),
              ChartData("USA", 20, 10, 50,colorList[1]),
            ], context),
            title(context,FFLocalizations.of(context).getText(
              'o00oeypg' /* Currency */,
            )),
            buildBarChart([
              ChartData("USD", 30, 10, 90, colorList[0]),
              ChartData("AED", 25, 5, 70, colorList[1]),
              ChartData("CHF", 15, 8, 50, colorList[2]),
            ], context),
            title(context,FFLocalizations.of(context).getText(
                "industries",
            )),
            buildBarChart([
              ChartData("No Industry", 40, 15, 85, colorList[0]),
              ChartData("Basic Materials", 30, 10, 75, colorList[1]),
              ChartData("Oil & Gas", 20, 5, 60, colorList[2]),
              ChartData("Consumer Services", 10, 2, 50, colorList[3]),
            ], context),
          ],
        ),
      ),
    );
  }

  Widget title(BuildContext context,String text,{bool is1st=false}) {
    return Padding(
      padding:  EdgeInsets.only(top: is1st?0:rSize*0.03),
      child: Text(text,style: FlutterFlowTheme.of(context)
                .displaySmall
                .override(
              color: FlutterFlowTheme.of(context)
                  .customColor4,
              fontSize: rSize * 0.016,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),),
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
        legend:  Legend(isVisible: true,textStyle:AppStyles.inputTextStyle(context) ), // Show legend
        series: <CartesianSeries>[
          // Bar chart (Column Series)
          ColumnSeries<ChartData, String>(
            name: "",
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.value,color: FlutterFlowTheme.of(context).info,
            pointColorMapper: (ChartData data, _) => data.color,
            markerSettings: const MarkerSettings(shape: DataMarkerType.none),
            dataLabelSettings:
                DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside, textStyle: AppStyles.inputTextStyle(context)),
          ),
          // Scatter Series for Min Triangle
          ScatterSeries<ChartData, String>(
            name: "Min",
            color: Colors.red,
            dataSource: data,
            dataLabelSettings: DataLabelSettings(
              textStyle: AppStyles.inputTextStyle(context),
            ),
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.minValue,
            pointColorMapper: (ChartData data, _) => Colors.red,
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
            dataSource: data,color: Colors.green,
            dataLabelSettings: DataLabelSettings(
              textStyle: AppStyles.inputTextStyle(context),
            ),
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.maxValue,
            pointColorMapper: (ChartData data, _) => Colors.green,
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
