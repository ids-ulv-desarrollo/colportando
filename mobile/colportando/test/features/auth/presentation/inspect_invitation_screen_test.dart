import 'dart:async';

import 'package:colportando/core/error/result.dart';
import 'package:colportando/core/router/global_route.dart';
import 'package:colportando/features/auth/domain/entities/invitation.dart';
import 'package:colportando/features/auth/presentation/screens/inspect_invitation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_auth_repository.dart';

void main() {
  // Abre la consulta sobre una pantalla inicial, llena el formulario y envía la consulta.
  Future<FakeAuthRepository> submitInspection(
    WidgetTester tester,
    Completer<Result<InvitationPreview>> pending,
  ) async {
    final repository = FakeAuthRepository()
      ..inspectResponses.add(() => pending.future);
    await tester.pumpWidget(
      ProviderScope(
        overrides: invitationTestOverrides(repository),
        child: MaterialApp(
          routes: {
            GlobalRoute.signup: (context) =>
                const Scaffold(body: Text('Registro abierto')),
          },
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const InspectInvitationScreen(),
                  ),
                ),
                child: const Text('Abrir consulta'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir consulta'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'aspirante@ejemplo.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'ABCD-1234-EFGH');
    await tester.tap(find.text('Consultar invitación'));
    await tester.pump();
    return repository;
  }

  testWidgets('abre el registro una vez cuando la consulta responde en pantalla', (tester) async {
    final pending = Completer<Result<InvitationPreview>>();
    final repository = await submitInspection(tester, pending);

    pending.complete(Result.success(samplePreview));
    await tester.pumpAndSettle();

    expect(repository.inspectCalls, 1);
    expect(find.text('Registro abierto'), findsOneWidget);
  });

  testWidgets('no navega ni avisa si la respuesta llega después de salir', (tester) async {
    final pending = Completer<Result<InvitationPreview>>();
    await submitInspection(tester, pending);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    pending.complete(Result.success(samplePreview));
    await tester.pumpAndSettle();

    expect(find.text('Registro abierto'), findsNothing);
    expect(find.byType(SnackBar), findsNothing);
    expect(find.text('Abrir consulta'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('no avisa si el error llega durante la transición de salida', (tester) async {
    final pending = Completer<Result<InvitationPreview>>();
    await submitInspection(tester, pending);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pump();
    pending.complete(
      const Result.failure(
        'La invitación no está disponible. Revisa el correo y el código.',
        statusCode: 404,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
