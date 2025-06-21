import 'package:flutter/material.dart';

class CalculatorButtons extends StatelessWidget {
  final void Function(String) onPressed;

  const CalculatorButtons({super.key, required this.onPressed});

  static const double buttonHeight = 60;
  static const double buttonSpacing = 8; // Consistent spacing

  static const List<List<CalculatorButtonModel>> buttonRows = [
    // Row 1: C, +/-, %, /
    [
      CalculatorButtonModel(label: '(', type: ButtonType.special),
      CalculatorButtonModel(label: ')', type: ButtonType.special),
      CalculatorButtonModel(label: 'C', type: ButtonType.clear),
      CalculatorButtonModel(label: '/', type: ButtonType.operator),
    ],
    // Row 2: 7, 8, 9, x
    [
      CalculatorButtonModel(label: '7', type: ButtonType.number),
      CalculatorButtonModel(label: '8', type: ButtonType.number),
      CalculatorButtonModel(label: '9', type: ButtonType.number),
      CalculatorButtonModel(label: '*', type: ButtonType.operator),
    ],
    // Row 3: 4, 5, 6, -
    [
      CalculatorButtonModel(label: '4', type: ButtonType.number),
      CalculatorButtonModel(label: '5', type: ButtonType.number),
      CalculatorButtonModel(label: '6', type: ButtonType.number),
      CalculatorButtonModel(label: '-', type: ButtonType.operator),
    ],
    // Row 4: 1, 2, 3, +
    [
      CalculatorButtonModel(label: '1', type: ButtonType.number),
      CalculatorButtonModel(label: '2', type: ButtonType.number),
      CalculatorButtonModel(label: '3', type: ButtonType.number),
      CalculatorButtonModel(label: '+', type: ButtonType.operator),
    ],
    // Row 5: 0, ., =
    [
      CalculatorButtonModel(label: '0', type: ButtonType.number),
      CalculatorButtonModel(label: '.', type: ButtonType.special),
      CalculatorButtonModel(label: '=', type: ButtonType.equals, flex: 2),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: buttonRows.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: buttonSpacing), // Spacing between rows
            child: Row(
              children: row.map((button) {
                return Expanded(
                  flex: button.flex,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: button.label == row.last.label ? 0 : buttonSpacing, // No spacing after last button in row
                    ),
                    child: SizedBox(
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () => onPressed(button.label),
                        style: _buttonStyle(button.type),
                        child: Text(button.label),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Styles based on button type
  ButtonStyle _buttonStyle(ButtonType type) {
    Color? backgroundColor;
    switch (type) {
      case ButtonType.operator:
        backgroundColor = Colors.orange[700];
      case ButtonType.equals:
        backgroundColor = Colors.blue[700];
      case ButtonType.clear:
      case ButtonType.special:
        backgroundColor = Colors.grey[600];
      case ButtonType.number:
        backgroundColor = Colors.grey[800];
    }

    return ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white, // Text color
      textStyle: const TextStyle(fontSize: 28), // Slightly larger text
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

// --- Button Model and Type Enums (as defined above) ---
enum ButtonType { number, operator, clear, special, equals }

class CalculatorButtonModel {
  final String label;
  final ButtonType type;
  final int flex;

  const CalculatorButtonModel({
    required this.label,
    required this.type,
    this.flex = 1,
  });
}