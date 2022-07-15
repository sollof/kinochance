import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import 'package:luck_and_roll/roll_button.dart';

class FortuneWheelScreen extends StatefulWidget {
  const FortuneWheelScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FortuneWheelScreenState createState() => _FortuneWheelScreenState();
}

class _FortuneWheelScreenState extends State<FortuneWheelScreen> {
  late List<String> items;

  StreamController<int> controller = StreamController<int>.broadcast();

  @override
  Widget build(BuildContext ctx) {
    items = ['1', '2', '3', '4'];
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                height: 100,
                width: 500,
                child: FortuneWheel(
                  animateFirst: false,
                  selected: controller.stream,
                  items: [for (var it in items) FortuneItem(child: Text(it))],
                )),
            RollButton(
              onPress: () {
                setState(() {
                  controller.add(
                    Fortune.randomInt(0, items.length),
                  );
                });
              },
              icon: Icons.sync_sharp,
              text: 'Roll',
            ),
          ],
        ),
      ),
    );
  }
}
