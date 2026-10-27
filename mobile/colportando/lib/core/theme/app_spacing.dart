import 'package:flutter/material.dart';

class AppSpacing {
  // Espaciado interno
  static const EdgeInsetsGeometry paddingSmall = EdgeInsets.all(8);
  static const EdgeInsetsGeometry paddingMedium = EdgeInsets.all(16);
  static const EdgeInsetsGeometry paddingSymetric0_16 = EdgeInsets.symmetric(
    horizontal: 0,
    vertical: 16,
  );
  static const EdgeInsetsGeometry paddingSymetric16_0 = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 0,
  );
  static const EdgeInsetsGeometry paddingSymetric0_8 = EdgeInsets.symmetric(
    horizontal: 0,
    vertical: 8,
  );
  static const EdgeInsetsGeometry paddingSymetric8_0 = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 0,
  );

  // Espaciado externo
  static const EdgeInsetsGeometry marginSmall = EdgeInsets.all(8);
  static const EdgeInsetsGeometry marginMedium = EdgeInsets.all(16);

  // Bordes
  static const BorderRadius borderSmall = BorderRadius.all(Radius.circular(8));
  static const BorderRadius borderMedium = BorderRadius.all(
    Radius.circular(16),
  );

  // Espaciado alto y ancho
  static const SizedBox heightSmall = SizedBox(height: 8);
  static const SizedBox heightMedium = SizedBox(height: 16);
  static const SizedBox widthSmall = SizedBox(width: 8);
  static const SizedBox widthMedium = SizedBox(width: 16);
}
