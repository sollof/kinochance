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
  Widget build(BuildContext ctx) {
    const height = 75.0;
    const margin = 5.0;
    const aspect = 1880 / 600;
    const textSize = 33.0;
    const iconSize = 38.0;

    return Container(
      color: Colors.amber,
      height: height,
      margin: const EdgeInsets.only(
        top: margin,
        left: margin,
        bottom: margin,
      ),
      child: AspectRatio(
        aspectRatio: aspect,
        child: Container(
          padding: const EdgeInsets.only(
            bottom: margin,
            right: margin,
          ),
          child: InkWell(
            onTap: () => onPress(),
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
                    style: Theme.of(ctx).textTheme.headline1!.copyWith(
                        fontSize: textSize, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
