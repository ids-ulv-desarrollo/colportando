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

  // Métodos privados de evaluación individual para la contraseña (Útil para la parte visual).
  static bool _hasMinLength(String pwd) => pwd.length >= 8;
  static bool _hasUppercase(String pwd) => RegExp(r'[A-Z]').hasMatch(pwd);
  static bool _hasLowercase(String pwd) => RegExp(r'[a-z]').hasMatch(pwd);
  static bool _hasNumber(String pwd) => RegExp(r'\d').hasMatch(pwd);
  static bool _hasSpecialChar(String pwd) => RegExp(r'[\W_]').hasMatch(pwd);

  // Validador de contraseña general.
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringsConstants.campoRequerido;
    }
    final isValid =
        _hasMinLength(value) &&
        _hasLowercase(value) &&
        _hasUppercase(value) &&
        _hasNumber(value) &&
        _hasSpecialChar(value);
    return !isValid ? "Formato de contraseña inválida" : null;
  }
}
