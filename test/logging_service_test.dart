import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/services/logging_service.dart';

void main() {
  group('LoggingService Tests', () {
    late LoggingService loggingService;

    setUp(() {
      loggingService = LoggingService();
      loggingService.initialize(isDebug: true);
    });

    test('LoggingService should be a singleton', () {
      final instance1 = LoggingService();
      final instance2 = LoggingService();
      expect(instance1, equals(instance2));
    });

    test('LoggingService should have required methods', () {
      expect(loggingService.logInfo, isA<Function>());
      expect(loggingService.logDebug, isA<Function>());
      expect(loggingService.logWarning, isA<Function>());
      expect(loggingService.logError, isA<Function>());
      expect(loggingService.logUserAction, isA<Function>());
      expect(loggingService.logAuthEvent, isA<Function>());
      expect(loggingService.logScreenView, isA<Function>());
      expect(loggingService.logNetworkCall, isA<Function>());
    });

    test('Logging methods should execute without errors', () {
      expect(() => loggingService.logInfo('Test info message'), returnsNormally);
      expect(() => loggingService.logDebug('Test debug message'), returnsNormally);
      expect(() => loggingService.logWarning('Test warning message'), returnsNormally);
      expect(() => loggingService.logError('Test error message'), returnsNormally);
      expect(() => loggingService.logUserAction('test_action'), returnsNormally);
      expect(() => loggingService.logAuthEvent('test_auth_event'), returnsNormally);
      expect(() => loggingService.logScreenView('TestScreen'), returnsNormally);
      expect(() => loggingService.logNetworkCall('GET', 'https://api.example.com'), returnsNormally);
    });

    test('Logging methods should handle data parameters', () {
      expect(() => loggingService.logInfo('Test message', data: {'key': 'value'}), returnsNormally);
      expect(() => loggingService.logUserAction('test_action', context: {'screen': 'home'}), returnsNormally);
      expect(() => loggingService.logAuthEvent('sign_in', userId: 'user123', details: {'method': 'google'}), returnsNormally);
      expect(() => loggingService.logScreenView('HomeScreen', parameters: {'userId': 'user123'}), returnsNormally);
      expect(() => loggingService.logNetworkCall('POST', 'https://api.example.com', statusCode: 200, data: {'response': 'ok'}), returnsNormally);
    });
  });
}