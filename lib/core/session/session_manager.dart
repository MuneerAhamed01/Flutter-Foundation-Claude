import 'dart:async';

import 'package:flutter_foundation/core/storage/secure_storage_service.dart';

/// Owns the auth tokens and broadcasts when the session expires,
/// so the UI layer can redirect to login without the network layer knowing about routes.
class SessionManager {
  SessionManager(this._storage);

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  final SecureStorageService _storage;
  final _expiredController = StreamController<void>.broadcast();

  Stream<void> get onSessionExpired => _expiredController.stream;

  Future<String?> get accessToken => _storage.read(_accessTokenKey);
  Future<String?> get refreshToken => _storage.read(_refreshTokenKey);

  Future<bool> get isLoggedIn async => (await accessToken) != null;

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(_accessTokenKey, accessToken);
    if (refreshToken != null) {
      await _storage.write(_refreshTokenKey, refreshToken);
    }
  }

  Future<void> clear() async {
    await _storage.delete(_accessTokenKey);
    await _storage.delete(_refreshTokenKey);
  }

  /// Called by the auth interceptor when a 401 cannot be recovered.
  Future<void> expire() async {
    await clear();
    _expiredController.add(null);
  }
}
