import 'package:logger/logger.dart';

enum LogLevel { debug, info, warning, error }

class LoggingService {
  static final LoggingService _instance = LoggingService._internal();
  factory LoggingService() => _instance;
  LoggingService._internal();

  Logger? _logger;

  void initialize({bool isDebug = false}) {
    if (_logger != null) return; // Already initialized
    
    _logger = Logger(
      level: isDebug ? Level.debug : Level.info,
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  void logInfo(String message, {Map<String, dynamic>? data}) {
    if (data != null) {
      _logger?.i('$message | Data: $data');
    } else {
      _logger?.i(message);
    }
  }

  void logDebug(String message, {Map<String, dynamic>? data}) {
    if (data != null) {
      _logger?.d('$message | Data: $data');
    } else {
      _logger?.d(message);
    }
  }

  void logWarning(String message, {Map<String, dynamic>? data}) {
    if (data != null) {
      _logger?.w('$message | Data: $data');
    } else {
      _logger?.w(message);
    }
  }

  void logError(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    var logMessage = message;
    if (data != null) {
      logMessage += ' | Data: $data';
    }
    _logger?.e(logMessage, error: error, stackTrace: stackTrace);
  }

  void logUserAction(String action, {Map<String, dynamic>? context}) {
    logInfo('User Action: $action', data: context);
  }

  void logAuthEvent(String event, {String? userId, Map<String, dynamic>? details}) {
    final data = <String, dynamic>{
      'event': event,
      if (userId != null) 'userId': userId,
      if (details != null) ...details,
    };
    logInfo('Auth Event: $event', data: data);
  }

  void logScreenView(String screenName, {Map<String, dynamic>? parameters}) {
    final data = <String, dynamic>{
      'screen': screenName,
      if (parameters != null) ...parameters,
    };
    logInfo('Screen View: $screenName', data: data);
  }

  void logNetworkCall(String method, String url, {int? statusCode, Map<String, dynamic>? data}) {
    final logData = <String, dynamic>{
      'method': method,
      'url': url,
      if (statusCode != null) 'statusCode': statusCode,
      if (data != null) ...data,
    };
    logInfo('Network Call: $method $url', data: logData);
  }
}