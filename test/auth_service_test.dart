import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sax_buddy/screens/sign_in_screen.dart';

void main() {
  group('Authentication UI Tests', () {
    testWidgets('SignInScreen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInScreen()));
      
      expect(find.text('Welcome to Sax Buddy'), findsOneWidget);
      expect(find.text('Please sign in to continue'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.byIcon(Icons.music_note), findsOneWidget);
    });

    testWidgets('SignInScreen has Google sign-in button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInScreen()));
      
      final signInButton = find.byType(ElevatedButton);
      expect(signInButton, findsOneWidget);
      
      expect(find.text('Sign in with Google'), findsOneWidget);
    });
  });
}