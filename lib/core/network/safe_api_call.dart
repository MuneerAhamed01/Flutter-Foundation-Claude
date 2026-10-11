import 'package:dio/dio.dart';
import 'package:flutter_foundation/core/network/failure.dart';
import 'package:flutter_foundation/core/network/result.dart';
import 'package:flutter_foundation/core/utils/app_logger.dart';

/// Wraps a Retrofit call so repositories never throw.
Future<Result<T>> safeApiCall<T>(Future<T> Function() call) async {
  try {
    return Ok(await call());
  } on DioException catch (e) {
    return Err(mapDioException(e));
  } on Object catch (e, s) {
    AppLogger.error('safeApiCall', e, s);
    return const Err(UnknownFailure());
  }
}

Failure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.cancel:
      return const CancelledFailure();
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      if (status == 401) return const UnauthorizedFailure();
      return ServerFailure(
        _extractMessage(e.response?.data) ?? 'Server error ($status).',
        statusCode: status,
      );
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return UnknownFailure(e.message ?? 'Something went wrong.');
  }
}

// TODO(setup): adjust to your backend's error body shape.
String? _extractMessage(Object? data) {
  if (data is Map<String, dynamic>) {
    final message = data['message'] ?? data['error'];
    if (message is String) return message;
  }
  return null;
}
