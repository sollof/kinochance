import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import 'package:spin_rex/widgets/roll_button.dart';
import 'package:provider/provider.dart';

import '../models.dart';

class FortuneWheelScreen extends StatefulWidget {
  const FortuneWheelScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FortuneWheelScreenState createState() => _FortuneWheelScreenState();
}

class _FortuneWheelScreenState extends State<FortuneWheelScreen> {
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

    List<int> indixes = List<int>.generate(items.length, (i) => i);
    indixes.shuffle();
    int count = items.length > 8 ? 8 : items.length;
    List<String> newItems = indixes.take(count).map((i) => items[i]).toList();

    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Row(children: [
            Flexible(
                flex: 1,
                child: Container(
                  width: 70,
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
                    Flexible(
                        flex: 7,
                        child: Container(
                            constraints:
                                const BoxConstraints(minWidth: 500, minHeight: 400, maxWidth: 1000, maxHeight: 1000),
                            alignment: Alignment.center,
                            child: FortuneWheel(
                              animateFirst: false,
                              indicators: const <FortuneIndicator>[
                                FortuneIndicator(
                                  alignment: Alignment.centerRight, // <-- changing the position of the indicator
                                  child: TriangleIndicator(
                                    color: Colors.black, // <-- changing the color of the indicator
                                  ),
                                ),
                              ],
                              selected: controller.stream,
                              items: [for (var it in newItems) FortuneItem(child: Text(it))],
                            ))),
                    const SizedBox(height: 50),
                    Flexible(
                        flex: 2,
                        child: RollButton(
                          onPress: () {
                            setState(() {
                              controller.add(
                                Fortune.randomInt(0, newItems.length),
                              );
                            });
                          },
                          icon: Icons.sync_sharp,
                          text: 'Spin',
                        )),
                  ],
                )),
          ])),
    );
  }
}
