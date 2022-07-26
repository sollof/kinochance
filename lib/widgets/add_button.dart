import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final String sign;
  final VoidCallback onPress;

  // ignore: use_key_in_widget_constructors
  const AddButton({
    required this.sign,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    const height = 40.0;
    const width = 60.0;
    const textSize = 15.0;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(5),
      child: MaterialButton(
        color: Colors.amber,
        height: height,
        onPressed: onPress,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 5.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(1),
              child: Text(
                sign,
                style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: textSize, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
