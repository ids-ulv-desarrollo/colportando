import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/features/auth/data/models/user_dto.dart';

abstract class IAuthRemoteDataSource {
  Future<Result<void>> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<UserDto>> signin({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;

  const AuthRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Result<void>> signup({
    required String name,
    required String email,
    required String password,
  }) => _apiClient.post<void>(
    '/api/auth/signup',
    body: {'name': name, 'email': email, 'password': password},
  );

  @override
  Future<Result<UserDto>> signin({
    required String email,
    required String password,
  }) => _apiClient.post<UserDto>(
    '/api/auth/signin',
    body: {'email': email, 'password': password},
    fromJson: (json) => UserDto.fromJson(json),
  );
}
