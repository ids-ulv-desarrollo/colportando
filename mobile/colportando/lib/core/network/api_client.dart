import 'dart:convert';
import 'package:colportando/core/error/exception_error.dart';
import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/network/api_constants.dart';
import 'package:colportando/core/network/manage_http_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ApiClient {
  // Mantiene una conexión HTTP persistente para optimizar el rendimiento de red.
  final http.Client _client;
  final Uuid _uuid = const Uuid();

  // Permite inyectar un cliente HTTP en pruebas; la app usa el cliente por defecto.
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  // Usa la clave de idempotencia recibida o, como hasta ahora, genera una nueva por petición.
  Map<String, String> _headers(
    String method, [
    String? token,
    String? idempotencyKey,
  ]) => {
    "Content-Type": "application/json; charset=utf-8",
    if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    if (method == "POST" || method == "PUT")
      "idempotency-key": idempotencyKey ?? _uuid.v4(),
  };

  // Ejecuta la petición HTTP y procesa la respuesta mediante manageHttpResponse.
  Future<Result<T>> _request<T>(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    T Function(dynamic json)? fromJson,
    String? idempotencyKey,
  }) async {
    try {
      final uri = Uri.parse('$uriProduction$endpoint');
      final headers = _headers(method, token, idempotencyKey);
      final encodedBody = body != null ? jsonEncode(body) : null;

      final response = switch (method) {
        "GET" => await _client.get(uri, headers: headers),
        "POST" => await _client.post(uri, headers: headers, body: encodedBody),
        "PUT" => await _client.put(uri, headers: headers, body: encodedBody),
        "DELETE" => await _client.delete(
          uri,
          headers: headers,
          body: encodedBody,
        ),
        _ => throw UnsupportedError("Método no soportado: $method"),
      };

      return manageHttpResponse<T>(response: response, fromJson: fromJson);
    } catch (e) {
      return exceptionError<T>(e);
    }
  }

  Future<Result<T>> get<T>(
    String endpoint, {
    String? token,
    T Function(dynamic json)? fromJson,
  }) => _request("GET", endpoint, token: token, fromJson: fromJson);

  Future<Result<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    T Function(dynamic json)? fromJson,
    String? idempotencyKey,
  }) => _request(
    "POST",
    endpoint,
    body: body,
    token: token,
    fromJson: fromJson,
    idempotencyKey: idempotencyKey,
  );

  Future<Result<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    T Function(dynamic json)? fromJson,
  }) => _request("PUT", endpoint, body: body, token: token, fromJson: fromJson);

  Future<Result<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    T Function(dynamic json)? fromJson,
  }) => _request(
    "DELETE",
    endpoint,
    body: body,
    token: token,
    fromJson: fromJson,
  );

  // Cierra el cliente HTTP liberando conexiones activas.
  void close() => _client.close();
}

// Proveedor global del cliente HTTP reutilizable por toda la aplicación.
final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  ref.onDispose(() => client.close());
  return client;
});
