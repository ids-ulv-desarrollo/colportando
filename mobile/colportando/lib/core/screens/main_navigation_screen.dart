import 'package:colportando/core/theme/app_breakpoint.dart';
import 'package:colportando/core/widgets/bottom_bar_format.dart';
import 'package:colportando/core/widgets/exit_confirmation_format.dart';
import 'package:colportando/core/widgets/side_bar_format.dart';
import 'package:flutter/material.dart';

// Pantalla principal que controla la navegación: barra inferior en celular y barra lateral en tablet.
class MainNavigationScreen extends StatefulWidget {
  final List<BottomBarItem> items;
  final List<Widget> screens;
  const MainNavigationScreen({
    super.key,
    required this.items,
    required this.screens,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // static const List<BottomBarItem> _items = [
  //   BottomBarItem(
  //     icon: AppIcon.homeInactive,
  //     selectedIcon: AppIcon.homeSelected,
  //     label: "Inicio",
  //   ),
  //   BottomBarItem(
  //     icon: AppIcon.personInactive,
  //     selectedIcon: AppIcon.personSelected,
  //     label: "Perfil",
  //   ),
  // ];

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Cambia de página con animación al seleccionar una pestaña.
  void _handleSelectTab(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = AppBreakpoint.isTablet(context);

    return ExitConfirmationFormat(
      child: Scaffold(
        extendBody: true,
        body: Row(
          children: [
            if (isTablet)
              SideBarFormat(
                selectedIndex: _currentIndex,
                onPressed: _handleSelectTab,
                items: widget.items,
              ),
            // La key mantiene el PageView al cambiar entre celular y tablet.
            Expanded(
              key: const ValueKey("pages"),
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                children: widget.screens,
              ),
            ),
          ],
        ),
        bottomNavigationBar: isTablet
            ? null
            : BottomBarFormat(
                selectedIndex: _currentIndex,
                onPressed: _handleSelectTab,
                items: widget.items,
              ),
      ),
    );
  }
}
