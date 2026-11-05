import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:flutter/material.dart';

// Pantalla principal de campañas de colportaje.
class CampaignsScreen extends StatelessWidget {
  const CampaignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> _text = ["campaña 1", "campaña 2", "campaña 3"];
    final List<String> _subti = ["Actual", "Proxima", "Finalizada"];
    return ScaffoldFormat(
      isLoading: false,
      titleAppBar: "Campañas",
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, GlobalRoute.addCampign),
        elevation: 50,
        child: AppIcon.add,
      ),
      children: [
        const InputTextFormart(
          hintText: 'Buscar campaña',
          maxLength: 20,
          prefixIcon: AppIcon.search,
        ),
        AppSpacing.heightMedium,
        ListViewFormat(
          emptyMessage: "No hay campañas aún",
          itemCount: 3,
          itemBuilder: (context, index) {
            return ContainerListTile(
              onPressed: () =>
                  Navigator.pushNamed(context, GlobalRoute.detailCampign),
              title: _text[index],
              subtitle: _subti[index],
              icon: AppIcon.campana,
            );
          },
        ),
      ],
    );
  }
}
