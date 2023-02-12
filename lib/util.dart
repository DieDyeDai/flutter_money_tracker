import 'package:table_calendar/table_calendar.dart';

import 'transaction.dart';

class Event {
  final String _title;
  final DateTime _date;
  final double _cost;
  final String _category;

  const Event(this._title, this._date, this._cost, this._category);

  @override
  String toString() => _title;
}

List<Event> parseTransactionsAsEvents(List<Transaction> transList) {
  List<Event> evList = [];
  for (var i = 0; i < transList.length; i++) {
    evList.add(Event(transList[i].name, transList[i].date, transList[i].cost,
        transList[i].category));
  }
  return evList;
}
