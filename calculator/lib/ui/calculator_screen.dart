import 'package:flutter/material.dart';
import '../logic/calculator_engine.dart';
import 'calculator_display.dart';
import 'calculator_buttons.dart';

const double buttonHeight = 60.0;

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

// Calculator Screen
class _CalculatorScreenState extends State<CalculatorScreen> {
  final calculator = CalculatorEngine();
  String display = '';
  String prevResult = '';
  String prevExpression = '';
  bool resetAfterCalculation = false;
  bool isPrevExpressionValid = false;

  void onButtonPressed(String value) {
    setState(() {
      // If user clicks on '='
      if (value == '=') {
        display = calculator.evaluate(display);
        prevResult = calculator.getPrevResult();
        prevExpression = calculator.getPrevExpression();
        isPrevExpressionValid = calculator.getPrevExpressionValidity();
        resetAfterCalculation = true;
      }
      // If user clicks on 'C 
      else if (value == 'C') {
        if (resetAfterCalculation) {
          // First tap after calculation clears display only
          display = '';
          resetAfterCalculation = false;
        } else if (display.isNotEmpty) {
          // Backspace
          display = display.substring(0, display.length - 1);
        } else if (display.isEmpty && prevExpression.isNotEmpty) {
          // Second tap clears prevExpression if display already empty
          prevExpression = '';
        }
      }
      // If user clicks on number/operator/parentheses 
      else {
        if (resetAfterCalculation) {
          if (isPrevExpressionValid) {
            display = prevResult + value;
          } else {
            display = value;
          }
          resetAfterCalculation = false;
        } else {
          display += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.all(10)),
          CalculatorDisplay(value: display, prevExpression: prevExpression,),
          SizedBox(height: 20),
          CalculatorButtons(onPressed: onButtonPressed,),
        ],
      ),
    );
  }
}