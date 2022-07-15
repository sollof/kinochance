import 'package:flutter/material.dart';

class RollButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPress;

  // ignore: use_key_in_widget_constructors
  const RollButton({
    required this.text,
    required this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    const height = 75.0;
    const width = 200.0;
    const textSize = 33.0;
    const iconSize = 38.0;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: MaterialButton(
        color: Colors.amber,
        height: height,
        onPressed: onPress,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 10.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: iconSize,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: textSize, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
