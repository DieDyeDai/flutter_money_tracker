class Transaction {
  static List<String> categories = [
    'food',
    'transportation',
    'education',
    'entertainment',
    'home',
    'clothes',
    'other'
  ];

  String name;
  double cost;
  double amount;
  DateTime date;
  String category;

  Transaction(
    this.name,
    this.cost,
    this.amount,
    this.date,
    this.category,
  );
}
