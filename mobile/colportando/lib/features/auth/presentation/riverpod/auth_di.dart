import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:colportando/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:colportando/features/auth/domain/repositories/auth_repository.dart';
import 'package:colportando/features/auth/domain/usecases/auth_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Inyección de dependencias del módulo de autenticación (API -> RemoteDataSource -> Repository -> Usecase -> Notifier (por Riverpod) -> UI)

// Fuente de datos remota de auth.
final _authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSource(apiClient: apiClient);
});

// Repositorio de auth.
final _authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final remoteDataSource = ref.watch(_authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Ahora sí lo que ese exporta, los UseCases de auth, que son los únicos que se expondrán a la UI.
final signinUsecaseProvider = Provider<SigninUsecase>((ref) {
  final repository = ref.watch(_authRepositoryProvider);
  return SigninUsecase(repository: repository);
});

final signupUsecaseProvider = Provider<SignupUsecase>((ref) {
  final repository = ref.watch(_authRepositoryProvider);
  return SignupUsecase(repository: repository);
});
