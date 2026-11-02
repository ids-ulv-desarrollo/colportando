import 'package:colportando/features/auth/domain/entities/user.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_riverpod.freezed.dart';

// Estado inmutable de la pantalla de autenticación.
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool isAuthenticated,
    User? user,
  }) = _AuthState;
}

// Notificador que gestiona el estado y las acciones del usuario.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Se retorna el estado INICIAL de la pantalla.
    return const AuthState();
  }

  // Ejecuta el registro de un nuevo usuario.
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    // Apenas se ejecuta la acción, se cambia el estado a cargando y se limpia el mensaje de error.
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Se llama al UseCase de signin.
    final signupUsecase = ref.read(signupUsecaseProvider);
    final result = await signupUsecase(
      name: name,
      email: email,
      password: password,
    );

    // Se evalúa si la petición fue exitosa para emitir el nuevo estado según el resultado.
    if (result.isSuccess) {
      state = state.copyWith(isLoading: false);
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result.error);
    }
  }

  // Ejecuta el inicio de sesión.
  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final signinUsecase = ref.read(signinUsecaseProvider);
    final result = await signinUsecase(email: email, password: password);

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

  // Restablece el estado al cerrar sesión.
  void signOut() {
    state = const AuthState();
  }
}

// Proveedor global que consume la interfaz de usuario.
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
