import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/auth/domain/entities/invitation.dart';
import 'package:colportando/features/auth/domain/repositories/auth_repository.dart';
import 'package:colportando/features/auth/domain/usecases/auth_usecase.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_di.dart';
import 'package:flutter_riverpod/misc.dart';

// Datos de ejemplo con la forma documentada en el contrato.
final sampleReceipt = InvitationReceipt(
  invitationId: 'inv-1',
  status: 'PENDING',
  expiresAt: DateTime.utc(2026, 11, 26, 18),
  isReplayed: false,
);

final samplePreview = InvitationPreview(
  invitationId: 'inv-1',
  clubName: 'Club Centro',
  institutionName: 'Institución Norte',
  emailHint: 'a***@ejemplo.com',
  expiresAt: DateTime.utc(2026, 11, 26, 18),
);

const sampleAcceptance = InvitationAcceptance(
  accountId: 'acc-1',
  personId: 'per-1',
  membershipId: 'mem-1',
  membershipStatus: 'PENDING',
  memberCondition: 'ASPIRANT',
  isEmailVerified: true,
  isReplayed: false,
);

// Repositorio falso: registra las claves recibidas y responde en el orden programado.
class FakeAuthRepository implements IAuthRepository {
  final List<String?> createKeys = [];
  final List<String?> acceptKeys = [];
  int inspectCalls = 0;
  final List<Future<Result<InvitationReceipt>> Function()> createResponses = [];
  final List<Future<Result<InvitationPreview>> Function()> inspectResponses =
      [];
  final List<Future<Result<InvitationAcceptance>> Function()>
  acceptResponses = [];

  @override
  Future<Result<InvitationReceipt>> createInvitation({
    required String clubId,
    required String email,
    String? idempotencyKey,
  }) {
    createKeys.add(idempotencyKey);
    return createResponses.removeAt(0)();
  }

  @override
  Future<Result<InvitationPreview>> inspectInvitation({
    required String email,
    required String code,
  }) {
    inspectCalls++;
    return inspectResponses.removeAt(0)();
  }

  @override
  Future<Result<InvitationAcceptance>> acceptInvitation({
    required String email,
    required String code,
    required String password,
    required String givenNames,
    required String familyName,
    String? secondFamilyName,
    String? phoneE164,
    String? idempotencyKey,
  }) {
    acceptKeys.add(idempotencyKey);
    return acceptResponses.removeAt(0)();
  }

  // Los demás métodos de autenticación no participan en estas pruebas.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Sustituye los casos de uso de invitaciones para que usen el repositorio falso.
List<Override> invitationTestOverrides(FakeAuthRepository repository) => [
  createInvitationUsecaseProvider.overrideWithValue(
    CreateInvitationUsecase(repository: repository),
  ),
  inspectInvitationUsecaseProvider.overrideWithValue(
    InspectInvitationUsecase(repository: repository),
  ),
  acceptInvitationUsecaseProvider.overrideWithValue(
    AcceptInvitationUsecase(repository: repository),
  ),
];
