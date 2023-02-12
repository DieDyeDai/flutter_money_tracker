import 'package:flutter/material.dart';
import 'SummaryPage.dart';
import 'transaction.dart';
import 'FormPage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp()); // runs an App that's defined in myApp
}

class MyApp extends StatelessWidget {
  //StatelessWidget is the base class of Flutter
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Spending Tracker',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 141, 219, 255)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // MyAppState defines app's "state". Here it uses ChangeNotifier
  // ChangeNotifier allows it to notify other widgets about its own changes
  List<Transaction> transactions = <Transaction>[
    Transaction('test', 2.00, 2, DateTime.now(), 'food')
  ];

  bool toUpdateSummary = false;

  void updateSummary() {
    if (toUpdateSummary) {
      notifyListeners();
      toUpdateSummary = false;
    }
  }

  var now = DateTime.now();

  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
  }

  void editTransaction(int i, Transaction transaction) {
    transactions.removeAt(i);
    transactions.insert(i, transaction);
  }

  void removeTransaction(int i) {
    transactions.removeAt(i);
  }

  static List<Transaction> getTransactionsFromDate(
      DateTime datetime, List<Transaction> transactionsToCheck) {
    List<Transaction> transactionsAtDate = <Transaction>[];
    for (var i in transactionsToCheck) {
      if (i.date == datetime) {
        transactionsAtDate.add(i);
      }
    }
    return transactionsAtDate;
  }

  static List<Transaction> getTransactionsFromCategory(
      String category, List<Transaction> transactionsToCheck) {
    List<Transaction> transactionsFromCategory = <Transaction>[];
    for (var i in transactionsToCheck) {
      if (i.category == category) {
        transactionsFromCategory.add(i);
      }
    }
    return transactionsFromCategory;
  }

  static double getSum(List<Transaction> transactions) {
    double sum = 0.0;
    for (var i in transactions) {
      sum += i.cost * i.amount;
    }
    return sum;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = FormPage();
        break;
      case 1:
        page = SummaryPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(// builds scaffold
        builder: (context, constraints) {
      // constraints: like page or window size
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >=
                    600, // if our app box is wider than 600, extend NavigationRail
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  print('selected: $value');
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
