import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Administra el almacenamiento cifrado de tokens mediante Android Keystore / iOS Keychain.
class SecureStorage {
  static const String _accessTokenKey = 'colportando.auth.access_token';
  static const String _refreshTokenKey = 'colportando.auth.refresh_token';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Guarda el access token de forma cifrada.
  static Future<bool> saveToken(String token) => _write(_accessTokenKey, token);

  // Obtiene el access token almacenado.
  static Future<String?> getToken() => _read(_accessTokenKey);

  // Guarda el refresh token de forma cifrada.
  static Future<bool> saveRefreshToken(String token) =>
      _write(_refreshTokenKey, token);

  // Obtiene el refresh token almacenado.
  static Future<String?> getRefreshToken() => _read(_refreshTokenKey);

  // Elimina todos los tokens de sesión.
  static Future<void> clearSession() async {
    try {
      await _storage.deleteAll();
    } catch (error) {
      debugPrint('Error al limpiar la sesión: $error');
    }
  }

  // Escribe un valor cifrado; nunca lanza excepciones hacia el llamador.
  static Future<bool> _write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      return true;
    } catch (error) {
      debugPrint('Error al escribir "$key": $error');
      return false;
    }
  }

  // Lee un valor cifrado; devuelve null ante cualquier fallo.
  static Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (error) {
      debugPrint('Error al leer "$key": $error');
      return null;
    }
  }
}
