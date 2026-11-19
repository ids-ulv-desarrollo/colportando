import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/storage/secure_storage.dart';
import 'package:colportando/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:colportando/features/auth/domain/entities/invitation.dart';
import 'package:colportando/features/auth/domain/entities/user.dart';
import 'package:colportando/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;
  String? _refreshToken;

  // Mensajes para los códigos documentados de cada operación de invitación.
  static const Map<int, String> _createInvitationMessages = {
    401: "Tu sesión expiró. Inicia sesión de nuevo.",
    403: "Tu cuenta no tiene permiso para invitar en este club.",
    409: "La solicitud no coincide con un intento anterior. Vuelve a enviarla.",
  };
  static const Map<int, String> _inspectInvitationMessages = {
    404: "La invitación no está disponible. Revisa el correo y el código.",
    429: "Demasiados intentos. Espera un momento y vuelve a intentarlo.",
  };
  static const Map<int, String> _acceptInvitationMessages = {
    401: "No se pudo validar la cuenta con los datos proporcionados.",
    404: "La invitación no está disponible. Vuelve a consultarla.",
    409:
        "La invitación ya no puede aceptarse o la solicitud no coincide con un intento anterior.",
    429: "Demasiados intentos. Espera un momento y vuelve a intentarlo.",
  };

  AuthRepositoryImpl({required this.remoteDataSource});

  Future<void> _saveTokens(Map<String, dynamic> session) async {
    SecureStorage.accessToken = session['accessToken'] as String;
    _refreshToken = session['refreshToken'] as String;
    await SecureStorage.writeRefreshToken(_refreshToken!);
  }

  Future<void> _clearTokens() async {
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
    if (result.isFailure) return Result.failure(result.error);

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

  // Sustituye el mensaje de los códigos documentados; conserva el código HTTP y los demás errores.
  Result<T> _withInvitationMessages<T>(
    Result<T> result,
    Map<int, String> messages,
  ) {
    final message = messages[result.statusCode];
    if (result.isSuccess || message == null) return result;
    return Result.failure(message, statusCode: result.statusCode);
  }

  @override
  Future<Result<InvitationReceipt>> createInvitation({
    required String clubId,
    required String email,
    String? idempotencyKey,
  }) async {
    if (SecureStorage.accessToken == null) {
      final refreshResult = await refreshSession();
      if (refreshResult.isFailure) {
        return _withInvitationMessages(
          Result<InvitationReceipt>.failure(
            refreshResult.error,
            statusCode: refreshResult.statusCode,
          ),
          _createInvitationMessages,
        );
      }
    }
    final result = await remoteDataSource.createInvitation(
      accessToken: SecureStorage.accessToken!,
      clubId: clubId,
      email: email,
      idempotencyKey: idempotencyKey,
    );
    return _withInvitationMessages(
      result.map((dto) => dto.toEntity()),
      _createInvitationMessages,
    );
  }

  @override
  Future<Result<InvitationPreview>> inspectInvitation({
    required String email,
    required String code,
  }) async {
    final result = await remoteDataSource.inspectInvitation(
      email: email,
      code: code,
    );
    return _withInvitationMessages(
      result.map((dto) => dto.toEntity()),
      _inspectInvitationMessages,
    );
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
  }) async {
    final result = await remoteDataSource.acceptInvitation(
      email: email,
      code: code,
      password: password,
      givenNames: givenNames,
      familyName: familyName,
      secondFamilyName: secondFamilyName,
      phoneE164: phoneE164,
      idempotencyKey: idempotencyKey,
    );
    return _withInvitationMessages(
      result.map((dto) => dto.toEntity()),
      _acceptInvitationMessages,
    );
  }
}
