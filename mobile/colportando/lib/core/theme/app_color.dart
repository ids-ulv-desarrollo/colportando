import 'package:flutter/material.dart';

class AppColor {
  // MODO CLARO

  // Fondo general de las pantallas (Scaffold, vistas completas)
  static const Color background = Color(0xFFFFFFFF);
  // Fondo para cards, contenedores e inputs (Tarjetas, textfields filled, shimmers)
  static const Color surface = Color(0xFFF8FAFC);
  // Íconos, títulos, subtítulos y texto principal
  static const Color black = Color(0xFF0F172A);
  // Texto secundario, bordes e inactivos (Placeholders/hinttext, dividers)
  static const Color gray = Color(0xFF64748B);

  // MODO OSCURO

  // Fondo general de las pantallas en modo oscuro (Scaffold, vistas completas)
  static const Color backgroundDark = Color(0xFF0F172A);
  // Fondo para cards, contenedores e inputs en modo oscuro (Tarjetas, textfields filled, dialogs)
  static const Color surfaceDark = Color(0xFF1E293B);
  // Texto secundario, bordes e inactivos en modo oscuro (Placeholders/hinttext, dividers)
  static const Color grayDark = Color(0xFF94A3B8);

  // COLORES ESTÁTICOS

  // Color principal de marca (Botones principales, FloatingActionButton, checks activos, éxito)
  static const Color primary = Color(0xFF249E6D);
  // Color secundario de marca (AppBar, BottomAppBar, tabs, menús)
  static const Color secondary = Color(0xFF1E487A);
  // Textos e íconos contrastantes (Texto principal en modo oscuro, textos sobre primary/secondary)
  static const Color white = Color(0xFFFFFFFF);

  // Estados del sistema (Información, enlaces, chips en progreso, tooltips)
  static const Color info = Color(0xFF0071BC);
  // Estados del sistema (Advertencias, stock bajo, alertas de conexión/offline)
  static const Color warning = Color(0xFFE5A823);
  // Estados del sistema (Errores, validaciones de formularios, acciones destructivas)
  static const Color error = Color(0xFFEF4444);
}
