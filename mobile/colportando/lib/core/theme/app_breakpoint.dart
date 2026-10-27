import 'package:flutter/material.dart';

class AppBreakpoint {
  // Ancho desde el cual se considera tablet (o celular en horizontal).
  static const double tablet = 600;
  // Ancho máximo del contenido para que no se estire en pantallas grandes.
  static const double contentMaxWidth = 600;

  // Se compara el tamaño del dispositivo con los px definidos para tablet.
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;
}
