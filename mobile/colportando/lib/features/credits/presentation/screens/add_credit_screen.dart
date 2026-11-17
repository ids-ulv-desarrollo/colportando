import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/quantity_selector_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class AddCreditScreen extends StatefulWidget {
  const AddCreditScreen({super.key});

  @override
  State<AddCreditScreen> createState() => _AddCreditScreenState();
}

class _AddCreditScreenState extends State<AddCreditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Agregar Crédito",
      isLoading: false,
      formKey: _formKey,
      children: [
        TextFormat.subtitle("Selecciona el material."),
        AppSpacing.heightMedium,
        Row(
          children: [
            Expanded(
              child: ContainerFormat(
                children: [
                  TextFormat.subtitle("Hello 1"),
                  AppSpacing.heightSmall,
                  QuantitySelectorFormat(
                    value: _quantity,
                    onChanged: (val) => setState(() => _quantity = val),
                  ),
                ],
              ),
            ),
            AppSpacing.widthMedium,
            Expanded(
              child: ContainerFormat(
                children: [
                  TextFormat.subtitle("Hello 2"),
                  AppSpacing.heightSmall,
                  QuantitySelectorFormat(
                    value: _quantity,
                    onChanged: (val) => setState(() => _quantity = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
