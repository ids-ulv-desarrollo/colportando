import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/auth/domain/entities/invitation.dart';
import 'package:colportando/features/auth/domain/entities/user.dart';
import 'package:colportando/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final IAuthRepository repository;

  const LoginUsecase({required this.repository});

  Future<Result<User>> call({
    required String email,
    required String password,
  }) => repository.login(email: email, password: password);
}

class RefreshSessionUsecase {
  final IAuthRepository repository;

  const RefreshSessionUsecase({required this.repository});

  Future<Result<void>> call() => repository.refreshSession();
}

class LogoutUsecase {
  final IAuthRepository repository;

  const LogoutUsecase({required this.repository});

  Future<Result<void>> call() => repository.logout();
}

class GetMeUsecase {
  final IAuthRepository repository;

  const GetMeUsecase({required this.repository});

  Future<Result<User>> call() => repository.getMe();
}

class RequestEmailVerificationUsecase {
  final IAuthRepository repository;

  const RequestEmailVerificationUsecase({required this.repository});

  Future<Result<void>> call({required String email}) =>
      repository.requestEmailVerification(email: email);
}

class ConfirmEmailVerificationUsecase {
  final IAuthRepository repository;

  const ConfirmEmailVerificationUsecase({required this.repository});

  Future<Result<void>> call({required String email, required String code}) =>
      repository.confirmEmailVerification(email: email, code: code);
}

class RequestPasswordResetUsecase {
  final IAuthRepository repository;

  const RequestPasswordResetUsecase({required this.repository});

  Future<Result<void>> call({required String email}) =>
      repository.requestPasswordReset(email: email);
}

class ConfirmPasswordResetUsecase {
  final IAuthRepository repository;

  const ConfirmPasswordResetUsecase({required this.repository});

  Future<Result<void>> call({
    required String email,
    required String code,
    required String newPassword,
  }) => repository.confirmPasswordReset(
    email: email,
    code: code,
    newPassword: newPassword,
  );
}

class CreateInvitationUsecase {
  final IAuthRepository repository;

  const CreateInvitationUsecase({required this.repository});

  Future<Result<InvitationReceipt>> call({
    required String clubId,
    required String email,
    String? idempotencyKey,
  }) => repository.createInvitation(
    clubId: clubId,
    email: email,
    idempotencyKey: idempotencyKey,
  );
}

class InspectInvitationUsecase {
  final IAuthRepository repository;

  const InspectInvitationUsecase({required this.repository});

  Future<Result<InvitationPreview>> call({
    required String email,
    required String code,
  }) => repository.inspectInvitation(email: email, code: code);
}

class AcceptInvitationUsecase {
  final IAuthRepository repository;

  const AcceptInvitationUsecase({required this.repository});

  Future<Result<InvitationAcceptance>> call({
    required String email,
    required String code,
    required String password,
    required String givenNames,
    required String familyName,
    String? secondFamilyName,
    String? phoneE164,
    String? idempotencyKey,
  }) => repository.acceptInvitation(
    email: email,
    code: code,
    password: password,
    givenNames: givenNames,
    familyName: familyName,
    secondFamilyName: secondFamilyName,
    phoneE164: phoneE164,
    idempotencyKey: idempotencyKey,
  );
}
