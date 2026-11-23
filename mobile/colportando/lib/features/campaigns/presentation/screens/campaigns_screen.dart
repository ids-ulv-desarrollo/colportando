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
import 'package:colportando/features/campaigns/presentation/riverpod/campaign_riverpod.dart';
import 'package:colportando/features/workspace/presentation/riverpod/workspace_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pantalla principal de campañas de colportaje.
class CampaignsScreen extends ConsumerStatefulWidget {
  const CampaignsScreen({super.key});

  @override
  ConsumerState<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends ConsumerState<CampaignsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStateFilter = "Todas";
  String _searchQuery = "";

  bool _isLoading = false;

  List<Map<String, dynamic>> _allCampaigns = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCampaigns();
    });
  }

  Future<void> _getCampaigns() async {
    final club = ref.read(workspaceProvider).workspace?.clubs.firstOrNull;
    if (club == null || club.clubId.isEmpty) {
      if (mounted) {
        SnackBarFormat().show(
          context,
          "No se encontró un club asignado para esta cuenta.",
          isError: true,
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ref
          .read(workspaceProvider.notifier)
          .listClubCampaigns(clubId: club.clubId);

      if (response != null && response['items'] is List) {
        setState(() {
          _allCampaigns = List<Map<String, dynamic>>.from(response['items']);
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBarFormat().show(
          context,
          "Error al cargar la campañas.",
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _changeCampaignStatus(
    String campaignId,
    String newStatus,
  ) async {
    setState(() => _isLoading = true);

    final result = await ref
        .read(campaignProvider.notifier)
        .changeCampaignStatus(campaignId: campaignId, status: newStatus);

    if (!mounted) return;

    final error = ref.read(campaignProvider).errorMessage;
    if (error != null) {
      setState(() => _isLoading = false);
      SnackBarFormat().show(context, error, isError: true);
    } else if (result != null) {
      SnackBarFormat().show(context, "Estado actualizado a $newStatus");
      await _getCampaigns();
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _showChangeStatusDialog(Map<String, dynamic> campaign) {
    final campaignId = campaign['campaignId']?.toString() ?? '';
    final currentStatus = (campaign['status'] ?? 'ACTIVE')
        .toString()
        .toUpperCase();
    String selectedStatus =
        ['ACTIVE', 'PLANNED', 'CLOSED', 'CANCELLED'].contains(currentStatus)
        ? currentStatus
        : 'ACTIVE';

    DialogFormat(
      title: 'Editar estado',
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return DropdownFormat<String>(
            labelText: 'Estado',
            value: selectedStatus,
            items: const [
              DropdownMenuItem(value: 'ACTIVE', child: Text('Activa')),
              DropdownMenuItem(value: 'PLANNED ', child: Text('Proxima')),
              DropdownMenuItem(value: 'CLOSED', child: Text('Cerrada')),
              DropdownMenuItem(value: 'CANCELLED', child: Text('Cancelada')),
            ],
            onChanged: (value) {
              if (value != null) {
                setDialogState(() => selectedStatus = value);
              }
            },
          );
        },
      ),
      onPressed: () {
        if (campaignId.isNotEmpty) {
          _changeCampaignStatus(campaignId, selectedStatus);
        }
      },
    ).show(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredCampaigns {
    return _allCampaigns.where((campaign) {
      final status = (campaign['status'] ?? '').toString().toUpperCase();
      final name = (campaign['name'] ?? '').toString().toLowerCase();

      final matchesState =
          _selectedStateFilter == "Todas" ||
          (_selectedStateFilter == "Activa" && status == "ACTIVE") ||
          (_searchController == "Proxima" && status == "PLANNED") ||
          (_selectedStateFilter == "Cerrada" && status == "CLOSED") ||
          (_selectedStateFilter == "Cancelada" && status == "CANCELLED");
      final matchesSearch = _searchQuery.isEmpty || name.contains(_searchQuery);

      return matchesState && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredCampaigns;

    return ScaffoldFormat(
      titleAppBar: "Campañas",
      isLoading: _isLoading,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, GlobalRoute.addCampign),
          elevation: 50,
          child: AppIcon.add,
        ),
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
          itemCount: 5,
          itemBuilder: (context, index) {
            const options = [
              "Todas",
              "Activa",
              "Proxima",
              "Cerrada",
              "Cancelada",
            ];
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
                      Expanded(child: TextFormat.subtitle(campaign['name'])),
                      ButtonFormat.icon(
                        icon: AppIcon.edit,
                        onPressed: () {
                          Navigator.pop(context);
                          _showChangeStatusDialog(campaign);
                        },
                      ),
                    ],
                  ),
                  AppSpacing.heightMedium,
                  ContainerFormat(
                    children: [
                      TextFormat.subtitle('Estado:  ${campaign['status']}'),
                      AppSpacing.heightMedium,
                      TextFormat.subtitle('Periodo'),
                      AppSpacing.heightSmall,
                      Row(
                        children: [
                          Expanded(
                            child: TextFormat.body(
                              'Inicio:  ${campaign['startsOn']}',
                            ),
                          ),

                          Expanded(
                            child: TextFormat.body(
                              'Fin:  ${campaign['endsOn']}',
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.heightMedium,
                      TextFormat.body(
                        'Participantes:  ${campaign['participantCount']}',
                      ),
                      AppSpacing.heightMedium,
                      TextFormat.body('Grupos:  ${campaign['groupCount']}'),
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
              title: campaign["name"],
              subtitle: campaign["status"],
              icon: AppIcon.campana,
            );
          },
        ),
      ],
    );
  }
}
