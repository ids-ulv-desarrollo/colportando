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
import 'package:flutter/material.dart';

// Modelo representativo de participante basado en prueba_widgets.dart
class _Participant {
  final String name;
  final String role; // "Asociado" o "Colportor"

  const _Participant({required this.name, required this.role});
}

// Pantalla de participantes asignados a la campaña o zona.
class ParticipantsScreen extends StatefulWidget {
  const ParticipantsScreen({super.key});

  @override
  State<ParticipantsScreen> createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  String? _selectedStatus;
  final List<String> _nameDoc = ["Doc 1", "Doc 2"];
  final List<String> _typeDoc = [
    "Carta de recomendación",
    "Certificado de bautizmo",
  ];
  final TextEditingController _searchController = TextEditingController();
  String _selectedRoleFilter = "Todos";
  String _searchQuery = "";

  // Lista base de participantes
  final List<_Participant> _allParticipants = const [
    _Participant(name: "Moisés Martínez", role: "Asociado"),
    _Participant(name: "Itiel Alvarez", role: "Colportor"),
    _Participant(name: "Jair Lopez", role: "Asociado"),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtro reactivo para ListViewFormat basado en prueba_widgets.dart
  List<_Participant> get _filteredParticipants {
    return _allParticipants.where((participant) {
      // 1. Filtro por rol (Todos, Asociados o Colportores)
      final matchesRole =
          _selectedRoleFilter == "Todos" ||
          (_selectedRoleFilter == "Asociados" &&
              participant.role == "Asociado") ||
          (_selectedRoleFilter == "Colportores" &&
              participant.role == "Colportor");

      // 2. Filtro por búsqueda de nombre
      final matchesSearch =
          _searchQuery.isEmpty ||
          participant.name.toLowerCase().contains(_searchQuery);

      return matchesRole && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredParticipants;

    return ScaffoldFormat(
      formKey: _formKey,
      titleAppBar: "Participantes",
      isLoading: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, GlobalRoute.addParticipants),
        elevation: 50,
        child: AppIcon.add,
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
                      TextFormat.subtitle('Nombre del participante'),
                      AppSpacing.heightMedium,
                      ContainerFormat(
                        children: [
                          Row(
                            children: [
                              Expanded(child: TextFormat.subtitle("Tipo")),
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
                                      //Navigator.pop(context);
                                    },
                                  ).show(context);
                                },
                              ),
                            ],
                          ),
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
              title: participant.name,
              subtitle: participant.role,
              icon: AppIcon.person,
            );
          },
        ),
        AppSpacing.heightMedium,
      ],
    );
  }
}
