import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/bottom_sheet_format.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
import 'package:colportando/core/widgets/dropdown_format.dart';
import 'package:colportando/core/widgets/filter_chip_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class _Campaign {
  final String name;
  final String state;

  const _Campaign({required this.name, required this.state});
}

// Pantalla principal de campañas de colportaje.
class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStateFilter = "Todas";
  String _searchQuery = "";
  String? _selectedStatus;

  final List<_Campaign> _allCampaigns = const [
    _Campaign(name: "Campaña 1", state: "Activa"),
    _Campaign(name: "Campaña 2", state: "Proxima"),
    _Campaign(name: "Campaña 3", state: "Finalizada"),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Campaign> get _filteredCampaigns {
    return _allCampaigns.where((campaign) {
      final matchesState =
          _selectedStateFilter == "Todas" ||
          (_selectedStateFilter == "Activa" && campaign.state == "Activa") ||
          (_selectedStateFilter == "Proxima" && campaign.state == "Proxima") ||
          (_selectedStateFilter == "Finalizada" &&
              campaign.state == "Finalizada");

      final matchesSearch =
          _searchQuery.isEmpty ||
          campaign.name.toLowerCase().contains(_searchQuery);

      return matchesState && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredCampaigns;

    return ScaffoldFormat(
      titleAppBar: "Campañas",
      isLoading: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, GlobalRoute.addCampign),
        elevation: 50,
        child: AppIcon.add,
      ),
      children: [
        // Buscador por nombre
        InputTextFormart(
          controller: _searchController,
          hintText: 'Buscar campaña',
          maxLength: 50,
          prefixIcon: AppIcon.search,
          onChanged: (query) {
            setState(() {
              _searchQuery = query.trim().toLowerCase();
            });
          },
        ),
        AppSpacing.heightMedium,

        // Chips de filtro por estado
        ListViewFormat(
          scrollDirection: Axis.horizontal,
          height: 38,
          itemCount: 4,
          itemBuilder: (context, index) {
            const options = ["Todas", "Activa", "Proxima", "Finalizada"];
            final option = options[index];
            return FilterChipFormat(
              label: option,
              isSelected: _selectedStateFilter == option,
              onSelected: (_) {
                setState(() => _selectedStateFilter = option);
              },
            );
          },
        ),
        AppSpacing.heightMedium,

        // Lista de campañas filtradas
        ListViewFormat(
          emptyMessage: _searchQuery.isEmpty
              ? "No hay participantes en esta categoría"
              : "No se encontraron resultados para '$_searchQuery'",
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final campaign = filteredList[index];
            return ContainerListTile(
              onPressed: () => BottomSheetFormat(
                title: "Detalles",
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormat.subtitle('Nombre de la campaña'),
                      ),
                      ButtonFormat.icon(
                        icon: AppIcon.edit,
                        onPressed: () => Navigator.pushNamed(
                          context,
                          GlobalRoute.editCampign,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.heightMedium,
                  ContainerFormat(
                    children: [
                      TextFormat.subtitle("Tipo"),
                      AppSpacing.heightMedium,
                      TextFormat.subtitle("Estado"),
                      AppSpacing.heightMedium,
                      TextFormat.body("Residencia"),
                      AppSpacing.heightSmall,
                      TextFormat.body("Email"),
                      AppSpacing.heightSmall,
                      TextFormat.body("Telefono"),
                      AppSpacing.heightMedium,
                      TextFormat.subtitle("Documentos"),
                      AppSpacing.heightSmall,
                      AppSpacing.heightMedium,
                      AppSpacing.heightMedium,
                      ButtonFormat.primary(
                        label: "Ver grupos",
                        icon: AppIcon.grupos,
                        onPressed: () =>
                            Navigator.pushNamed(context, GlobalRoute.groups),
                      ),
                      AppSpacing.heightMedium,
                      ButtonFormat.secondary(
                        label: "Ver participantes",
                        icon: AppIcon.participaciones,
                        onPressed: () => Navigator.pushNamed(
                          context,
                          GlobalRoute.participants,
                        ),
                      ),
                    ],
                  ),
                ],
              ).show(context),
              title: campaign.name,
              subtitle: campaign.state,
              icon: AppIcon.campana,
            );
          },
        ),
      ],
    );
  }
}
