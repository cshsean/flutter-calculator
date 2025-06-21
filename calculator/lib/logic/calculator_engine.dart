// lib/logic/calculator_engine.dart
import 'dart:developer';

class CalculatorEngine {
  String prevResult = '';
  String prevExpression = '';
  bool isPrevExpressionValid = false;

  String evaluate(String currExpression) {
    String output = _calculateAnswer(currExpression);

    String displayedOutput;
    if (_isNumeric(output)) {
      // Rounds number to 7dp, also removes trailing zeros and converts floats to ints
      displayedOutput = double.parse(output)
          .toStringAsFixed(7)
          .replaceAll(RegExp(r"0+$"), "")
          .replaceAll(RegExp(r"\.$"), "");
      prevResult = output;
      prevExpression = currExpression;
      isPrevExpressionValid = true;
    } else {
      // If error found:
      displayedOutput = output;
      prevExpression = '';
      isPrevExpressionValid = false;
    }
    return displayedOutput;
  }

  String getPrevExpression() {
    return prevExpression;
  }

  String getPrevResult() {
    return prevResult;
  }

  bool getPrevExpressionValidity() {
    return isPrevExpressionValid;
  }

  String _calculateAnswer(String expression) {
    String answer = '';
    try {
      answer = _postfixToProduct(_tokensToPostfix(_expressionToTokens(expression)));
    } catch(e) {
      if (e is FormatException && e.message == 'Cannot divide by zero') {
        answer = 'Cannot divide by zero';
      } else {
        answer = 'Error';
      }
    }
    return answer;
  }

  List<String> _expressionToTokens(String expression) {
    List<String> output = [];
    String value = '';
    for (int i = 0; i < expression.length; i++) {
      // If char is numeric
      if (_isNumeric(expression[i])) {
        value += expression[i];
      } 
      // If char is a decimal point
      else if (expression[i] == '.') {
        // If value already has a decimal point
        if (value.contains('.')) {
          log('Multiple decimal points found');
          throw FormatException('Multiple decimal points found');
        }
        value += expression[i];
      }
      // If char is an operator/parentheses 
      else {
        // If value is still present
        if (value.isNotEmpty) {
          output.add(value);
          value = '';
        }
        // Check if '-', is unary
        if (expression[i] == '-' &&
            (output.isEmpty || operators.contains(output.last) || output.last == '(')) {
          value += expression[i];
          continue; // Skip rest of this iteration
        }
        // If there is a useless parentheses
        if (expression[i] == ')' && output.isNotEmpty && output.last == '(') {
          log('Invalid parentheses');
          throw FormatException('Invalid parentheses');
        }
        if (operators.contains(expression[i]) && output.isNotEmpty && output.last == '(' && expression[i] != '-') {
          log('Invalid syntax');
          throw FormatException('Invalid syntax');
        }
        output.add(expression[i]);
      }
    }
    if (value.isNotEmpty) {
      output.add(value);
    }
    return output;
  }


  List<String> _tokensToPostfix(List<String> tokens) {
    List<String> output = [];
    List<String> stack = [];

    for (int i = 0; i < tokens.length; i++) {
      if (_isNumeric(tokens[i])) {
        output.add(tokens[i]);
      } else if (operators.contains(tokens[i])) {
        while (stack.isNotEmpty && _getPrecedence(stack.last) >= _getPrecedence(tokens[i])) {
          output.add(stack.last);
          stack.removeLast();
        }
        stack.add(tokens[i]);
      } else if (parens.contains(tokens[i])) {
        if (tokens[i] == '(') {
          stack.add(tokens[i]);
        } else {
          while (stack.isNotEmpty && stack.last != '(') {
            output.add(stack.last);
            stack.removeLast();
          }
          stack.removeLast();
        }
      }
    }
    while (stack.isNotEmpty) {
      output.add(stack.last);
      stack.removeLast();
    }
    return output;
  }

  String _postfixToProduct(List<String> postfix) {
    List<String> output = [];
    for (int i = 0; i < postfix.length; i++) {
      if (_isNumeric(postfix[i])) {
        output.add(postfix[i]);
      } else {
        // get the last value in output
        String lastValue = output.last;
        // remove the last value in output
        output.removeLast();
        switch (postfix[i]) {
          case '+':
            output.last = (num.parse(output.last) + num.parse(lastValue)).toString();
          case '-':
            output.last = (num.parse(output.last) - num.parse(lastValue)).toString();
          case '*':
            output.last = (num.parse(output.last) * num.parse(lastValue)).toString();
          case '/':
            if (num.parse(lastValue) == 0) {
              log('Cannot divide by zero');
              throw FormatException('Cannot divide by zero');
            }
            output.last = (num.parse(output.last) / num.parse(lastValue)).toString();
        }
      }
    }
    return output.last;
  }

  bool _isNumeric(String str) {
    return num.tryParse(str) != null;
  }

  int _getPrecedence(String char) {
    switch(char) {
      case '+':
      case '-':
        return 1;
      case '*':
      case '/':
        return 2;
      default:
        return 0;
    }
  }
}

const parens = {'(', ')'};
const operators = {'+', '-', '*', '/'};
