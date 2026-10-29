import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project04_unit_converter/main.dart';

void main() {
  testWidgets('Unit Converter app loads successfully', (tester) async {
    await tester.pumpWidget(const UnitConverterApp());

    expect(find.text('Unit Converter'), findsOneWidget);
    expect(find.text('Convert anything.'), findsOneWidget);
    expect(find.text('CONVERTED RESULT'), findsOneWidget);
  });

  testWidgets('Reset button is displayed', (tester) async {
    await tester.pumpWidget(const UnitConverterApp());

    expect(find.text('Reset Converter'), findsOneWidget);
  });

  testWidgets('Swap button is displayed', (tester) async {
    await tester.pumpWidget(const UnitConverterApp());

    expect(find.byKey(const Key('swap_units')), findsOneWidget);
  });

  testWidgets('Conversion input is displayed', (tester) async {
    await tester.pumpWidget(const UnitConverterApp());

    expect(find.byKey(const Key('converter_input')), findsOneWidget);
  });
}