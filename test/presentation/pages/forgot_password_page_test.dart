import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitos_saludables/presentation/pages/forgot_password_page.dart';
import 'package:habitos_saludables/config/providers/auth_state_provider.dart';
import 'package:habitos_saludables/domain/entities/auth_state.dart';

class _FakeAuthStateNotifier extends AuthStateNotifier {
  _FakeAuthStateNotifier()
      : super(
          loginUsecase: ({required String email, required String password}) async {}
              as dynamic,
          registerUsecase:
              ({required String email, required String password, required String name}) async {}
                  as dynamic,
          logoutUsecase: () async {} as dynamic,
          getCurrentUserUsecase: () async {} as dynamic,
          resetPasswordUsecase: ({required String email}) async {} as dynamic,
          getCachedUserUsecase: () async {} as dynamic,
          checkUserCachedUsecase: () async => false as dynamic,
        );
}

void main() {
  group('ForgotPasswordPage', () {
    testWidgets('Renderiza campo de email', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: ForgotPasswordPage(),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Recuperar contraseña'), findsOneWidget);
    });

    testWidgets('Muestra título de recuperación', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: ForgotPasswordPage(),
          ),
        ),
      );

      expect(find.text('Recuperar acceso'), findsOneWidget);
      expect(
          find.text('Ingresa tu correo para recibir instrucciones'),
          findsOneWidget);
    });

    testWidgets('Renderiza botón de enviar enlace', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: ForgotPasswordPage(),
          ),
        ),
      );

      expect(find.text('Enviar enlace'), findsOneWidget);
    });

    testWidgets('Tiene botón de volver atrás', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: ForgotPasswordPage(),
          ),
        ),
      );

      expect(find.text('Volver atrás'), findsOneWidget);
    });

    testWidgets('Acepta entrada en campo de email', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: ForgotPasswordPage(),
          ),
        ),
      );

      final emailField = find.byType(TextFormField);
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();
      expect(find.text('test@example.com'), findsWidgets);
    });

    testWidgets('Tiene AppBar con título', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: ForgotPasswordPage(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Recuperar contraseña'), findsOneWidget);
    });

    testWidgets('Inicialmente muestra formulario, no confirmación',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: ForgotPasswordPage(),
          ),
        ),
      );

      // Debe mostrar el formulario inicialmente
      expect(find.text('Enviar enlace'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });
  });
}
