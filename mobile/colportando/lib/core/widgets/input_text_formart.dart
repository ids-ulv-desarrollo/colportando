import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextFormart extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int maxLength;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const InputTextFormart({
    this.focusNode,
    super.key,
    this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.controller,
    this.validator,
    required this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  State<InputTextFormart> createState() => _InputTextFormartState();
}

class _InputTextFormartState extends State<InputTextFormart> {
  bool? _obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      // Salta al siguiente campo cuando se presiona Enter.
      textInputAction: widget.maxLines == 1
          ? TextInputAction.next
          : TextInputAction.newline,
      onChanged: (value) {
        // Salta si tiene un límite de 1 y no es multilínea.
        if (widget.maxLength == 1 && widget.maxLines == 1) {
          FocusScope.of(context).nextFocus();
        }
        widget.onChanged?.call(value);
      },
      // Limita la longitud del texto y aplica formateadores adicionales si se especifican.
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.maxLength),
        ...?widget.inputFormatters,
      ],
      // Centra el texto si no tiene ícono.
      textAlign: widget.maxLength == 1 ? TextAlign.center : TextAlign.start,

      validator: widget.validator,
      // AutovalidateMode para que valide mientras se escribe.
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: context.textTheme.bodyLarge,
      cursorColor: context.colorScheme.onSurface,
      controller: widget.controller,
      //Censura el texto cuando se tiene un ícono de contraseña.
      obscureText: widget.prefixIcon == AppIcon.password
          ? _obscureText ?? true
          : false,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: AppSpacing.paddingMedium,
                child: widget.prefixIcon,
              )
            : null,
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon: widget.prefixIcon == AppIcon.password
            ? ButtonFormat.icon(
                onPressed: () => setState(() {
                  _obscureText = !(_obscureText ?? true);
                }),
                icon: (_obscureText ?? true)
                    ? AppIcon.visibility
                    : AppIcon.visibilityOff,
              )
            : widget.suffixIcon,
      ),
    );
  }
}
