import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'x17%618hAH718Token17@!!0shhxdsd^^^28';

  // Simpan token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // Ambil token
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Hapus token
  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }
}
