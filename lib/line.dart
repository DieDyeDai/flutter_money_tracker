import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'main.dart';

class TransLineChart extends StatefulWidget {
  const TransLineChart({super.key});

  @override
  State<StatefulWidget> createState() => TransLineChartState();
}

class TransLineChartState extends State {
  var appState;
  @override
  Widget build(BuildContext context) {
    appState = context.watch<MyAppState>();
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 37,
              ),
              const Text(
                'Transaction History (Past 7 Days)',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 37,
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.only(right: 16, left: 6),
                    child: LineChart(LineChartData(
                        lineTouchData: lineTouchData1,
                        gridData: gridData,
                        titlesData: titlesData1,
                        borderData: borderData,
                        lineBarsData: lineBarsData1,
                        minX: 0,
                        maxX: 6,
                        minY: 0))),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*LineChartData get sampleData1 => LineChartData();*/

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (0) {
      case 0:
        text = ' ';
        break;
      case 1:
        text = '2m';
        break;
      case 3:
        text = '3m';
        break;
      case 4:
        text = '5m';
        break;
      case 5:
        text = '6m';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(DateFormat('dd')
            .format(DateTime.now().subtract(const Duration(days: 6))));
        break;
      case 1:
        text = Text(DateFormat('dd')
            .format(DateTime.now().subtract(const Duration(days: 5))));
        break;
      case 2:
        text = Text(DateFormat('dd')
            .format(DateTime.now().subtract(const Duration(days: 4))));
        break;
      case 3:
        text = Text(DateFormat('dd')
            .format(DateTime.now().subtract(const Duration(days: 3))));
        break;
      case 4:
        text = Text(DateFormat('dd')
            .format(DateTime.now().subtract(const Duration(days: 2))));
        break;
      case 5:
        text = Text(DateFormat('dd')
            .format(DateTime.now().subtract(const Duration(days: 1))));
        break;
      case 6:
        text = Text(DateFormat('dd')
            .format(DateTime.now().subtract(const Duration(days: 0))));
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.blue.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
      isCurved: true,
      color: Colors.black,
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: generateSpots());

  List<FlSpot> generateSpots() {
    List<FlSpot> spotList = [];
    for (int i = 0; i < 7; i++) {
      //For each day add an Flspot where x is i days ago (today - that day) and y is the sum of date transactions
      spotList.add(FlSpot(
          //From right to left
          DateTime.now() //x
              .difference(DateTime.now().subtract(Duration(days: i)))
              .inDays
              .roundToDouble(),
          //y
          MyAppState.getSum(MyAppState.getTransactionsFromDate(
              DateTime.now().subtract(Duration(days: i)),
              appState.transactions))));
    }
    return spotList;
  }
}
