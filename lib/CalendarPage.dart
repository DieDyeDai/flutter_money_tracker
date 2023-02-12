import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'SummaryPage.dart';
import 'transaction.dart';
import 'main.dart';
import 'util.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String categoryChosen = ' ';

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerCost = TextEditingController();
  TextEditingController controllerAmount = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<DropdownMenuItem> categories = [
    DropdownMenuItem(value: 'food', child: Text(" Food")),
    DropdownMenuItem(value: 'transportation', child: Text("Transportation")),
    DropdownMenuItem(value: 'education', child: Text(" Education")),
    DropdownMenuItem(value: 'entertainment', child: Text("Entertainment")),
    DropdownMenuItem(value: 'home', child: Text(" Home")),
    DropdownMenuItem(value: 'clothes', child: Text(" Clothes")),
    DropdownMenuItem(value: 'other', child: Text(" Other")),
  ];

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    //_selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  var appState;
  @override
  Widget build(BuildContext context) {
    appState = context.watch<MyAppState>();

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

    //final TextEditingController controllerName;
    //final TextEditingController controllerCost;
    //final TextEditingController controllerAmount;

    // String categoryChosen = '';

    // final _formKey = GlobalKey<FormState>();

    // TextEditingController controllerName = TextEditingController();
    // TextEditingController controllerCost = TextEditingController();
    // TextEditingController controllerAmount = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: Text('Transaction Calendar'),
        ),
        body: Column(children: [
          TableCalendar(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2024),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },

            //Event handling
            eventLoader: (day) {
              return _getEventsForDay(day);
            },
          ),
          /*Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          )*/

          Expanded(
            flex: 10,
            child: Row(children: [
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

                const Text(
                  'Click on a transaction to edit',
                  textAlign: TextAlign.center,
                ),
                for (int i = 0; (i < appState.transactions.length); i++)
                  Row(
                    children: [
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
                                        onPressed: () =>
                                            Navigator.pop(context, 'No'),
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
                          label: const Text('Delete')),
                    ],
                  )
              ])),
            ]),
          ),
          ElevatedButton.icon(
            onPressed: () => {
              // DateTime _selectedDate = widget.transaction.date;
              // var appState = context.read<MyAppState>();
              // var summaryPageState = context.read<SummaryPage>();

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
                                    value: null,
                                    items: categories,
                                    hint: const Text(' Categories'),
                                    onChanged: (value) {
                                      categoryChosen = value;
                                    }),
                                TextButton(
                                    onPressed: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: _selectedDay!,
                                        firstDate: DateTime(2010),
                                        lastDate: DateTime(2030),
                                      ).then((chosenDate) {
                                        if (chosenDate == null) {
                                          return _selectedDay;
                                        }

                                        _selectedDay = chosenDate;
                                      });
                                    },
                                    child: Text(DateFormat.MMMd()
                                        .format(_selectedDay!))),
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
                            if (_formKey.currentState!.validate() &&
                                Transaction.categories
                                    .contains(categoryChosen)) {
                              _formKey.currentState!.save();
                              appState.addTransaction(Transaction(
                                  controllerName.text,
                                  double.parse(controllerCost.text),
                                  double.parse(controllerAmount.text),
                                  _selectedDay!,
                                  categoryChosen));
                              //appState.toUpdateSummary = true;
                              //appState.updateSummary();
                              Navigator.pop(context, 'Update');
                            } else {
                              showDialog<void>(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
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
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  })
            },
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          )
        ]));
  }

  List<Event> _getEventsForDay(DateTime day) {
    return parseTransactionsAsEvents(
        MyAppState.getTransactionsFromDate(day, appState.transactions));
  }
}
