import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Sax Buddy Test'),
        ),
      ),
    ));
    
    expect(find.text('Sax Buddy Test'), findsOneWidget);
  });
}
