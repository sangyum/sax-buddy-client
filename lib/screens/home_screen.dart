import 'package:flutter/material.dart';
import 'package:sax_buddy/services/auth_service.dart';
import 'package:sax_buddy/services/logging_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final LoggingService _logger = LoggingService();

  @override
  void initState() {
    super.initState();
    _logger.logScreenView(
      'HomeScreen',
      parameters: {
        'userId': _authService.currentUser?.uid,
        'userEmail': _authService.currentUser?.email,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sax Buddy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              _logger.logUserAction(
                'tap_sign_out_button',
                context: {'userId': _authService.currentUser?.uid},
              );
              await _authService.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 100, color: Colors.blue),
            const SizedBox(height: 32),
            Text(
              'Welcome, ${_authService.currentUser?.displayName ?? 'User'}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'You are signed in to Sax Buddy',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
