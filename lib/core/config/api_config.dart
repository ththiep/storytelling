import 'package:flutter/foundation.dart';

class ApiConfig {
  const ApiConfig({
    this.baseUrl = 'https://api.example.com/v1',
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.enableLogging = kDebugMode,
  });

  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableLogging;

  static const ApiConfig instance = ApiConfig();
}
