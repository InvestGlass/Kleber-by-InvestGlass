import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kleber_bank/portfolio/portfolio_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/app_widgets.dart';
import '../utils/flutter_flow_theme.dart';

class BarChartSample5 extends StatefulWidget {
  const BarChartSample5(
      {super.key,
        this.width,
        this.height,
        this.customWidth,
        this.xLabels = const [],
        this.listY = const [],
        this.listAmount = const [],
        this.additionPercents = const [],
        this.sectionName = '',
        this.item});

  final double? width;
  final double? height;
  final double? customWidth;
  final List<String> xLabels;
  final List<String> listY;
  final List<String> listAmount;
  final List<double> additionPercents;
  final String? sectionName;
  final PortfolioModel? item;

  @override
  State<StatefulWidget> createState() => BarChartSample5State();
}

class BarChartSample5State extends State<BarChartSample5> {
  static const double barWidth = 22;
  static const shadowOpacity = 0.2;
  static const mainItems = <int, List<double>>{
    0: [2],
    1: [-1],
    2: [1],
    3: [5],
    4: [-6],
    5: [-8],
    6: [4],
  };
  int touchedIndex = -1;
  int i=-1;
  String selectedPeriod = '6 M';
  // final StreamController<String> _streamController=StreamController.broadcast();
  var key= const ValueKey('1');

  @override
  void initState() {
    super.initState();
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.black, fontSize: 10);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${value.toInt()}';
    }
    return SideTitleWidget(
      angle: AppUtils().degreeToRadian(value < 0 ? -45 : 45),
      axisSide: meta.axisSide,
      space: 2,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget rightTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.black, fontSize: 10);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${value.toInt()}';
    }
    return SideTitleWidget(
      angle: AppUtils().degreeToRadian(90),
      axisSide: meta.axisSide,
      space: 0,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  BarChartGroupData generateGroup(
      int x,
      double value1
      ) {
    final isTop = value1 > 0;
    final sum = value1;
    final isTouched = touchedIndex == x;
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      showingTooltipIndicators: isTouched ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: sum,
          width: barWidth,
          borderRadius: isTop
              ? const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          )
              : const BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
          rodStackItems: [
            BarChartRodStackItem(
              0,
              value1,
              isTop?Colors.green:FlutterFlowTheme.of(context)
                  .error,
              BorderSide(
                color: Colors.orange,
                width: isTouched ? 2 : 0,
              ),
            ),
          ],
        ),
        BarChartRodData(
          toY: -sum,
          width: barWidth,
          color: Colors.transparent,
          borderRadius: isTop
              ? const BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          )
              : const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  bool isShadowBar(int rodIndex) => rodIndex == 1;

  @override
  Widget build(BuildContext context) {
    List<ChartModel> performanceChartList = List<ChartModel>.generate(
      widget.xLabels.length,
          (index) => ChartModel(
          widget.additionPercents[index], widget.xLabels[index], widget.listY[index],
          date: DateFormat('dd-MM-yyyy').parse(widget.xLabels[index])),
    );
    List<ChartModel> filteredList = performanceChartList
        .where((data) => data.date!.isAfter(startDate(selectedPeriod)))
        .toList();
    i=-1;
    ChartModel smallestModel = filteredList.reduce((current, next) {
      return current.percentage < next.percentage ? current : next;
    });
    ChartModel biggestModel = filteredList.reduce((current, next) {
      return current.percentage > next.percentage ? current : next;
    });
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width(filteredList),
            height: 350,
            margin: EdgeInsets.only(bottom: rSize*0.015),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.start,
                  maxY: biggestModel.percentage+(biggestModel.percentage%1),
                  minY: smallestModel.percentage-(smallestModel.percentage%1),
                  groupsSpace: 12,
                  barTouchData: BarTouchData(
                    handleBuiltInTouches: false,
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      if (!event.isInterestedForInteractions ||
                          barTouchResponse == null ||
                          barTouchResponse.spot == null) {
                        setState(() {
                          touchedIndex = -1;
                        });
                        return;
                      }
                      final rodIndex = barTouchResponse.spot!.touchedRodDataIndex;
                      if (isShadowBar(rodIndex)) {
                        setState(() {
                          touchedIndex = -1;
                        });
                        return;
                      }
                      setState(() {
                        touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(color: Colors.blue, fontSize: 10);
                          print('index values : ${value}');
                            return SideTitleWidget(
                              axisSide: meta.axisSide,angle: 45,
                              child: Text(filteredList[value.toInt()].label, style: style),
                            );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: leftTitles,
                        // interval: 1,
                        // reservedSize: 42,
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    checkToShowHorizontalLine: (value) => value % 5 == 0,
                    getDrawingHorizontalLine: (value) {
                      if (value == 0) {
                        return FlLine(
                          color: AppColors.kBorderColor,
                          strokeWidth: 3,
                        );
                      }
                      return FlLine(
                        color: AppColors.kBorderColor,
                        strokeWidth: 0.8,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: filteredList
                      .map(
                        (e) {
                          return generateGroup(
                              filteredList.indexOf(e),
                              e.percentage);
                        } ,
                  )
                      .toList(),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // periodCell('1 W'),
              periodCell('1 M'),
              periodCell('6 M'),
              periodCell('1 Y'),
            ],
          )
        ],
      ),
    );
  }

  double width(List<ChartModel> filteredList)  {
    double x=(barWidth+17)* filteredList.length;
    if(x<MediaQuery.of(context).size.width){
      return MediaQuery.of(context).size.width;
    }
  return x;
}

  DateTime startDate(String period) {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (period) {
      case '1 W':
        startDate = now.subtract(Duration(days: 7));
        break;
      case '1 M':
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case '6 M':
        startDate = DateTime(now.year, now.month - 7, now.day);
        break;
      case '1 Y':
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        startDate = DateTime(1970); // Show all data if no filter
    }

    return startDate;
  }

  Widget periodCell(String label) {
    return AppWidgets.click(
      onTap: () {
        selectedPeriod = label;
        // _streamController.add('');
        key=ValueKey(selectedPeriod);
        setState(() {

        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: rSize * 0.015, vertical: rSize * 0.005),
        decoration: BoxDecoration(
            color: label != selectedPeriod
                ? Colors.transparent
                : FlutterFlowTheme.of(context).primary,
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          label,
          style: AppStyles.inputTextStyle(context).copyWith(
              color: label == selectedPeriod
                  ? Colors.white
                  : FlutterFlowTheme.of(context).customColor4),
        ),
      ),
    );
  }
}

class AppUtils {
  factory AppUtils() {
    return _singleton;
  }

  AppUtils._internal();
  static final AppUtils _singleton = AppUtils._internal();

  double degreeToRadian(double degree) {
    return degree * math.pi / 180;
  }

  double radianToDegree(double radian) {
    return radian * 180 / math.pi;
  }

  Future<bool> tryToLaunchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }
}

class ChartModel {
  double percentage;
  String label;
  String amount;
  DateTime? date;

  ChartModel(this.percentage, this.label, this.amount, {this.date});
}