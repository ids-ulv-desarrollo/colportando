import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/filter_chip_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:flutter/material.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedStatusFilter = "Todas";

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormat(
      titleAppBar: "Campañas",
      isLoading: false,
      formKey: _formKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, GlobalRoute.addCampign),
        elevation: 50,
        child: AppIcon.add,
      ),
      children: [
        InputTextFormart(
          controller: _searchController,
          hintText: "Buscar campaña",
          maxLength: 50,
          prefixIcon: AppIcon.search,
          onChanged: (query) {
            setState(() {
              _searchQuery = query.trim().toLowerCase();
            });
          },
        ),
        AppSpacing.heightMedium,
        // Chips para filtrar estados
        ListViewFormat(
          scrollDirection: Axis.horizontal,
          height: 38,
          itemCount: 4,
          itemBuilder: (context, index) {
            const options = ["Todas", "Activa", "Finalizadas", "Canceladas"];
            final option = options[index];
            return FilterChipFormat(
              label: option,
              isSelected: _selectedStatusFilter == option,
              onSelected: (_) {
                setState(() => _selectedStatusFilter = option);
              },
            );
          },
        ),
      ],
    );
  }
}
