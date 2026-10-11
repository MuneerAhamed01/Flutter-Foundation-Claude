import 'package:dio/dio.dart';
import 'package:flutter_foundation/core/config/app_config.dart';
import 'package:flutter_foundation/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_foundation/core/session/session_manager.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Builds the single [Dio] instance shared by every Retrofit API.
abstract final class DioClient {
  static Dio create({
    required AppConfig config,
    required SessionManager session,
    TokenRefresher? refresher,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        headers: const {'Accept': 'application/json'},
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(session: session, dio: dio, refresher: refresher),
    );
    if (config.enableNetworkLogs) {
      dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true),
      );
    }
    return dio;
  }
}
