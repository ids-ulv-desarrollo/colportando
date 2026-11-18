import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/utils/global_validator.dart';
import 'package:colportando/core/widgets/badge_format.dart';
import 'package:colportando/core/widgets/bottom_sheet_format.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/checkbox_format.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/date_picker_format.dart';
import 'package:colportando/core/widgets/dialog_format.dart';
import 'package:colportando/core/widgets/dropdown_format.dart';
import 'package:colportando/core/widgets/file_upload_format.dart';
import 'package:colportando/core/widgets/filter_chip_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/menu_button_format.dart';
import 'package:colportando/core/widgets/qr_generator_format.dart';
import 'package:colportando/core/widgets/qr_scanner_format.dart';
import 'package:colportando/core/widgets/quantity_selector_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/skeleton_format.dart';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:colportando/core/widgets/tab_bar_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:colportando/features/workspace/presentation/riverpod/workspace_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class PruebaWidgets extends ConsumerStatefulWidget {
  const PruebaWidgets({super.key});

  @override
  ConsumerState<PruebaWidgets> createState() => _PruebaWidgetsState();
}

class _PruebaWidgetsState extends ConsumerState<PruebaWidgets> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controladores de texto para pruebas de endpoints de Auth.
  final TextEditingController _authEmailController = TextEditingController(
    text: "proyectos_ids@ulv.edu.mx",
  );
  final TextEditingController _authClubIdController = TextEditingController();
  final TextEditingController _authPasswordController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();
  final TextEditingController _authGivenNamesController = TextEditingController(
    text: "Juan",
  );
  final TextEditingController _authFamilyNameController = TextEditingController(
    text: "Pérez",
  );

  DateTime? _selectedDate;
  int _selectedTabIndex = 0; // 0: Formulario, 1: Colportor, 2: Endpoints
  String? _selectedRole;
  String _selectedStatusFilter = "Todos";
  String _searchQuery = "";
  bool _isLoading = false;
  String? _uploadedFileName;

  final List<_MockUser> _users = const [
    _MockUser(name: "Ana García", category: "Colportor", status: "Activo"),
    _MockUser(name: "Carlos López", category: "Colportor", status: "Pendiente"),
    _MockUser(
      name: "Daniela Martínez",
      category: "Colportor",
      status: "Activo",
    ),
    _MockUser(
      name: "Eduardo Hernández",
      category: "Colportor",
      status: "Pendiente",
    ),
    _MockUser(
      name: "Fernanda Castillo",
      category: "Colportor",
      status: "Activo",
    ),
    _MockUser(
      name: "Gabriela Morales",
      category: "Colportor",
      status: "Activo",
    ),
    _MockUser(
      name: "Héctor Ramírez",
      category: "Colportor",
      status: "Pendiente",
    ),
    _MockUser(name: "Isabel Torres", category: "Colportor", status: "Activo"),
    _MockUser(name: "Jorge Vargas", category: "Colportor", status: "Activo"),
    _MockUser(
      name: "Karla Mendoza",
      category: "Colportor",
      status: "Pendiente",
    ),
    _MockUser(name: "Luis Navarro", category: "Colportor", status: "Activo"),
    _MockUser(name: "Mariana Ríos", category: "Colportor", status: "Activo"),
    _MockUser(name: "Néstor Ortiz", category: "Colportor", status: "Pendiente"),
    _MockUser(name: "Olga Paredes", category: "Colportor", status: "Activo"),
    _MockUser(name: "Pedro Salazar", category: "Colportor", status: "Activo"),
    _MockUser(name: "Rosa Medina", category: "Colportor", status: "Pendiente"),
    _MockUser(name: "Sergio Castro", category: "Colportor", status: "Activo"),
    _MockUser(name: "Tania Cruz", category: "Colportor", status: "Activo"),
    _MockUser(
      name: "Ulises Guzmán",
      category: "Colportor",
      status: "Pendiente",
    ),
    _MockUser(name: "Valeria Soto", category: "Colportor", status: "Activo"),
  ];

  @override
  void dispose() {
    _numberController.dispose();
    _passController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    _authEmailController.dispose();
    _authClubIdController.dispose();
    _authPasswordController.dispose();
    _authCodeController.dispose();
    _authGivenNamesController.dispose();
    _authFamilyNameController.dispose();
    super.dispose();
  }

  // Filtra por pestaña y búsqueda de texto.
  List<_MockUser> get _filteredUsers {
    return _users.where((user) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          user.name.toLowerCase().contains(_searchQuery);
      final matchesStatus = switch (_selectedStatusFilter) {
        "Activos" => user.status == "Activo",
        "Pendientes" => user.status == "Pendiente",
        _ => true,
      };
      return matchesSearch && matchesStatus;
    }).toList();
  }

  // Abre el selector de fecha y actualiza el estado.
  Future<void> _handleSelectDate() async {
    final pickedDate = await DatePickerFormat(
      firstDate: DateTime(2020),
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
    final authState = ref.watch(authProvider);
    final workspaceState = ref.watch(workspaceProvider);

    // Muestra notificaciones cuando el estado de autenticación reporte errores.
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        SnackBarFormat().show(context, next.errorMessage!, isError: true);
      }
    });

    // Muestra notificaciones cuando el estado de workspace reporte errores.
    ref.listen<WorkspaceState>(workspaceProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        SnackBarFormat().show(context, next.errorMessage!, isError: true);
      }
    });

    return ScaffoldFormat(
      titleAppBar: "Prueba de Widgets",
      formKey: _formKey,
      onRefresh: () async {
        setState(() => _isLoading = true);
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) setState(() => _isLoading = false);
      },
      actions: [
        ButtonFormat.icon(icon: AppIcon.calendar, onPressed: _handleSelectDate),
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
              value: "settings",
              icon: AppIcon.edit,
              text: "Ajustes",
            ),
            MenuItemModel(
              value: "signin",
              icon: AppIcon.logoutOutlined,
              text: "Iniciar sesión",
            ),
            MenuItemModel(
              value: "cancel",
              icon: AppIcon.cancel,
              text: "Cancelar",
            ),
          ],
          onSelected: (value) {
            if (value == "signin") {
              Navigator.pushNamed(context, GlobalRoute.signin);
            }
            SnackBarFormat().show(context, "Opción seleccionada: $value");
          },
        ),
      ],
      children: [
        // Selector de pestañas: Formulario, Colportor, Endpoints Auth
        TabBarFormat(
          labels: const ["Formulario", "Colportor", "Endpoints"],
          selectedIndex: _selectedTabIndex,
          onTabSelected: (index) {
            setState(() => _selectedTabIndex = index);
          },
        ),

        AppSpacing.heightMedium,

        if (_selectedTabIndex == 0) ...[
          // Pestaña Formulario
          ListViewFormat(
            scrollDirection: Axis.horizontal,
            itemCount: 8,
            height: 48,
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
          InputTextFormart(
            controller: _numberController,
            prefixIcon: AppIcon.person,
            labelText: "Número",
            hintText: "Ej. 42",
            maxLength: 5,
            keyboardType: TextInputType.number,
            validator: GlobalValidator.validateNumber,
          ),
          AppSpacing.heightMedium,
          InputTextFormart(
            controller: _passController,
            prefixIcon: AppIcon.password,
            labelText: "Contraseña",
            hintText: "Ingresa tu contraseña",
            maxLength: 50,
          ),
          AppSpacing.heightMedium,
          DropdownFormat<String>(
            hintText: "Selecciona un rol",
            value: _selectedRole,
            items: ["Administrador", "Usuario", "Invitado"]
                .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                .toList(),
            onChanged: (value) => setState(() => _selectedRole = value),
            validator: (value) => GlobalValidator.validateRequired(value),
          ),
          AppSpacing.heightMedium,
          InputTextFormart(
            controller: _descriptionController,
            prefixIcon: AppIcon.home,
            hintText: "Descripción amplia del problema...",
            maxLength: 200,
            maxLines: 4,
          ),
          AppSpacing.heightMedium,
          QuantitySelectorFormat(
            value: 1,
            onChanged: (quantity) {
              SnackBarFormat().show(context, "Cantidad: $quantity");
            },
          ),
          AppSpacing.heightMedium,
          ContainerFormat(
            children: [
              ButtonFormat.primary(
                label: "Botón primario",
                formKey: _formKey,
                onPressed: () {
                  SnackBarFormat().show(
                    context,
                    "Formulario validado con éxito",
                  );
                },
              ),
              AppSpacing.heightMedium,
              FileUploadFormat(
                label: "Subir comprobante",
                fileName: _uploadedFileName,
                onFileSelected: (path) {
                  final name = path.split(RegExp(r'[\\/]')).last;
                  setState(() => _uploadedFileName = name);
                  SnackBarFormat().show(context, "Archivo: $name");
                },
                onRemove: () => setState(() => _uploadedFileName = null),
              ),
              AppSpacing.heightMedium,
              ButtonFormat.secondary(
                label: "Botón secundario",
                onPressed: () {},
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
                                  subtitle: "Escanea para registrar asistencia",
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
                      const CheckboxFormat(
                        text: "Acepto términos y condiciones",
                      ),
                    ],
                  ).show(context);
                },
              ),
            ],
          ),
        ] else if (_selectedTabIndex == 1) ...[
          // Pestaña Colportor
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
                  icon: AppIcon.person,
                  title: user.name,
                  subtitle: "Rol: ${user.category}",
                  subsubtitle: "Estado: ${user.status}",
                  expandedChild: [
                    AppSpacing.heightSmall,
                    TextFormat.bodySecondary(
                      "Detalles: ${user.name} se encuentra ${user.status.toLowerCase()}.",
                    ),
                    AppSpacing.heightSmall,
                    ButtonFormat.text(
                      label: "Ver detalle",
                      onPressed: () => SnackBarFormat().show(
                        context,
                        "Detalle: ${user.name}",
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ] else ...[
          // Pestaña Endpoints: Ejecución directa de los endpoints de Auth mediante Riverpod
          ContainerFormat(
            children: [
              TextFormat.subtitle("Sesión Actual"),
              AppSpacing.heightSmall,
              TextFormat.body(
                authState.isAuthenticated
                    ? "Usuario: ${authState.user?.email} (${authState.user?.id})"
                    : "Estado: No autenticado",
              ),
            ],
          ),
          AppSpacing.heightMedium,
          InputTextFormart(
            controller: _authEmailController,
            prefixIcon: AppIcon.email,
            labelText: "Correo Electrónico",
            hintText: "correo@ejemplo.com",
            maxLength: 100,
          ),
          AppSpacing.heightSmall,
          InputTextFormart(
            controller: _authPasswordController,
            prefixIcon: AppIcon.password,
            labelText: "Contraseña",
            hintText: "••••••••",
            maxLength: 50,
          ),
          AppSpacing.heightSmall,
          InputTextFormart(
            controller: _authCodeController,
            prefixIcon: AppIcon.doneAll,
            labelText: "Código (8 dígitos)",
            hintText: "12345678",
            maxLength: 15,
          ),
          AppSpacing.heightSmall,
          InputTextFormart(
            controller: _authClubIdController,
            prefixIcon: AppIcon.home,
            labelText: "Club ID (UUID para invitación)",
            hintText: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            maxLength: 50,
          ),
          AppSpacing.heightMedium,

          // Iniciar Sesión (POST /auth/login)
          ButtonFormat.primary(
            label: "1. Iniciar Sesión (/auth/login)",
            isLoading: authState.isLoading,
            onPressed: () async {
              await ref
                  .read(authProvider.notifier)
                  .login(
                    email: _authEmailController.text.trim(),
                    password: _authPasswordController.text.trim(),
                  );
              if (context.mounted && ref.read(authProvider).isAuthenticated) {
                SnackBarFormat().show(context, "Sesión iniciada correctamente");
              }
            },
          ),
          AppSpacing.heightSmall,

          // Consultar Usuario (GET /auth/me)
          ButtonFormat.secondary(
            label: "2. Obtener Perfil (/auth/me)",
            onPressed: () async {
              await ref.read(authProvider.notifier).getMe();
              if (context.mounted && ref.read(authProvider).user != null) {
                final u = ref.read(authProvider).user!;
                SnackBarFormat().show(
                  context,
                  "Perfil: ${u.email} (${u.status})",
                );
              }
            },
          ),
          AppSpacing.heightSmall,

          // Renovar Sesión (POST /auth/refresh)
          ButtonFormat.secondary(
            label: "3. Renovar Token (/auth/refresh)",
            onPressed: () async {
              final ok = await ref.read(authProvider.notifier).refreshSession();
              if (context.mounted && ok) {
                SnackBarFormat().show(context, "Token renovado con éxito");
              }
            },
          ),
          AppSpacing.heightSmall,

          // Solicitar Verificación de Email (POST /auth/email-verification/request)
          ButtonFormat.secondary(
            label: "4. Solicitar Verif. Email",
            onPressed: () async {
              final ok = await ref
                  .read(authProvider.notifier)
                  .requestEmailVerification(
                    email: _authEmailController.text.trim(),
                  );
              if (context.mounted && ok) {
                SnackBarFormat().show(
                  context,
                  "Código de verificación solicitado",
                );
              }
            },
          ),
          AppSpacing.heightSmall,

          // Confirmar Verificación de Email (POST /auth/email-verification/confirm)
          ButtonFormat.secondary(
            label: "5. Confirmar Verif. Email",
            onPressed: () async {
              final ok = await ref
                  .read(authProvider.notifier)
                  .confirmEmailVerification(
                    email: _authEmailController.text.trim(),
                    code: _authCodeController.text.trim(),
                  );
              if (context.mounted && ok) {
                SnackBarFormat().show(
                  context,
                  "Email verificado correctamente",
                );
              }
            },
          ),
          AppSpacing.heightSmall,

          // Solicitar Restablecer Contraseña (POST /auth/password-reset/request)
          ButtonFormat.secondary(
            label: "6. Solicitar Reset Contraseña",
            onPressed: () async {
              final ok = await ref
                  .read(authProvider.notifier)
                  .requestPasswordReset(
                    email: _authEmailController.text.trim(),
                  );
              if (context.mounted && ok) {
                SnackBarFormat().show(context, "Código de reset solicitado");
              }
            },
          ),
          AppSpacing.heightSmall,

          // Confirmar Restablecer Contraseña (POST /auth/password-reset/confirm)
          ButtonFormat.secondary(
            label: "7. Confirmar Reset Contraseña",
            onPressed: () async {
              final ok = await ref
                  .read(authProvider.notifier)
                  .confirmPasswordReset(
                    email: _authEmailController.text.trim(),
                    code: _authCodeController.text.trim(),
                    newPassword: _authPasswordController.text.trim(),
                  );
              if (context.mounted && ok) {
                SnackBarFormat().show(context, "Contraseña cambiada con éxito");
              }
            },
          ),
          AppSpacing.heightSmall,

          // Inspeccionar Invitación de Club (POST /auth/invitations/inspect)
          ButtonFormat.secondary(
            label: "8. Inspeccionar Invitación (/invitations/inspect)",
            onPressed: () async {
              final info = await ref
                  .read(authProvider.notifier)
                  .inspectInvitation(
                    email: _authEmailController.text.trim(),
                    code: _authCodeController.text.trim(),
                  );
              if (context.mounted && info != null) {
                SnackBarFormat().show(
                  context,
                  "Club: ${info['clubName']} | Institución: ${info['institutionName']}",
                );
              }
            },
          ),
          AppSpacing.heightSmall,

          // Aceptar Invitación de Club (POST /auth/invitations/accept)
          ButtonFormat.secondary(
            label: "9. Aceptar Invitación (/invitations/accept)",
            onPressed: () async {
              final info = await ref
                  .read(authProvider.notifier)
                  .acceptInvitation(
                    email: _authEmailController.text.trim(),
                    code: _authCodeController.text.trim(),
                    password: _authPasswordController.text.trim(),
                    givenNames: _authGivenNamesController.text.trim(),
                    familyName: _authFamilyNameController.text.trim(),
                  );
              if (context.mounted && info != null) {
                SnackBarFormat().show(context, "Invitación aceptada con éxito");
              }
            },
          ),
          AppSpacing.heightSmall,

          // Crear Invitación (POST /auth/invitations)
          ButtonFormat.secondary(
            label: "10. Crear Invitación (/auth/invitations)",
            onPressed: () async {
              final info = await ref
                  .read(authProvider.notifier)
                  .createInvitation(
                    clubId: _authClubIdController.text.trim(),
                    // email: _authEmailController.text.trim(),
                    email: "jonathan.juarez@ulv.edu.mx",
                  );
              if (context.mounted && info != null) {
                SnackBarFormat().show(
                  context,
                  "Invitación creada: ${info['invitationId']}",
                );
              }
            },
          ),
          AppSpacing.heightSmall,

          // Cerrar Sesión (POST /auth/logout)
          ButtonFormat.text(
            label: "11. Cerrar Sesión (/auth/logout)",
            onPressed: () async {
              await ref.read(authProvider.notifier).signOut();
              if (context.mounted) {
                SnackBarFormat().show(context, "Sesión cerrada");
              }
            },
          ),
          AppSpacing.heightMedium,

          // Sección de pruebas de Workspace
          ContainerFormat(
            children: [
              TextFormat.subtitle("Workspace Actual"),
              AppSpacing.heightSmall,
              TextFormat.body(
                workspaceState.workspace != null &&
                        workspaceState.workspace!.clubs.isNotEmpty
                    ? "Club: ${workspaceState.workspace!.clubs.first.clubName} (${workspaceState.workspace!.clubs.first.clubId})"
                    : "Workspace: Sin cargar",
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // Obtener Contexto (GET /workspace/context)
          ButtonFormat.primary(
            label: "W1. Obtener Contexto (/workspace/context)",
            isLoading: workspaceState.isLoading,
            onPressed: () async {
              await ref.read(workspaceProvider.notifier).getContext();
              final ws = ref.read(workspaceProvider).workspace;
              if (ws != null && ws.clubs.isNotEmpty) {
                _authClubIdController.text = ws.clubs.first.clubId;
                if (context.mounted) {
                  SnackBarFormat().show(
                    context,
                    "Club activo: ${ws.clubs.first.clubName}",
                  );
                }
              }
            },
          ),
          AppSpacing.heightSmall,

          // Listar Membresías (GET /workspace/clubs/{clubId}/memberships)
          ButtonFormat.secondary(
            label: "W2. Membresías del Club (/memberships)",
            onPressed: () async {
              final data = await ref
                  .read(workspaceProvider.notifier)
                  .listClubMemberships(
                    clubId: _authClubIdController.text.trim(),
                  );
              if (context.mounted && data != null) {
                SnackBarFormat().show(
                  context,
                  "Total miembros: ${data['total']}",
                );
              }
            },
          ),
          AppSpacing.heightSmall,

          // Listar Campañas (GET /workspace/clubs/{clubId}/campaigns)
          ButtonFormat.secondary(
            label: "W3. Campañas del Club (/campaigns)",
            onPressed: () async {
              final data = await ref
                  .read(workspaceProvider.notifier)
                  .listClubCampaigns(clubId: _authClubIdController.text.trim());
              if (context.mounted && data != null) {
                SnackBarFormat().show(
                  context,
                  "Total campañas: ${data['total']}",
                );
              }
            },
          ),
          AppSpacing.heightSmall,

          // Listar Grupos de Campaña (GET /workspace/campaigns/{campaignId}/groups)
          ButtonFormat.secondary(
            label: "W4. Grupos de Campaña (/campaigns/{id}/groups)",
            onPressed: () async {
              final data = await ref
                  .read(workspaceProvider.notifier)
                  .listCampaignGroups(
                    campaignId: _authCodeController.text.trim(),
                  );
              if (context.mounted && data != null) {
                SnackBarFormat().show(
                  context,
                  "Total grupos: ${data['total']}",
                );
              }
            },
          ),
          AppSpacing.heightSmall,

          // Listar Programas de Capacitación (GET /workspace/clubs/{clubId}/training-programs)
          ButtonFormat.secondary(
            label: "W5. Programas Capacitación (/training-programs)",
            onPressed: () async {
              final data = await ref
                  .read(workspaceProvider.notifier)
                  .listClubTrainingPrograms(
                    clubId: _authClubIdController.text.trim(),
                  );
              if (context.mounted && data != null) {
                SnackBarFormat().show(
                  context,
                  "Total programas: ${data['total']}",
                );
              }
            },
          ),
          AppSpacing.heightSmall,

          // Listar Roles del Club (GET /workspace/clubs/{clubId}/roles)
          ButtonFormat.secondary(
            label: "W6. Roles del Club (/roles)",
            onPressed: () async {
              final roles = await ref
                  .read(workspaceProvider.notifier)
                  .listClubRoles(clubId: _authClubIdController.text.trim());
              if (context.mounted && roles != null) {
                SnackBarFormat().show(
                  context,
                  "Roles disponibles: ${roles.length}",
                );
              }
            },
          ),
          AppSpacing.heightSmall,

          // Asignar Rol (POST /workspace/clubs/{clubId}/access-assignments)
          ButtonFormat.secondary(
            label: "W7. Asignar Rol (/access-assignments)",
            onPressed: () async {
              final accountId =
                  ref.read(authProvider).user?.id ??
                  _authCodeController.text.trim();
              final data = await ref
                  .read(workspaceProvider.notifier)
                  .assignClubRole(
                    clubId: _authClubIdController.text.trim(),
                    accountId: accountId,
                    roleCode: "TRAINING_COORDINATOR",
                    reason: "Asignación desde móvil",
                  );
              if (context.mounted && data != null) {
                SnackBarFormat().show(
                  context,
                  "Asignación: ${data['accessAssignmentId']}",
                );
              }
            },
          ),
          AppSpacing.heightSmall,

          // Revocar Rol (POST /workspace/access-assignments/{id}/revoke)
          ButtonFormat.secondary(
            label: "W8. Revocar Rol (/access-assignments/{id}/revoke)",
            onPressed: () async {
              final data = await ref
                  .read(workspaceProvider.notifier)
                  .revokeAccessAssignment(
                    accessAssignmentId: _authCodeController.text.trim(),
                    reason: "Revocación desde móvil",
                  );
              if (context.mounted && data != null) {
                SnackBarFormat().show(
                  context,
                  "Estado: ${data['status']}",
                );
              }
            },
          ),
          AppSpacing.heightMedium,
        ],
      ],
    );
  }
}
