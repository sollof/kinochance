import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import 'package:luck_and_roll/widgets/roll_button.dart';

class FortuneBarScreen extends StatefulWidget {
  const FortuneBarScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FortuneBarScreenState createState() => _FortuneBarScreenState();
}

class _FortuneBarScreenState extends State<FortuneBarScreen> {
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
                child: FortuneBar(
                  visibleItemCount: 5,
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
