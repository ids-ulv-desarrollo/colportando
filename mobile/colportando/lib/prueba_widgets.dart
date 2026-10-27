import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/badge_format.dart';
import 'package:colportando/core/widgets/bottom_sheet_format.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/date_picker_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
import 'package:colportando/core/widgets/drawer_format.dart';
import 'package:colportando/core/widgets/dropdown_format.dart';
import 'package:colportando/core/widgets/filter_chip_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/menu_button_format.dart';
import 'package:colportando/core/widgets/qr_generator_format.dart';
import 'package:colportando/core/widgets/qr_scanner_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/skeleton_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/tab_bar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

// Modelo representativo de la estructura de datos de un usuario.
class _MockUser {
  final String name;
  final String category; // Colportor o Asociado
  final String status; // Activo o Pendiente

  const _MockUser({
    required this.name,
    required this.category,
    required this.status,
  });
}

class PruebaWidgets extends StatefulWidget {
  const PruebaWidgets({super.key});

  @override
  State<PruebaWidgets> createState() => _PruebaWidgetsState();
}

class _PruebaWidgetsState extends State<PruebaWidgets> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  int _selectedTabIndex = 0; // 0: Formulario, 1: Colportor, 2: Asociado
  String? _selectedRole;
  String _selectedStatusFilter = "Todos";
  String _searchQuery = "";
  bool _isLoading = false;

  // Datos de prueba limpios y directos
  final List<_MockUser> _allUsers = const [
    _MockUser(name: "Jose Pérez", category: "Colportor", status: "Activo"),
    _MockUser(name: "María Gómez", category: "Colportor", status: "Activo"),
    _MockUser(name: "Ana Martínez", category: "Colportor", status: "Pendiente"),
    _MockUser(name: "Carlos Ruiz", category: "Asociado", status: "Pendiente"),
    _MockUser(name: "Sofía Hernández", category: "Asociado", status: "Activo"),
  ];

  // Filtro simplificado: categoría según tab, estado y únicamente por nombre
  List<_MockUser> get _filteredUsers {
    final currentCategory = _selectedTabIndex == 1 ? "Colportor" : "Asociado";

    return _allUsers.where((user) {
      final matchesCategory = user.category == currentCategory;

      final matchesStatus =
          _selectedStatusFilter == "Todos" ||
          (_selectedStatusFilter == "Activos" && user.status == "Activo") ||
          (_selectedStatusFilter == "Pendientes" && user.status == "Pendiente");

      // Búsqueda únicamente por nombre
      final matchesSearch =
          _searchQuery.isEmpty ||
          user.name.toLowerCase().contains(_searchQuery);

      return matchesCategory && matchesStatus && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _numberController.dispose();
    _passController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Abre el selector de fecha y guarda la selección.
  Future<void> _handleSelectDate() async {
    final pickedDate = await DatePickerFormat(
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    ).show(context);

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
      if (mounted) {
        SnackBarFormat().show(
          context,
          "Fecha: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
        );
      }
    }
  }

  // Muestra el diálogo de prueba.
  void _handleShowDialog() {
    Navigator.pop(context);
    DialogFormat(
      title: "Confirmación",
      content: TextFormat.body("¿Deseas continuar?"),
      onPressed: () => SnackBarFormat().show(context, "Confirmado"),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredUsers;

    return ScaffoldFormat(
      titleAppBar: "Prueba de Widgets",
      formKey: _formKey,
      drawer: DrawerFormat(
        items: [
          DrawerItem(
            icon: AppIcon.person,
            label: "Mi Participación",
            onPressed: () => SnackBarFormat().show(context, "Mi Participación"),
          ),
          DrawerItem(
            icon: AppIcon.depositos,
            label: "Depósitos",
            onPressed: () => SnackBarFormat().show(context, "Depósitos"),
          ),
          DrawerItem(
            icon: AppIcon.capacitaciones,
            label: "Capacitaciones",
            onPressed: () => SnackBarFormat().show(context, "Capacitaciones"),
          ),
          DrawerItem(
            icon: AppIcon.apelaciones,
            label: "Apelaciones",
            onPressed: () => SnackBarFormat().show(context, "Apelaciones"),
          ),
          DrawerItem(
            icon: AppIcon.logoutOutlined,
            label: "Iniciar sesión",
            onPressed: () => Navigator.pushNamed(context, GlobalRoute.signin),
          ),
          DrawerItem(
            icon: AppIcon.notifications,
            label: "Notificaciones",
            onPressed: () =>
                Navigator.pushNamed(context, GlobalRoute.notifications),
          ),
        ],
      ),
      onRefresh: () async {
        setState(() => _isLoading = true);
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) setState(() => _isLoading = false);
      },
      actions: [
        ButtonFormat.icon(icon: AppIcon.calendar, onPressed: _handleSelectDate),
        // Botón interactivo para probar SkeletonFormat
        ButtonFormat.icon(
          icon: _isLoading ? AppIcon.visibilityOff : AppIcon.visibility,
          onPressed: () {
            setState(() => _isLoading = !_isLoading);
            SnackBarFormat().show(
              context,
              _isLoading ? "Skeleton activado" : "Skeleton desactivado",
            );
          },
        ),
        const BadgeFormat(unreadCount: 3),
        MenuButtonFormat(
          items: [
            MenuItemModel(
              value: "ajustes",
              icon: AppIcon.edit,
              text: "Ajustes",
            ),
            MenuItemModel(
              value: "salir",
              icon: AppIcon.logoutOutlined,
              text: "Cerrar sesión",
            ),
            MenuItemModel(
              value: "cancelar",
              icon: AppIcon.cancel,
              text: "Cancelar",
            ),
          ],
          onSelected: (value) {
            SnackBarFormat().show(context, "Opción seleccionada: $value");
          },
        ),
      ],
      children: [
        // Selector de pestañas superiores: Formulario, Colportor, Asociado
        TabBarFormat(
          labels: const ["Formulario", "Colportor", "Asociado"],
          selectedIndex: _selectedTabIndex,
          onTabSelected: (index) {
            setState(() => _selectedTabIndex = index);
          },
        ),

        AppSpacing.heightMedium,

        // Lista horizontal con ListViewFormat (mantenida siempre arriba)
        ListViewFormat(
          scrollDirection: Axis.horizontal,
          itemCount: 8,
          itemBuilder: (context, index) {
            return ContainerFormat(
              width: 100,
              onPressed: () {
                SnackBarFormat().show(context, "Clic en Item ${index + 1}");
              },
              children: [Center(child: TextFormat.body("Item ${index + 1}"))],
            );
          },
        ),

        AppSpacing.heightMedium,

        // Contenido condicional según la pestaña seleccionada
        if (_selectedTabIndex == 0) ...[
          // Pestaña Formulario
          SkeletonFormat(
            isLoading: _isLoading,
            child: ContainerFormat(
              children: [
                TextFormat.subtitle("Formulario de prueba"),
                Padding(
                  padding: AppSpacing.paddingSymetric0_16,
                  child: TextFormat.bodySecondary(
                    "Ejemplo sencillo de campos de texto y selector desplegable.",
                  ),
                ),
                // Selector desplegable (DropdownFormat)
                DropdownFormat<String>(
                  labelText: "Categoría",
                  hintText: "Selecciona una opción",
                  prefixIcon: AppIcon.person,
                  value: _selectedRole,
                  validator: GlobalValidator.validateRequired,
                  items: const [
                    DropdownMenuItem(
                      value: "colportor",
                      child: Text("Colportor"),
                    ),
                    DropdownMenuItem(
                      value: "asociado",
                      child: Text("Asociado"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() => _selectedRole = val);
                  },
                ),
                AppSpacing.heightMedium,
                InputTextFormart(
                  prefixIcon: AppIcon.home,
                  validator: GlobalValidator.validateRequired,
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  labelText: "Descripción",
                  hintText:
                      "Ej. Pueden probar con más ejemplos, solo les coloqué algunos.",
                  maxLength: 100,
                  minLines: 2,
                  maxLines: 4,
                ),
                AppSpacing.heightMedium,
                InputTextFormart(
                  prefixIcon: AppIcon.calendar,
                  validator: GlobalValidator.validateNumber,
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  labelText: "Número",
                  hintText: "Ej. 123456",
                  maxLength: 30,
                ),
                AppSpacing.heightMedium,
                InputTextFormart(
                  prefixIcon: AppIcon.password,
                  validator: GlobalValidator.validatePassword,
                  controller: _passController,
                  keyboardType: TextInputType.text,
                  labelText: "Contraseña",
                  hintText: "Ej. Aa12345%",
                  maxLength: 50,
                ),
                AppSpacing.heightMedium,
                ButtonFormat.primary(
                  formKey: _formKey,
                  label: "Validar Formulario",
                  onPressed: () => SnackBarFormat().show(
                    context,
                    "Formulario válido: \n ${_descriptionController.text} \n ${_passController.text} \n ${_numberController.text}",
                  ),
                ),
                AppSpacing.heightMedium,
                ButtonFormat.text(
                  label: "Abrir BottomSheet",
                  onPressed: () {
                    BottomSheetFormat(
                      title: "Opciones",
                      children: [
                        TextFormat.body(
                          "Contenido necesario en bottomsheet. Pueden colocar la cantidad de contenido que deseen, tiene scroll.",
                        ),
                        AppSpacing.heightMedium,
                        ButtonFormat.text(
                          label: "Escanear QR",
                          onPressed: () async {
                            // Cierra el sheet para que el SnackBar quede visible.
                            Navigator.pop(context);
                            final code = await const QrScannerFormat(
                              title: "Escanear Asistencia",
                              label: "Apunta al código QR de la sesión",
                            ).show(context);
                            if (code != null && context.mounted) {
                              SnackBarFormat().show(
                                context,
                                "Asistencia registrada: $code",
                              );
                            }
                          },
                        ),
                        AppSpacing.heightMedium,
                        ButtonFormat.text(
                          label: "Ver QR",
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => const Dialog(
                                child: Padding(
                                  padding: AppSpacing.paddingMedium,
                                  child: QrGeneratorFormat(
                                    data: "ASISTENCIA-COLPORTANDO-2026",
                                    title: "Pase de Lista",
                                    subtitle:
                                        "Escanea para registrar asistencia",
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        AppSpacing.heightMedium,
                        const InputTextFormart(
                          hintText: "Prueba de texto dinámico",
                          maxLength: 50,
                        ),
                        AppSpacing.heightMedium,
                        ButtonFormat.text(
                          label: "Abrir Diálogo",
                          onPressed: _handleShowDialog,
                        ),
                      ],
                    ).show(context);
                  },
                ),
              ],
            ),
          ),
        ] else ...[
          // Pestañas colportor o asociado. Buscador únicamente por nombre (InputTextFormart con onChanged)
          InputTextFormart(
            controller: _searchController,
            prefixIcon: AppIcon.search,
            hintText: "Buscar por nombre...",
            maxLength: 50,
            onChanged: (query) {
              setState(() {
                _searchQuery = query.trim().toLowerCase();
              });
            },
          ),

          AppSpacing.heightMedium,

          // Chips de estado (ListViewFormat horizontal)
          ListViewFormat(
            scrollDirection: Axis.horizontal,
            height: 38,
            itemCount: 3,
            itemBuilder: (context, index) {
              const options = ["Todos", "Activos", "Pendientes"];
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

          AppSpacing.heightMedium,

          // Lista de usuarios con SkeletonFormat y ListViewFormat
          SkeletonFormat(
            isLoading: _isLoading,
            child: ListViewFormat(
              itemCount: filteredList.length,
              emptyMessage:
                  "No se encontraron resultados para '$_searchQuery'.",
              emptyWidget: AppIcon.noAccounts,
              itemBuilder: (context, index) {
                final user = filteredList[index];
                return ContainerListTile(
                  onTap: () => SnackBarFormat().show(
                    context,
                    "Solo usar con el ícono arrowRight",
                  ),
                  icon: AppIcon.person,
                  title: user.name,
                  subtitle: "${user.category} • ${user.status}",

                  trailing: MenuButtonFormat(
                    items: [
                      MenuItemModel(value: "ver", text: "Ver detalle"),
                      MenuItemModel(value: "editar", text: "Editar"),
                    ],
                    onSelected: (val) {
                      SnackBarFormat().show(context, "$val: ${user.name}");
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
