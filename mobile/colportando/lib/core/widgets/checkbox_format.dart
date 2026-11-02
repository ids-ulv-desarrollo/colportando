import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class CheckboxFormat extends StatefulWidget {
  final String text;
  const CheckboxFormat({super.key, required this.text});

  @override
  State<CheckboxFormat> createState() => _CheckboxFormatState();
}

class _CheckboxFormatState extends State<CheckboxFormat> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isSelected,
      title: TextFormat.body(widget.text),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (value) => setState(() {
        isSelected = value!;
      }),
    );
  }
}
