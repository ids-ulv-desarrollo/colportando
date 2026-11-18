import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/auth/domain/entities/user.dart';

abstract class IAuthRepository {
  Future<Result<User>> login({required String email, required String password});

  Future<Result<void>> refreshSession();

  Future<Result<void>> logout();

  Future<Result<User>> getMe();

  Future<Result<void>> requestEmailVerification({required String email});

  Future<Result<void>> confirmEmailVerification({
    required String email,
    required String code,
  });

  Future<Result<void>> requestPasswordReset({required String email});

  Future<Result<void>> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<Result<Map<String, dynamic>>> createInvitation({
    required String clubId,
    required String email,
  });

  Future<Result<Map<String, dynamic>>> inspectInvitation({
    required String email,
    required String code,
  });

  Future<Result<Map<String, dynamic>>> acceptInvitation({
    required String email,
    required String code,
    required String password,
    required String givenNames,
    required String familyName,
    String? secondFamilyName,
    String? phoneE164,
  });
}
