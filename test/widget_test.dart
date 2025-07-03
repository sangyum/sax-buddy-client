import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/screens/sign_in_screen.dart';
import 'package:sax_buddy/screens/home_screen.dart';

void main() {
  testWidgets('SignInScreen shows welcome message', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignInScreen()));
    
    expect(find.text('Welcome to Sax Buddy'), findsOneWidget);
    expect(find.text('Please sign in to continue'), findsOneWidget);
  });

  testWidgets('HomeScreen shows welcome message', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    
    expect(find.text('Welcome, User!'), findsOneWidget);
    expect(find.text('You are signed in to Sax Buddy'), findsOneWidget);
  });
}
