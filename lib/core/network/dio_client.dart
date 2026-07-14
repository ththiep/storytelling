import 'package:dio/dio.dart';

import '../config/api_config.dart';
import 'api_exception.dart';

Dio createDioClient([ApiConfig config = ApiConfig.instance]) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  if (config.enableLogging) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) {
        handler.reject(_mapDioError(error));
      },
    ),
  );

  return dio;
}

DioException _mapDioError(DioException error) {
  final response = error.response;
  final statusCode = response?.statusCode;
  final data = response?.data;

  String message;
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      message = 'Request timed out';
    case DioExceptionType.connectionError:
      message = 'No internet connection';
    case DioExceptionType.badResponse:
      message = _messageFromResponse(data) ?? 'Server error ($statusCode)';
    case DioExceptionType.cancel:
      message = 'Request cancelled';
    default:
      message = error.message ?? 'Unexpected network error';
  }

  return DioException(
    requestOptions: error.requestOptions,
    response: error.response,
    type: error.type,
    error: ApiException(
      message: message,
      statusCode: statusCode,
      data: data,
    ),
    message: message,
  );
}

String? _messageFromResponse(Object? data) {
  if (data is Map<String, dynamic>) {
    final message = data['message'] ?? data['error'];
    if (message is String) return message;
  }
  return null;
}

ApiException parseApiException(Object error) {
  if (error is DioException && error.error is ApiException) {
    return error.error! as ApiException;
  }
  if (error is ApiException) return error;
  return ApiException(message: error.toString());
}
