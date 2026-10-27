import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class GlobalTheme {
  static ThemeData themeLight = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.background,

    textTheme: TextTheme(
      titleMedium: AppText.title,
      titleSmall: AppText.subtitle,
      bodyLarge: AppText.body,
      bodyMedium: AppText.bodySecondary,
      labelMedium: AppText.label,
    ),

    colorScheme: const ColorScheme.light(
      // Para componentes y acciones principales.
      primary: AppColor.primary,
      // Para texto e íconos sobre componentes y acciones principales.
      onPrimary: AppColor.white,
      // Para AppBar y componentes y acciones secundarias.
      secondary: AppColor.secondary,
      // Para texto e íconos sobre elementos secundarios.
      onSecondary: AppColor.white,
      // Para contenedores, tarjetas y campos de texto.
      surface: AppColor.surface,
      // Para textos principales sobre el fondo o superficies.
      onSurface: AppColor.black,
      // Para textos secundarios y hintText.
      onSurfaceVariant: AppColor.gray,
      // Para bordes.
      outline: AppColor.gray,
      // Para estados de error y validaciones fallidas.
      error: AppColor.error,
      // Para texto e íconos sobre fondos de error.
      onError: AppColor.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.secondary,
      foregroundColor: AppColor.white,
      iconTheme: const IconThemeData(color: AppColor.white),
      titleTextStyle: AppText.titleWhite,
    ),

    datePickerTheme: DatePickerThemeData(
      // Configuraciones generales del DatePicker.
      backgroundColor: AppColor.white,
      // Botones Cancelar y Confirmar.
      cancelButtonStyle: TextButton.styleFrom(foregroundColor: AppColor.white),
      confirmButtonStyle: TextButton.styleFrom(foregroundColor: AppColor.white),
      headerBackgroundColor: AppColor.secondary,
      headerForegroundColor: AppColor.white,

      // Configuraciones específicas del DateRangePicker.
      rangePickerHeaderBackgroundColor: AppColor.secondary,
      rangePickerHeaderForegroundColor: AppColor.white,
      // Tamaño de la fecha seleccionada en el menú superior ("Ene 12 - Ene 15").
      rangePickerHeaderHeadlineStyle: AppText.titleWhite,
      // Tamaño del texto de ayuda superior ("Select range" o traducido).
      rangePickerHeaderHelpStyle: AppText.subtitleWhite,
      // Color intermedio de los días en un rango: del 12 al 15 (el 13 y 14).
      rangeSelectionBackgroundColor: AppColor.primary.withValues(alpha: 0.2),

      // Estilos de los días interactivos del calendario.
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColor.primary;
        return Colors.transparent;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColor.white;
        if (states.contains(WidgetState.disabled)) return AppColor.gray;
        return AppColor.black;
      }),
      todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColor.primary;
        return Colors.transparent;
      }),
      todayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColor.white;
        return AppColor.primary;
      }),
    ),

    switchTheme: SwitchThemeData(
      // Color del botón (pulgar) del switch según su estado.
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColor.white;
        return AppColor.gray;
      }),
      // Color del fondo del switch según su estado.
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColor.primary;
        return AppColor.surface;
      }),
      // Color del borde del switch según su estado.
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.transparent;
        return AppColor.gray;
      }),
    ),

    // Botones.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: AppText.bodySecondary,
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        disabledBackgroundColor: AppColor.surface,
        disabledForegroundColor: AppColor.gray,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderSmall,
        ),
        minimumSize: const Size(double.infinity, 45),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: AppText.bodySecondary,
        foregroundColor: AppColor.black,
        disabledForegroundColor: AppColor.gray,
        side: BorderSide(color: AppColor.gray.withValues(alpha: 0.3), width: 1),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderSmall,
        ),
        minimumSize: const Size(double.infinity, 45),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: AppText.bodySecondary,
        foregroundColor: AppColor.primary,
        disabledForegroundColor: AppColor.gray,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColor.black,
        disabledForegroundColor: AppColor.gray,
      ),
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: AppColor.black,
      textColor: AppColor.black,
    ),
    iconTheme: const IconThemeData(color: AppColor.black),

    // Barra de navegación inferior.
    bottomAppBarTheme: const BottomAppBarThemeData(color: AppColor.secondary),
    // Botón flotante para acciones principales.
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.primary,
      foregroundColor: AppColor.white,
    ),
    // Notificaciones emergentes inferiores.
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColor.secondary,
      contentTextStyle: AppText.bodyWhite,
    ),

    // Decoración para campos de texto.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.surface,
      hintStyle: AppText.bodySecondary,
      labelStyle: AppText.body,
      floatingLabelStyle: AppText.body,
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.gray),
        borderRadius: AppSpacing.borderSmall,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.gray),
        borderRadius: AppSpacing.borderSmall,
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.primary, width: 1.5),
        borderRadius: AppSpacing.borderSmall,
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.error),
        borderRadius: AppSpacing.borderSmall,
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.error, width: 1.5),
        borderRadius: AppSpacing.borderSmall,
      ),
      prefixIconColor: AppColor.gray,
      suffixIconColor: AppColor.gray,
    ),

    // Indicador de carga circular o lineal.
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColor.primary,
      circularTrackColor: AppColor.surface,
      strokeWidth: 2,
    ),

    // Selector deslizable.
    sliderTheme: const SliderThemeData(
      inactiveTrackColor: AppColor.gray,
      activeTrackColor: AppColor.primary,
      thumbColor: AppColor.primary,
    ),

    // Menú desplegable emergente.
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColor.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderSmall),
    ),
    // Menú lateral (Drawer).
    drawerTheme: const DrawerThemeData(backgroundColor: AppColor.background),
    // Hoja inferior emergente (Bottom Sheet).
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColor.surface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: AppColor.surface,
      elevation: 4,
      modalElevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      showDragHandle: true,
      dragHandleColor: AppColor.gray,
    ),
    // Cuadros de diálogo y modales emergentes.
    dialogTheme: DialogThemeData(
      backgroundColor: AppColor.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderSmall),
      titleTextStyle: AppText.subtitle,
      contentTextStyle: AppText.body,
    ),
    // Color de divisor general.
    dividerTheme: DividerThemeData(
      color: AppColor.gray.withValues(alpha: 0.2),
      thickness: 1,
    ),
    // Color de divisor de QA.
    dividerColor: Colors.transparent,

    // Selección y cursor de texto.
    textSelectionTheme: TextSelectionThemeData(
      // Color del cursor.
      cursorColor: AppColor.primary,
      // Color del texto seleccionado.
      selectionColor: AppColor.primary.withValues(alpha: 0.2),
      // Color de las bolitas que permiten seleccionar el texto.
      selectionHandleColor: AppColor.primary,
    ),
  );

  static ThemeData themeDark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.backgroundDark,

    textTheme: TextTheme(
      titleMedium: AppText.titleWhite,
      titleSmall: AppText.subtitleWhite,
      bodyLarge: AppText.bodyWhite,
      bodyMedium: AppText.bodySecondaryDark,
      labelMedium: AppText.labelWhite,
    ),

    colorScheme: const ColorScheme.dark(
      // Para componentes y acciones principales.
      primary: AppColor.primary,
      // Para texto e íconos sobre componentes y acciones principales.
      onPrimary: AppColor.white,
      // Para AppBar y componentes y acciones secundarias.
      secondary: AppColor.secondary,
      // Para texto e íconos sobre elementos secundarios.
      onSecondary: AppColor.white,
      // Para contenedores, tarjetas y campos de texto.
      surface: AppColor.surfaceDark,
      // Para textos principales sobre el fondo o superficies.
      onSurface: AppColor.white,
      // Para textos secundarios y hintText.
      onSurfaceVariant: AppColor.grayDark,
      // Para bordes.
      outline: AppColor.grayDark,
      // Para estados de error y validaciones fallidas.
      error: AppColor.error,
      // Para texto e íconos sobre fondos de error.
      onError: AppColor.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.secondary,
      foregroundColor: AppColor.white,
      iconTheme: const IconThemeData(color: AppColor.white),
      titleTextStyle: AppText.titleWhite,
    ),

    datePickerTheme: DatePickerThemeData(
      // Configuraciones generales del DatePicker.
      backgroundColor: AppColor.surfaceDark,
      // Botones Cancelar y Confirmar.
      cancelButtonStyle: TextButton.styleFrom(foregroundColor: AppColor.white),
      confirmButtonStyle: TextButton.styleFrom(foregroundColor: AppColor.white),
      headerBackgroundColor: AppColor.secondary,
      headerForegroundColor: AppColor.white,

      // Configuraciones específicas del DateRangePicker.
      rangePickerHeaderBackgroundColor: AppColor.secondary,
      rangePickerHeaderForegroundColor: AppColor.white,
      // Tamaño de la fecha seleccionada en el menú superior ("Ene 12 - Ene 15").
      rangePickerHeaderHeadlineStyle: AppText.titleWhite,
      // Tamaño del texto de ayuda superior ("Select range" o traducido).
      rangePickerHeaderHelpStyle: AppText.subtitleWhite,
      // Color intermedio de los días en un rango: del 12 al 15 (el 13 y 14).
      rangeSelectionBackgroundColor: AppColor.primary.withValues(alpha: 0.2),

      // Estilos de los días interactivos del calendario.
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColor.primary;
        return Colors.transparent;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColor.white;
        if (states.contains(WidgetState.disabled)) return AppColor.grayDark;
        return AppColor.white;
      }),
      todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColor.primary;
        return Colors.transparent;
      }),
      todayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColor.backgroundDark;
        }
        return AppColor.primary;
      }),
    ),

    switchTheme: SwitchThemeData(
      // Color del botón (pulgar) del switch según su estado.
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColor.white;
        return AppColor.grayDark;
      }),
      // Color del fondo del switch según su estado.
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColor.primary;
        return AppColor.surfaceDark;
      }),
      // Color del borde del switch según su estado.
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.transparent;
        return AppColor.grayDark;
      }),
    ),

    // Botones.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: AppText.bodySecondary,
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        disabledBackgroundColor: AppColor.surfaceDark,
        disabledForegroundColor: AppColor.grayDark,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderSmall,
        ),
        minimumSize: const Size(double.infinity, 45),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: AppText.bodySecondary,
        foregroundColor: AppColor.white,
        disabledForegroundColor: AppColor.grayDark,
        side: BorderSide(
          color: AppColor.grayDark.withValues(alpha: 0.3),
          width: 1,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderSmall,
        ),
        minimumSize: const Size(double.infinity, 45),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: AppText.bodySecondary,
        foregroundColor: AppColor.primary,
        disabledForegroundColor: AppColor.grayDark,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColor.white,
        disabledForegroundColor: AppColor.grayDark,
      ),
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: AppColor.white,
      textColor: AppColor.white,
    ),
    iconTheme: const IconThemeData(color: AppColor.white),

    // Barra de navegación inferior.
    bottomAppBarTheme: const BottomAppBarThemeData(color: AppColor.secondary),
    // Botón flotante para acciones principales.
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.primary,
      foregroundColor: AppColor.white,
    ),
    // Notificaciones emergentes inferiores.
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColor.secondary,
      contentTextStyle: AppText.bodyWhite,
    ),

    // Decoración para campos de texto.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.surfaceDark,
      hintStyle: AppText.bodySecondaryDark,
      labelStyle: AppText.bodyWhite,
      floatingLabelStyle: AppText.bodyWhite,
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.grayDark),
        borderRadius: AppSpacing.borderSmall,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.grayDark),
        borderRadius: AppSpacing.borderSmall,
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.primary, width: 1.5),
        borderRadius: AppSpacing.borderSmall,
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.error),
        borderRadius: AppSpacing.borderSmall,
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.error, width: 1.5),
        borderRadius: AppSpacing.borderSmall,
      ),
      prefixIconColor: AppColor.grayDark,
      suffixIconColor: AppColor.grayDark,
    ),

    // Indicador de carga circular o lineal.
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColor.primary,
      circularTrackColor: AppColor.surfaceDark,
      strokeWidth: 2,
    ),

    // Selector deslizable.
    sliderTheme: const SliderThemeData(
      inactiveTrackColor: AppColor.grayDark,
      activeTrackColor: AppColor.primary,
      thumbColor: AppColor.primary,
    ),

    // Menú desplegable emergente.
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColor.backgroundDark,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderSmall),
    ),
    // Menú lateral (Drawer).
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColor.backgroundDark,
    ),
    // Hoja inferior emergente (Bottom Sheet).
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColor.surfaceDark,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: AppColor.surfaceDark,
      elevation: 4,
      modalElevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      showDragHandle: true,
      dragHandleColor: AppColor.grayDark,
    ),
    // Cuadros de diálogo y modales emergentes.
    dialogTheme: DialogThemeData(
      backgroundColor: AppColor.surfaceDark,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.borderSmall),
      titleTextStyle: AppText.subtitleWhite,
      contentTextStyle: AppText.bodyWhite,
    ),
    // Color de divisor general.
    dividerTheme: DividerThemeData(
      color: AppColor.grayDark.withValues(alpha: 0.2),
      thickness: 1,
    ),
    // Color de divisor de QA.
    dividerColor: Colors.transparent,

    // Selección y cursor de texto.
    textSelectionTheme: TextSelectionThemeData(
      // Color del cursor.
      cursorColor: AppColor.primary,
      // Color del texto seleccionado.
      selectionColor: AppColor.primary.withValues(alpha: 0.2),
      // Color de las bolitas que permiten seleccionar el texto.
      selectionHandleColor: AppColor.primary,
    ),
  );
}
