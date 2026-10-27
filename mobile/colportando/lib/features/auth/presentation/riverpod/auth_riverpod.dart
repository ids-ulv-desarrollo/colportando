import 'package:colportando/features/auth/presentation/riverpod/auth_di.dart';
import 'package:colportando/features/auth/domain/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Estado inmutable de la pantalla de autenticación.
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;
  final User? user;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
    User? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
    );
  }
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
