import 'package:colportando/core/router/role_navigation_config.dart';
import 'package:colportando/core/theme/app_breakpoint.dart';
import 'package:colportando/core/widgets/bottom_bar_format.dart';
import 'package:colportando/core/widgets/drawer_format.dart';
import 'package:colportando/core/widgets/exit_confirmation_format.dart';
import 'package:colportando/core/widgets/side_bar_format.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:colportando/features/auth/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pantalla principal que controla la navegación adaptativa y dinámica según el rol.
class MainNavigationScreen extends ConsumerStatefulWidget {
  final List<BottomBarItem>? items;
  final List<Widget>? screens;

  const MainNavigationScreen({super.key, this.items, this.screens});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  int? _selectedDrawerIndex;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Cambia de pestaña en la barra inferior.
  void _handleSelectTab(int index) {
    setState(() {
      _selectedDrawerIndex = null;
      _currentIndex = index;
    });
    if (_pageController.hasClients) {
      _pageController.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = AppBreakpoint.isTablet(context);
    final role = ref.watch(authProvider).user?.role;
    // final role = "directiva";
    final items = widget.items ?? RoleNavigationConfig.getItems(role);
    final screens = widget.screens ?? RoleNavigationConfig.getScreens(role);
    final drawerItems = RoleNavigationConfig.getDrawerItems(context, role);
    final drawerScreens = RoleNavigationConfig.getDrawerScreens(role);

    // Muestra pantalla del Drawer, Perfil o el PageView de la barra inferior.
    final Widget currentBody = _selectedDrawerIndex == -1
        ? const ProfileScreen()
        : (_selectedDrawerIndex != null &&
              _selectedDrawerIndex! < drawerScreens.length)
        ? drawerScreens[_selectedDrawerIndex!]
        : PageView(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            children: screens,
          );

    final bottomIndex = _selectedDrawerIndex == null ? _currentIndex : -1;

    return ExitConfirmationFormat(
      child: Scaffold(
        extendBody: true,
        drawer: DrawerFormat(
          items: drawerItems,
          selectedIndex: _selectedDrawerIndex,
          onPressed: (index) => setState(() => _selectedDrawerIndex = index),
          onProfileTap: () => setState(() => _selectedDrawerIndex = -1),
        ),
        drawerEdgeDragWidth: 60,
        body: Row(
          children: [
            if (isTablet)
              SideBarFormat(
                selectedIndex: bottomIndex,
                onPressed: _handleSelectTab,
                items: items,
              ),
            Expanded(child: currentBody),
          ],
        ),
        bottomNavigationBar: isTablet
            ? null
            : BottomBarFormat(
                selectedIndex: bottomIndex,
                onPressed: _handleSelectTab,
                items: items,
              ),
      ),
    );
  }
}
