import 'dart:async';

import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/auth/domain/entities/invitation.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:colportando/features/auth/presentation/riverpod/invitation_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_auth_repository.dart';

void main() {
  late FakeAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeAuthRepository();
    container = ProviderContainer.test(
      overrides: invitationTestOverrides(repository),
    );
  });

  // Mantiene vivo el proveedor autoDispose como lo hace la pantalla que lo observa.
  CreateInvitationNotifier watchCreate() {
    container.listen(createInvitationProvider, (_, _) {});
    return container.read(createInvitationProvider.notifier);
  }

  group('Idempotencia al crear invitaciones', () {
    test('reutiliza la clave mientras el resultado sea incierto', () async {
      repository.createResponses.addAll([
        () async => const Result.failure('Error de conexión al servidor.'),
        () async => const Result.failure('Unexpected error.', statusCode: 503),
        () async => Result.success(sampleReceipt),
      ]);
      final notifier = watchCreate();

      await notifier.submit(clubId: 'club-1', email: 'aspirante@ejemplo.com');
      expect(container.read(createInvitationProvider).isRetryPending, isTrue);
      await notifier.submit(clubId: 'club-1', email: 'aspirante@ejemplo.com');
      await notifier.submit(clubId: 'club-1', email: 'aspirante@ejemplo.com');

      expect(repository.createKeys, hasLength(3));
      expect(repository.createKeys.first, isNotNull);
      expect(repository.createKeys.toSet(), hasLength(1));
      expect(container.read(createInvitationProvider).isRetryPending, isFalse);
    });

    test('usa otra clave después de una respuesta definitiva', () async {
      repository.createResponses.addAll([
        () async => const Result.failure('Sin permiso', statusCode: 403),
        () async => Result.success(sampleReceipt),
      ]);
      final notifier = watchCreate();

      await notifier.submit(clubId: 'club-1', email: 'aspirante@ejemplo.com');
      await notifier.submit(clubId: 'club-1', email: 'aspirante@ejemplo.com');

      expect(repository.createKeys.last, isNot(repository.createKeys.first));
    });

    test('usa otra clave después de un éxito', () async {
      repository.createResponses.addAll([
        () async => Result.success(sampleReceipt),
        () async => Result.success(sampleReceipt),
      ]);
      final notifier = watchCreate();

      await notifier.submit(clubId: 'club-1', email: 'aspirante@ejemplo.com');
      await notifier.submit(clubId: 'club-1', email: 'aspirante@ejemplo.com');

      expect(repository.createKeys.last, isNot(repository.createKeys.first));
    });

    test('usa otra clave cuando cambian los datos del formulario', () async {
      repository.createResponses.addAll([
        () async => const Result.failure('Error de conexión al servidor.'),
        () async => Result.success(sampleReceipt),
      ]);
      final notifier = watchCreate();

      await notifier.submit(clubId: 'club-1', email: 'aspirante@ejemplo.com');
      notifier.startNewOperation();
      expect(container.read(createInvitationProvider).isRetryPending, isFalse);
      await notifier.submit(clubId: 'club-1', email: 'otra@ejemplo.com');

      expect(repository.createKeys.last, isNot(repository.createKeys.first));
    });

    test('bloquea una segunda solicitud mientras la primera está pendiente', () async {
      final pending = Completer<Result<InvitationReceipt>>();
      repository.createResponses.add(() => pending.future);
      final notifier = watchCreate();

      final firstRequest = notifier.submit(
        clubId: 'club-1',
        email: 'aspirante@ejemplo.com',
      );
      final secondResult = await notifier.submit(
        clubId: 'club-1',
        email: 'aspirante@ejemplo.com',
      );
      expect(secondResult, isNull);
      expect(repository.createKeys, hasLength(1));

      pending.complete(Result.success(sampleReceipt));
      expect((await firstRequest)?.data, sampleReceipt);
    });

    test('descarta la respuesta que llega después de abandonar la pantalla', () async {
      final pending = Completer<Result<InvitationReceipt>>();
      repository.createResponses.add(() => pending.future);
      final subscription = container.listen(
        createInvitationProvider,
        (_, _) {},
      );
      final request = container
          .read(createInvitationProvider.notifier)
          .submit(clubId: 'club-1', email: 'aspirante@ejemplo.com');

      subscription.close();
      await container.pump();
      pending.complete(Result.success(sampleReceipt));

      expect(await request, isNull);
    });
  });

  test('aceptar reutiliza la clave tras un resultado incierto', () async {
    repository.acceptResponses.addAll([
      () async => const Result.failure('Bad gateway', statusCode: 502),
      () async => const Result.success(sampleAcceptance),
    ]);
    container.listen(acceptInvitationProvider, (_, _) {});
    final notifier = container.read(acceptInvitationProvider.notifier);

    for (var attempt = 0; attempt < 2; attempt++) {
      await notifier.submit(
        email: 'aspirante@ejemplo.com',
        code: 'ABCD-1234-EFGH',
        password: 'Clave-de-prueba-1',
        givenNames: 'Ana',
        familyName: 'Pérez',
      );
    }

    expect(repository.acceptKeys, hasLength(2));
    expect(repository.acceptKeys.last, repository.acceptKeys.first);
  });

  group('Adaptadores de la demo', () {
    test('inspectInvitation conserva las claves que lee la demo', () async {
      repository.inspectResponses.add(() async => Result.success(samplePreview));

      final info = await container
          .read(authProvider.notifier)
          .inspectInvitation(
            email: 'aspirante@ejemplo.com',
            code: 'ABCD-1234-EFGH',
          );

      expect(info?['clubName'], samplePreview.clubName);
      expect(info?['institutionName'], samplePreview.institutionName);
      expect(info?['invitationId'], samplePreview.invitationId);
    });

    test('createInvitation y acceptInvitation devuelven las claves del contrato', () async {
      repository.createResponses.add(() async => Result.success(sampleReceipt));
      repository.acceptResponses.add(
        () async => const Result.success(sampleAcceptance),
      );
      final notifier = container.read(authProvider.notifier);

      final receipt = await notifier.createInvitation(
        clubId: 'club-1',
        email: 'aspirante@ejemplo.com',
      );
      final acceptance = await notifier.acceptInvitation(
        email: 'aspirante@ejemplo.com',
        code: 'ABCD-1234-EFGH',
        password: 'Clave-de-prueba-1',
        givenNames: 'Ana',
        familyName: 'Pérez',
      );

      expect(
        receipt?.keys,
        containsAll(['invitationId', 'status', 'expiresAt', 'replayed']),
      );
      expect(
        acceptance?.keys,
        containsAll([
          'accountId',
          'personId',
          'membershipId',
          'membershipStatus',
          'memberCondition',
          'emailVerified',
          'replayed',
        ]),
      );
      // La demo no fija clave: ApiClient sigue generando una por petición.
      expect(repository.createKeys.single, isNull);
      expect(repository.acceptKeys.single, isNull);
    });

    test('un error se publica en AuthState y devuelve null, como antes', () async {
      repository.createResponses.add(
        () async => const Result.failure('Sin permiso', statusCode: 403),
      );

      final info = await container
          .read(authProvider.notifier)
          .createInvitation(clubId: 'club-1', email: 'aspirante@ejemplo.com');

      expect(info, isNull);
      expect(container.read(authProvider).errorMessage, 'Sin permiso');
      expect(container.read(authProvider).isLoading, isFalse);
    });
  });
}
