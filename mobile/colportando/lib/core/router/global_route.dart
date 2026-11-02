import 'package:colportando/core/router/imports.dart';
import 'package:colportando/core/screens/main_navigation_screen.dart';
import 'package:colportando/features/auth/presentation/screens/profile_screen.dart';
import 'package:colportando/features/auth/presentation/screens/signin_screen.dart';
import 'package:colportando/features/notifications/presentation/screens/notification_screen.dart';
import 'package:colportando/prueba_widgets.dart';
import 'package:flutter/material.dart';

class GlobalRoute {
  static const String initial = '/';

  // Auth
  static const String signup = "/signup";
  static const String signin = "/signin";
  static const String resetPassword = "/reset_password";
  static const String forgotPassword = "/forgot_password";
  static const String confirmation = "/confirmation";

  static const String notifications = "/notifications";

  // Navegación principal
  static const String mainNavigation = "/main_navigation";

  // Perfil
  static const String profile = "/profile";

  // Pruebas
  static const String pruebaWidgets = "/prueba_widgets";

  static Map<String, WidgetBuilder> routes = {
    signup: (context) => const SignupScreen(),
    signin: (context) => const SigninScreen(),
    mainNavigation: (context) => const MainNavigationScreen(),
    profile: (context) => const ProfileScreen(),
    notifications: (context) => const NotificationScreen(),
    pruebaWidgets: (context) => const PruebaWidgets(),
  };
}
