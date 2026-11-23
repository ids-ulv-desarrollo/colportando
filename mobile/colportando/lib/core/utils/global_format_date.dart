// Utilidad global para formateo y conversión de fechas en la aplicación.
class GlobalFormatDate {
  // Formatea un DateTime al formato requerido por la API (YYYY-MM-DD).
  static String toApi(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  // Convierte un texto con fecha (DD/MM/AAAA, DD-MM-AAAA o AAAA-MM-DD) al formato ISO para la API (YYYY-MM-DD).
  static String toApiFromString(String? dateText) {
    if (dateText == null) return '';
    final trimmed = dateText.trim();
    if (trimmed.isEmpty) return '';

    // Si ya viene en formato AAAA-MM-DD
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(trimmed)) {
      return trimmed;
    }

    // Si viene con separador / o -
    final separator = trimmed.contains('/')
        ? '/'
        : (trimmed.contains('-') ? '-' : null);

    if (separator != null) {
      final parts = trimmed.split(separator);
      if (parts.length == 3) {
        // Formato DD/MM/AAAA
        if (parts[2].length == 4) {
          final day = parts[0].padLeft(2, '0');
          final month = parts[1].padLeft(2, '0');
          final year = parts[2];
          return '$year-$month-$day';
        }
      }
    }

    return trimmed;
  }

  // Formatea un DateTime al formato visual estándar para el usuario (DD/MM/AAAA).
  static String toView(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(4, '0');
    return '$day/$month/$year';
  }

  // Convierte un texto en formato AAAA-MM-DD a formato visual DD/MM/AAAA.
  static String toViewFromString(String? dateText) {
    if (dateText == null) return '';
    final trimmed = dateText.trim();
    if (trimmed.isEmpty) return '';

    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(trimmed)) {
      final parts = trimmed.split('-');
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }

    return trimmed;
  }

  // Intenta convertir un texto de fecha a DateTime admitiendo formatos visuales e ISO.
  static DateTime? tryParse(String? dateText) {
    if (dateText == null) return null;
    final isoDate = toApiFromString(dateText);
    return DateTime.tryParse(isoDate);
  }

  // Verifica que un rango de fechas sea válido (fecha fin >= fecha inicio).
  static bool isValidRange({required String start, required String end}) {
    final startDate = tryParse(start);
    final endDate = tryParse(end);
    if (startDate == null || endDate == null) return false;
    return !endDate.isBefore(startDate);
  }
}
