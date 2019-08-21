import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calculator_demo/calculator.dart';

void main() async {
	await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
	runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {

	static const String _title = "Flutter Calculator";

	@override
	Widget build(BuildContext context) {

		return MaterialApp(
			title: _title,
			theme: ThemeData(primarySwatch: Colors.teal),
			home: Calculator(title: _title),
		);
	}
}