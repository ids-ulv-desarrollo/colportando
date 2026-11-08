import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/bottom_sheet_format.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/dropdown_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/groups/presentation/riverpod/groups_riverpod.dart';
import 'package:colportando/features/groups/presentation/screens/detail_groups_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllGroupsScreen extends ConsumerWidget {
  const AllGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsProvider);

    return ScaffoldFormat(
      titleAppBar: "Grupos",
      children: [
        ButtonFormat.primary(
          label: "Crear zona",
          onPressed: () => const BottomSheetFormat.content(
            _CreateZoneForm(),
            title: "Nueva zona",
          ).show(context),
        ),
        AppSpacing.heightSmall,
        ButtonFormat.secondary(
          label: "Ver zonas",
          onPressed: () => const BottomSheetFormat.content(
            _ZonesList(),
            title: "Zonas creadas",
          ).show(context),
        ),
        AppSpacing.heightMedium,
        ButtonFormat.primary(
          label: "Crear grupo",
          onPressed: () => const BottomSheetFormat.content(
            _CreateGroupForm(),
            title: "Nuevo grupo",
          ).show(context),
        ),
        AppSpacing.heightMedium,
        TextFormat.subtitle("Grupos creados"),
        AppSpacing.heightSmall,
        ListViewFormat(
          itemCount: groups.length,
          emptyWidget: AppIcon.noAccounts,
          emptyMessage: "Aún no hay grupos creados.",
          itemBuilder: (context, index) {
            final group = groups[index];
            return ContainerListTile(
              title: group.name,
              subtitle: group.assignedZone,
              subsubtitle: TextFormat.label(
                "${group.colporters.length} colportores",
              ),
              icon: AppIcon.grupos,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailGroupsScreen(groupId: group.id),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ZonesList extends ConsumerWidget {
  const _ZonesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zones = ref.watch(zonesProvider);

    return ListViewFormat(
      itemCount: zones.length,
      emptyWidget: AppIcon.campos,
      emptyMessage: "Aún no hay zonas creadas.",
      itemBuilder: (context, index) {
        final zone = zones[index];
        return ContainerListTile(
          title: zone.name,
          subtitle: "Fecha de creación: ${zone.formattedCreatedAt}",
          icon: AppIcon.campos,
        );
      },
    );
  }
}

class _CreateZoneForm extends ConsumerStatefulWidget {
  const _CreateZoneForm();

  @override
  ConsumerState<_CreateZoneForm> createState() => _CreateZoneFormState();
}

class _CreateZoneFormState extends ConsumerState<_CreateZoneForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputTextFormart(
            labelText: "Nombre de la zona",
            hintText: "Escribe el nombre de la zona",
            controller: _nameController,
            maxLength: 80,
            validator: (value) => value == null || value.trim().isEmpty
                ? "Escribe el nombre de la zona"
                : null,
          ),
          AppSpacing.heightMedium,
          ButtonFormat.primary(label: "Guardar zona", onPressed: _createZone),
          ButtonFormat.secondary(
            label: "Cancelar",
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _createZone() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final created = ref
        .read(zonesProvider.notifier)
        .createZone(_nameController.text);
    if (!created) {
      SnackBarFormat().show(
        context,
        "Ya existe una zona con ese nombre.",
        isError: true,
      );
      return;
    }

    Navigator.pop(context);
  }
}

class _CreateGroupForm extends ConsumerStatefulWidget {
  const _CreateGroupForm();

  @override
  ConsumerState<_CreateGroupForm> createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends ConsumerState<_CreateGroupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _assignedZone;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zones = ref.watch(zonesProvider);
    final zoneNames = zones.isEmpty
        ? ["Sin zona"]
        : zones.map((zone) => zone.name).toList();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputTextFormart(
            labelText: "Nombre del grupo",
            hintText: "Escribe el nombre del grupo",
            controller: _nameController,
            maxLength: 80,
            validator: (value) => value == null || value.trim().isEmpty
                ? "Escribe el nombre del grupo"
                : null,
          ),
          AppSpacing.heightMedium,
          DropdownFormat<String>(
            value: _assignedZone,
            labelText: "Zona asignada",
            items: [
              for (final zoneName in zoneNames)
                DropdownMenuItem(
                  value: zoneName,
                  child: TextFormat.bodySecondary(zoneName),
                ),
            ],
            validator: (value) => value == null ? "Selecciona una zona" : null,
            onChanged: (value) => setState(() => _assignedZone = value),
          ),
          AppSpacing.heightMedium,
          ButtonFormat.primary(label: "Guardar grupo", onPressed: _createGroup),
          ButtonFormat.secondary(
            label: "Cancelar",
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _createGroup() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    ref
        .read(groupsProvider.notifier)
        .createGroup(name: _nameController.text, assignedZone: _assignedZone!);
    Navigator.pop(context);
  }
}
