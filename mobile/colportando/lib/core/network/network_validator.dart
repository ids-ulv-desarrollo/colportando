import 'dart:async';
import 'package:colportando/core/widgets/snackbar_format.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// Valida la conectividad a internet en tiempo real y notifica cambios de estado.
class NetworkValidator extends ConsumerStatefulWidget {
  final Widget screen;
  const NetworkValidator({super.key, required this.screen});

  @override
  ConsumerState<NetworkValidator> createState() => _NetworkValidatorState();
}

class _NetworkValidatorState extends ConsumerState<NetworkValidator> {
  StreamSubscription? _connectivitySub;
  Timer? _debounceTimer;
  bool? _hasInternet;

  @override
  void initState() {
    super.initState();
    _initNetworkListener();
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _initNetworkListener() async {
    // Verificación inicial de conectividad real.
    final isConnected = await InternetConnection().hasInternetAccess;
    if (!mounted) return;
    _hasInternet = isConnected;
    if (!isConnected) _snackbarNoConnection();

    // Escucha cambios de conectividad con debounce para evitar falsos positivos.
    _connectivitySub = Connectivity().onConnectivityChanged.listen((_) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), _checkAccess);
    });
  }

  Future<void> _checkAccess() async {
    final hasAccess = await InternetConnection().hasInternetAccess;
    if (!mounted || hasAccess == _hasInternet) return;

    _hasInternet = hasAccess;
    if (hasAccess) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      SnackBarFormat().show(context, "Conexión restaurada");
      _refresh();
    } else {
      _snackbarNoConnection();
    }
  }

  void _snackbarNoConnection() =>
      SnackBarFormat().show(context, "Sin conexión a internet", isError: true);

  // Refresca datos reactivos mediante Riverpod al restaurar la conexión.
  void _refresh() {
    // Hooks...
  }

  @override
  Widget build(BuildContext context) {
    return widget.screen;
  }
}
