import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/core/theme/app_icon.dart';
import 'package:colportando/core/theme/app_spacing.dart';
import 'package:colportando/core/widgets/bottom_sheet_format.dart';
import 'package:colportando/core/widgets/container_list_tile_format.dart';
import 'package:colportando/core/widgets/filter_chip_format.dart';
import 'package:colportando/core/widgets/input_text_formart.dart';
import 'package:colportando/core/widgets/list_view_format.dart';
import 'package:colportando/core/widgets/scaffold_format.dart';
import 'package:colportando/core/widgets/text_format.dart';
import 'package:flutter/material.dart';

class _Credits {
  final String name;
  final String date;
  final String state;

  const _Credits({required this.name, required this.date, required this.state});
}

class _Books {
  final String name;
  final String state;

  const _Books({required this.name, required this.state});
}

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  final GlobalKey<FormState> _fromkey = GlobalKey<FormState>();

  final TextEditingController _searchController = TextEditingController();
  final List<_Credits> _allCredits = const [
    _Credits(name: "Moisés Martínez", date: "09/11/2026", state: "Vigente"),
    _Credits(name: "Jonathan Juarez", date: "09/11/2026", state: "Pendiente"),
    _Credits(name: "Jair lopez", date: "09/11/2026", state: "Vencido"),
    _Credits(name: "Itiel Alvarez", date: "09/11/2026", state: "Liquidado"),
  ];
  final List<_Books> _allBooks = const [
    _Books(name: "Su palabra de honor", state: "Anonimo 1"),
    _Books(name: "Hijos triunfadores", state: "Anonimo 2"),
    _Books(name: "El confilcto de los siglos", state: "Anonimo 3"),
    _Books(name: "El camino a Cristo", state: "Anonimo 4"),
  ];

  String __selectStateFilter = "Todos";
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Credits> get _filteredCredits {
    return _allCredits.where((credits) {
      final matchesState =
          __selectStateFilter == "Todos" ||
          (__selectStateFilter == "Vigentes" && credits.state == "Vigente") ||
          (__selectStateFilter == "Vencidos" && credits.state == "Vencido") ||
          (__selectStateFilter == "Liquidados" && credits.state == "Liquidado");

      final matchesSearch =
          _searchQuery.isEmpty ||
          credits.name.toLowerCase().contains(_searchQuery);

      return matchesState && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredCredits;
    return ScaffoldFormat(
      formKey: _fromkey,
      titleAppBar: "Créditos",
      isLoading: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.popAndPushNamed(context, GlobalRoute.addCredit),
        elevation: 50,
        child: AppIcon.add,
      ),
      children: [
        InputTextFormart(
          controller: _searchController,
          hintText: "Buscar crédito",
          maxLength: 50,
          prefixIcon: AppIcon.search,
        ),
        AppSpacing.heightMedium,
        ListViewFormat(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) {
            const options = ["Todos", "Vigentes", "Vencidos", "Liquidados"];
            final option = options[index];
            return FilterChipFormat(
              label: option,
              isSelected: __selectStateFilter == option,
              onSelected: (_) {
                setState(() => __selectStateFilter = option);
              },
            );
          },
        ),
        AppSpacing.heightMedium,
        ListViewFormat(
          emptyMessage: _searchQuery.isEmpty
              ? "No hay créditos en esta categoría"
              : "No se encontraron resultados para '$_searchQuery'",
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final credits = filteredList[index];
            return ContainerListTile(
              title: credits.name,
              subsubtitle: credits.state,
              icon: AppIcon.credito,
              onPressed: () => BottomSheetFormat(
                title: "Detalles",
                children: [
                  TextFormat.body("Fecha de inicio"),
                  AppSpacing.heightMedium,
                  TextFormat.body("Fecha de corte"),
                  AppSpacing.heightMedium,
                  TextFormat.body("Estado"),
                  AppSpacing.heightMedium,
                  TextFormat.body("Folio: ###"),
                  AppSpacing.heightMedium,
                  TextFormat.body("Total: "),
                  AppSpacing.heightMedium,
                  TextFormat.subtitle("Materiales"),
                  AppSpacing.heightSmall,
                  ListViewFormat(
                    emptyMessage: "No hay materiales registrados",
                    itemCount: _allBooks.length,
                    itemBuilder: (context, index) {
                      final book = _allBooks[index];
                      return ContainerListTile(
                        title: book.name,
                        subtitle: book.state,
                        icon: AppIcon.catalogo,
                      );
                    },
                  ),
                ],
              ).show(context),
            );
          },
        ),
      ],
    );
  }
}
