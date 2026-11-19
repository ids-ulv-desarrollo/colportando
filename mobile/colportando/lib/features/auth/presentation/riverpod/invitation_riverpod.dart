import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/auth/domain/entities/invitation.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_di.dart';
import 'package:flutter/foundation.dart' show protected;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// Estado de una operación de invitación en la pantalla que la ejecuta.
class InvitationOperationState {
  final bool isLoading;
  // El último intento quedó sin respuesta definitiva; el siguiente reutilizará la misma clave.
  final bool isRetryPending;

  const InvitationOperationState({
    this.isLoading = false,
    this.isRetryPending = false,
  });
}

// Coordina una operación idempotente: conserva la clave solo tras un resultado incierto y mientras los datos no cambien.
abstract class IdempotentInvitationNotifier<T>
    extends Notifier<InvitationOperationState> {
  static const Uuid _uuid = Uuid();
  String? _idempotencyKey;

  @override
  InvitationOperationState build() => const InvitationOperationState();

  // Inicia una operación nueva: la siguiente solicitud usará otra clave.
  void startNewOperation() {
    _idempotencyKey = null;
    if (state.isRetryPending) {
      state = InvitationOperationState(isLoading: state.isLoading);
    }
  }

  // Envía una solicitud a la vez; devuelve null si ya había una en curso o si la pantalla se abandonó.
  @protected
  Future<Result<T>?> sendOnce(
    Future<Result<T>> Function(String idempotencyKey) send,
  ) async {
    if (state.isLoading) return null;
    final idempotencyKey = _idempotencyKey ??= _uuid.v4();
    state = InvitationOperationState(
      isLoading: true,
      isRetryPending: state.isRetryPending,
    );
    final result = await send(idempotencyKey);
    // Al abandonar la pantalla el proveedor se descarta con su clave y la respuesta se ignora.
    if (!ref.mounted) return null;

    final isRetryPending =
        result.isOutcomeUnknown && _idempotencyKey == idempotencyKey;
    if (!isRetryPending) _idempotencyKey = null;
    state = InvitationOperationState(isRetryPending: isRetryPending);
    return result;
  }
}

// Envía invitaciones desde la pantalla autenticada.
class CreateInvitationNotifier
    extends IdempotentInvitationNotifier<InvitationReceipt> {
  // Invita a un aspirante al club seleccionado.
  Future<Result<InvitationReceipt>?> submit({
    required String clubId,
    required String email,
  }) => sendOnce(
    (idempotencyKey) => ref.read(createInvitationUsecaseProvider)(
      clubId: clubId,
      email: email,
      idempotencyKey: idempotencyKey,
    ),
  );
}

// Acepta la invitación consultada en el registro público.
class AcceptInvitationNotifier
    extends IdempotentInvitationNotifier<InvitationAcceptance> {
  // Registra o vincula la cuenta con los datos del formulario.
  Future<Result<InvitationAcceptance>?> submit({
    required String email,
    required String code,
    required String password,
    required String givenNames,
    required String familyName,
    String? secondFamilyName,
    String? phoneE164,
  }) => sendOnce(
    (idempotencyKey) => ref.read(acceptInvitationUsecaseProvider)(
      email: email,
      code: code,
      password: password,
      givenNames: givenNames,
      familyName: familyName,
      secondFamilyName: secondFamilyName,
      phoneE164: phoneE164,
      idempotencyKey: idempotencyKey,
    ),
  );
}

// Consulta invitaciones públicas; no coordina clave porque la consulta no modifica datos.
class InspectInvitationNotifier extends Notifier<InvitationOperationState> {
  @override
  InvitationOperationState build() => const InvitationOperationState();

  // Envía una consulta a la vez; devuelve null si ya había una en curso o si la pantalla se abandonó.
  Future<Result<InvitationPreview>?> inspect({
    required String email,
    required String code,
  }) async {
    if (state.isLoading) return null;
    state = const InvitationOperationState(isLoading: true);
    final result = await ref.read(inspectInvitationUsecaseProvider)(
      email: email,
      code: code,
    );
    if (!ref.mounted) return null;
    state = const InvitationOperationState();
    return result;
  }
}

// Proveedores ligados a cada pantalla: al salir se descartan su estado y su clave.
final createInvitationProvider =
    NotifierProvider.autoDispose<
      CreateInvitationNotifier,
      InvitationOperationState
    >(CreateInvitationNotifier.new);

final inspectInvitationProvider =
    NotifierProvider.autoDispose<
      InspectInvitationNotifier,
      InvitationOperationState
    >(InspectInvitationNotifier.new);

final acceptInvitationProvider =
    NotifierProvider.autoDispose<
      AcceptInvitationNotifier,
      InvitationOperationState
    >(AcceptInvitationNotifier.new);
