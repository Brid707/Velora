import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  SessionService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const _tokenKey = 'token';
  static const _userIdKey = 'userId';
  static const _usernameKey = 'username';

  static Future<void> saveSession({
    required String token,
    required String userId,
    required String username,
  }) async {
    await _storage.write(key: _tokenKey, value: token);

    await _storage.write(key: _userIdKey, value: userId);

    await _storage.write(key: _usernameKey, value: username);
  }

  static Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  static Future<String?> getUserId() async {
    return _storage.read(key: _userIdKey);
  }

  static Future<String?> getUsername() async {
    return _storage.read(key: _usernameKey);
  }

  static Future<void> clearSession() async {
    await _storage.deleteAll();
  }
}
