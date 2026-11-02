import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/widgets/bottom_bar_format.dart';
import 'package:colportando/core/widgets/drawer_format.dart';
import 'package:colportando/features/acquisitions/presentation/screens/acquisitions_screen.dart';
import 'package:colportando/features/auth/presentation/screens/waiting_role_screen.dart';
import 'package:colportando/features/campaigns/presentation/screens/agenda_screen.dart';
import 'package:colportando/features/campaigns/presentation/screens/appeals_screen.dart';
import 'package:colportando/features/campaigns/presentation/screens/campaigns_screen.dart';
import 'package:colportando/features/campaigns/presentation/screens/fields_screen.dart';
import 'package:colportando/features/campaigns/presentation/screens/participations_screen.dart';
import 'package:colportando/features/catalog/presentation/screens/catalog_screen.dart';
import 'package:colportando/features/credits/presentation/screens/credits_screen.dart';
import 'package:colportando/features/deposits/presentation/screens/deposits_screen.dart';
import 'package:colportando/features/participants/presentation/screens/groups_screen.dart';
import 'package:colportando/features/participants/presentation/screens/participants_screen.dart';
import 'package:colportando/features/sales/presentation/screens/payments_screen.dart';
import 'package:colportando/features/sales/presentation/screens/sales_screen.dart';
import 'package:colportando/features/trainings/presentation/screens/trainings_screen.dart';
import 'package:colportando/prueba_widgets.dart';
import 'package:flutter/material.dart';

// Configuración de navegación para barra inferior, drawer y pantallas según el rol.
class RoleNavigationConfig {
  RoleNavigationConfig._();

  // Elementos de la barra inferior (BottomBar).
  static List<BottomBarItem> getItems(String? role) {
    switch (role?.toLowerCase()) {
      case "directiva":
        return const [
          BottomBarItem(icon: AppIcon.home, label: "Inicio"),
          BottomBarItem(icon: AppIcon.asociados, label: "Asociados"),
          BottomBarItem(icon: AppIcon.calendar, label: "Agenda"),
        ];

      case "colportor":
        return const [
          BottomBarItem(icon: AppIcon.home, label: "Inicio"),
          BottomBarItem(icon: AppIcon.ventas, label: "Ventas"),
          BottomBarItem(icon: AppIcon.catalogo, label: "Catálogo"),
        ];

      case "asociado":
        return const [
          BottomBarItem(icon: AppIcon.home, label: "Inicio"),
          BottomBarItem(icon: AppIcon.person, label: "Colportores"),
          BottomBarItem(icon: AppIcon.campos, label: "Campo"),
        ];

      default:
        return const [
          BottomBarItem(icon: AppIcon.home, label: "Inicio"),
          BottomBarItem(icon: AppIcon.catalogo, label: "Catálogo"),
          BottomBarItem(icon: AppIcon.capacitaciones, label: "Capacitación"),
        ];
    }
  }

  // Pantallas asignadas a la barra inferior.
  static List<Widget> getScreens(String? role) {
    switch (role?.toLowerCase()) {
      case "directiva":
        return const [CampaignsScreen(), ParticipantsScreen(), AgendaScreen()];

      case "colportor":
        return const [CampaignsScreen(), SalesScreen(), CatalogScreen()];

      case "asociado":
        return const [CampaignsScreen(), ParticipantsScreen(), FieldsScreen()];

      default:
        return const [WaitingRoleScreen(), CatalogScreen(), TrainingsScreen()];
    }
  }

  // Opciones del Drawer sin repetir las que ya están en la barra inferior.
  static List<DrawerItem> getDrawerItems(BuildContext context, String? role) {
    switch (role?.toLowerCase()) {
      case "directiva":
        return const [
          DrawerItem(icon: AppIcon.person, label: "Colportores"),
          DrawerItem(icon: AppIcon.grupos, label: "Grupos"),
          DrawerItem(icon: AppIcon.participaciones, label: "Participaciones"),
          DrawerItem(icon: AppIcon.campana, label: "Campaña"),
          DrawerItem(icon: AppIcon.capacitaciones, label: "Capacitaciones"),
          DrawerItem(icon: AppIcon.campos, label: "Campos"),
          DrawerItem(icon: AppIcon.apelaciones, label: "Apelaciones"),
          DrawerItem(icon: AppIcon.depositos, label: "Depósitos"),
          DrawerItem(icon: AppIcon.catalogo, label: "Catálogo"),
        ];

      case "colportor":
        return const [
          DrawerItem(icon: AppIcon.participaciones, label: "Mi Participación"),
          DrawerItem(icon: AppIcon.adquisiciones, label: "Mis solicitudes"),
          DrawerItem(icon: AppIcon.depositos, label: "Depósitos"),
          DrawerItem(icon: AppIcon.pagos, label: "Pagos"),
          DrawerItem(icon: AppIcon.credito, label: "Crédito"),
          DrawerItem(icon: AppIcon.adquisiciones, label: "Adquisiciones"),
          DrawerItem(icon: AppIcon.capacitaciones, label: "Capacitaciones"),
          DrawerItem(icon: AppIcon.apelaciones, label: "Apelaciones"),
        ];

      case "asociado":
        return const [
          DrawerItem(icon: AppIcon.participaciones, label: "Mi Participación"),
          DrawerItem(icon: AppIcon.adquisiciones, label: "Adquisiciones"),
          DrawerItem(icon: AppIcon.catalogo, label: "Catálogo"),
          DrawerItem(icon: AppIcon.depositos, label: "Depósitos"),
          DrawerItem(icon: AppIcon.credito, label: "Créditos"),
        ];

      default:
        return const [
          DrawerItem(icon: AppIcon.cancel, label: "Widgets prueba"),
        ];
    }
  }

  // Pantallas correspondientes a cada opción del Drawer.
  static List<Widget> getDrawerScreens(String? role) {
    switch (role?.toLowerCase()) {
      case "directiva":
        return const [
          ParticipantsScreen(),
          GroupsScreen(),
          ParticipationsScreen(),
          CampaignsScreen(),
          TrainingsScreen(),
          FieldsScreen(),
          AppealsScreen(),
          DepositsScreen(),
          CatalogScreen(),
        ];

      case "colportor":
        return const [
          ParticipationsScreen(),
          AcquisitionsScreen(),
          DepositsScreen(),
          PaymentsScreen(),
          CreditsScreen(),
          AcquisitionsScreen(),
          TrainingsScreen(),
          AppealsScreen(),
        ];

      case "asociado":
        return const [
          ParticipationsScreen(),
          AcquisitionsScreen(),
          CatalogScreen(),
          DepositsScreen(),
          CreditsScreen(),
        ];

      default:
        return const [PruebaWidgets()];
    }
  }
}
