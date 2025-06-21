import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  final String value;
  final String? prevExpression;

  const CalculatorDisplay({
    super.key,
    required this.value,
    this.prevExpression,
  });

  @override
  Widget build(BuildContext context) {
    final double fontSize;
    final EdgeInsets paddingAroundDisplayText;

    if (value.toLowerCase().contains('zero')) {
      fontSize = 32;
      paddingAroundDisplayText = const EdgeInsets.only(right: 10, bottom: 10);
    } else {
      fontSize = 60;
      paddingAroundDisplayText = const EdgeInsets.only(right: 10);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 150,
      constraints: const BoxConstraints(maxWidth: 400),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (prevExpression != null)
            Padding(
              padding: EdgeInsets.only(
                right: paddingAroundDisplayText.right,
                top: 20, // pull it closer to the main value
              ),
              child: Text(
                prevExpression!,
                style: const TextStyle(
                  fontSize: 24, // slightly larger
                  color: Colors.white70,
                ),
                textAlign: TextAlign.right,
                softWrap: false,
                maxLines: 1,
              ),
            ),
          const Spacer(),
          Padding(
            padding: paddingAroundDisplayText,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true, // Makes overflow go left
              child: Text(
                value,
                style: TextStyle(fontSize: fontSize, color: Colors.white),
                textAlign: TextAlign.right,
                softWrap: false,
                overflow: TextOverflow.visible,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
