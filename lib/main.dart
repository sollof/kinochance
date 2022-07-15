import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import 'package:luck_and_roll/roll_button.dart';
import 'package:luck_and_roll/screens/fortune_bar_screen.dart';
import 'package:luck_and_roll/screens/fortune_wheel_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luck&Roll Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: 'home',
      routes: {
        'home': (context) => const HomePage(title: 'Luck&Roll Demo'),
        'wheel': (context) => const FortuneWheelScreen(),
        'bar': (context) => const FortuneBarScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = <String>[
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RollButton(
              onPress: () {
                Navigator.pushNamed(context, 'bar');
              },
              icon: Icons.crop_3_2_rounded,
              text: 'Bar',
            ),
            RollButton(
              onPress: () {
                Navigator.pushNamed(context, 'wheel');
              },
              icon: Icons.circle_outlined,
              text: 'Whell',
            ),
          ],
        ),
      ),
    );
  }
}
