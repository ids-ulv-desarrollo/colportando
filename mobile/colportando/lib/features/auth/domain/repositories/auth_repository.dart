import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/auth/domain/entities/user.dart';

abstract class IAuthRepository {
  Future<Result<void>> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<User>> signin({
    required String email,
    required String password,
  });
}
