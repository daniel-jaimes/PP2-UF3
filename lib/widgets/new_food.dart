import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewFood extends StatefulWidget {
  final Function(String, int, DateTime) _addNewFoodHandler;

  NewFood(this._addNewFoodHandler);

  @override
  State<NewFood> createState() => _NewFoodState();
}

class _NewFoodState extends State<NewFood> {
  final titleController = TextEditingController();
  final caloriesController = TextEditingController();
  var _selectedDate;

  void _submit() {
    final distance = int.parse(caloriesController.text);
    if (titleController.text.isEmpty ||
        caloriesController.text.isEmpty ||
        distance <= 0 ||
        distance >= 5000 ||
        _selectedDate == null) {
      return;
    }

    widget._addNewFoodHandler(
      titleController.text,
      distance,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((value) {
      print(value);
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration:
                  const InputDecoration(labelText: 'Nombre de la comida'),
            ),
            TextField(
              controller: caloriesController,
              decoration: const InputDecoration(labelText: 'Calorias'),
              keyboardType: TextInputType.number,
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? "Sin fecha seleccionada"
                          : DateFormat.yMd().format(_selectedDate),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text(
                      'Seleccionar fecha',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                    onPressed: _showDatePicker,
                  ),
                ],
              ),
              height: 80,
            ),
            ElevatedButton(
              child: const Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () {
                _submit();
              },
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
        padding: const EdgeInsets.all(20),
      ),
      elevation: 8,
    );
  }
}
