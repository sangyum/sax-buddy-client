import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth_wrapper.dart';
import 'services/logging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging
  LoggingService().initialize(isDebug: kDebugMode);
  LoggingService().logInfo('App starting');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  LoggingService().logInfo('Firebase initialized');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sax Buddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}
