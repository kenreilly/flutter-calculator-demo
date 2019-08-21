import 'package:flutter/material.dart';
import 'package:flutter_calculator_demo/calculator-key.dart';
import 'package:flutter_calculator_demo/display.dart';
import 'package:flutter_calculator_demo/key-controller.dart';
import 'package:flutter_calculator_demo/key-pad.dart';
import 'package:flutter_calculator_demo/key-symbol.dart';

class Calculator extends StatefulWidget {

	Calculator({Key key, this.title}) : super(key: key);
	final String title;

	@override
	_CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

	KeySymbol _operator;
	String _valueA = '0';
	String _valueB = '0';
	String _result;

	String get _output => _result == null ? _equation : _result;

	String get _equation => _valueA
		+ (_operator != null ? ' ' + _operator.value : '')
		+ (_valueB != '0' ? ' ' + _valueB : '');

	@override
	void initState() {
		
		KeyController.listen(_handler);
		super.initState();
	}

	@override
	void dispose() {

		KeyController.dispose();
		super.dispose();
	}

	void _handler(dynamic event) {
		
		CalculatorKey key = (event as KeyEvent).key;
		switch(key.symbol.type) {

			case KeyType.FUNCTION:
				return handleFunction(key);

			case KeyType.OPERATOR:
				return handleOperator(key);

			case KeyType.INTEGER:
				return handleInteger(key);
		}
	}

	void handleFunction(CalculatorKey key) {

		if (_valueA == '0') { return; }

		Map<KeySymbol, dynamic> table = {
			Keys.clear: () => _clear(),
			Keys.sign: () => _sign(),
			Keys.percent: () => _percent(),
			Keys.decimal: () => _decimal(),
		};

		table[key.symbol]();
	}

	void handleOperator(CalculatorKey key) {

		if (_valueA == '0') { return; }
		if (key.symbol == Keys.equals) { return _calculate(); }
		setState(() { _operator = key.symbol; });
	}

	void handleInteger(CalculatorKey key) {

		setState(() {

			if (_valueA == '0' || _operator == null) {
				_valueA = (_valueA == '0') ? key.symbol.value : _valueA + key.symbol.value;
			}
			else {
				_valueB = (_valueB == '0') ? key.symbol.value : _valueB + key.symbol.value;
			}
		});
	}

	void _clear() {

		setState(() { _valueA = _valueB = '0'; _operator = _result = null; });
	}

	void _sign() {

		if (_valueB != '0' && _valueB.contains('-')) {
			setState(() { 
				_valueB = (_valueB.contains('-') ? _valueB.substring(1) : '-' + _valueB); 
			});
		}
		if (_valueB != '0') {
			setState(() { _valueB = (_valueB.contains('-') ? _valueB.substring(1) : '-' + _valueB); });
		}
		else if (_valueA != '0') { 
			setState(() { _valueA = (_valueA.contains('-') ? _valueA.substring(1) : '-' + _valueA); });
		}
	}

	void _percent() {

	}

	void _decimal() {


	}

	void _calculate() {

		if (_operator == null || _valueB == '0') { return; }

		Map<KeySymbol, dynamic> table = {
			Keys.divide: (a, b) => (a / b),
			Keys.multiply: (a, b) => (a * b),
			Keys.subtract: (a, b) => (a - b),
			Keys.add: (a, b) => (a + b)
		};

		double result = table[_operator](double.parse(_valueA), double.parse(_valueB));
		String str = result.toStringAsFixed(4);

		setState(() { _result = str.endsWith('.0000') ? str.substring(0, str.length - 5) : str; });
	}

	@override
	Widget build(BuildContext context) {

		Size screen = MediaQuery.of(context).size;

		double buttonSize = screen.width / 4;
		double displayHeight = screen.height - (buttonSize * 5) - (buttonSize);
	
		return Scaffold(
			backgroundColor: Color.fromARGB(196, 32, 64, 96),
			body: Column(
				
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[

					Display(value: _output, height: displayHeight),
					KeyPad()
				]
			),
		);
	}
}
