import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import './models/food.dart';
import 'widgets/foods_list.dart';
import './widgets/new_food.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Food> _foods = [];
  final randomGen = Random();

  @override
  void initState() {
    _readFoods();
    super.initState();
  }

  Future<void> _readFoods() async {
    final url = Uri.parse(
      "https://prueba-practica2-default-rtdb.firebaseio.com/food.json",
    );
    try {
      final response = await http.get(url);
      var result = json.decode(response.body);

      List<Food> foods = [];
      result.forEach((k, v) {
        final food = Food(
          id: k,
          name: v["name"],
          date: DateTime.parse(v["date"]),
          calories: v["calories"],
        );
        foods.add(food);
      });
      setState(() {
        _foods = foods;
      });
    } catch (error) {
      Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> _addNewFood(String name, int calories, DateTime date) async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://prueba-practica2-default-rtdb.firebaseio.com/food.json",
        ),
        body: json.encode(
          {'name': name, 'calories': calories, 'date': date.toString()},
        ),
      );
      final newFood = Food(
        id: json.decode(response.body)["name"],
        name: name,
        calories: calories,
        date: date,
      );
      setState(() {
        _foods.add(newFood);
      });
    } catch (error) {
      Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void _startNewFood(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewFood(_addNewFood);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Main(
        foods: _foods,
        addNewFood: _addNewFood,
        startNewFood: _startNewFood,
      ),
    );
  }
}

class Main extends StatelessWidget {
  final Function(BuildContext) startNewFood;
  final Function(String, int, DateTime) addNewFood;
  final List<Food> foods;

  Main({
    required this.startNewFood,
    required this.addNewFood,
    required this.foods,
  });

  List<Food> get _recentFoods {
    return foods.where((food) {
      return food.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity App"),
      ),
      body: ListView(
        children: [FoodsList(foods: foods)],
        // crossAxisAlignment: CrossAxisAlignment.start,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          startNewFood(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
