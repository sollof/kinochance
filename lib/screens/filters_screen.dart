import 'package:flutter/material.dart';
import 'package:luck_and_roll/widgets/add_button.dart';
import 'package:luck_and_roll/widgets/multi_selector_widget.dart';
import 'package:luck_and_roll/widgets/range_slider_widget.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../widgets/roll_button.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> with SingleTickerProviderStateMixin {
  // ignore: deprecated_member_use, prefer_final_fields
  String? categoryValue;
  final List<FilterWidget> _filtersWidgets = <FilterWidget>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DataModel>(context);
    final filters = Provider.of<FilterModel>(context);

    var categoryItems = model.dataTypes.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList();
    categoryValue ??= filters.category.isNotEmpty ? filters.category : categoryItems.first.value;
    if (_filtersWidgets.isEmpty) {
      for (var entry in filters.getExistingFilters().entries) {
        if (DataModel.availableIntegerFilters.contains(entry.key)) {
          _filtersWidgets.add(FilterWidget(
              category: categoryValue!,
              filterKey: entry.key,
              selectedValues: RangeValues(entry.value['from'], entry.value['to'])));
        } else {
          _filtersWidgets.add(FilterWidget(category: categoryValue!, filterKey: entry.key, selectedItems: entry.value));
        }
      }
    }

    return Scaffold(
        body: Row(children: [
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
                    Navigator.pop(context);
                  }),
            ),
          )),
      Expanded(
          flex: 9,
          child: Container(
              padding: const EdgeInsets.only(top: 15),
              alignment: Alignment.topCenter,
              child: Column(children: <Widget>[
                Flexible(
                    flex: 1,
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        decoration: BoxDecoration(color: Colors.amberAccent, borderRadius: BorderRadius.circular(15)),
                        child: DropdownButton<String>(
                          alignment: Alignment.center,
                          menuMaxHeight: 300,
                          items: categoryItems,
                          value: categoryValue,
                          onChanged: (String? categoryNewValue) {
                            setState(() {
                              if (categoryNewValue != categoryValue) {
                                categoryValue = categoryNewValue;
                                filters.category = categoryNewValue!;
                                _filtersWidgets.clear();
                                filters.removeFilters();
                              }
                            });
                          },
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          underline: const SizedBox(),
                        ))),
                Expanded(
                    flex: 7,
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 300,
                          ),
                          child: Column(
                            children: List.generate(_filtersWidgets.length, (i) {
                              return _filtersWidgets[i];
                            }),
                          )),
                    )),
                Flexible(
                    flex: 1,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AddButton(
                            sign: '+',
                            onPress: () {
                              setState(() {
                                if (_filtersWidgets.length <= 7) {
                                  if (categoryValue != null && model.availableParams[categoryValue] != null) {
                                    _filtersWidgets.add(FilterWidget(category: categoryValue!));
                                  }
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          AddButton(
                            sign: '-',
                            onPress: () {
                              setState(() {
                                if (_filtersWidgets.isNotEmpty) {
                                  FilterWidget lastFilter = _filtersWidgets.last;
                                  if (lastFilter.filterKey != null) {
                                    filters.removeFilter(lastFilter.filterKey!);
                                  }
                                  _filtersWidgets.removeLast();
                                }
                              });
                            },
                          ),
                        ])),
                const SizedBox(height: 5),
                Flexible(
                    flex: 2,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RollButton(
                            onPress: () {
                              Navigator.pushNamed(context, 'bar');
                            },
                            icon: Icons.crop_3_2_rounded,
                            text: 'Bar',
                          ),
                          const SizedBox(width: 30),
                          RollButton(
                            onPress: () {
                              Navigator.pushNamed(context, 'wheel');
                            },
                            icon: Icons.circle_outlined,
                            text: 'Whell',
                          ),
                        ]))
              ])))
    ]));
  }
}

class FilterWidget extends StatefulWidget {
  FilterWidget({Key? key, required this.category, this.filterKey, this.selectedValues, this.selectedItems})
      : super(key: key);

  final String category;

  String? filterKey;
  RangeValues? selectedValues;
  List<String>? selectedItems;

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> with SingleTickerProviderStateMixin {
  _FilterWidgetState();

  @override
  void initState() {
    super.initState();
  }

  void _showMultiSelect(List<String> items) async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectWidget(items: items, selectedItems: widget.selectedItems!);
      },
    );

    if (results != null) {
      setState(() {
        final filters = Provider.of<FilterModel>(context, listen: false);

        widget.selectedItems = results;
        filters.addStringFilter(widget.filterKey!, results);
      });
    }
  }

  void _showRangeSlider(List<double> items) async {
    final RangeValues? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return RangeSliderWidget(items: items, values: widget.selectedValues!);
      },
    );

    if (results != null) {
      setState(() {
        final filters = Provider.of<FilterModel>(context, listen: false);

        widget.selectedValues = results;
        filters.addIntFilter(widget.filterKey!, results.start.toDouble(), results.end.toDouble());
      });
    }
  }

  Widget _getFilterValueWidget() {
    final model = Provider.of<DataModel>(context);

    if (DataModel.availableIntegerFilters.contains(widget.filterKey)) {
      List<double> items = model.availableParams[widget.category]![widget.filterKey]!.toList().cast();
      widget.selectedValues ??= RangeValues(items.first, items.last);
      return SizedBox(
          width: 200,
          height: 40,
          child: ElevatedButton(
            child: Text('Selected ${widget.selectedValues!.start.toInt()} - ${widget.selectedValues!.end.toInt()}'),
            onPressed: () {
              _showRangeSlider(items);
            },
          ));
    } else {
      List<String> filterItems =
          model.availableParams[widget.category]![widget.filterKey]!.map((e) => e.toString()).toList();
      widget.selectedItems ??= [];
      return SizedBox(
          width: 200,
          height: 40,
          child: ElevatedButton(
            child: Text('Selected ${widget.selectedItems!.length} items'),
            onPressed: () {
              _showMultiSelect(filterItems);
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DataModel>(context);
    final filters = Provider.of<FilterModel>(context);

    List<DropdownMenuItem<String>> filterKeyItems = [];
    for (var i in model.availableParams[widget.category]!.keys.toList()) {
      filterKeyItems.add(DropdownMenuItem<String>(value: i, child: Text(i)));
    }
    widget.filterKey ??= filterKeyItems.isNotEmpty ? filterKeyItems.first.value : null;

    return Container(
        width: 600,
        padding: const EdgeInsets.all(5),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: BoxDecoration(color: Colors.amberAccent, borderRadius: BorderRadius.circular(10)),
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(10.0),
                items: filterKeyItems,
                value: widget.filterKey,
                menuMaxHeight: 300,
                onChanged: (String? filterNewKey) {
                  setState(() {
                    if (filterNewKey != null && filterNewKey != widget.filterKey) {
                      filters.removeFilter(widget.filterKey!);
                      widget.filterKey = filterNewKey;
                      widget.selectedValues = null;
                      widget.selectedItems = [];
                    }
                  });
                },
                alignment: AlignmentDirectional.center,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                underline: const SizedBox(),
              )),
          const SizedBox(width: 30),
          _getFilterValueWidget(),
        ]));
  }
}
