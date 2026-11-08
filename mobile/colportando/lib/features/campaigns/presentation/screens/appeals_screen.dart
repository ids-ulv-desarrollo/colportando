import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/bottom_sheet_format.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/auth/presentation/riverpod/auth_riverpod.dart';
import 'package:colportando/features/campaigns/presentation/riverpod/appeals_riverpod.dart';
import 'package:colportando/features/campaigns/presentation/screens/add_appeals_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pantalla de apelaciones y revisiones de solicitudes.
class AppealsScreen extends ConsumerWidget {
  const AppealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final userId = user?.id ?? unauthenticatedAppealUserId;
    final appeals = ref
        .watch(appealsProvider)
        .where((appeal) => appeal.userId == userId)
        .toList()
        .reversed
        .toList();

    return ScaffoldFormat(
      titleAppBar: "Apelaciones",
      children: [
        ButtonFormat.primary(
          label: "Realizar apelación",
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AppealFormScreen()),
          ),
        ),
        AppSpacing.heightMedium,
        TextFormat.subtitle("Mis apelaciones"),
        AppSpacing.heightSmall,
        ListViewFormat(
          itemCount: appeals.length,
          emptyWidget: AppIcon.noAccounts,
          emptyMessage: "Aún no has realizado apelaciones.",
          itemBuilder: (context, index) {
            final appeal = appeals[index];
            return ContainerListTile(
              title: "Folio: ${appeal.id}",
              subtitle: appeal.userName,
              subsubtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFormat.label(appeal.currentGroup),
                  Container(
                    height: 20,
                    width: 85,
                    decoration: BoxDecoration(
                      color: getColorStatus(appeal.status).withOpacity(0.3),
                      borderRadius: AppSpacing.borderMedium,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: TextFormat.label(
                        appeal.status,
                        textAlign: TextAlign.center,
                        color: getColorStatus(appeal.status),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              icon: AppIcon.apelaciones,
              onPressed: () => BottomSheetFormat.content(
                AppealsContent(
                  name: appeal.userName,
                  currentGroup: appeal.currentGroup,
                  realizationDate: appeal.formattedRealizationDate,
                  status: appeal.status,
                  responseDate: appeal.formattedResponseDate,
                  requestedGroup: appeal.requestedGroup,
                  reason: appeal.reason,
                ),
                title: "Detalle de apelación",
              ).show(context),
            );
          },
        ),
      ],
    );
  }
}

Color getColorStatus(String status) {
  return switch (status) {
    "Aceptada" => AppColor.primary,
    "Rechazada" => AppColor.error,
    _ => AppColor.warning,
  };
}

class AppealsContent extends StatelessWidget {
  final String name;
  final String currentGroup;
  final String realizationDate;
  final String status;
  final String? responseDate;
  final String requestedGroup;
  final String reason;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const AppealsContent({
    super.key,
    required this.name,
    required this.currentGroup,
    required this.realizationDate,
    required this.status,
    required this.requestedGroup,
    required this.reason,
    this.responseDate,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _detail("Nombre", name),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 20,
              width: 85,
              decoration: BoxDecoration(
                color: getColorStatus(status).withOpacity(0.3),
                borderRadius: AppSpacing.borderMedium,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: TextFormat.label(
                  status,
                  textAlign: TextAlign.center,
                  color: getColorStatus(status),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        _detail("Grupo actual", currentGroup),
        _detail("Fecha de realización", realizationDate),
        _detail("Grupo solicitado", requestedGroup),
        if (responseDate != null) _detail("Fecha de respuesta", responseDate!),
        _detail("Motivo", reason),
        if (onAccept != null && onReject != null)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onReject!,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColor.error,
                    side: const BorderSide(color: AppColor.error),
                  ),
                  icon: IconTheme(
                    data: const IconThemeData(color: AppColor.error),
                    child: AppIcon.cancel,
                  ),
                  label: TextFormat.body("Rechazar", color: AppColor.error),
                ),
              ),
              AppSpacing.widthSmall,
              Expanded(
                child: ButtonFormat.primary(
                  label: "Aceptar",
                  onPressed: onAccept!,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormat.label(label, color: AppColor.gray),
          TextFormat.body(value),
        ],
      ),
    );
  }
}
