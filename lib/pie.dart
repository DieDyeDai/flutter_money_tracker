import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'transaction.dart';

class TransPieChart extends StatefulWidget {
  const TransPieChart({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;
  var appState;
  @override
  Widget build(BuildContext context) {
    appState = context.watch<MyAppState>();
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              /*  Indicator(
                color: Theme.of(context),
                text: 'First',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: AppColors.contentColorYellow,
                text: 'Second',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: AppColors.contentColorPurple,
                text: 'Third',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: AppColors.contentColorGreen,
                text: 'Fourth',
                isSquare: true,
              ),
              */
              SizedBox(
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(Transaction.categories.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: MyAppState.getSum(MyAppState.getTransactionsFromCategory(
                Transaction.categories[0], appState.transactions)),
            title: Transaction.categories[0],
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellow,
            value: MyAppState.getSum(MyAppState.getTransactionsFromCategory(
                Transaction.categories[1], appState.transactions)),
            title: Transaction.categories[1],
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.yellowAccent,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: MyAppState.getSum(MyAppState.getTransactionsFromCategory(
                Transaction.categories[2], appState.transactions)),
            title: Transaction.categories[2],
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: MyAppState.getSum(MyAppState.getTransactionsFromCategory(
                Transaction.categories[3], appState.transactions)),
            title: Transaction.categories[3],
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
              shadows: shadows,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.green,
            value: MyAppState.getSum(MyAppState.getTransactionsFromCategory(
                Transaction.categories[4], appState.transactions)),
            title: Transaction.categories[4],
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
              shadows: shadows,
            ),
          );
        case 5:
          return PieChartSectionData(
            color: Colors.green,
            value: MyAppState.getSum(MyAppState.getTransactionsFromCategory(
                Transaction.categories[5], appState.transactions)),
            title: Transaction.categories[5],
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
              shadows: shadows,
            ),
          );

        case 6:
          return PieChartSectionData(
            color: Colors.green,
            value: MyAppState.getSum(MyAppState.getTransactionsFromCategory(
                Transaction.categories[6], appState.transactions)),
            title: Transaction.categories[6],
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
