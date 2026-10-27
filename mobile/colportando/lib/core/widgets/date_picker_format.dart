import 'package:colportando/core/constants/strings_constants.dart';
import 'package:flutter/material.dart';

class DatePickerFormat extends StatelessWidget {
  final DateTime firstDate;
  final DateTime lastDate;

  const DatePickerFormat({
    super.key,
    required this.firstDate,
    required this.lastDate,
  });

  // Muestra el selector de fecha y retorna la fecha seleccionada.
  Future<DateTime?> show(BuildContext context) {
    return showDialog<DateTime>(context: context, builder: (_) => this);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return DatePickerDialog(
      // Evita error si la fecha actual está fuera del rango.
      initialDate: now.isAfter(lastDate)
          ? lastDate
          : (now.isBefore(firstDate) ? firstDate : now),
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: "Seleccionar fecha",
      cancelText: StringsConstants.cancel,
      confirmText: StringsConstants.confirm,
    );
  }
}
