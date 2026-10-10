import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Guarda las credenciales del acceso con huella/cara en el almacén cifrado
// del sistema (Keystore en Android, Keychain en iOS).
class SecureCredentialsService {
  static const String _credentialsKey = "biometricCredentials";
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveCredentials({
    required String userName,
    required String userPassword,
    required String userRole,
  }) async {
    await _storage.write(
      key: _credentialsKey,
      value: jsonEncode({
        'userName': userName,
        'userPassword': userPassword,
        'userRole': userRole,
      }),
    );
  }

  // Devuelve null si no hay credenciales guardadas o si no se pueden leer.
  static Future<Map<String, dynamic>?> getCredentials() async {
    try {
      final String? data = await _storage.read(key: _credentialsKey);
      return data != null ? jsonDecode(data) : null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearCredentials() async {
    await _storage.delete(key: _credentialsKey);
  }
}
