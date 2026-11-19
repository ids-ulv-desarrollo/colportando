import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/network/manage_http_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('un éxito sin fromJson devuelve el cuerpo como antes', () {
    final result = manageHttpResponse<Map<String, dynamic>>(
      response: http.Response('{"message":"ok"}', 202),
    );
    expect(result.data, {'message': 'ok'});
    expect(result.statusCode, isNull);
  });

  // manageHttpResponse no adjunta el código HTTP a las fallas; solo devuelve el mensaje.
  test('un error conserva el mensaje del servidor sin código HTTP', () {
    final result = manageHttpResponse<void>(
      response: http.Response('{"error":{"message":"Invalid request."}}', 400),
    );
    expect(result.error, 'Invalid request.');
    expect(result.statusCode, isNull);
  });

  test('un 401 sin mensaje conserva el texto anterior sin código HTTP', () {
    final result = manageHttpResponse<void>(response: http.Response('', 401));
    expect(result.error, 'Sesión expirada o no autorizada.');
    expect(result.statusCode, isNull);
  });

  test('un 5xx sin mensaje conserva el texto anterior y queda como incierto', () {
    final result = manageHttpResponse<void>(response: http.Response('', 503));
    expect(result.error, 'Error en la petición: 503');
    expect(result.isOutcomeUnknown, isTrue);
  });

  test('Result.map conserva el código de la falla', () {
    const failure = Result<int>.failure('Sin permiso', statusCode: 403);
    final mapped = failure.map((value) => value.toString());
    expect(mapped.error, 'Sin permiso');
    expect(mapped.statusCode, 403);
  });

  test('una falla creada sin código funciona como antes', () {
    const failure = Result<int>.failure('Sin sesión activa.');
    expect(failure.isFailure, isTrue);
    expect(failure.statusCode, isNull);
  });
}
