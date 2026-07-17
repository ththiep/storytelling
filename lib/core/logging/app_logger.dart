import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static void debug(
    String scope,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _write(scope, message, level: 500, error: error, stackTrace: stackTrace);
  }

  static void info(
    String scope,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _write(scope, message, level: 800, error: error, stackTrace: stackTrace);
  }

  static void warning(
    String scope,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _write(scope, message, level: 900, error: error, stackTrace: stackTrace);
  }

  static void error(
    String scope,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _write(scope, message, level: 1000, error: error, stackTrace: stackTrace);
  }

  static void _write(
    String scope,
    String message, {
    required int level,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    developer.log(
      message,
      name: 'storytelling.$scope',
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
