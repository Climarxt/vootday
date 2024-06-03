import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ContextualLogger {
  final Logger _logger;
  final String widgetName;

  ContextualLogger(this.widgetName)
      : _logger = Logger(
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 8,
            lineLength: 120,
            colors: true,
            printEmojis: true,
            printTime: false,
          ),
          output: SingleLineOutput(),
        );

  void logInfo(String functionName, String message,
      [Map<String, dynamic>? details]) {
    var detailMessage = details != null
        ? details.entries.map((e) => '${e.key}: ${e.value}').join(' ')
        : '';
    _logger.i('[$widgetName][$functionName] : $message $detailMessage');
  }

  void logError(String functionName, String message,
      [Map<String, dynamic>? details]) {
    var detailMessage = details != null
        ? details.entries.map((e) => '${e.key}: ${e.value}').join(', ')
        : '';
    _logger.e('[$widgetName][$functionName] : $message $detailMessage');
  }
}

class SingleLineOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd - HH:mm:ss.SS');
    final String timestamp = formatter.format(DateTime.now());

    for (var line in event.lines) {
      debugPrint('$timestamp $line');
    }
  }
}
