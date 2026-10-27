import 'dart:convert';
import 'package:colportando/core/error/result.dart';
import 'package:http/http.dart' as http;

Result<T> manageHttpResponse<T>({
  required http.Response response,
  T Function(dynamic json)? fromJson,
}) {
  dynamic body;
  try {
    if (response.body.isNotEmpty) body = jsonDecode(response.body);
  } catch (_) {
    body = response.body;
  }

  // Éxito: 200 - 299
  if (response.statusCode >= 200 && response.statusCode < 300) {
    if (fromJson != null) {
      try {
        final payload = (body is Map && body.containsKey('data'))
            ? body['data']
            : body;
        return Result.success(fromJson(payload));
      } catch (e) {
        return Result.failure('Error al procesar datos: $e');
      }
    }
    return Result.success(body as T);
  }

  // Extracción unificada del mensaje de error
  final message = (body is Map)
      ? (body['message'] ?? body['error'] ?? body['errors']?[0]?['message'])
      : null;

  if (response.statusCode == 401) {
    return Result.failure(
      message?.toString() ?? 'Sesión expirada o no autorizada.',
    );
  }

  return Result.failure(
    message?.toString() ?? 'Error en la petición: ${response.statusCode}',
  );
}
