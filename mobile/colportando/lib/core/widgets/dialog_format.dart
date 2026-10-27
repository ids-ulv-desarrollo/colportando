import 'package:colportando/core/widgets/button_format.dart';
import 'package:flutter/material.dart';

class DialogFormat extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback onPressed;
  final GlobalKey<FormState>? formKey;
  final bool isLoading;

  const DialogFormat({
    super.key,
    required this.title,
    required this.content,
    required this.onPressed,
    this.formKey,
    this.isLoading = false,
  });

  // Muestra el diálogo en pantalla y retorna el resultado al cerrarse.
  Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(context: context, builder: (_) => this);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: content),
      actions: [
        ButtonFormat.dialog(
          onConfirm: () {
            onPressed();
            Navigator.pop(context);
          },
          formKey: formKey,
          isLoading: isLoading,
        ),
      ],
    );
  }
}
