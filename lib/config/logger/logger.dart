import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

mixin LoggingMixin<T extends StatefulWidget> on State<T> {
  late final ContextualLogger logger;

  @override
  void initState() {
    super.initState();
    logger = ContextualLogger(T.toString());
  }

  void logInfo(String functionName, String message,
      [Map<String, dynamic>? details]) {
    logger.logInfo(functionName, message, details);
  }

  void logError(String functionName, String message,
      [Map<String, dynamic>? details]) {
    logger.logError(functionName, message, details);
  }
}

class ContextualLogger {
  final Logger _logger;
  final String widgetName;

  ContextualLogger(this.widgetName)
      : _logger = Logger(
          printer: PlainPrinter(),
          output: SingleLineOutput(),
        );

  void logInfo(String functionName, String message,
      [Map<String, dynamic>? details]) {
    var detailMessage = details != null
        ? details.entries.map((e) => '${e.key}: ${e.value}').join(', ')
        : '';
    _logger.i('[$widgetName] [$functionName] : $message | $detailMessage');
  }

  void logError(String functionName, String message,
      [Map<String, dynamic>? details]) {
    var detailMessage = details != null
        ? details.entries.map((e) => '${e.key}: ${e.value}').join(', ')
        : '';
    _logger.e('[$widgetName] [$functionName] : $message | $detailMessage');
  }
}

class PlainPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    var messageStr = event.message;
    var errorStr = event.error != null ? "  ERROR: ${event.error}" : "";
    String level = event.level.toString().toUpperCase().split('.').last;
    return ['[$level] $messageStr$errorStr'];
  }
}

class SingleLineOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final DateFormat formatter = DateFormat('HH:mm:ss.SS');
    final String timestamp = formatter.format(DateTime.now());

    for (var line in event.lines) {
      debugPrint('$timestamp $line');
    }
  }
}
