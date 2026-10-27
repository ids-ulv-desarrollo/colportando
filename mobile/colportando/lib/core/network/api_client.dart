import 'dart:convert';
import 'package:colportando/core/error/exception_error.dart';
import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/network/api_constants.dart';
import 'package:colportando/core/network/manage_http_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  // Se usa http.Client para abrir peticiones http y mantenerla activa, lo cual puede mejorar el rendimiento, ya que http puro abre una nueva conexión cada vez que se hace una peticion.
  final http.Client _client = http.Client();

  Map<String, String> _headers([String? token]) => {
    "Content-Type": "application/json; charset=utf-8",
    if (token != null && token.isNotEmpty) "Authorization": token,
  };

  // Ejecuta la petición HTTP, donde envía el body y token al servidor, y transforma la respuesta recibida con fromJson.
  Future<Result<T>> _request<T>(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$uriLocal$endpoint');
      final headers = _headers(token);
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
  }) =>
      _request("POST", endpoint, body: body, token: token, fromJson: fromJson);

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
