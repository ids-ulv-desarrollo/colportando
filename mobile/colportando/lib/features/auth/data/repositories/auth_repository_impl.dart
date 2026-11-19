import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/storage/secure_storage.dart';
import 'package:colportando/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:colportando/features/auth/domain/entities/user.dart';
import 'package:colportando/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;
  String? _refreshToken;

  AuthRepositoryImpl({required this.remoteDataSource});

  Future<void> _saveTokens(Map<String, dynamic> session) async {
    SecureStorage.accessToken = session['accessToken'] as String;
    _refreshToken = session['refreshToken'] as String;
    await SecureStorage.writeRefreshToken(_refreshToken!);
  }

  Future<void> _clearTokens() async {
    SecureStorage.accessToken = null;
    _refreshToken = null;
    await SecureStorage.clearRefreshToken();
  }

  @override
  Future<Result<User>> login({
    required String email,
    required String password,
  }) async {
    final sessionResult = await remoteDataSource.login(
      email: email,
      password: password,
    );
    if (sessionResult.isFailure) return Result.failure(sessionResult.error);

    await _saveTokens(sessionResult.data!);
    return getMe();
  }

  @override
  Future<Result<void>> refreshSession() async {
    final refreshToken =
        _refreshToken ?? await SecureStorage.readRefreshToken();
    if (refreshToken == null) return const Result.failure('Sin sesión activa.');

    final result = await remoteDataSource.refreshSession(
      refreshToken: refreshToken,
    );
    if (result.isFailure) {
      await _clearTokens();
      return Result.failure(result.error);
    }

    await _saveTokens(result.data!);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> logout() async {
    final refreshToken =
        _refreshToken ?? await SecureStorage.readRefreshToken();
    if (refreshToken != null) {
      await remoteDataSource.logout(refreshToken: refreshToken);
    }
    await _clearTokens();
    return const Result.success(null);
  }

  @override
  Future<Result<User>> getMe() async {
    if (SecureStorage.accessToken == null) {
      final refreshResult = await refreshSession();
      if (refreshResult.isFailure) return Result.failure(refreshResult.error);
    }
    final result = await remoteDataSource.getMe(
      accessToken: SecureStorage.accessToken!,
    );
    return result.map((dto) => dto.toEntity());
  }

  @override
  Future<Result<void>> requestEmailVerification({required String email}) =>
      remoteDataSource.requestEmailVerification(email: email);

  @override
  Future<Result<void>> confirmEmailVerification({
    required String email,
    required String code,
  }) => remoteDataSource.confirmEmailVerification(email: email, code: code);

  @override
  Future<Result<void>> requestPasswordReset({required String email}) =>
      remoteDataSource.requestPasswordReset(email: email);

  @override
  Future<Result<void>> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  }) => remoteDataSource.confirmPasswordReset(
    email: email,
    code: code,
    newPassword: newPassword,
  );

  @override
  Future<Result<Map<String, dynamic>>> createInvitation({
    required String clubId,
    required String email,
  }) async {
    if (SecureStorage.accessToken == null) {
      final refreshResult = await refreshSession();
      if (refreshResult.isFailure) return Result.failure(refreshResult.error);
    }
    return remoteDataSource.createInvitation(
      accessToken: SecureStorage.accessToken!,
      clubId: clubId,
      email: email,
    );
  }

  @override
  Future<Result<Map<String, dynamic>>> inspectInvitation({
    required String email,
    required String code,
  }) => remoteDataSource.inspectInvitation(email: email, code: code);

  @override
  Future<Result<Map<String, dynamic>>> acceptInvitation({
    required String email,
    required String code,
    required String password,
    required String givenNames,
    required String familyName,
    String? secondFamilyName,
    String? phoneE164,
  }) => remoteDataSource.acceptInvitation(
    email: email,
    code: code,
    password: password,
    givenNames: givenNames,
    familyName: familyName,
    secondFamilyName: secondFamilyName,
    phoneE164: phoneE164,
  );
}
