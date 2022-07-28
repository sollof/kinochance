import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import 'package:spin_rex/widgets/roll_button.dart';
import 'package:provider/provider.dart';

import '../models.dart';

class FortuneBarScreen extends StatefulWidget {
  const FortuneBarScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FortuneBarScreenState createState() => _FortuneBarScreenState();
}

class _FortuneBarScreenState extends State<FortuneBarScreen> {
  StreamController<int> controller = StreamController<int>.broadcast();

  @override
  Widget build(BuildContext ctx) {
    final model = Provider.of<DataModel>(context);
    final filters = Provider.of<FilterModel>(context);
    List<String> items = [];
    for (var row in model.data[filters.category]) {
      if (filters.checkRowByFilters(row)) {
        items.add(row['name']);
      }
    }
    if (items.isEmpty) {
      for (var x in [0, 1, 2]) {
        items.add('Sorry, bratishka, but selection is empty');
      }
    }
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Row(children: [
            Flexible(
                flex: 1,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 70),
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 15),
                    child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.amber,
                        iconSize: 24,
                        onPressed: () {
                          Navigator.pop(ctx);
                        }),
                  ),
                )),
            Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: FortuneBar(
                          visibleItemCount: 5,
                          height: 200,
                          animateFirst: false,
                          selected: controller.stream,
                          items: [
                            for (var it in items)
                              FortuneItem(
                                  child: Text(it),
                                  style: FortuneItemStyle(textAlign: TextAlign.center, borderWidth: 0.5))
                          ],
                        )),
                    const SizedBox(height: 50),
                    RollButton(
                      onPress: () {
                        setState(() {
                          controller.add(
                            Fortune.randomInt(0, items.length),
                          );
                        });
                      },
                      icon: Icons.sync_sharp,
                      text: 'Spin',
                    ),
                  ],
                )),
          ])),
    );
  }
}
