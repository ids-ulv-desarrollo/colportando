import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:colportando/features/auth/domain/entities/user.dart';
import 'package:colportando/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<User>> signin({
    required String email,
    required String password,
  }) => remoteDataSource.signin(email: email, password: password);

  @override
  Future<Result<void>> signup({
    required String email,
    required String name,
    required String password,
  }) => remoteDataSource.signup(name: name, email: email, password: password);
}
