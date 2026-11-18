import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Administra el almacenamiento cifrado del refresh token mediante Android Keystore / iOS Keychain.
class SecureStorage {
  static const String _refreshTokenKey = 'colportando.auth.refresh_token';

  // Mantiene el access token únicamente en memoria RAM durante la sesión.
  static String? accessToken;

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Lee el refresh token almacenado, o null si no existe.
  static Future<String?> readRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (error) {
      debugPrint('Error al leer refresh token: $error');
      return null;
    }
  }

  // Guarda el refresh token de forma cifrada.
  static Future<void> writeRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
    } catch (error) {
      debugPrint('Error al guardar refresh token: $error');
    }
  }

  // Elimina el refresh token almacenado y limpia el access token en RAM.
  static Future<void> clearRefreshToken() async {
    accessToken = null;
    try {
      await _storage.delete(key: _refreshTokenKey);
    } catch (error) {
      debugPrint('Error al eliminar refresh token: $error');
    }
  }
}
