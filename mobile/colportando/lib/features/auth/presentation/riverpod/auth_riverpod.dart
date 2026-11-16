import 'package:colportando/core/error/result.dart';
import 'package:colportando/features/auth/domain/entities/user.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_riverpod.freezed.dart';

// Estado inmutable de autenticación.
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool isAuthenticated,
    User? user,
  }) = _AuthState;
}

// Notificador que gestiona el estado y las acciones de autenticación.
class AuthNotifier extends Notifier<AuthState> {
  @override

  AuthState build() => const AuthState();

  // Ejecuta una acción asíncrona que no retorna entidad actualizando carga y error.
  Future<bool> _runAction(Future<Result<dynamic>> Function() action) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await action();
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.isSuccess;
  }

  // Inicia sesión y carga el usuario autenticado.
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(
      isLoading: true,
      isAuthenticated: false,
      errorMessage: null,
    );

    final result = await ref.read(loginUsecaseProvider)(
      email: email,
      password: password,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: result.data,
      );
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result.error);
    }
  }

  // Consulta la cuenta autenticada actual.
  Future<void> getMe() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(getMeUsecaseProvider)();

    if (result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: result.data,
      );
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result.error);
    }
  }

  // Renueva los tokens de la sesión actual.
  Future<bool> refreshSession() =>
      _runAction(() => ref.read(refreshSessionUsecaseProvider)());

  // Solicita el envío del código de verificación al correo.
  Future<bool> requestEmailVerification({required String email}) => _runAction(
    () => ref.read(requestEmailVerificationUsecaseProvider)(email: email),
  );

  // Confirma el correo electrónico con el código recibido.
  Future<bool> confirmEmailVerification({
    required String email,
    required String code,
  }) => _runAction(
    () => ref.read(confirmEmailVerificationUsecaseProvider)(
      email: email,
      code: code,
    ),
  );

  // Solicita el envío del código para restablecer contraseña.
  Future<bool> requestPasswordReset({required String email}) => _runAction(
    () => ref.read(requestPasswordResetUsecaseProvider)(email: email),
  );

  // Confirma el cambio de contraseña con el código recibido.
  Future<bool> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  }) => _runAction(
    () => ref.read(confirmPasswordResetUsecaseProvider)(
      email: email,
      code: code,
      newPassword: newPassword,
    ),
  );

  // Invita a un aspirante a un club (rol directiva).
  Future<Map<String, dynamic>?> createInvitation({
    required String clubId,
    required String email,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(createInvitationUsecaseProvider)(
      clubId: clubId,
      email: email,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Verifica los datos de una invitación por correo y código.
  Future<Map<String, dynamic>?> inspectInvitation({
    required String email,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(inspectInvitationUsecaseProvider)(
      email: email,
      code: code,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Registra al aspirante aceptando la invitación del club.
  Future<Map<String, dynamic>?> acceptInvitation({
    required String email,
    required String code,
    required String password,
    required String givenNames,
    required String familyName,
    String? secondFamilyName,
    String? phoneE164,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(acceptInvitationUsecaseProvider)(
      email: email,
      code: code,
      password: password,
      givenNames: givenNames,
      familyName: familyName,
      secondFamilyName: secondFamilyName,
      phoneE164: phoneE164,
    );
    state = state.copyWith(
      isLoading: false,
      errorMessage: result.isFailure ? result.error : null,
    );
    return result.data;
  }

  // Revoca la sesión en el servidor, limpia almacenamiento seguro y reinicia el estado.
  Future<void> signOut() async {
    await ref.read(logoutUsecaseProvider)();
    state = const AuthState();
  }
}

// Proveedor global que consume la interfaz de usuario.
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
