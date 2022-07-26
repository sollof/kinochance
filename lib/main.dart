import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:spin_rex/screens/filters_screen.dart';

import 'package:spin_rex/widgets/roll_button.dart';
import 'package:spin_rex/screens/fortune_bar_screen.dart';
import 'package:spin_rex/screens/fortune_wheel_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'models.dart';
import 'package:flutter/rendering.dart';

Future loadAssetData() async {
  final content = await rootBundle.loadString('assets/core.json', cache: false);
  return json.decode(content);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final modelData = await loadAssetData();
  final filters = FilterModel.initFilters();
  final model = DataModel.fromJson(modelData);

  // debugPaintSizeEnabled = true;
  runApp(MyApp(
    providers: [Provider<DataModel>.value(value: model), Provider<FilterModel>.value(value: filters)],
  ));
}

class MyApp extends StatelessWidget {
  final List<SingleChildStatelessWidget> providers;

  const MyApp({Key? key, required this.providers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: providers,
        child: MaterialApp(
          title: 'SpinRex Demo',
          theme: ThemeData(
            primarySwatch: Colors.amber,
          ),
          initialRoute: 'home',
          routes: {
            'home': (context) => const HomePage(title: 'SpinRex Demo'),
            'wheel': (context) => const FortuneWheelScreen(),
            'bar': (context) => const FortuneBarScreen(),
            'filters': (context) => const FiltersScreen(),
          },
        ));
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
                Navigator.pushNamed(context, 'filters');
              },
              icon: Icons.play_arrow,
              text: 'Spin',
            ),
            RollButton(text: 'Exit', icon: Icons.close, onPress: () => exit(0))
          ],
        ),
      ),
    );
  }
}
