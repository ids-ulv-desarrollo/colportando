import 'package:colportando/core/network/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late List<http.Request> requests;
  late ApiClient apiClient;

  setUp(() {
    requests = [];
    apiClient = ApiClient(
      client: MockClient((request) async {
        requests.add(request);
        return http.Response('', 204);
      }),
    );
  });

  test('POST sin clave genera una distinta en cada petición, como antes', () async {
    await apiClient.post<void>('/prueba', body: {'valor': 1});
    await apiClient.post<void>('/prueba', body: {'valor': 1});
    final keys = requests
        .map((request) => request.headers['idempotency-key'])
        .toList();
    expect(keys, everyElement(isNotNull));
    expect(keys.first, isNot(keys.last));
  });

  test('POST con clave envía exactamente esa clave', () async {
    await apiClient.post<void>('/prueba', idempotencyKey: 'clave-prueba-0003');
    expect(requests.single.headers['idempotency-key'], 'clave-prueba-0003');
  });

  test('GET no envía clave de idempotencia', () async {
    await apiClient.get<void>('/prueba');
    expect(requests.single.headers.containsKey('idempotency-key'), isFalse);
  });
}
