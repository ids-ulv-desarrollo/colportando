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
import 'package:colportando/features/campaigns/presentation/riverpod/campaign_riverpod.dart';
import 'package:colportando/features/catalog/presentation/riverpod/catalog_riverpod.dart';
import 'package:colportando/features/trainings/presentation/riverpod/training_riverpod.dart';
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

  // Controladores de texto para pruebas de Workspace.
  final TextEditingController _wsClubIdController = TextEditingController();
  final TextEditingController _wsCampaignIdController = TextEditingController();
  final TextEditingController _wsAccountIdController = TextEditingController();
  final TextEditingController _wsRoleCodeController = TextEditingController(
    text: "TRAINING_COORDINATOR",
  );
  final TextEditingController _wsReasonController = TextEditingController(
    text: "Asignación desde app móvil",
  );
  final TextEditingController _wsAccessAssignmentIdController =
      TextEditingController();

  // Controladores de texto para pruebas de Catálogos y Materiales.
  final TextEditingController _materialClubIdController =
      TextEditingController();
  final TextEditingController _materialCodeController = TextEditingController(
    text: "LIB-001",
  );
  final TextEditingController _materialNameController = TextEditingController(
    text: "El Deseado de Todas las Gentes",
  );
  final TextEditingController _materialCategoryController =
      TextEditingController(text: "Libros");
  final TextEditingController _materialDescController = TextEditingController(
    text: "Edición tapa dura estándar",
  );

  final TextEditingController _catalogCampaignIdController =
      TextEditingController();
  final TextEditingController _catalogNameController = TextEditingController(
    text: "Catálogo Oficial Verano",
  );
  final TextEditingController _catalogSourceTypeController =
      TextEditingController(text: "MANUAL");
  final TextEditingController _catalogSourceNameController =
      TextEditingController(text: "Editorial IADPA");
  final TextEditingController _catalogCurrencyController =
      TextEditingController(text: "MXN");

  final TextEditingController _catalogIdController = TextEditingController();
  final TextEditingController _catalogMaterialIdController =
      TextEditingController();
  final TextEditingController _catalogListPriceController =
      TextEditingController(text: "250.00");
  final TextEditingController _catalogStatusController = TextEditingController(
    text: "ACTIVE",
  );

  final TextEditingController _acqParticipationIdController =
      TextEditingController();
  final TextEditingController _acqCatalogItemIdController =
      TextEditingController();
  final TextEditingController _acqQuantityController = TextEditingController(
    text: "1",
  );
  final TextEditingController _acqIdController = TextEditingController();
  final TextEditingController _acqStatusController = TextEditingController(
    text: "DELIVERED",
  );
  final TextEditingController _acqResolutionController = TextEditingController(
    text: "Entrega presencial confirmada",
  );
  final TextEditingController _materialSearchController =
      TextEditingController();

  // Controladores para endpoints de Capacitación (Training)
  final TextEditingController _trProgramClubIdController =
      TextEditingController();
  final TextEditingController _trProgramCodeController =
      TextEditingController(text: "CAP-2026-A");
  final TextEditingController _trProgramNameController =
      TextEditingController(text: "Capacitación Inicial de Colportaje");
  final TextEditingController _trProgramVersionLabelController =
      TextEditingController(text: "v1.0");

  final TextEditingController _trVersionIdController =
      TextEditingController();
  final TextEditingController _trSessionTitleController =
      TextEditingController(text: "Técnicas de Venta y Abordaje");
  final TextEditingController _trSessionStartsAtController =
      TextEditingController(text: "2026-06-01T09:00:00Z");
  final TextEditingController _trSessionEndsAtController =
      TextEditingController(text: "2026-06-01T11:00:00Z");

  final TextEditingController _trEnrollmentMembershipIdController =
      TextEditingController();
  final TextEditingController _trSessionIdController =
      TextEditingController();
  final TextEditingController _trSessionStatusController =
      TextEditingController(text: "CLOSED");

  final TextEditingController _trAttendanceEnrollmentIdController =
      TextEditingController();
  final TextEditingController _trAttendanceStatusController =
      TextEditingController(text: "PRESENT");
  final TextEditingController _trAttendanceNotesController =
      TextEditingController(text: "Asistencia validada puntualmente");

  final TextEditingController _trProgressEnrollmentIdController =
      TextEditingController();

  final TextEditingController _trPromotionMinSessionsController =
      TextEditingController(text: "5");
  final TextEditingController _trPromotionMinRateController =
      TextEditingController(text: "80.0");

  final TextEditingController _trDecisionEnrollmentIdController =
      TextEditingController();
  final TextEditingController _trDecisionOutcomeController =
      TextEditingController(text: "APPROVED");
  final TextEditingController _trDecisionReasonController =
      TextEditingController(text: "Cumplió satisfactoriamente los requisitos");

  final TextEditingController _trExpMembershipIdController =
      TextEditingController();
  final TextEditingController _trExpOutcomeController =
      TextEditingController(text: "APPROVED");
  final TextEditingController _trExpReasonController =
      TextEditingController(text: "Acreditación por campañas previas");
  final TextEditingController _trExpSummaryController =
      TextEditingController(text: "2 años continuos de experiencia en campo");

  final TextEditingController _trHistoryMembershipIdController =
      TextEditingController();

  // Controladores para endpoints de Operaciones de Campaña (Campaign Operations)
  final TextEditingController _cpClubIdController = TextEditingController();
  final TextEditingController _cpNameController = TextEditingController(
    text: "Campaña Verano 2026",
  );
  final TextEditingController _cpStartsOnController = TextEditingController(
    text: "2026-06-01",
  );
  final TextEditingController _cpEndsOnController = TextEditingController(
    text: "2026-08-31",
  );
  final TextEditingController _cpDescController = TextEditingController(
    text: "Campaña evangelística de colportaje",
  );

  final TextEditingController _cpCampaignIdController = TextEditingController();
  final TextEditingController _cpStatusController = TextEditingController(
    text: "ACTIVE",
  );

  final TextEditingController _cpGroupNameController = TextEditingController(
    text: "Grupo Los Pioneros",
  );
  final TextEditingController _cpGroupDescController = TextEditingController(
    text: "Grupo asignado a la zona centro",
  );

  final TextEditingController _cpGroupIdController = TextEditingController();
  final TextEditingController _cpMembershipIdController =
      TextEditingController();
  final TextEditingController _cpParticipationIdController =
      TextEditingController();
  final TextEditingController _cpAssociateReasonController =
      TextEditingController(text: "Designación como líder del grupo");

  final TextEditingController _cpFieldNameController = TextEditingController(
    text: "Campo Colonia del Valle",
  );
  final TextEditingController _cpFieldOrgController = TextEditingController(
    text: "Misión del Norte",
  );

  final TextEditingController _cpReqGroupIdController = TextEditingController();
  final TextEditingController _cpReqReasonController = TextEditingController(
    text: "Solicito cambio por cercanía a mi domicilio",
  );

  final TextEditingController _cpChangeRequestIdController =
      TextEditingController();
  final TextEditingController _cpResolveOutcomeController =
      TextEditingController(text: "APPROVED");
  final TextEditingController _cpResolveReasonController =
      TextEditingController(text: "Solicitud procedente tras revisión");

  final TextEditingController _cpAppealReasonController =
      TextEditingController(text: "Apelo la decisión por causas de fuerza mayor");
  final TextEditingController _cpAppealIdController = TextEditingController();
  final TextEditingController _cpAppealOutcomeController =
      TextEditingController(text: "APPROVED");
  final TextEditingController _cpAppealResolutionController =
      TextEditingController(text: "Resolución final favorable");

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

    _wsClubIdController.dispose();
    _wsCampaignIdController.dispose();
    _wsAccountIdController.dispose();
    _wsRoleCodeController.dispose();
    _wsReasonController.dispose();
    _wsAccessAssignmentIdController.dispose();

    _materialClubIdController.dispose();
    _materialCodeController.dispose();
    _materialNameController.dispose();
    _materialCategoryController.dispose();
    _materialDescController.dispose();

    _catalogCampaignIdController.dispose();
    _catalogNameController.dispose();
    _catalogSourceTypeController.dispose();
    _catalogSourceNameController.dispose();
    _catalogCurrencyController.dispose();

    _catalogIdController.dispose();
    _catalogMaterialIdController.dispose();
    _catalogListPriceController.dispose();
    _catalogStatusController.dispose();

    _acqParticipationIdController.dispose();
    _acqCatalogItemIdController.dispose();
    _acqQuantityController.dispose();
    _acqIdController.dispose();
    _acqStatusController.dispose();
    _acqResolutionController.dispose();
    _materialSearchController.dispose();

    _trProgramClubIdController.dispose();
    _trProgramCodeController.dispose();
    _trProgramNameController.dispose();
    _trProgramVersionLabelController.dispose();
    _trVersionIdController.dispose();
    _trSessionTitleController.dispose();
    _trSessionStartsAtController.dispose();
    _trSessionEndsAtController.dispose();
    _trEnrollmentMembershipIdController.dispose();
    _trSessionIdController.dispose();
    _trSessionStatusController.dispose();
    _trAttendanceEnrollmentIdController.dispose();
    _trAttendanceStatusController.dispose();
    _trAttendanceNotesController.dispose();
    _trProgressEnrollmentIdController.dispose();
    _trPromotionMinSessionsController.dispose();
    _trPromotionMinRateController.dispose();
    _trDecisionEnrollmentIdController.dispose();
    _trDecisionOutcomeController.dispose();
    _trDecisionReasonController.dispose();
    _trExpMembershipIdController.dispose();
    _trExpOutcomeController.dispose();
    _trExpReasonController.dispose();
    _trExpSummaryController.dispose();
    _trHistoryMembershipIdController.dispose();

    _cpClubIdController.dispose();
    _cpNameController.dispose();
    _cpStartsOnController.dispose();
    _cpEndsOnController.dispose();
    _cpDescController.dispose();
    _cpCampaignIdController.dispose();
    _cpStatusController.dispose();
    _cpGroupNameController.dispose();
    _cpGroupDescController.dispose();
    _cpGroupIdController.dispose();
    _cpMembershipIdController.dispose();
    _cpParticipationIdController.dispose();
    _cpAssociateReasonController.dispose();
    _cpFieldNameController.dispose();
    _cpFieldOrgController.dispose();
    _cpReqGroupIdController.dispose();
    _cpReqReasonController.dispose();
    _cpChangeRequestIdController.dispose();
    _cpResolveOutcomeController.dispose();
    _cpResolveReasonController.dispose();
    _cpAppealReasonController.dispose();
    _cpAppealIdController.dispose();
    _cpAppealOutcomeController.dispose();
    _cpAppealResolutionController.dispose();
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
    final catalogState = ref.watch(catalogProvider);

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

    // Muestra notificaciones cuando el estado de catálogo reporte errores.
    ref.listen<CatalogState>(catalogProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        SnackBarFormat().show(context, next.errorMessage!, isError: true);
      }
    });

    // Muestra notificaciones cuando el estado de capacitación reporte errores.
    ref.listen<TrainingState>(trainingProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        SnackBarFormat().show(context, next.errorMessage!, isError: true);
      }
    });

    // Muestra notificaciones cuando el estado de campaña reporte errores.
    ref.listen<CampaignState>(campaignProvider, (previous, next) {
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
                    ? "Usuario: ${authState.user?.email} (${authState.user?.accountId})"
                    : "Estado: No autenticado",
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // 1. Iniciar Sesión (POST /auth/login)
          ContainerListTile(
            title: "1. Iniciar Sesión",
            subtitle: "POST /auth/login",
            expandedChild: [
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
              ButtonFormat.primary(
                label: "Iniciar Sesión",
                isLoading: authState.isLoading,
                onPressed: () async {
                  await ref
                      .read(authProvider.notifier)
                      .login(
                        email: _authEmailController.text.trim(),
                        password: _authPasswordController.text.trim(),
                      );
                  if (context.mounted &&
                      ref.read(authProvider).isAuthenticated) {
                    SnackBarFormat().show(
                      context,
                      "Sesión iniciada correctamente",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // 2. Consultar Usuario (GET /auth/me)
          ContainerListTile(
            title: "2. Obtener Perfil",
            subtitle: "GET /auth/me",
            expandedChild: [
              TextFormat.body(
                "Consulta la identidad, estado y roles de la cuenta en sesión.",
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Obtener Perfil",
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
            ],
          ),
          AppSpacing.heightSmall,

          // 3. Renovar Sesión (POST /auth/refresh)
          ContainerListTile(
            title: "3. Renovar Token",
            subtitle: "POST /auth/refresh",
            expandedChild: [
              TextFormat.body(
                "Renueva el token de acceso mediante el refresh token persistido.",
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Renovar Token",
                onPressed: () async {
                  final ok = await ref
                      .read(authProvider.notifier)
                      .refreshSession();
                  if (context.mounted && ok) {
                    SnackBarFormat().show(context, "Token renovado con éxito");
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // 4. Solicitar Verificación de Email (POST /auth/email-verification/request)
          ContainerListTile(
            title: "4. Solicitar Verif. Email",
            subtitle: "POST /auth/email-verification/request",
            expandedChild: [
              InputTextFormart(
                controller: _authEmailController,
                prefixIcon: AppIcon.email,
                labelText: "Correo Electrónico",
                hintText: "correo@ejemplo.com",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Solicitar Verif. Email",
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
            ],
          ),
          AppSpacing.heightSmall,

          // 5. Confirmar Verificación de Email (POST /auth/email-verification/confirm)
          ContainerListTile(
            title: "5. Confirmar Verif. Email",
            subtitle: "POST /auth/email-verification/confirm",
            expandedChild: [
              InputTextFormart(
                controller: _authEmailController,
                prefixIcon: AppIcon.email,
                labelText: "Correo Electrónico",
                hintText: "correo@ejemplo.com",
                maxLength: 100,
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
              ButtonFormat.secondary(
                label: "Confirmar Verif. Email",
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
            ],
          ),
          AppSpacing.heightSmall,

          // 6. Solicitar Restablecer Contraseña (POST /auth/password-reset/request)
          ContainerListTile(
            title: "6. Solicitar Reset Contraseña",
            subtitle: "POST /auth/password-reset/request",
            expandedChild: [
              InputTextFormart(
                controller: _authEmailController,
                prefixIcon: AppIcon.email,
                labelText: "Correo Electrónico",
                hintText: "correo@ejemplo.com",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Solicitar Reset Contraseña",
                onPressed: () async {
                  final ok = await ref
                      .read(authProvider.notifier)
                      .requestPasswordReset(
                        email: _authEmailController.text.trim(),
                      );
                  if (context.mounted && ok) {
                    SnackBarFormat().show(
                      context,
                      "Código de reset solicitado",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // 7. Confirmar Restablecer Contraseña (POST /auth/password-reset/confirm)
          ContainerListTile(
            title: "7. Confirmar Reset Contraseña",
            subtitle: "POST /auth/password-reset/confirm",
            expandedChild: [
              InputTextFormart(
                controller: _authEmailController,
                prefixIcon: AppIcon.email,
                labelText: "Correo Electrónico",
                hintText: "correo@ejemplo.com",
                maxLength: 100,
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
                controller: _authPasswordController,
                prefixIcon: AppIcon.password,
                labelText: "Nueva Contraseña",
                hintText: "••••••••",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Confirmar Reset Contraseña",
                onPressed: () async {
                  final ok = await ref
                      .read(authProvider.notifier)
                      .confirmPasswordReset(
                        email: _authEmailController.text.trim(),
                        code: _authCodeController.text.trim(),
                        newPassword: _authPasswordController.text.trim(),
                      );
                  if (context.mounted && ok) {
                    SnackBarFormat().show(
                      context,
                      "Contraseña cambiada con éxito",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // 8. Inspeccionar Invitación de Club (POST /auth/invitations/inspect)
          ContainerListTile(
            title: "8. Inspeccionar Invitación",
            subtitle: "POST /auth/invitations/inspect",
            expandedChild: [
              InputTextFormart(
                controller: _authEmailController,
                prefixIcon: AppIcon.email,
                labelText: "Correo Electrónico",
                hintText: "correo@ejemplo.com",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _authCodeController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Código de Invitación",
                hintText: "Código recibido",
                maxLength: 20,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Inspeccionar Invitación",
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
            ],
          ),
          AppSpacing.heightSmall,

          // 9. Aceptar Invitación de Club (POST /auth/invitations/accept)
          ContainerListTile(
            title: "9. Aceptar Invitación",
            subtitle: "POST /auth/invitations/accept",
            expandedChild: [
              InputTextFormart(
                controller: _authEmailController,
                prefixIcon: AppIcon.email,
                labelText: "Correo Electrónico",
                hintText: "correo@ejemplo.com",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _authCodeController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Código de Invitación",
                hintText: "Código recibido",
                maxLength: 20,
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
                controller: _authGivenNamesController,
                prefixIcon: AppIcon.person,
                labelText: "Nombres",
                hintText: "Juan",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _authFamilyNameController,
                prefixIcon: AppIcon.person,
                labelText: "Apellidos",
                hintText: "Pérez",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Aceptar Invitación",
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
                    SnackBarFormat().show(
                      context,
                      "Invitación aceptada con éxito",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // 10. Crear Invitación (POST /auth/invitations)
          ContainerListTile(
            title: "10. Crear Invitación",
            subtitle: "POST /auth/invitations",
            expandedChild: [
              InputTextFormart(
                controller: _authClubIdController,
                prefixIcon: AppIcon.home,
                labelText: "Club ID (UUID)",
                hintText: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _authEmailController,
                prefixIcon: AppIcon.email,
                labelText: "Correo del Invitado",
                hintText: "correo@ejemplo.com",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Crear Invitación",
                onPressed: () async {
                  final info = await ref
                      .read(authProvider.notifier)
                      .createInvitation(
                        clubId: _authClubIdController.text.trim(),
                        email: _authEmailController.text.trim(),
                      );
                  if (context.mounted && info != null) {
                    SnackBarFormat().show(
                      context,
                      "Invitación creada: ${info['invitationId']}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // 11. Cerrar Sesión (POST /auth/logout)
          ContainerListTile(
            title: "11. Cerrar Sesión",
            subtitle: "POST /auth/logout",
            expandedChild: [
              TextFormat.body(
                "Revoca las credenciales y limpia los datos de sesión activa en el dispositivo.",
              ),
              AppSpacing.heightSmall,
              ButtonFormat.text(
                label: "Cerrar Sesión",
                onPressed: () async {
                  await ref.read(authProvider.notifier).signOut();
                  if (context.mounted) {
                    SnackBarFormat().show(context, "Sesión cerrada");
                  }
                },
              ),
            ],
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

          // W1. Obtener Contexto (GET /workspace/context)
          ContainerListTile(
            title: "W1. Obtener Contexto",
            subtitle: "GET /workspace/context",
            expandedChild: [
              TextFormat.body(
                "Consulta el contexto del usuario autenticado (clubes e instituciones) y auto-rellena los IDs de Club y Campaña.",
              ),
              AppSpacing.heightSmall,
              ButtonFormat.primary(
                label: "Consultar Contexto",
                isLoading: workspaceState.isLoading,
                onPressed: () async {
                  await ref.read(workspaceProvider.notifier).getContext();
                  final ws = ref.read(workspaceProvider).workspace;
                  if (ws != null && ws.clubs.isNotEmpty) {
                    final club = ws.clubs.first;
                    // Auto-rellena clubId en todos los módulos
                    _wsClubIdController.text = club.clubId;
                    _materialClubIdController.text = club.clubId;
                    _authClubIdController.text = club.clubId;
                    _trProgramClubIdController.text = club.clubId;
                    _cpClubIdController.text = club.clubId;

                    // Si el usuario tiene membresía activa en el club, auto-rellena su membershipId
                    final membershipId = club.membership?['membershipId']?.toString();
                    if (membershipId != null && membershipId.isNotEmpty) {
                      _trEnrollmentMembershipIdController.text = membershipId;
                      _trExpMembershipIdController.text = membershipId;
                      _trHistoryMembershipIdController.text = membershipId;
                      _cpMembershipIdController.text = membershipId;
                    }

                    if (context.mounted) {
                      SnackBarFormat().show(
                        context,
                        "Contexto cargado: ${club.clubName}",
                      );
                    }
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // W2. Listar Membresías (GET /workspace/clubs/{clubId}/memberships)
          ContainerListTile(
            title: "W2. Membresías del Club",
            subtitle: "GET /workspace/clubs/{clubId}/memberships",
            expandedChild: [
              InputTextFormart(
                controller: _wsClubIdController,
                prefixIcon: AppIcon.home,
                labelText: "Club ID",
                hintText: "UUID del club",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Listar Membresías",
                onPressed: () async {
                  final data = await ref
                      .read(workspaceProvider.notifier)
                      .listClubMemberships(
                        clubId: _wsClubIdController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    final items = data['items'] as List<dynamic>?;
                    if (items != null && items.isNotEmpty) {
                      final firstMemId =
                          items.first['membershipId']?.toString() ??
                          items.first['id']?.toString() ??
                          "";
                      if (firstMemId.isNotEmpty) {
                        _trEnrollmentMembershipIdController.text = firstMemId;
                        _trExpMembershipIdController.text = firstMemId;
                        _trHistoryMembershipIdController.text = firstMemId;
                        _cpMembershipIdController.text = firstMemId;
                      }
                    }
                    SnackBarFormat().show(
                      context,
                      "Total miembros: ${data['total']}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // W3. Listar Campañas (GET /workspace/clubs/{clubId}/campaigns)
          ContainerListTile(
            title: "W3. Campañas del Club",
            subtitle: "GET /workspace/clubs/{clubId}/campaigns",
            expandedChild: [
              InputTextFormart(
                controller: _wsClubIdController,
                prefixIcon: AppIcon.home,
                labelText: "Club ID",
                hintText: "UUID del club",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Listar Campañas",
                onPressed: () async {
                  final data = await ref
                      .read(workspaceProvider.notifier)
                      .listClubCampaigns(
                        clubId: _wsClubIdController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    final items = data['items'] as List<dynamic>?;
                    if (items != null && items.isNotEmpty) {
                      final firstId =
                          items.first['campaignId']?.toString() ??
                          items.first['id']?.toString() ??
                          "";
                      if (firstId.isNotEmpty) {
                        _wsCampaignIdController.text = firstId;
                        _catalogCampaignIdController.text = firstId;
                        _cpCampaignIdController.text = firstId;
                      }
                    }
                    SnackBarFormat().show(
                      context,
                      "Total campañas: ${data['total']}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // W4. Listar Grupos de Campaña (GET /workspace/campaigns/{campaignId}/groups)
          ContainerListTile(
            title: "W4. Grupos de Campaña",
            subtitle: "GET /workspace/campaigns/{campaignId}/groups",
            expandedChild: [
              InputTextFormart(
                controller: _wsCampaignIdController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Campaign ID",
                hintText: "UUID de la campaña",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Listar Grupos",
                onPressed: () async {
                  final data = await ref
                      .read(workspaceProvider.notifier)
                      .listCampaignGroups(
                        campaignId: _wsCampaignIdController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    final items = data['items'] as List<dynamic>?;
                    if (items != null && items.isNotEmpty) {
                      final firstGroupId =
                          items.first['groupId']?.toString() ??
                          items.first['id']?.toString() ??
                          "";
                      if (firstGroupId.isNotEmpty) {
                        _cpGroupIdController.text = firstGroupId;
                        _cpReqGroupIdController.text = firstGroupId;
                      }
                    }
                    SnackBarFormat().show(
                      context,
                      "Total grupos: ${data['total']}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // W5. Listar Programas de Capacitación (GET /workspace/clubs/{clubId}/training-programs)
          ContainerListTile(
            title: "W5. Programas Capacitación",
            subtitle: "GET /workspace/clubs/{clubId}/training-programs",
            expandedChild: [
              InputTextFormart(
                controller: _wsClubIdController,
                prefixIcon: AppIcon.home,
                labelText: "Club ID",
                hintText: "UUID del club",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Listar Programas",
                onPressed: () async {
                  final data = await ref
                      .read(workspaceProvider.notifier)
                      .listClubTrainingPrograms(
                        clubId: _wsClubIdController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Total programas: ${data['total']}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // W6. Listar Roles del Club (GET /workspace/clubs/{clubId}/roles)
          ContainerListTile(
            title: "W6. Roles del Club",
            subtitle: "GET /workspace/clubs/{clubId}/roles",
            expandedChild: [
              InputTextFormart(
                controller: _wsClubIdController,
                prefixIcon: AppIcon.home,
                labelText: "Club ID",
                hintText: "UUID del club",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Listar Roles",
                onPressed: () async {
                  final roles = await ref
                      .read(workspaceProvider.notifier)
                      .listClubRoles(clubId: _wsClubIdController.text.trim());
                  if (context.mounted && roles != null) {
                    SnackBarFormat().show(
                      context,
                      "Roles disponibles: ${roles.length}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // W7. Asignar Rol (POST /workspace/clubs/{clubId}/access-assignments)
          ContainerListTile(
            title: "W7. Asignar Rol en Club",
            subtitle: "POST /workspace/clubs/{clubId}/access-assignments",
            expandedChild: [
              InputTextFormart(
                controller: _wsClubIdController,
                prefixIcon: AppIcon.home,
                labelText: "Club ID",
                hintText: "UUID del club",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _wsAccountIdController,
                prefixIcon: AppIcon.person,
                labelText: "Account ID (Usuario)",
                hintText: "UUID del usuario a asignar",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _wsRoleCodeController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Código de Rol",
                hintText: "Ej. TRAINING_COORDINATOR",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _wsReasonController,
                prefixIcon: AppIcon.document,
                labelText: "Motivo / Razón",
                hintText: "Razón de la asignación",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Asignar Rol",
                onPressed: () async {
                  final accountId =
                      _wsAccountIdController.text.trim().isNotEmpty
                      ? _wsAccountIdController.text.trim()
                      : (ref.read(authProvider).user?.accountId ?? "");
                  final data = await ref
                      .read(workspaceProvider.notifier)
                      .assignClubRole(
                        clubId: _wsClubIdController.text.trim(),
                        accountId: accountId,
                        roleCode: _wsRoleCodeController.text.trim(),
                        reason: _wsReasonController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    if (data['accessAssignmentId'] != null) {
                      _wsAccessAssignmentIdController.text =
                          data['accessAssignmentId'].toString();
                    }
                    SnackBarFormat().show(
                      context,
                      "Asignación: ${data['accessAssignmentId']}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // W8. Revocar Rol (POST /workspace/access-assignments/{id}/revoke)
          ContainerListTile(
            title: "W8. Revocar Rol en Club",
            subtitle: "POST /workspace/access-assignments/{id}/revoke",
            expandedChild: [
              InputTextFormart(
                controller: _wsAccessAssignmentIdController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Access Assignment ID",
                hintText: "UUID de la asignación a revocar",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _wsReasonController,
                prefixIcon: AppIcon.document,
                labelText: "Motivo de Revocación",
                hintText: "Razón de la revocación",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Revocar Rol",
                onPressed: () async {
                  final data = await ref
                      .read(workspaceProvider.notifier)
                      .revokeAccessAssignment(
                        accessAssignmentId: _wsAccessAssignmentIdController.text
                            .trim(),
                        reason: _wsReasonController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(context, "Estado: ${data['status']}");
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightMedium,

          // Sección de pruebas de Catalog and Materials (10 endpoints)
          ContainerFormat(
            children: [
              TextFormat.subtitle("Catálogos y Materiales"),
              AppSpacing.heightSmall,
              TextFormat.body(
                catalogState.catalogs.isNotEmpty
                    ? "Catálogos cargados: ${catalogState.catalogs.length} | Materiales: ${catalogState.materials.length}"
                    : "Catálogo: Sin consultar",
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // C1. Dar de alta material (POST /inventory/materials)
          ContainerListTile(
            title: "C1. Crear Material",
            subtitle: "POST /inventory/materials",
            expandedChild: [
              InputTextFormart(
                controller: _materialClubIdController,
                prefixIcon: AppIcon.home,
                labelText: "Club ID",
                hintText: "UUID del club",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _materialCodeController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Código Material",
                hintText: "Ej. LIB-001",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _materialNameController,
                prefixIcon: AppIcon.document,
                labelText: "Nombre del Material",
                hintText: "Ej. El Deseado de Todas las Gentes",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _materialCategoryController,
                prefixIcon: AppIcon.catalogo,
                labelText: "Categoría",
                hintText: "Ej. Libros",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _materialDescController,
                prefixIcon: AppIcon.edit,
                labelText: "Descripción",
                hintText: "Descripción breve",
                maxLength: 200,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Crear Material",
                onPressed: () async {
                  final data = await ref
                      .read(catalogProvider.notifier)
                      .createMaterial(
                        clubId: _materialClubIdController.text.trim(),
                        code: _materialCodeController.text.trim(),
                        name: _materialNameController.text.trim(),
                        category: _materialCategoryController.text.trim(),
                        description: _materialDescController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    if (data['materialId'] != null) {
                      _catalogMaterialIdController.text = data['materialId']
                          .toString();
                    }
                    SnackBarFormat().show(
                      context,
                      "Material creado: ${data['code']} (${data['status']})",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // C2. Crear borrador de catálogo (POST /inventory/campaigns/{id}/catalogs)
          ContainerListTile(
            title: "C2. Crear Catálogo de Campaña",
            subtitle: "POST /inventory/campaigns/{id}/catalogs",
            expandedChild: [
              InputTextFormart(
                controller: _catalogCampaignIdController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Campaign ID",
                hintText: "UUID de la campaña",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _catalogNameController,
                prefixIcon: AppIcon.document,
                labelText: "Nombre Catálogo",
                hintText: "Ej. Catálogo Oficial Campaña",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _catalogSourceTypeController,
                prefixIcon: AppIcon.catalogo,
                labelText: "Source Type",
                hintText: "Ej. MANUAL",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _catalogSourceNameController,
                prefixIcon: AppIcon.home,
                labelText: "Source Name",
                hintText: "Ej. Editorial IADPA",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _catalogCurrencyController,
                prefixIcon: AppIcon.pagos,
                labelText: "Moneda (ISO)",
                hintText: "Ej. MXN",
                maxLength: 10,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Crear Catálogo",
                onPressed: () async {
                  final data = await ref
                      .read(catalogProvider.notifier)
                      .createCampaignCatalog(
                        campaignId: _catalogCampaignIdController.text.trim(),
                        name: _catalogNameController.text.trim(),
                        sourceType: _catalogSourceTypeController.text.trim(),
                        sourceName: _catalogSourceNameController.text.trim(),
                        sourceCutAt: DateTime.now().toIso8601String(),
                        currency: _catalogCurrencyController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    if (data['catalogId'] != null) {
                      _catalogIdController.text = data['catalogId'].toString();
                    }
                    SnackBarFormat().show(
                      context,
                      "Catálogo ID: ${data['catalogId']} (${data['status']})",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // C3. Listar catálogos de campaña (GET /inventory/campaigns/{id}/catalogs)
          ContainerListTile(
            title: "C3. Catálogos de Campaña",
            subtitle: "GET /inventory/campaigns/{id}/catalogs",
            expandedChild: [
              InputTextFormart(
                controller: _catalogCampaignIdController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Campaign ID",
                hintText: "UUID de la campaña",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.primary(
                label: "Listar Catálogos",
                isLoading: catalogState.isLoading,
                onPressed: () async {
                  final list = await ref
                      .read(catalogProvider.notifier)
                      .listCampaignCatalogs(
                        campaignId: _catalogCampaignIdController.text.trim(),
                      );
                  if (context.mounted && list != null) {
                    if (list.isNotEmpty) {
                      _catalogIdController.text = list.first.catalogId;
                    }
                    SnackBarFormat().show(
                      context,
                      "Catálogos encontrados: ${list.length}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // C4. Agregar ítem a catálogo (POST /inventory/catalogs/{id}/items)
          ContainerListTile(
            title: "C4. Agregar Ítem a Catálogo",
            subtitle: "POST /inventory/catalogs/{id}/items",
            expandedChild: [
              InputTextFormart(
                controller: _catalogIdController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Catalog ID",
                hintText: "UUID del catálogo",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _catalogMaterialIdController,
                prefixIcon: AppIcon.document,
                labelText: "Material ID",
                hintText: "UUID del material a vincular",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _catalogListPriceController,
                prefixIcon: AppIcon.pagos,
                labelText: "Precio de Lista",
                hintText: "Ej. 250.00",
                maxLength: 20,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Agregar Ítem",
                onPressed: () async {
                  final data = await ref
                      .read(catalogProvider.notifier)
                      .addCatalogItem(
                        catalogId: _catalogIdController.text.trim(),
                        materialId: _catalogMaterialIdController.text.trim(),
                        listPrice: _catalogListPriceController.text.trim(),
                        bonusEligible: true,
                      );
                  if (context.mounted && data != null) {
                    if (data['catalogItemId'] != null) {
                      _acqCatalogItemIdController.text = data['catalogItemId']
                          .toString();
                    }
                    SnackBarFormat().show(
                      context,
                      "Ítem agregado ID: ${data['catalogItemId']}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // C5. Publicar o cerrar catálogo (PUT /inventory/catalogs/{id}/status)
          ContainerListTile(
            title: "C5. Cambiar Estado Catálogo",
            subtitle: "PUT /inventory/catalogs/{id}/status",
            expandedChild: [
              InputTextFormart(
                controller: _catalogIdController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Catalog ID",
                hintText: "UUID del catálogo",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _catalogStatusController,
                prefixIcon: AppIcon.catalogo,
                labelText: "Nuevo Estado (ACTIVE, CLOSED, ARCHIVED)",
                hintText: "ACTIVE",
                maxLength: 20,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Actualizar Estado Catálogo",
                onPressed: () async {
                  final data = await ref
                      .read(catalogProvider.notifier)
                      .updateCatalogStatus(
                        catalogId: _catalogIdController.text.trim(),
                        status: _catalogStatusController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Catálogo publicado: ${data['status']}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // C6. Registrar asignación/pedido de material (POST /inventory/campaigns/{id}/acquisitions)
          ContainerListTile(
            title: "C6. Registrar Asignación / Pedido",
            subtitle: "POST /inventory/campaigns/{id}/acquisitions",
            expandedChild: [
              InputTextFormart(
                controller: _catalogCampaignIdController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Campaign ID",
                hintText: "UUID de la campaña",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _acqParticipationIdController,
                prefixIcon: AppIcon.person,
                labelText: "Participation ID (Colportor)",
                hintText: "UUID de la participación",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _catalogIdController,
                prefixIcon: AppIcon.document,
                labelText: "Catalog ID",
                hintText: "UUID del catálogo",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _acqCatalogItemIdController,
                prefixIcon: AppIcon.catalogo,
                labelText: "Catalog Item ID",
                hintText: "UUID del ítem del catálogo",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _acqQuantityController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Cantidad",
                hintText: "Ej. 1",
                maxLength: 10,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Registrar Asignación",
                onPressed: () async {
                  final qty =
                      int.tryParse(_acqQuantityController.text.trim()) ?? 1;
                  final data = await ref
                      .read(catalogProvider.notifier)
                      .createAcquisition(
                        campaignId: _catalogCampaignIdController.text.trim(),
                        participationId: _acqParticipationIdController.text
                            .trim(),
                        catalogId: _catalogIdController.text.trim(),
                        acquiredAt: DateTime.now().toIso8601String(),
                        items: [
                          {
                            "catalogItemId": _acqCatalogItemIdController.text
                                .trim(),
                            "quantity": qty,
                          },
                        ],
                      );
                  if (context.mounted && data != null) {
                    if (data['acquisitionId'] != null) {
                      _acqIdController.text = data['acquisitionId'].toString();
                    }
                    SnackBarFormat().show(
                      context,
                      "Adquisición creada: ${data['acquisitionId']}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // C7. Listar asignaciones de la campaña (GET /inventory/campaigns/{id}/acquisitions)
          ContainerListTile(
            title: "C7. Asignaciones de Campaña",
            subtitle: "GET /inventory/campaigns/{id}/acquisitions",
            expandedChild: [
              InputTextFormart(
                controller: _catalogCampaignIdController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Campaign ID",
                hintText: "UUID de la campaña",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Listar Asignaciones",
                onPressed: () async {
                  final data = await ref
                      .read(catalogProvider.notifier)
                      .listCampaignAcquisitions(
                        campaignId: _catalogCampaignIdController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Total pedidos: ${data['total']}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // C8. Actualizar estado adquisición (PUT /inventory/acquisitions/{id}/status)
          ContainerListTile(
            title: "C8. Actualizar Estado Asignación",
            subtitle: "PUT /inventory/acquisitions/{id}/status",
            expandedChild: [
              InputTextFormart(
                controller: _acqIdController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Acquisition ID",
                hintText: "UUID de la adquisición",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _acqStatusController,
                prefixIcon: AppIcon.catalogo,
                labelText: "Nuevo Estado (DELIVERED, CANCELLED, RETURNED)",
                hintText: "DELIVERED",
                maxLength: 30,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _acqResolutionController,
                prefixIcon: AppIcon.document,
                labelText: "Resolución / Motivo",
                hintText: "Motivo del cambio de estado",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Actualizar Estado",
                onPressed: () async {
                  final data = await ref
                      .read(catalogProvider.notifier)
                      .updateAcquisitionStatus(
                        acquisitionId: _acqIdController.text.trim(),
                        status: _acqStatusController.text.trim(),
                        resolution: _acqResolutionController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Estado pedido: ${data['status']}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // C9. Listar materiales del club (GET /inventory/clubs/{id}/materials)
          ContainerListTile(
            title: "C9. Materiales del Club",
            subtitle: "GET /inventory/clubs/{id}/materials",
            expandedChild: [
              InputTextFormart(
                controller: _materialClubIdController,
                prefixIcon: AppIcon.home,
                labelText: "Club ID",
                hintText: "UUID del club",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _materialSearchController,
                prefixIcon: AppIcon.search,
                labelText: "Búsqueda (opcional)",
                hintText: "Buscar por nombre o código",
                maxLength: 50,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Listar Materiales",
                onPressed: () async {
                  final list = await ref
                      .read(catalogProvider.notifier)
                      .listClubMaterials(
                        clubId: _materialClubIdController.text.trim(),
                        search: _materialSearchController.text.trim().isEmpty
                            ? null
                            : _materialSearchController.text.trim(),
                      );
                  if (context.mounted && list != null) {
                    if (list.isNotEmpty) {
                      _catalogMaterialIdController.text = list.first.materialId;
                    }
                    SnackBarFormat().show(
                      context,
                      "Materiales encontrados: ${list.length}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // C10. Mis adquisiciones de colportor (GET /inventory/me/acquisitions)
          ContainerListTile(
            title: "C10. Mis Adquisiciones",
            subtitle: "GET /inventory/me/acquisitions",
            expandedChild: [
              TextFormat.body(
                "Consulta todas las asignaciones o pedidos de material registrados a nombre del colportor autenticado.",
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Consultar Mis Adquisiciones",
                onPressed: () async {
                  final list = await ref
                      .read(catalogProvider.notifier)
                      .listMyAcquisitions();
                  if (context.mounted && list != null) {
                    SnackBarFormat().show(
                      context,
                      "Mis pedidos asignados: ${list.length}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightMedium,

          
          // MÓDULO 3: CAPACITACIÓN Y ASISTENCIAS (TRAINING)
          
          ContainerFormat(
            children: [
              TextFormat.subtitle("Módulo 3: Capacitación y Asistencias"),
              AppSpacing.heightSmall,
              TextFormat.body(
                "Endpoints de programas formativos, sesiones, asistencia QR, criterios y promociones.",
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // T1. Crear Programa de Capacitación (POST /training/programs)
          ContainerListTile(
            title: "T1. Crear Programa",
            subtitle: "POST /training/programs",
            expandedChild: [
              InputTextFormart(
                controller: _trProgramClubIdController,
                prefixIcon: AppIcon.home,
                labelText: "Club ID",
                hintText: "UUID del club",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trProgramCodeController,
                prefixIcon: AppIcon.capacitaciones,
                labelText: "Código",
                hintText: "Ej. CAP-2026-A",
                maxLength: 60,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trProgramNameController,
                prefixIcon: AppIcon.capacitaciones,
                labelText: "Nombre del Programa",
                hintText: "Nombre descriptivo",
                maxLength: 180,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trProgramVersionLabelController,
                prefixIcon: AppIcon.edit,
                labelText: "Etiqueta de Versión",
                hintText: "Ej. v1.0",
                maxLength: 120,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Crear Programa",
                onPressed: () async {
                  final clubId = _trProgramClubIdController.text.trim().isNotEmpty
                      ? _trProgramClubIdController.text.trim()
                      : _wsClubIdController.text.trim();
                  final data = await ref
                      .read(trainingProvider.notifier)
                      .createProgram(
                        clubId: clubId,
                        code: _trProgramCodeController.text.trim(),
                        name: _trProgramNameController.text.trim(),
                        versionLabel: _trProgramVersionLabelController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    if (data['versionId'] != null) {
                      _trVersionIdController.text = data['versionId'].toString();
                    }
                    SnackBarFormat().show(
                      context,
                      "Programa creado. Versión ID: ${data['versionId'] ?? 'OK'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // T2. Crear Sesión de Capacitación (POST /training/program-versions/{versionId}/sessions)
          ContainerListTile(
            title: "T2. Crear Sesión",
            subtitle: "POST /training/program-versions/{versionId}/sessions",
            expandedChild: [
              InputTextFormart(
                controller: _trVersionIdController,
                prefixIcon: AppIcon.capacitaciones,
                labelText: "Version ID",
                hintText: "UUID de la versión de programa",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trSessionTitleController,
                prefixIcon: AppIcon.edit,
                labelText: "Título de la Sesión",
                hintText: "Título descriptivo",
                maxLength: 180,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trSessionStartsAtController,
                prefixIcon: AppIcon.calendar,
                labelText: "Fecha de Inicio (ISO)",
                hintText: "YYYY-MM-DDTHH:MM:SSZ",
                maxLength: 30,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trSessionEndsAtController,
                prefixIcon: AppIcon.calendar,
                labelText: "Fecha de Fin (ISO)",
                hintText: "YYYY-MM-DDTHH:MM:SSZ",
                maxLength: 30,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Crear Sesión",
                onPressed: () async {
                  final data = await ref
                      .read(trainingProvider.notifier)
                      .createSession(
                        versionId: _trVersionIdController.text.trim(),
                        title: _trSessionTitleController.text.trim(),
                        startsAt: _trSessionStartsAtController.text.trim(),
                        endsAt: _trSessionEndsAtController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    if (data['sessionId'] != null) {
                      _trSessionIdController.text = data['sessionId'].toString();
                    }
                    SnackBarFormat().show(
                      context,
                      "Sesión creada. ID: ${data['sessionId'] ?? 'OK'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // T3. Inscribir Aspirante (POST /training/program-versions/{versionId}/enrollments)
          ContainerListTile(
            title: "T3. Inscribir Aspirante",
            subtitle: "POST /training/program-versions/{versionId}/enrollments",
            expandedChild: [
              InputTextFormart(
                controller: _trVersionIdController,
                prefixIcon: AppIcon.capacitaciones,
                labelText: "Version ID",
                hintText: "UUID de la versión de programa",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trEnrollmentMembershipIdController,
                prefixIcon: AppIcon.person,
                labelText: "Membership ID",
                hintText: "UUID de membresía del aspirante",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Inscribir Aspirante",
                onPressed: () async {
                  final data = await ref
                      .read(trainingProvider.notifier)
                      .createEnrollment(
                        versionId: _trVersionIdController.text.trim(),
                        membershipId:
                            _trEnrollmentMembershipIdController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    if (data['enrollmentId'] != null) {
                      _trAttendanceEnrollmentIdController.text =
                          data['enrollmentId'].toString();
                      _trProgressEnrollmentIdController.text =
                          data['enrollmentId'].toString();
                      _trDecisionEnrollmentIdController.text =
                          data['enrollmentId'].toString();
                    }
                    SnackBarFormat().show(
                      context,
                      "Inscrito. Enrollment ID: ${data['enrollmentId'] ?? 'OK'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // T4. Cambiar Estado de Sesión (PUT /training/sessions/{sessionId}/status)
          ContainerListTile(
            title: "T4. Cambiar Estado de Sesión",
            subtitle: "PUT /training/sessions/{sessionId}/status",
            expandedChild: [
              InputTextFormart(
                controller: _trSessionIdController,
                prefixIcon: AppIcon.calendar,
                labelText: "Session ID",
                hintText: "UUID de la sesión",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trSessionStatusController,
                prefixIcon: AppIcon.edit,
                labelText: "Estado (CLOSED / CANCELLED)",
                hintText: "CLOSED",
                maxLength: 20,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Actualizar Estado",
                onPressed: () async {
                  final data = await ref
                      .read(trainingProvider.notifier)
                      .changeSessionStatus(
                        sessionId: _trSessionIdController.text.trim(),
                        status: _trSessionStatusController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Estado actualizado a: ${data['status'] ?? 'OK'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // T5. Registrar Asistencia (PUT /training/sessions/{sessionId}/attendance/{enrollmentId})
          ContainerListTile(
            title: "T5. Registrar Asistencia QR",
            subtitle: "PUT /training/sessions/{sessionId}/attendance/{enrollmentId}",
            expandedChild: [
              InputTextFormart(
                controller: _trSessionIdController,
                prefixIcon: AppIcon.calendar,
                labelText: "Session ID",
                hintText: "UUID de la sesión abierta",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trAttendanceEnrollmentIdController,
                prefixIcon: AppIcon.person,
                labelText: "Enrollment ID",
                hintText: "UUID de inscripción del aspirante",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trAttendanceStatusController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Estado (PRESENT / ABSENT / EXCUSED)",
                hintText: "PRESENT",
                maxLength: 20,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trAttendanceNotesController,
                prefixIcon: AppIcon.edit,
                labelText: "Notas",
                hintText: "Observación opcional",
                maxLength: 200,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Registrar Asistencia",
                onPressed: () async {
                  final data = await ref
                      .read(trainingProvider.notifier)
                      .recordAttendance(
                        sessionId: _trSessionIdController.text.trim(),
                        enrollmentId:
                            _trAttendanceEnrollmentIdController.text.trim(),
                        attendanceStatus:
                            _trAttendanceStatusController.text.trim(),
                        notes: _trAttendanceNotesController.text.trim().isNotEmpty
                            ? _trAttendanceNotesController.text.trim()
                            : null,
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Asistencia: ${data['attendanceStatus'] ?? 'Registrada'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // T6. Consultar Progreso Factual (GET /training/enrollments/{enrollmentId}/progress)
          ContainerListTile(
            title: "T6. Progreso de Asistencia",
            subtitle: "GET /training/enrollments/{enrollmentId}/progress",
            expandedChild: [
              InputTextFormart(
                controller: _trProgressEnrollmentIdController,
                prefixIcon: AppIcon.person,
                labelText: "Enrollment ID",
                hintText: "UUID de inscripción",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Consultar Progreso",
                onPressed: () async {
                  final progress = await ref
                      .read(trainingProvider.notifier)
                      .getProgress(
                        enrollmentId:
                            _trProgressEnrollmentIdController.text.trim(),
                      );
                  if (context.mounted && progress != null) {
                    SnackBarFormat().show(
                      context,
                      "Asistencias: ${progress.presentSessions}/${progress.totalSessions} (${progress.attendanceRate ?? 0}%)",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // T7. Configurar Criterios de Promoción (PUT /training/program-versions/{versionId}/promotion-criteria)
          ContainerListTile(
            title: "T7. Criterios de Promoción",
            subtitle: "PUT /training/program-versions/{versionId}/promotion-criteria",
            expandedChild: [
              InputTextFormart(
                controller: _trVersionIdController,
                prefixIcon: AppIcon.capacitaciones,
                labelText: "Version ID",
                hintText: "UUID de versión",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trPromotionMinSessionsController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Mínimo Sesiones Presentes",
                hintText: "Ej. 5",
                maxLength: 5,
                keyboardType: TextInputType.number,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trPromotionMinRateController,
                prefixIcon: AppIcon.edit,
                labelText: "Porcentaje Mínimo Asistencia",
                hintText: "Ej. 80.0",
                maxLength: 5,
                keyboardType: TextInputType.number,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Guardar Criterios",
                onPressed: () async {
                  final minSessions = int.tryParse(
                        _trPromotionMinSessionsController.text.trim(),
                      ) ??
                      5;
                  final minRate = double.tryParse(
                        _trPromotionMinRateController.text.trim(),
                      ) ??
                      80.0;
                  final data = await ref
                      .read(trainingProvider.notifier)
                      .configurePromotionCriteria(
                        versionId: _trVersionIdController.text.trim(),
                        criteria: {
                          "minimumPresentSessions": minSessions,
                          "minimumAttendanceRate": minRate,
                          "requiredEvidenceCodes": ["EXAM_APPROVED"],
                        },
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Criterios de versión guardados con éxito",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // T8. Decidir Promoción de Aspirante (POST /training/enrollments/{enrollmentId}/promotion-decisions)
          ContainerListTile(
            title: "T8. Decidir Promoción",
            subtitle: "POST /training/enrollments/{enrollmentId}/promotion-decisions",
            expandedChild: [
              InputTextFormart(
                controller: _trDecisionEnrollmentIdController,
                prefixIcon: AppIcon.person,
                labelText: "Enrollment ID",
                hintText: "UUID de inscripción",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trDecisionOutcomeController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Resultado (APPROVED / REJECTED)",
                hintText: "APPROVED",
                maxLength: 20,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trDecisionReasonController,
                prefixIcon: AppIcon.edit,
                labelText: "Motivo",
                hintText: "Justificación de la directiva",
                maxLength: 200,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Aplicar Decisión de Promoción",
                onPressed: () async {
                  final data = await ref
                      .read(trainingProvider.notifier)
                      .decidePromotion(
                        enrollmentId:
                            _trDecisionEnrollmentIdController.text.trim(),
                        outcome: _trDecisionOutcomeController.text.trim(),
                        reason: _trDecisionReasonController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Decisión: ${data['outcome'] ?? 'Registrada'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // T9. Reconocer Experiencia Previa (POST /training/memberships/{membershipId}/experience-recognitions)
          ContainerListTile(
            title: "T9. Reconocimiento de Experiencia",
            subtitle: "POST /training/memberships/{membershipId}/experience-recognitions",
            expandedChild: [
              InputTextFormart(
                controller: _trExpMembershipIdController,
                prefixIcon: AppIcon.person,
                labelText: "Membership ID",
                hintText: "UUID de membresía del aspirante",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trExpOutcomeController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Resultado (APPROVED / REJECTED)",
                hintText: "APPROVED",
                maxLength: 20,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trExpReasonController,
                prefixIcon: AppIcon.edit,
                labelText: "Motivo",
                hintText: "Justificación",
                maxLength: 200,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _trExpSummaryController,
                prefixIcon: AppIcon.edit,
                labelText: "Resumen de Experiencia",
                hintText: "Detalle de campañas o experiencia previa",
                maxLength: 300,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Reconocer Experiencia",
                onPressed: () async {
                  final data = await ref
                      .read(trainingProvider.notifier)
                      .decideExperienceRecognition(
                        membershipId: _trExpMembershipIdController.text.trim(),
                        outcome: _trExpOutcomeController.text.trim(),
                        reason: _trExpReasonController.text.trim(),
                        experienceSummary: _trExpSummaryController.text.trim(),
                        evidence: [
                          {
                            "code": "PREV_CAMPAIGN",
                            "reference": "EXP-2024-01",
                            "description": "Participó en campaña verano 2024"
                          }
                        ],
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Experiencia: ${data['outcome'] ?? 'Registrada'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // T10. Historial de Transiciones (GET /training/memberships/{membershipId}/transition-history)
          ContainerListTile(
            title: "T10. Historial de Transiciones",
            subtitle: "GET /training/memberships/{membershipId}/transition-history",
            expandedChild: [
              InputTextFormart(
                controller: _trHistoryMembershipIdController,
                prefixIcon: AppIcon.person,
                labelText: "Membership ID",
                hintText: "UUID de membresía",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Consultar Historial",
                onPressed: () async {
                  final data = await ref
                      .read(trainingProvider.notifier)
                      .getMemberTransitionHistory(
                        membershipId:
                            _trHistoryMembershipIdController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    final events = (data['events'] as List?) ?? [];
                    SnackBarFormat().show(
                      context,
                      "Eventos de transición registrados: ${events.length}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightMedium,

          
          // MÓDULO 4: OPERACIONES DE CAMPAÑA (CAMPAIGN OPERATIONS)
          
          ContainerFormat(
            children: [
              TextFormat.subtitle("Módulo 4: Operaciones de Campaña"),
              AppSpacing.heightSmall,
              TextFormat.body(
                "Endpoints de planificación, grupos de trabajo, participantes, campos territoriales y traslados/apelaciones.",
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // O1. Crear Campaña (POST /operations/campaigns)
          ContainerListTile(
            title: "O1. Crear Campaña",
            subtitle: "POST /operations/campaigns",
            expandedChild: [
              InputTextFormart(
                controller: _cpClubIdController,
                prefixIcon: AppIcon.home,
                labelText: "Club ID",
                hintText: "UUID del club",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpNameController,
                prefixIcon: AppIcon.campana,
                labelText: "Nombre de la Campaña",
                hintText: "Ej. Campaña Verano 2026",
                maxLength: 180,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpStartsOnController,
                prefixIcon: AppIcon.calendar,
                labelText: "Fecha Inicio (YYYY-MM-DD)",
                hintText: "2026-06-01",
                maxLength: 10,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpEndsOnController,
                prefixIcon: AppIcon.calendar,
                labelText: "Fecha Fin (YYYY-MM-DD)",
                hintText: "2026-08-31",
                maxLength: 10,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpDescController,
                prefixIcon: AppIcon.edit,
                labelText: "Descripción",
                hintText: "Descripción de la campaña",
                maxLength: 200,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Crear Campaña",
                onPressed: () async {
                  final clubId = _cpClubIdController.text.trim().isNotEmpty
                      ? _cpClubIdController.text.trim()
                      : _wsClubIdController.text.trim();
                  final data = await ref
                      .read(campaignProvider.notifier)
                      .createCampaign(
                        clubId: clubId,
                        name: _cpNameController.text.trim(),
                        startsOn: _cpStartsOnController.text.trim(),
                        endsOn: _cpEndsOnController.text.trim(),
                        description: _cpDescController.text.trim().isNotEmpty
                            ? _cpDescController.text.trim()
                            : null,
                      );
                  if (context.mounted && data != null) {
                    if (data['campaignId'] != null) {
                      _cpCampaignIdController.text = data['campaignId'].toString();
                    }
                    SnackBarFormat().show(
                      context,
                      "Campaña creada. ID: ${data['campaignId'] ?? 'OK'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // O2. Cambiar Estado de Campaña (PUT /operations/campaigns/{campaignId}/status)
          ContainerListTile(
            title: "O2. Cambiar Estado de Campaña",
            subtitle: "PUT /operations/campaigns/{campaignId}/status",
            expandedChild: [
              InputTextFormart(
                controller: _cpCampaignIdController,
                prefixIcon: AppIcon.campana,
                labelText: "Campaign ID",
                hintText: "UUID de la campaña",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpStatusController,
                prefixIcon: AppIcon.edit,
                labelText: "Nuevo Estado (ACTIVE / CLOSED / CANCELLED)",
                hintText: "ACTIVE",
                maxLength: 20,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Actualizar Estado",
                onPressed: () async {
                  final data = await ref
                      .read(campaignProvider.notifier)
                      .changeCampaignStatus(
                        campaignId: _cpCampaignIdController.text.trim(),
                        status: _cpStatusController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Estado de campaña: ${data['status'] ?? 'Actualizado'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // O3. Crear Grupo de Trabajo (POST /operations/campaigns/{campaignId}/groups)
          ContainerListTile(
            title: "O3. Crear Grupo de Trabajo",
            subtitle: "POST /operations/campaigns/{campaignId}/groups",
            expandedChild: [
              InputTextFormart(
                controller: _cpCampaignIdController,
                prefixIcon: AppIcon.campana,
                labelText: "Campaign ID",
                hintText: "UUID de la campaña",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpGroupNameController,
                prefixIcon: AppIcon.grupos,
                labelText: "Nombre del Grupo",
                hintText: "Ej. Grupo Los Pioneros",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpGroupDescController,
                prefixIcon: AppIcon.edit,
                labelText: "Descripción",
                hintText: "Descripción del grupo",
                maxLength: 200,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Crear Grupo",
                onPressed: () async {
                  final data = await ref
                      .read(campaignProvider.notifier)
                      .createCampaignGroup(
                        campaignId: _cpCampaignIdController.text.trim(),
                        name: _cpGroupNameController.text.trim(),
                        description: _cpGroupDescController.text.trim().isNotEmpty
                            ? _cpGroupDescController.text.trim()
                            : null,
                      );
                  if (context.mounted && data != null) {
                    if (data['groupId'] != null) {
                      _cpGroupIdController.text = data['groupId'].toString();
                    }
                    SnackBarFormat().show(
                      context,
                      "Grupo creado. ID: ${data['groupId'] ?? 'OK'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // O4. Inscribir Participante en Campaña (POST /operations/campaigns/{campaignId}/participations)
          ContainerListTile(
            title: "O4. Inscribir Participante",
            subtitle: "POST /operations/campaigns/{campaignId}/participations",
            expandedChild: [
              InputTextFormart(
                controller: _cpCampaignIdController,
                prefixIcon: AppIcon.campana,
                labelText: "Campaign ID",
                hintText: "UUID de la campaña",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpMembershipIdController,
                prefixIcon: AppIcon.person,
                labelText: "Membership ID",
                hintText: "UUID de membresía del participante",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpGroupIdController,
                prefixIcon: AppIcon.grupos,
                labelText: "Group ID",
                hintText: "UUID del grupo inicial",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Inscribir Participante",
                onPressed: () async {
                  final data = await ref
                      .read(campaignProvider.notifier)
                      .enrollParticipation(
                        campaignId: _cpCampaignIdController.text.trim(),
                        membershipId: _cpMembershipIdController.text.trim(),
                        groupId: _cpGroupIdController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    if (data['participationId'] != null) {
                      _cpParticipationIdController.text =
                          data['participationId'].toString();
                    }
                    SnackBarFormat().show(
                      context,
                      "Participación inscrita. ID: ${data['participationId'] ?? 'OK'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // O5. Asignar Asociado Líder (PUT /operations/groups/{groupId}/associate)
          ContainerListTile(
            title: "O5. Asignar Asociado Líder",
            subtitle: "PUT /operations/groups/{groupId}/associate",
            expandedChild: [
              InputTextFormart(
                controller: _cpGroupIdController,
                prefixIcon: AppIcon.grupos,
                labelText: "Group ID",
                hintText: "UUID del grupo",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpParticipationIdController,
                prefixIcon: AppIcon.asociados,
                labelText: "Participation ID",
                hintText: "UUID de participación",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpAssociateReasonController,
                prefixIcon: AppIcon.edit,
                labelText: "Motivo / Justificación",
                hintText: "Motivo de la designación",
                maxLength: 200,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Asignar Asociado",
                onPressed: () async {
                  final data = await ref
                      .read(campaignProvider.notifier)
                      .assignGroupAssociate(
                        groupId: _cpGroupIdController.text.trim(),
                        participationId: _cpParticipationIdController.text.trim(),
                        reason: _cpAssociateReasonController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Asociado asignado al grupo con éxito",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // O6. Crear Campo Operativo (POST /operations/campaigns/{campaignId}/fields)
          ContainerListTile(
            title: "O6. Crear Campo Operativo",
            subtitle: "POST /operations/campaigns/{campaignId}/fields",
            expandedChild: [
              InputTextFormart(
                controller: _cpCampaignIdController,
                prefixIcon: AppIcon.campana,
                labelText: "Campaign ID",
                hintText: "UUID de la campaña",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpGroupIdController,
                prefixIcon: AppIcon.grupos,
                labelText: "Group ID",
                hintText: "UUID del grupo asignado",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpFieldNameController,
                prefixIcon: AppIcon.campos,
                labelText: "Nombre del Campo",
                hintText: "Ej. Colonia del Valle",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpFieldOrgController,
                prefixIcon: AppIcon.home,
                labelText: "Organización / Iglesia",
                hintText: "Entidad organizativa",
                maxLength: 100,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Crear Campo",
                onPressed: () async {
                  final data = await ref
                      .read(campaignProvider.notifier)
                      .createOperationalField(
                        campaignId: _cpCampaignIdController.text.trim(),
                        groupId: _cpGroupIdController.text.trim(),
                        name: _cpFieldNameController.text.trim(),
                        organization: _cpFieldOrgController.text.trim().isNotEmpty
                            ? _cpFieldOrgController.text.trim()
                            : null,
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Campo operativo creado. ID: ${data['fieldId'] ?? 'OK'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // O7. Solicitar Cambio de Grupo (POST /operations/participations/{participationId}/group-change-requests)
          ContainerListTile(
            title: "O7. Solicitar Cambio de Grupo",
            subtitle:
                "POST /operations/participations/{participationId}/group-change-requests",
            expandedChild: [
              InputTextFormart(
                controller: _cpParticipationIdController,
                prefixIcon: AppIcon.person,
                labelText: "Participation ID",
                hintText: "UUID de participación",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpReqGroupIdController,
                prefixIcon: AppIcon.grupos,
                labelText: "Requested Group ID",
                hintText: "UUID del grupo solicitado",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpReqReasonController,
                prefixIcon: AppIcon.edit,
                labelText: "Motivo del Traslado",
                hintText: "Explicación de la solicitud",
                maxLength: 200,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Enviar Solicitud de Traslado",
                onPressed: () async {
                  final data = await ref
                      .read(campaignProvider.notifier)
                      .requestGroupChange(
                        participationId: _cpParticipationIdController.text.trim(),
                        requestedGroupId: _cpReqGroupIdController.text.trim(),
                        reason: _cpReqReasonController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    if (data['requestId'] != null) {
                      _cpChangeRequestIdController.text =
                          data['requestId'].toString();
                    }
                    SnackBarFormat().show(
                      context,
                      "Solicitud enviada. Request ID: ${data['requestId'] ?? 'OK'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // O8. Resolver Solicitud de Traslado (POST /operations/group-change-requests/{requestId}/resolve)
          ContainerListTile(
            title: "O8. Resolver Solicitud de Traslado",
            subtitle:
                "POST /operations/group-change-requests/{requestId}/resolve",
            expandedChild: [
              InputTextFormart(
                controller: _cpChangeRequestIdController,
                prefixIcon: AppIcon.grupos,
                labelText: "Request ID",
                hintText: "UUID de la solicitud",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpResolveOutcomeController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Resultado (APPROVED / REJECTED)",
                hintText: "APPROVED",
                maxLength: 20,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpResolveReasonController,
                prefixIcon: AppIcon.edit,
                labelText: "Resolución",
                hintText: "Dictamen de la directiva",
                maxLength: 200,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Resolver Traslado",
                onPressed: () async {
                  final data = await ref
                      .read(campaignProvider.notifier)
                      .resolveGroupChange(
                        requestId: _cpChangeRequestIdController.text.trim(),
                        outcome: _cpResolveOutcomeController.text.trim(),
                        resolution: _cpResolveReasonController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Resolución: ${data['outcome'] ?? 'Registrada'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // O9. Apelar Decisión de Traslado (POST /operations/group-change-requests/{requestId}/appeals)
          ContainerListTile(
            title: "O9. Apelar Decisión de Traslado",
            subtitle:
                "POST /operations/group-change-requests/{requestId}/appeals",
            expandedChild: [
              InputTextFormart(
                controller: _cpChangeRequestIdController,
                prefixIcon: AppIcon.apelaciones,
                labelText: "Request ID",
                hintText: "UUID de la solicitud rechazada",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpAppealReasonController,
                prefixIcon: AppIcon.edit,
                labelText: "Motivo de la Apelación",
                hintText: "Justificación de la apelación",
                maxLength: 200,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Presentar Apelación",
                onPressed: () async {
                  final data = await ref
                      .read(campaignProvider.notifier)
                      .createGroupChangeAppeal(
                        requestId: _cpChangeRequestIdController.text.trim(),
                        reason: _cpAppealReasonController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    if (data['appealId'] != null) {
                      _cpAppealIdController.text = data['appealId'].toString();
                    }
                    SnackBarFormat().show(
                      context,
                      "Apelación presentada. Appeal ID: ${data['appealId'] ?? 'OK'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // O10. Resolver Apelación de Traslado (POST /operations/group-change-appeals/{appealId}/resolve)
          ContainerListTile(
            title: "O10. Resolver Apelación",
            subtitle:
                "POST /operations/group-change-appeals/{appealId}/resolve",
            expandedChild: [
              InputTextFormart(
                controller: _cpAppealIdController,
                prefixIcon: AppIcon.apelaciones,
                labelText: "Appeal ID",
                hintText: "UUID de la apelación",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpAppealOutcomeController,
                prefixIcon: AppIcon.doneAll,
                labelText: "Resultado (APPROVED / REJECTED)",
                hintText: "APPROVED",
                maxLength: 20,
              ),
              AppSpacing.heightSmall,
              InputTextFormart(
                controller: _cpAppealResolutionController,
                prefixIcon: AppIcon.edit,
                labelText: "Resolución Final",
                hintText: "Dictamen final",
                maxLength: 200,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Resolver Apelación",
                onPressed: () async {
                  final data = await ref
                      .read(campaignProvider.notifier)
                      .resolveGroupChangeAppeal(
                        appealId: _cpAppealIdController.text.trim(),
                        outcome: _cpAppealOutcomeController.text.trim(),
                        resolution: _cpAppealResolutionController.text.trim(),
                      );
                  if (context.mounted && data != null) {
                    SnackBarFormat().show(
                      context,
                      "Apelación: ${data['outcome'] ?? 'Resuelta'}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightSmall,

          // O11. Resumen Operativo del Grupo (GET /operations/groups/{groupId}/overview)
          ContainerListTile(
            title: "O11. Resumen Operativo del Grupo",
            subtitle: "GET /operations/groups/{groupId}/overview",
            expandedChild: [
              InputTextFormart(
                controller: _cpGroupIdController,
                prefixIcon: AppIcon.grupos,
                labelText: "Group ID",
                hintText: "UUID del grupo",
                maxLength: 40,
              ),
              AppSpacing.heightSmall,
              ButtonFormat.secondary(
                label: "Consultar Resumen",
                onPressed: () async {
                  final overview = await ref
                      .read(campaignProvider.notifier)
                      .getGroupOverview(
                        groupId: _cpGroupIdController.text.trim(),
                      );
                  if (context.mounted && overview != null) {
                    SnackBarFormat().show(
                      context,
                      "Grupo: ${overview.name} | Participantes: ${overview.participants.length} | Campos: ${overview.fields.length}",
                    );
                  }
                },
              ),
            ],
          ),
          AppSpacing.heightMedium,
        ],
      ],
    );
  }
}
