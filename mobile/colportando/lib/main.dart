import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/global_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Se inicializa Flutter antes de acceder a plugins nativos.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // Widget que gestiona el estado de la aplicación.
    const ProviderScope(child: MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Colportando",
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: GlobalTheme.themeLight,
      darkTheme: GlobalTheme.themeDark,
      initialRoute: GlobalRoute.mainNavigation,
      routes: GlobalRoute.routes,
    );
  }
}
