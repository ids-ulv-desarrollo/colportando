import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
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
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:colportando/features/workspace/presentation/riverpod/workspace_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pantalla de participantes asignados a la campaña o zona.
class ParticipantsScreen extends ConsumerStatefulWidget {
  const ParticipantsScreen({super.key});

  @override
  ConsumerState<ParticipantsScreen> createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends ConsumerState<ParticipantsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  String _selectedRoleFilter = "Todos";
  String _searchQuery = "";

  List<Map<String, dynamic>> _allParticipants = [];

  Future<void> _getParticipants() async {
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
          .listClubMemberships(clubId: club.clubId);

      if (response != null && response['items'] is List) {
        setState(() {
          _allParticipants = List<Map<String, dynamic>>.from(response['items']);
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBarFormat().show(
          context,
          "Error al cargar participantes: $e",
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Envía la invitación del club al correo ingresado.
  Future<void> _handleSendInvitation() async {
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

    final isSent = await ref
        .read(authProvider.notifier)
        .createInvitation(
          clubId: club.clubId,
          email: _emailController.text.trim(),
        );
    if (!mounted) return;

    if (isSent != null) {
      SnackBarFormat().show(context, "Invitación enviada con éxito");
      _emailController.clear();
      await _getParticipants();
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getParticipants();
    });
  }

  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _inviteFormKey = GlobalKey<FormState>();
  String? _selectedStatus;
  final List<String> _nameDoc = ["Doc 1", "Doc 2"];
  final List<String> _typeDoc = [
    "Carta de recomendación",
    "Certificado de bautizmo",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredParticipants {
    return _allParticipants.where((participant) {
      final name = (participant['displayName'] ?? '').toString().toLowerCase();
      final condition = (participant['memberCondition'] ?? '')
          .toString()
          .toUpperCase();

      final matchesRole =
          _selectedRoleFilter == "Todos" ||
          (_selectedRoleFilter == "Asociados" &&
              condition.contains("EXPERIENCED")) ||
          (_selectedRoleFilter == "Colportores" &&
              !condition.contains("EXPERIENCED"));

      final matchesSearch = _searchQuery.isEmpty || name.contains(_searchQuery);

      return matchesRole && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredParticipants;

    return ScaffoldFormat(
      titleAppBar: "Participantes",
      isLoading: _isLoading,
      formKey: _formKey,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () {
            _emailController.clear();
            DialogFormat(
              formKey: _inviteFormKey,
              title: "Invitar participante",
              content: Form(
                key: _inviteFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormat.body(
                      "Ingresa el correo electrónico de la persona para enviarle la invitación.",
                    ),
                    AppSpacing.heightMedium,
                    InputTextFormart(
                      controller: _emailController,
                      prefixIcon: AppIcon.email,
                      labelText: "Correo electrónico",
                      hintText: "ejemplo@correo.com",
                      maxLength: 80,
                      validator: GlobalValidator.validateEmail,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                _handleSendInvitation();
              },
            ).show(context);
          },
          elevation: 50,
          child: AppIcon.add,
        ),
      ),
      children: [
        // Buscador por nombre
        InputTextFormart(
          controller: _searchController,
          hintText: 'Buscar participante',
          maxLength: 50,
          prefixIcon: AppIcon.search,
          onChanged: (query) {
            setState(() {
              _searchQuery = query.trim().toLowerCase();
            });
          },
        ),
        AppSpacing.heightMedium,

        // Chips de filtro horizontal: Todos, Asociados, Colportores
        ListViewFormat(
          scrollDirection: Axis.horizontal,
          height: 38,
          itemCount: 3,
          itemBuilder: (context, index) {
            const options = ["Todos", "Asociados", "Colportores"];
            final option = options[index];
            return FilterChipFormat(
              label: option,
              isSelected: _selectedRoleFilter == option,
              onSelected: (_) {
                setState(() => _selectedRoleFilter = option);
              },
            );
          },
        ),
        AppSpacing.heightMedium,
        ListViewFormat(
          emptyMessage: _searchQuery.isEmpty
              ? "No hay participantes en esta categoría"
              : "No se encontraron resultados para '$_searchQuery'",
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final participant = filteredList[index];
            return ContainerListTile(
              onPressed: () =>
                  // Navigator.pushNamed(context, GlobalRoute.detailParticipants),
                  BottomSheetFormat(
                    title: "Detalles",
                    children: [
                      TextFormat.subtitle(
                        participant['displayName'] ?? 'Sin nombre',
                      ),
                      AppSpacing.heightMedium,
                      ContainerFormat(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormat.subtitle(
                                  "Condición: ${participant['memberCondition'] ?? 'REGULAR'}",
                                ),
                              ),
                              ButtonFormat.icon(
                                icon: AppIcon.edit,
                                onPressed: () {
                                  DialogFormat(
                                    formKey: _dialogFormKey,
                                    title: "Editar rol de participante",
                                    content: DropdownFormat<String>(
                                      validator:
                                          GlobalValidator.validateRequired,
                                      labelText: "Rol",
                                      hintText: 'Selecciona un rol',
                                      value: _selectedStatus,
                                      onChanged: (value) {
                                        setState(() => _selectedStatus = value);
                                      },
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'Colportor',
                                          child: Text('Colportor'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Asociado',
                                          child: Text('Asociado'),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      SnackBarFormat().show(
                                        context,
                                        "Participación modificada exitosamente",
                                      );
                                    },
                                  ).show(context);
                                },
                              ),
                            ],
                          ),
                          AppSpacing.heightMedium,
                          TextFormat.subtitle(
                            "Estado: ${participant['membershipStatus'] ?? 'ACTIVE'}",
                          ),
                          AppSpacing.heightMedium,
                          TextFormat.body(
                            "Email: ${participant['email'] ?? 'Sin correo'}",
                          ),
                          AppSpacing.heightSmall,
                          TextFormat.body(
                            "ID Membresía: ${participant['membershipId'] ?? ''}",
                          ),
                          AppSpacing.heightMedium,
                          TextFormat.subtitle("Documentos"),
                          AppSpacing.heightSmall,
                          ListViewFormat(
                            emptyMessage: "No hay documentos aún",
                            itemCount: 0,
                            itemBuilder: (context, index) {
                              return ContainerListTile(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  GlobalRoute.participants,
                                ),
                                title: _nameDoc[index],
                                subtitle: _typeDoc[index],
                                icon: AppIcon.document,
                              );
                            },
                          ),
                          AppSpacing.heightMedium,
                          ButtonFormat.icon(
                            icon: AppIcon.delete,
                            onPressed: () {
                              DialogFormat(
                                title: "Eiliminar campaña",
                                content: TextFormat.body(
                                  "Confirma la eliminación de la campaña",
                                ),
                                onPressed: () {
                                  SnackBarFormat().show(
                                    context,
                                    "Campaña eliminada exitosamente",
                                  );
                                  Navigator.pop(context);
                                },
                              ).show(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ).show(context),
              title: participant['displayName'] ?? '',
              subtitle:
                  participant['memberCondition'] ??
                  participant['membershipStatus'] ??
                  '',
              icon: AppIcon.person,
            );
          },
        ),
        AppSpacing.heightMedium,
      ],
    );
  }
}
