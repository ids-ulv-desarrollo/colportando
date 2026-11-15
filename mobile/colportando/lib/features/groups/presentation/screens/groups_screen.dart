import 'package:colportando/core/theme/app_color.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/button_format.dart';
import 'package:colportando/core/widgets/bottom_sheet_format.dart';
import 'package:colportando/core/widgets/container_format.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:colportando/features/campaigns/presentation/riverpod/appeals_riverpod.dart';
import 'package:colportando/features/campaigns/presentation/screens/appeals_screen.dart';
import 'package:colportando/features/groups/domain/entities/group_zone.dart';
import 'package:colportando/features/groups/presentation/riverpod/groups_riverpod.dart';
import 'package:colportando/features/groups/presentation/screens/all_groups_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  static const _zoneColors = [
    AppColor.primary,
    AppColor.info,
    AppColor.warning,
    AppColor.error,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appeals = ref.watch(appealsProvider);
    final groups = ref.watch(groupsProvider);
    final zones = ref.watch(zonesProvider);
    final zoneCounts = {for (final zone in zones) zone.name: 0};
    var unassignedGroupCount = 0;
    for (final group in groups) {
      if (zoneCounts.containsKey(group.assignedZone)) {
        zoneCounts.update(group.assignedZone, (count) => count + 1);
      } else {
        unassignedGroupCount++;
      }
    }
    final zoneEntries = [
      ...zoneCounts.entries,
      if (zones.isEmpty || unassignedGroupCount > 0)
        MapEntry("Sin zona", unassignedGroupCount),
    ];
    final chartEntries = zones.isEmpty || groups.isEmpty
        ? const <MapEntry<String, int>>[]
        : zoneEntries.where((entry) => entry.value > 0).toList();

    return ScaffoldFormat(
      titleAppBar: "Grupos",
      children: [
        ContainerFormat(
          children: [
            TextFormat.subtitle("Grupos activos", textAlign: .left),
            Row(
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      sections: chartEntries.isEmpty
                          ? [
                              PieChartSectionData(
                                color: AppColor.gray,
                                value: 1,
                                title: "",
                                radius: 30,
                              ),
                            ]
                          : [
                              for (
                                var index = 0;
                                index < chartEntries.length;
                                index++
                              )
                                PieChartSectionData(
                                  color: _zoneColorFor(
                                    chartEntries[index].key,
                                    zones,
                                  ),
                                  value: chartEntries[index].value.toDouble(),
                                  title: "",
                                  radius: 30,
                                ),
                            ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: .center,
                      children: [
                        for (final entry in zoneEntries)
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _zoneColorFor(entry.key, zones),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              AppSpacing.widthSmall,
                              Expanded(
                                child: TextFormat.bodySecondary(
                                  "${entry.key}: ${entry.value}",
                                ),
                              ),
                            ],
                          ),
                        ButtonFormat.primary(
                          label: "Ver detalles",
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AllGroupsScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormat.subtitle("Apelaciones", textAlign: .center),
        ),
        ListViewFormat(
          itemCount: appeals.length,
          emptyMessage: "No se encontraron resultados.",
          emptyWidget: AppIcon.noAccounts,
          itemBuilder: (context, index) {
            final appeal = appeals[index];
            final isPending = appeal.status == "Pendiente";
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
                        textAlign: .center,
                        color: getColorStatus(appeal.status),
                        fontWeight: .w900,
                      ),
                    ),
                  ),
                ],
              ),
              //showTrailing: false,
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
                  onAccept: isPending
                      ? () => _updateAppealStatus(
                          context,
                          ref,
                          appeal.id,
                          "Aceptada",
                        )
                      : null,
                  onReject: isPending
                      ? () => _updateAppealStatus(
                          context,
                          ref,
                          appeal.id,
                          "Rechazada",
                        )
                      : null,
                ),
                title: "Apelación",
              ).show(context),
            );
          },
        ),
      ],
    );
  }

  void _updateAppealStatus(
    BuildContext context,
    WidgetRef ref,
    String appealId,
    String status,
  ) {
    final wasUpdated = ref
        .read(appealsProvider.notifier)
        .updateStatus(appealId, status);
    if (wasUpdated) Navigator.pop(context);
  }

  Color getColorStatus(String status) {
    return switch (status) {
      "Aceptada" => AppColor.primary,
      "Rechazada" => AppColor.error,
      _ => AppColor.warning,
    };
  }

  Color _zoneColorFor(String zoneName, List<GroupZone> zones) {
    final zoneIndex = zones.indexWhere((zone) => zone.name == zoneName);
    if (zoneIndex == -1) return AppColor.gray;
    return _zoneColors[zoneIndex % _zoneColors.length];
  }
}
