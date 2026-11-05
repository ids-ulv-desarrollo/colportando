import 'package:colportando/core/router/imports.dart';
import 'package:colportando/core/screens/main_navigation_screen.dart';
import 'package:colportando/features/auth/presentation/screens/profile_screen.dart';
import 'package:colportando/features/auth/presentation/screens/signin_screen.dart';
import 'package:colportando/features/campaigns/presentation/screens/add_campign_screen.dart';
import 'package:colportando/features/campaigns/presentation/screens/campaigns_screen.dart';
import 'package:colportando/features/campaigns/presentation/screens/detail_campign_screen.dart';
import 'package:colportando/features/campaigns/presentation/screens/edit_campign.dart';
import 'package:colportando/features/groups/presentation/screens/global_groups_screen.dart';
import 'package:colportando/features/notifications/presentation/screens/notification_screen.dart';
import 'package:colportando/features/participants/presentation/screens/participants_screen.dart';
import 'package:colportando/prueba_widgets.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class GlobalRoute {
  static const String initial = '/';

  // Auth
  static const String signup = "/signup";
  static const String signin = "/signin";
  static const String resetPassword = "/reset_password";
  static const String forgotPassword = "/forgot_password";
  static const String confirmation = "/confirmation";

  static const String notifications = "/notifications";

  // Campañas
  static const String campaign = "/campaign";
  static const String detailCampign = "/detail_campign";
  static const String addCampign = "/add_campign";
  static const String editCampign = "/edit_campign";

  // Participaciones
  static const String participants = "/participants";

  // Grupos
  static const String groups = "/groups";

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
    campaign: (context) => const CampaignsScreen(),
    detailCampign: (context) => const DetailCampignScreen(),
    addCampign: (context) => const AddCampignScreen(),
    editCampign: (context) => const EditCampignScreen(),
    participants: (context) => const ParticipantsScreen(),
    groups: (context) => const GlobalGroupsScreen(),
    pruebaWidgets: (context) => const PruebaWidgets(),
  };
}
