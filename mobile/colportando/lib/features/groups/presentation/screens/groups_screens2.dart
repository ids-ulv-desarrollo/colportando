import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
//import 'package:colportando/core/widgets/dropdown_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/campaigns/presentation/riverpod/campaign_riverpod.dart';
import 'package:colportando/features/groups/presentation/riverpod/groups_riverpod.dart';
import 'package:colportando/features/workspace/presentation/riverpod/workspace_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupsScreens2 extends ConsumerStatefulWidget {
  final String campaignId;
  const GroupsScreens2({super.key, required this.campaignId});

  @override
  ConsumerState<GroupsScreens2> createState() => _GroupsScreens2State();
}

class _GroupsScreens2State extends ConsumerState<GroupsScreens2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescController = TextEditingController();
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _groupNameController.dispose();
    _groupDescController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _allGroups = [];

  Future<void> _getGroups() async {
    setState(() => _isLoading = true);
    try {
      final club = ref.read(workspaceProvider).workspace?.clubs.firstOrNull;
      if (club == null || club.clubId.isEmpty) {
        if (mounted) {
          SnackBarFormat().show(
            context,
            "No se encontró un club asignado.",
            isError: true,
          );
        }
        return;
      }
      String? campaignId = widget.campaignId;
      if (campaignId.isEmpty) {
        final campaignData = await ref
            .read(workspaceProvider.notifier)
            .listClubCampaigns(clubId: club.clubId);

        final campaigns = campaignData?['items'] as List<dynamic>?;
        if (campaigns != null && campaigns.isNotEmpty) {
          campaignId = campaigns.first['campaignId']?.toString();
        }
      }
      if (campaignId == null || campaignId.isEmpty) {
        if (mounted) {
          SnackBarFormat().show(
            context,
            "No hay campañas registradas para listar grupos.",
            isError: true,
          );
        }
        return;
      }

      // consultar los grupos
      final groupsData = await ref
          .read(workspaceProvider.notifier)
          .listCampaignGroups(campaignId: campaignId);
      if (groupsData != null && groupsData['items'] is List) {
        setState(() {
          _allGroups = List<Map<String, dynamic>>.from(groupsData['items']);
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBarFormat().show(
          context,
          "Error al cargar grupos: $e",
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleCreateGroup() async {
    if (widget.campaignId.isEmpty) {
      if (mounted) {
        SnackBarFormat().show(
          context,
          "No hay campaña activa seleccionada.",
          isError: true,
        );
      }
      return;
    }

    final result = await ref
        .read(campaignProvider.notifier)
        .createCampaignGroup(
          campaignId: widget.campaignId,
          name: _groupNameController.text.trim(),
          description: _groupDescController.text.trim().isNotEmpty
              ? _groupDescController.text.trim()
              : null,
        );

    final error = ref.read(campaignProvider).errorMessage;
    if (error != null) {
      SnackBarFormat().show(context, error, isError: true);
    } else if (result != null) {
      SnackBarFormat().show(context, 'Grupo creado exitosamente.');
      _groupNameController.clear();
      _groupDescController.clear();
      await _getGroups();
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getGroups();
    });
  }

  // filtar grupos
  List<Map<String, dynamic>> get _filteredGroups {
    if (_searchQuery.isEmpty) return _allGroups;
    return _allGroups.where((group) {
      final name = (group['name'] ?? '').toString().toLowerCase();
      return name.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredGroups;
    return ScaffoldFormat(
      titleAppBar: "Grupos",
      formKey: _formKey,
      isLoading: _isLoading,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          child: AppIcon.add,
          onPressed: () {
            _groupNameController.clear();
            _groupDescController.clear();

            DialogFormat(
              formKey: _dialogFormKey,
              title: 'Crear grupo',
              content: StatefulBuilder(
                builder: (dialogContext, setDialogState) {
                  return Form(
                    key: _dialogFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InputTextFormart(
                          controller: _groupNameController,
                          labelText: 'Nombre del grupo',
                          hintText: 'Ej. Grupo Alpha',
                          maxLength: 30,
                          prefixIcon: AppIcon.grupos,
                          validator: GlobalValidator.validateRequired,
                        ),
                        AppSpacing.heightMedium,
                        InputTextFormart(
                          controller: _groupDescController,
                          labelText: 'Descripción',
                          hintText: 'Ej. Descripción del grupo',
                          maxLength: 100, //prefixIcon: AppIcon.grupos,
                          validator: GlobalValidator.validateRequired,
                        ),
                      ],
                    ),
                  );
                },
              ),
              onPressed: () {
                _handleCreateGroup();
              },
            ).show(context);
          },
        ),
      ),
      children: [
        ContainerFormat(children: [TextFormat.body("Hello")]),
        AppSpacing.heightMedium,
        InputTextFormart(
          controller: _searchController,
          hintText: 'Buscar grupo',
          maxLength: 50,
          prefixIcon: AppIcon.search,
          onChanged: (query) {
            setState(() {
              _searchQuery = query.trim().toLowerCase();
            });
          },
        ),
        AppSpacing.heightMedium,
        ListViewFormat(
          emptyMessage: _searchQuery.isEmpty
              ? "No hay grupos en este campaña"
              : "No se encontraron resultados para '$_searchQuery'",
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final group = filteredList[index];
            return ContainerListTile(
              title: group['name'] ?? 'Sin nombre',
              subtitle:
                  "Participantes: ${group['participantCount'] ?? 0} · Campos: ${group['fieldCount'] ?? 0}",
              onPressed: () =>
                  Navigator.pushNamed(context, GlobalRoute.detailCampign),
            );
          },
        ),
      ],
    );
  }
}
