import 'package:colportando/core/router/imports.dart';
import 'package:colportando/core/screens/main_navigation_screen.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/widgets/bottom_bar_format.dart';
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

  // Profile
  static const String profile = "/profile";

  static const String pruebaWidgets = "/prueba_widgets";

  static Map<String, WidgetBuilder> routes = {
    // initial: (context) => const StartScreen(),
    signup: (context) => const SignupScreen(),
    signin: (context) => const SigninScreen(),
    // resetPassword: (context) => const ResetPasswordScreen(),
    // forgotPassword: (context) => const ForgotPasswordScreen(),
    // confirmation: (context) => const ConfirmationScreen(),
    mainNavigation: (context) => const MainNavigationScreen(
      items: [
        BottomBarItem(
          icon: AppIcon.homeInactive,
          selectedIcon: AppIcon.homeSelected,
          label: "Inicio",
        ),
        BottomBarItem(
          icon: AppIcon.personInactive,
          selectedIcon: AppIcon.personSelected,
          label: "Perfil",
        ),
      ],
      screens: [PruebaWidgets(), ProfileScreen()],
    ),
    profile: (context) => const ProfileScreen(),
    notifications: (context) => const NotificationScreen(),
    pruebaWidgets: (context) => const PruebaWidgets(),
  };
}
