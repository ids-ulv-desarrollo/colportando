import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/filter_chip_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:flutter/material.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  bool _showAll = true;

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: 'Recursos',
      children: [
        InputTextFormart(
          hintText: 'Buscar recurso',
          onChanged: (value) {},
          maxLength: 50,
          prefixIcon: AppIcon.search,
        ),
        AppSpacing.heightSmall,
        ListViewFormat(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (context, index) => FilterChipFormat(
            label: 'Todos',
            isSelected: _showAll,
            onSelected: (value) => setState(() => _showAll = value),
          ),
        ),
      ],
    );
  }
}
