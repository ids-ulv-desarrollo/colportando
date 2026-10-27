import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/auth/domain/entities/user.dart';
import 'package:colportando/features/auth/domain/repositories/auth_repository.dart';

class SignupUsecase {
  final IAuthRepository repository;

  SignupUsecase({required this.repository});

  Future<Result<void>> call({
    required String name,
    required String email,
    required String password,
  }) => repository.signup(name: name, email: email, password: password);
}

class SigninUsecase {
  final IAuthRepository repository;

  SigninUsecase({required this.repository});

  // Ejecuta la acción de inicio de sesión.
  Future<Result<User>> call({
    required String email,
    required String password,
  }) => repository.signin(email: email, password: password);
}
