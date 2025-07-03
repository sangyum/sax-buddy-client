import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sax_buddy/screens/sign_in_screen.dart';
import 'package:sax_buddy/screens/home_screen.dart';
import 'package:sax_buddy/services/auth_service.dart';
import 'package:sax_buddy/services/logging_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  final LoggingService _logger = LoggingService();

  @override
  void initState() {
    super.initState();
    _logger.logInfo('AuthWrapper initialized');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          _logger.logInfo('Auth state loading');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          _logger.logInfo(
            'User authenticated, showing home screen',
            data: {'userId': snapshot.data?.uid, 'email': snapshot.data?.email},
          );
          return const HomeScreen();
        } else {
          _logger.logInfo('User not authenticated, showing sign-in screen');
          return const SignInScreen();
        }
      },
    );
  }
}
