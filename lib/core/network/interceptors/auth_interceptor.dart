import 'package:dio/dio.dart';
import 'package:flutter_foundation/core/session/session_manager.dart';

/// Refreshes tokens. Implement this against your auth endpoint and pass it to
/// [AuthInterceptor]; without one, a 401 simply expires the session.
abstract interface class TokenRefresher {
  /// Returns the new access token, or null if refresh failed.
  Future<String?> refresh(String refreshToken);
}

/// Adds `Authorization: Bearer <token>` and handles 401 responses.
///
/// Mark a request public (no auth header) with `@Extra({AuthInterceptor.skipAuth: true})`
/// in the Retrofit interface.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this._session,
    required this._dio,
    this._refresher,
  });

  static const skipAuth = 'skipAuth';
  static const _retried = '_authRetried';

  final SessionManager _session;
  final Dio _dio;
  final TokenRefresher? _refresher;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuth] != true) {
      final token = await _session.accessToken;
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    if (!isUnauthorized ||
        options.extra[skipAuth] == true ||
        options.extra[_retried] == true) {
      return handler.next(err);
    }

    final newToken = await _tryRefresh();
    if (newToken == null) {
      await _session.expire();
      return handler.next(err);
    }

    try {
      options
        ..headers['Authorization'] = 'Bearer $newToken'
        ..extra[_retried] = true;
      handler.resolve(await _dio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<String?> _tryRefresh() async {
    final refresher = _refresher;
    final refreshToken = await _session.refreshToken;
    if (refresher == null || refreshToken == null) return null;

    final newToken = await refresher.refresh(refreshToken);
    if (newToken != null) await _session.saveTokens(accessToken: newToken);
    return newToken;
  }
}
