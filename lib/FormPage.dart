import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'main.dart';
import 'transaction.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final controllerName = TextEditingController();
    final controllerCost = TextEditingController();
    final controllerAmount = TextEditingController();

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

    String? categoryChosen;

    /*
    @override
    void dispose() {
      controllerName.dispose();
      controllerCost.dispose();
      controllerAmount.dispose();
    }
    */

    return Form(
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
                  if (value == null || value.runtimeType != String) {
                    return ' Must enter a name';
                  }
                  return null;
                }),
            TextFormField(
                controller: controllerCost,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow((RegExp("[.0-9]")))
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
                    const TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    initialDate:
                        _selectedDate == null ? DateTime.now() : _selectedDate!,
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2030),
                  ).then((chosenDate) {
                    if (chosenDate == null) {
                      return null;
                    }

                    _selectedDate = chosenDate;
                  });
                },
                child: Text(_selectedDate == null
                    ? 'Now'
                    : DateFormat.MMMd().format(_selectedDate!))),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        categoryChosen != null) {
                      _formKey.currentState!.save();
                      appState.addTransaction(Transaction(
                          controllerName.text,
                          double.parse(controllerCost.text),
                          double.parse(controllerAmount.text),
                          _selectedDate == null
                              ? DateTime.now()
                              : _selectedDate!,
                          categoryChosen!));
                      // dispose();
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
                  child: const Text('Add transaction'),
                ))
          ],
        ));
  }
}
