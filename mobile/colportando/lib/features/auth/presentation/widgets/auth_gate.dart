import 'package:colportando/core/screens/main_navigation_screen.dart';
import 'package:colportando/core/widgets/circular_loading.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:colportando/features/auth/presentation/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Encargado de dirigir a la pantalla principal o de inicio de sesión según el estado de la sesión.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isInitializing) {
      return const Scaffold(body: Center(child: CircularLoading()));
    }

    if (!authState.isAuthenticated) {
      return const SigninScreen();
    }

    return const MainNavigationScreen();
  }
}
