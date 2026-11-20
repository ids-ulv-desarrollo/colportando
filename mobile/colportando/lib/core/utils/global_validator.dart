import 'package:colportando/core/constants/strings_constants.dart';

class GlobalValidator {
  // Validador para campos requeridos.
  static String? validateRequired(String? value) {
    return value == null || value.trim().isEmpty
        ? StringsConstants.campoRequerido
        : null;
  }

  // Validador de números.
  static String? validateNumber(String? value) {
    final numRegex = RegExp(r"^[0-9]+(\.[0-9]+)?$");
    return validateRequired(value) ??
        (numRegex.hasMatch(value!) ? null : "Número inválido");
  }

  // Validador de campos únicos.
  static String? validateUnique(String? value) {
    return value == null || value.trim().isEmpty ? "Nº" : null;
  }

  // Validador de correo electrónico.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringsConstants.campoRequerido;
    }
    final emailRegex = RegExp(
      r"^[-!#$%&'*+\/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+\/0-9=?A-Z^_a-z`{|}~])*@[a-zA-Z0-9](-*\.?[a-zA-Z0-9])*\.[a-zA-Z](-?[a-zA-Z0-9])+",
    );
    return !emailRegex.hasMatch(value) ? "Formato de correo inválido" : null;
  }

  // Validador de contraseña (mínimo 8 caracteres según backend).
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringsConstants.campoRequerido;
    }
    return value.length < 8
        ? "La contraseña debe tener al menos 8 caracteres"
        : null;
  }

  // Validador de confirmación de contraseña.
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return StringsConstants.campoRequerido;
    }
    return value != password ? "Las contraseñas no coinciden" : null;
  }

  // Validador de código de verificación numérico de 8 dígitos.
  static String? validateEightDigitCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringsConstants.campoRequerido;
    }
    return RegExp(r'^\d{8}$').hasMatch(value.trim())
        ? null
        : "El código debe tener 8 dígitos";
  }

  // Validador de código alfanumérico de invitación (12 a 15 caracteres).
  static String? validateInvitationCode(String? value) {
    final code = value?.trim() ?? "";
    if (code.isEmpty) return StringsConstants.campoRequerido;
    return RegExp(r'^[A-Za-z0-9-]{12,15}$').hasMatch(code)
        ? null
        : "El código debe tener de 12 a 15 caracteres";
  }

  // Validador de teléfono en formato internacional E.164 (opcional).
  static String? validatePhone(String? value) {
    final phone = value?.trim() ?? "";
    if (phone.isEmpty) return null;
    return RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(phone)
        ? null
        : "Usa el formato internacional, ej. +525512345678";
  }
}
