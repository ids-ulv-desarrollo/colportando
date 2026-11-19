import 'dart:convert';

import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/core/storage/secure_storage.dart';
import 'package:colportando/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:colportando/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final requests = <http.Request>[];

  // Crea el repositorio real sobre un cliente HTTP simulado con la respuesta indicada.
  AuthRepositoryImpl createRepository(int statusCode, Object body) {
    requests.clear();
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response(
        jsonEncode(body),
        statusCode,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
    return AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSource(
        apiClient: ApiClient(client: client),
      ),
    );
  }

  // Cuerpo de error con la forma documentada en ErrorResponse.
  Map<String, Object> errorBody(String message) => {
    'error': {
      'code': 'TEST_ERROR',
      'message': message,
      'correlationId': '00000000-0000-4000-8000-000000000000',
    },
  };

  setUp(() => SecureStorage.accessToken = 'token-de-prueba');
  tearDown(() => SecureStorage.accessToken = null);

  group('POST /auth/invitations', () {
    test('envía la clave recibida y reconoce la repetición documentada (200, replayed)', () async {
      final repository = createRepository(200, {
        'invitationId': 'inv-1',
        'status': 'PENDING',
        'expiresAt': '2026-11-26T18:00:00.000Z',
        'replayed': true,
      });
      final result = await repository.createInvitation(
        clubId: 'club-1',
        email: 'aspirante@ejemplo.com',
        idempotencyKey: 'clave-prueba-0001',
      );

      expect(requests.single.headers['idempotency-key'], 'clave-prueba-0001');
      expect(requests.single.headers['authorization'], 'Bearer token-de-prueba');
      expect(jsonDecode(requests.single.body), {
        'clubId': 'club-1',
        'email': 'aspirante@ejemplo.com',
      });
      expect(result.data?.isReplayed, isTrue);
      expect(result.data?.expiresAt, DateTime.utc(2026, 11, 26, 18));
    });

    // manageHttpResponse no adjunta el código HTTP, así que el repositorio conserva el mensaje del servidor.
    test('un 403 conserva el mensaje del servidor', () async {
      final repository = createRepository(
        403,
        errorBody('Missing invitation permission.'),
      );
      final result = await repository.createInvitation(
        clubId: 'club-1',
        email: 'aspirante@ejemplo.com',
      );
      expect(result.isFailure, isTrue);
      expect(result.error, 'Missing invitation permission.');
      expect(result.statusCode, isNull);
    });

    test('un 5xx conserva el mensaje del servidor y queda como incierto', () async {
      final repository = createRepository(500, errorBody('Unexpected error.'));
      final result = await repository.createInvitation(
        clubId: 'club-1',
        email: 'aspirante@ejemplo.com',
      );
      expect(result.error, 'Unexpected error.');
      expect(result.isOutcomeUnknown, isTrue);
    });

    test('un éxito con cuerpo ilegible queda como incierto', () async {
      final repository = createRepository(202, {'status': 'PENDING'});
      final result = await repository.createInvitation(
        clubId: 'club-1',
        email: 'aspirante@ejemplo.com',
      );
      expect(result.isFailure, isTrue);
      expect(result.isOutcomeUnknown, isTrue);
    });
  });

  group('POST /auth/invitations/inspect', () {
    test('convierte la respuesta en InvitationPreview', () async {
      final repository = createRepository(200, {
        'invitationId': 'inv-1',
        'clubName': 'Club Centro',
        'institutionName': 'Institución Norte',
        'emailHint': 'a***@ejemplo.com',
        'expiresAt': '2026-11-26T18:00:00.000Z',
      });
      final result = await repository.inspectInvitation(
        email: 'aspirante@ejemplo.com',
        code: 'ABCD-1234-EFGH',
      );
      expect(result.data?.clubName, 'Club Centro');
      expect(result.data?.institutionName, 'Institución Norte');
      expect(result.data?.emailHint, 'a***@ejemplo.com');
    });

    test('un 404 conserva el mensaje del servidor', () async {
      final repository = createRepository(404, errorBody('Invitation unavailable.'));
      final result = await repository.inspectInvitation(
        email: 'aspirante@ejemplo.com',
        code: 'ABCD-1234-EFGH',
      );
      expect(result.isFailure, isTrue);
      expect(result.error, 'Invitation unavailable.');
      expect(result.statusCode, isNull);
    });
  });

  group('POST /auth/invitations/accept', () {
    test('omite los opcionales vacíos y lee la membresía creada (201)', () async {
      final repository = createRepository(201, {
        'accountId': 'acc-1',
        'personId': 'per-1',
        'membershipId': 'mem-1',
        'membershipStatus': 'PENDING',
        'memberCondition': 'ASPIRANT',
        'emailVerified': true,
        'replayed': false,
      });
      final result = await repository.acceptInvitation(
        email: 'aspirante@ejemplo.com',
        code: 'ABCD-1234-EFGH',
        password: 'Clave-de-prueba-1',
        givenNames: 'Ana',
        familyName: 'Pérez',
        idempotencyKey: 'clave-prueba-0002',
      );

      final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
      expect(body.containsKey('secondFamilyName'), isFalse);
      expect(body.containsKey('phoneE164'), isFalse);
      expect(requests.single.headers['idempotency-key'], 'clave-prueba-0002');
      expect(result.data?.isEmailVerified, isTrue);
      expect(result.data?.memberCondition, 'ASPIRANT');
    });

    test('un 409 conserva el mensaje del servidor', () async {
      final repository = createRepository(
        409,
        errorBody('Invitation or idempotency conflict.'),
      );
      final result = await repository.acceptInvitation(
        email: 'aspirante@ejemplo.com',
        code: 'ABCD-1234-EFGH',
        password: 'Clave-de-prueba-1',
        givenNames: 'Ana',
        familyName: 'Pérez',
      );
      expect(result.isFailure, isTrue);
      expect(result.error, 'Invitation or idempotency conflict.');
      expect(result.statusCode, isNull);
    });
  });
}
