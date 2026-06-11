import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();
  static const _kToken = 'auth_token';
  static const _kName = 'user_name';

  Future<void> save({required String token, required String name}) async {
    await _storage.write(key: _kToken, value: token);
    await _storage.write(key: _kName, value: name);
  }

  Future<String?> readToken() => _storage.read(key: _kToken);

  Future<String?> readName() => _storage.read(key: _kName);

  Future<void> clear() async {
    await _storage.delete(key: _kToken);
    await _storage.delete(key: _kName);
  }
}
