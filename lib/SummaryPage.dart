import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'transaction.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

class SummaryPage extends StatefulWidget {
  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(context) {
    var appState = context.watch<MyAppState>();

    if (appState.transactions.isEmpty) {
      return const Center(
        child: Text("No transactions yet"),
      );
    }

    return Row(children: [
      Expanded(
          child: ListView(scrollDirection: Axis.vertical, children: [
/*
        for (var i in appState.transactions)
          ListTile(
            isThreeLine: true,
            leading: const Icon(Icons.favorite),
            title: Text('${i.name}'
                ' x'
                '${i.amount.toStringAsFixed(1)}'
                ' on '
                '${i.category}'),
            subtitle: Text(i.cost.toStringAsFixed(2)),
          ),
          */
        for (int i = 0; i < appState.transactions.length; i++)
          Row(children: [
            BigCard(
              transaction: appState.transactions[i],
              index: i,
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
                onPressed: () => showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete transaction?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'No'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                appState.removeTransaction(i);
                                setState(() {});
                                Navigator.pop(context, 'Yes');
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        )),
                icon: const Icon(Icons.delete),
                label: const Text('Delete'))
          ])
      ])),
      const SizedBox(width: 50),
      Expanded(
          child: ListView(scrollDirection: Axis.vertical, children: [
        const Text('You spent:'),
        for (var i in Transaction.categories)
          Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                  '${MyAppState.getSum(MyAppState.getTransactionsFromCategory(i, appState.transactions)).toStringAsFixed(2)}'
                  ' on '
                  '$i'))
      ]))
    ]);
  }
}

class BigCard extends StatefulWidget {
  const BigCard({
    super.key,
    required this.transaction,
    required this.index,
  });

  final Transaction transaction;
  final int index;

  @override
  State<BigCard> createState() => _BigCardState();
}

class _BigCardState extends State<BigCard> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var style = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    var styleBigger = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    var styleSmaller = theme.textTheme.titleSmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return TextButton(
      onPressed: () {
        final _formKey = GlobalKey<FormState>();

        DateTime _selectedDate = widget.transaction.date;
        var appState = context.read<MyAppState>();
        // var summaryPageState = context.read<SummaryPage>();

        final controllerName = TextEditingController.fromValue(
            TextEditingValue(text: widget.transaction.name));
        final controllerCost = TextEditingController.fromValue(
            TextEditingValue(text: widget.transaction.cost.toStringAsFixed(2)));
        final controllerAmount = TextEditingController.fromValue(
            TextEditingValue(text: widget.transaction.amount.toString()));

        void disposeAndExit() {
          controllerName.dispose();
          controllerCost.dispose();
          controllerAmount.dispose();
          Navigator.pop(context);
        }

        List<DropdownMenuItem> categories = [
          const DropdownMenuItem(value: 'food', child: Text(" Food")),
          const DropdownMenuItem(
              value: 'transportation', child: Text("Transportation")),
          const DropdownMenuItem(value: 'education', child: Text(" Education")),
          const DropdownMenuItem(
              value: 'entertainment', child: Text("Entertainment")),
          const DropdownMenuItem(value: 'home', child: Text(" Home")),
          const DropdownMenuItem(value: 'clothes', child: Text(" Clothes")),
          const DropdownMenuItem(value: 'other', child: Text(" Other")),
        ];

        String categoryChosen = widget.transaction.category;

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Edit transaction"),
                content: Stack(children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                              controller: controllerName,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: ' Enter name',
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.runtimeType != String) {
                                  return ' Must enter a name';
                                }
                                return null;
                              }),
                          TextFormField(
                              controller: controllerCost,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    (RegExp("[.0-9]")))
                              ],
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: ' Enter cost',
                              ),
                              validator: (value) {
                                //if (value == null || (value.runtimeType != double && value.runtimeType != int))
                                if (value == null) {
                                  return ' Must enter a cost';
                                }
                                return null;
                              }),
                          TextFormField(
                              controller: controllerAmount,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: false),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              //initialValue: 1,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: ' Enter amount',
                              ),
                              validator: (value) {
                                //if (value == null || (value.runtimeType != double && value.runtimeType != int)) {
                                if (value == null) {
                                  return ' Must enter an amount';
                                }
                                return null;
                              }),
                          DropdownButtonFormField(
                              value: widget.transaction.category,
                              items: categories,
                              hint: const Text(' Categories'),
                              onChanged: (value) {
                                categoryChosen = value;
                              }),
                          TextButton(
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate,
                                  firstDate: DateTime(2010),
                                  lastDate: DateTime(2030),
                                ).then((chosenDate) {
                                  if (chosenDate == null) {
                                    return _selectedDate;
                                  }

                                  _selectedDate = chosenDate;
                                });
                              },
                              child: Text(
                                  DateFormat.MMMd().format(_selectedDate!))),
                          /* Row(children: [
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          disposeAndExit();
                                        },
                                        child: const Text('Cancel')))),
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        appState.editTransaction(
                                            widget.index,
                                            Transaction(
                                                controllerName.text,
                                                double.parse(
                                                    controllerCost.text),
                                                double.parse(
                                                    controllerAmount.text),
                                                _selectedDate,
                                                categoryChosen));
                                        // dispose();
                                        disposeAndExit();
                                      } else {
                                        showDialog<void>(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: const Text(
                                                      'Missing fields'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, 'OK'),
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                ));
                                      }
                                    },
                                    child: const Text('Update'),
                                  )),
                            ),
                          ]), */
                        ],
                      )),
                ]),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'No'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        appState.editTransaction(
                            widget.index,
                            Transaction(
                                controllerName.text,
                                double.parse(controllerCost.text),
                                double.parse(controllerAmount.text),
                                _selectedDate,
                                categoryChosen));
                        appState.toUpdateSummary = true;
                        appState.updateSummary();
                        Navigator.pop(context, 'Update');
                      } else {
                        showDialog<void>(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Missing fields'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ));
                      }
                    },
                    child: const Text('Update'),
                  ),
                ],
              );
            });
      },
      child: Card(
          color: theme.colorScheme.primary,
          elevation: 0,
          child: Column(
            children: [
              Row(
                children: [
                  //const SizedBox(width: 10),
                  Text(widget.transaction.name,
                      textAlign: (TextAlign.left), style: styleBigger),
                  const SizedBox(width: 20),
                  Text(
                    "\$${(widget.transaction.cost * widget.transaction.amount).toStringAsFixed(2)}",
                    style: styleBigger,
                    textAlign: (TextAlign.left),
                  ),
                  const SizedBox(width: 10),
                  Text(widget.transaction.category,
                      textAlign: (TextAlign.right), style: style),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 30),
                  Text("\$" '${widget.transaction.cost.toStringAsFixed(2)}',
                      textAlign: (TextAlign.left), style: style),
                  const SizedBox(width: 10),
                  Text('count: ' '${widget.transaction.amount}',
                      textAlign: (TextAlign.right), style: styleSmaller),
                  const SizedBox(width: 30),
                  Text(
                      ' on '
                      '${DateFormat.MMMd().format(widget.transaction.date)}',
                      style: style),
                  const SizedBox(width: 20),
                ],
              )
            ],
          )),
    );
  }
}
