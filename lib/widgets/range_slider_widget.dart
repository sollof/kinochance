import 'package:flutter/material.dart';

class RangeSliderWidget extends StatefulWidget {
  final List<double> items;
  RangeValues values;
  RangeSliderWidget({Key? key, required this.items, required this.values}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RangeSliderWidgetState();
}

class _RangeSliderWidgetState extends State<RangeSliderWidget> {
  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, widget.values);
  }

  @override
  Widget build(BuildContext context) {
    widget.items.sort();
    return AlertDialog(
      title: const Text('Select Range'),
      content: SizedBox(
          height: 100,
          child: RangeSlider(
            values: widget.values,
            max: widget.items.last.toDouble(),
            min: widget.items.first.toDouble(),
            labels: RangeLabels(
              widget.values.start.round().toString(),
              widget.values.end.round().toString(),
            ),
            divisions: widget.items.last.toInt() - widget.items.first.toInt(),
            onChanged: (RangeValues values) {
              setState(() {
                widget.values = values;
              });
            },
          )),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
      contentPadding: const EdgeInsets.all(10),
    );
  }
}
