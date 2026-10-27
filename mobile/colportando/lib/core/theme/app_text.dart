import 'package:colportando/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  // Usado para los títulos principales de las secciones.
  static final TextStyle title = GoogleFonts.publicSans(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColor.black,
  );
  // Usado para los títulos que están encima de color primary o secondary.
  static final TextStyle titleWhite = GoogleFonts.publicSans(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColor.white,
  );

  // Usado para los subtítulos de las secciones.
  static final TextStyle subtitle = GoogleFonts.publicSans(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColor.black,
  );
  // Usado para los subtítulos que están encima de color primary o secondary.
  static final TextStyle subtitleWhite = GoogleFonts.publicSans(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColor.white,
  );
  // Usado para el cuerpo del texto.
  static final TextStyle body = GoogleFonts.publicSans(
    fontSize: 16,
    color: AppColor.black,
  );

  static final TextStyle bodyWhite = GoogleFonts.publicSans(
    fontSize: 16,
    color: AppColor.white,
  );
  // Usado para el cuerpo del texto secundario.
  static final TextStyle bodySecondary = GoogleFonts.publicSans(
    fontSize: 14,
    color: AppColor.gray,
  );
  // Usado para el cuerpo del texto secundario en modo oscuro.
  static final TextStyle bodySecondaryDark = GoogleFonts.publicSans(
    fontSize: 14,
    color: AppColor.grayDark,
  );
  // Usado para las etiquetas de los gráficos.
  static final TextStyle label = GoogleFonts.publicSans(
    fontSize: 12,
    color: AppColor.black,
  );
  // Usado para las etiquetas en modo oscuro o sobre fondos contrastantes.
  static final TextStyle labelWhite = GoogleFonts.publicSans(
    fontSize: 12,
    color: AppColor.white,
  );
}
