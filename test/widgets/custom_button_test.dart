import 'package:ammentor/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ammentor/screen/auth/model/auth_model.dart';

void main() {
  Widget createWidgetUnderTest({Function(String)? onSelect}) {
    return MaterialApp(
    home: Scaffold(
    body: CustomButton(
    options: const ['Option 1', 'Option 2', 'Option 3'],
          initialSelection: 'Option 1',
          onSelect: onSelect,
        ),
      ),
    );
  }

  testWidgets('Initial selection is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Option 1'), findsOneWidget);
  });

  testWidgets('Dropdown expands when tapped', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Option 1'));
    await tester.pumpAndSettle();

    expect(find.text('Option 2'), findsOneWidget);
    expect(find.text('Option 3'), findsOneWidget);
  });

  testWidgets('Selecting option updates selected value', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Option 1'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Option 2'));
    await tester.pumpAndSettle();

    expect(find.text('Option 2'), findsOneWidget);
  });

  testWidgets('onSelect callback is triggered', (WidgetTester tester) async {
    String? selected;

    await tester.pumpWidget(
      createWidgetUnderTest(onSelect: (value) {
        selected = value;
      }),
    );

    await tester.tap(find.text('Option 1'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Option 3'));
    await tester.pumpAndSettle();

    expect(selected, 'Option 3');
  });
}
