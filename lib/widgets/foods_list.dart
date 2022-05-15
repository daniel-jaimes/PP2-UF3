import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/food.dart';

class FoodsList extends StatefulWidget {
  const FoodsList({Key? key, required this.foods}) : super(key: key);
  final List<Food> foods;

  @override
  _FoodsListState createState() => _FoodsListState();
}

class _FoodsListState extends State<FoodsList> {
  Future<void> _removeFood(Food food) async {
    try {
      await http.delete(
        Uri.parse(
          "https://prueba-practica2-default-rtdb.firebaseio.com/food/${food.id}.json",
        ),
      );
      setState(() {
        widget.foods.remove(food);
      });
    } catch (error) {
      Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.foods.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    return Column(
      children: widget.foods.isEmpty
          ? [
              const SizedBox(height: 50),
              const Text("Actualmente no tienes ningun registro")
            ]
          : widget.foods.map((food) {
              return Card(
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        '${food.calories} cal.',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 3,
                        ),
                      ),
                      padding: EdgeInsets.all(12),
                    ),
                    const SizedBox(width: 25),
                    Column(
                      children: [
                        Text(
                          food.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy').format(food.date),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(12),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20.0,
                          color: Colors.brown[900],
                        ),
                        onPressed: () {
                          setState(() {
                            _removeFood(food);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
    );
  }
}
