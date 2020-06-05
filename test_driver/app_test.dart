import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main () {
	group("Todo App", () {
		final buttonFinder = find.byValueKey('.');
		final addButton = find.byValueKey('+');
		final oneButton = find.byValueKey('1');
		final threeButton = find.byValueKey('3');
		final equalButton = find.byValueKey('=');
		final clearButton = find.byValueKey('C');
		final counter = find.byValueKey('output');

		FlutterDriver driver;

		setUpAll(() async {
			driver = await FlutterDriver.connect();
		});

		tearDownAll(() async {
      		if (driver != null) {
        		await driver.close();
      		}
    	});

		test('tap decimal button', () async {
			await driver.tap(buttonFinder);
			expect(await driver.getText(counter), matches("0."));
		});

		test('decimal value and plus sign 0.', () async {
			await driver.tap(oneButton);
			await driver.tap(addButton);
			expect(await driver.getText(counter), matches("0.1 +"));
		});

		test('2nd decimal button 0.1 +', () async {
			await driver.tap(buttonFinder);
			expect(await driver.getText(counter), "0.1 + 0.");
		});

		test('2nd decimal value entry 0.1 + 0.1', () async {
			await driver.tap(oneButton);
			expect(await driver.getText(counter), '0.1 + 0.1');
		});

		test('calculate .1 + .1', () async {
			await driver.tap(equalButton);
			expect(await driver.getText(counter), matches("0.2"));
		});

		test('clear', () async {
			await driver.tap(clearButton);
			expect(await driver.getText(counter), matches("0"));;
		});

		test('decimal over 1', () async {
			await driver.tap(oneButton);
			expect(await driver.getText(counter), matches("1"));
			await driver.tap(buttonFinder);
			expect(await driver.getText(counter), matches("1."));
			await driver.tap(oneButton);
			expect(await driver.getText(counter), matches("1.1"));
		});

		test('decimal value and plus sign 1.1 +', () async {
			//await driver.tap(oneButton);
			await driver.tap(addButton);
			expect(await driver.getText(counter), matches("1.1 +"));
		});

		test('2nd decimal number entry 1.1 + 1.3', () async {
			await driver.tap(oneButton);
			await driver.tap(buttonFinder);
			await driver.tap(threeButton);
			expect(await driver.getText(counter), "1.1 + 1.3");
		});

		test('calculate 1.1 + 1.3', () async {
			await driver.tap(equalButton);
			expect(await driver.getText(counter), "2.4");
		});

	});    
}

