import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthService {
  Future<String?> getLoggedEmail();
  Future<void> setLoggedEmail(String email);
  Future<void> logout();
}

/// Implementación de auth con FlutterSecureStorage
class StorageAuthService implements AuthService {
  final _storage = const FlutterSecureStorage();
  static const _emailKey = 'user_email';

  @override
  Future<String?> getLoggedEmail() async {
    return await _storage.read(key: _emailKey);
  }

  @override
  Future<void> setLoggedEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: _emailKey);
  }
}
