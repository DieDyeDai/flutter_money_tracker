import 'package:flutter/material.dart';
import 'package:flutter_money_tracker/pie.dart';
import 'line.dart';
import 'main.dart';
import 'transaction.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatelessWidget {
  @override
  Widget build(context) {
    var appState = context.watch<MyAppState>();

    if (appState.transactions.isEmpty) {
      return const Center(
        child: Text("No transactions yet"),
      );
    }

    return Column(children: [
      const Spacer(flex: 1),
      Expanded(
          flex: 10,
          //Top
          child: Row(children: [
            Expanded(
                child: ListView(scrollDirection: Axis.vertical, children: [
              /*Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
                'You have ' '${appState.transactions.length}' ' transactions')),*/
              for (var i in appState.transactions)
                ListTile(
                  isThreeLine: true,
                  leading: const Icon(Icons.money),
                  title: Text('${i.name}'
                      ' x'
                      '${i.amount.toStringAsFixed(1)}'
                      ' on '
                      '${i.category}'),
                  subtitle: Text(i.cost.toStringAsFixed(2)),
                ),
            ])),
            Expanded(
                child: Center(
                    child: ListView(scrollDirection: Axis.vertical, children: [
              for (var i in Transaction.categories)
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                        textAlign: TextAlign.center,
                        'You spent \$'
                        '${MyAppState.getSum(MyAppState.getTransactionsFromCategory(i, appState.transactions)).toStringAsFixed(2)}'
                        ' on '
                        '$i',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )))
            ]))),
          ])),
      Expanded(
          flex: 10,
          //Bottom
          child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Expanded(child: Center(child: TransPieChart())),
            Expanded(child: Center(child: TransLineChart()))
          ]))
    ]);
  }
}
