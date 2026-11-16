import 'package:colportando/core/network/api_client.dart';
import 'package:colportando/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:colportando/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:colportando/features/auth/domain/repositories/auth_repository.dart';
import 'package:colportando/features/auth/domain/usecases/auth_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

// Casos de uso de auth expuestos para el estado y la UI.
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  return LoginUsecase(repository: ref.watch(_authRepositoryProvider));
});

final refreshSessionUsecaseProvider = Provider<RefreshSessionUsecase>((ref) {
  return RefreshSessionUsecase(repository: ref.watch(_authRepositoryProvider));
});

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  return LogoutUsecase(repository: ref.watch(_authRepositoryProvider));
});

final getMeUsecaseProvider = Provider<GetMeUsecase>((ref) {
  return GetMeUsecase(repository: ref.watch(_authRepositoryProvider));
});

final requestEmailVerificationUsecaseProvider =
    Provider<RequestEmailVerificationUsecase>((ref) {
      return RequestEmailVerificationUsecase(
        repository: ref.watch(_authRepositoryProvider),
      );
    });

final confirmEmailVerificationUsecaseProvider =
    Provider<ConfirmEmailVerificationUsecase>((ref) {
      return ConfirmEmailVerificationUsecase(
        repository: ref.watch(_authRepositoryProvider),
      );
    });

final requestPasswordResetUsecaseProvider =
    Provider<RequestPasswordResetUsecase>((ref) {
      return RequestPasswordResetUsecase(
        repository: ref.watch(_authRepositoryProvider),
      );
    });

final confirmPasswordResetUsecaseProvider =
    Provider<ConfirmPasswordResetUsecase>((ref) {
      return ConfirmPasswordResetUsecase(
        repository: ref.watch(_authRepositoryProvider),
      );
    });

final createInvitationUsecaseProvider = Provider<CreateInvitationUsecase>((
  ref,
) {
  return CreateInvitationUsecase(
    repository: ref.watch(_authRepositoryProvider),
  );
});

final inspectInvitationUsecaseProvider = Provider<InspectInvitationUsecase>((
  ref,
) {
  return InspectInvitationUsecase(
    repository: ref.watch(_authRepositoryProvider),
  );
});

final acceptInvitationUsecaseProvider = Provider<AcceptInvitationUsecase>((
  ref,
) {
  return AcceptInvitationUsecase(
    repository: ref.watch(_authRepositoryProvider),
  );
});
