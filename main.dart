import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YashCalculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 7, 74, 245)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Calculator()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.calculate,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'YashCalculator',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _display = '0';
  double _previousValue = 0;
  String _operation = '';
  bool _isNewInput = true;

  void _buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _previousValue = 0;
        _operation = '';
        _isNewInput = true;
      } else if (value == 'CE') {
        _display = '0';
        _isNewInput = true;
      } else if ('+-*/'.contains(value)) {
        if (_operation.isNotEmpty) {
          _calculate();
        }
        _previousValue = double.tryParse(_display) ?? 0;
        _operation = value;
        _isNewInput = true;
      } else if (value == '=') {
        _calculate();
        _operation = '';
      } else {
        if (_isNewInput || _display == '0') {
          _display = value;
          _isNewInput = false;
        } else {
          _display += value;
        }
      }
    });
  }

  void _calculate() {
    double currentValue = double.tryParse(_display) ?? 0;
    double result;

    switch (_operation) {
      case '+':
        result = _previousValue + currentValue;
        break;
      case '-':
        result = _previousValue - currentValue;
        break;
      case '*':
        result = _previousValue * currentValue;
        break;
      case '/':
        if (currentValue == 0) {
          _display = 'ERROR';
          return;
        } else {
          result = _previousValue / currentValue;
        }
        break;
      default:
        return;
    }

    _display = result.toStringAsFixed(2).replaceAll(RegExp(r'\.0+$'), '');
    _isNewInput = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                _display,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildButtonRow(['7', '8', '9', '/']),
                _buildButtonRow(['4', '5', '6', '*']),
                _buildButtonRow(['1', '2', '3', '-']),
                _buildButtonRow(['C', '0', 'CE', '+']),
                _buildButtonRow(['=']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> values) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: values.map((value) => _buildButton(value)).toList(),
      ),
    );
  }

  Widget _buildButton(String value) {
    final bool isNumeric = RegExp(r'^[0-9]+$').hasMatch(value);
    final bool isOperator = '+-*/'.contains(value);
    final bool isEqual = value == '=';
    final bool isClear = value == 'C' || value == 'CE';

    return Expanded(
      child: ElevatedButton(
        onPressed: () => _buttonPressed(value),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          textStyle: const TextStyle(fontSize: 20),
          backgroundColor: isNumeric
              ? const Color.fromARGB(255, 8, 8, 8)
              : isEqual
                  ? Colors.red
                  : isClear
                      ? const Color.fromARGB(255, 8, 8, 8)
                      : const Color.fromARGB(255, 23, 158, 216),
          foregroundColor: Colors.white,
        ),
        child: Text(value),
      ),
    );
  }
}
