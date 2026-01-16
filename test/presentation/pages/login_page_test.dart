import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitos_saludables/presentation/pages/login_page.dart';
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
  group('LoginPage', () {
    testWidgets('Renderiza campos de email y contraseña',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsWidgets);
      expect(find.text('Bienvenido'), findsOneWidget);
    });

    testWidgets('Muestra título y subtítulo', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      expect(find.text('Bienvenido'), findsOneWidget);
      expect(find.text('Inicia sesión para continuar'), findsOneWidget);
    });

    testWidgets('Renderiza botón de iniciar sesión',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      expect(find.text('Iniciar sesión'), findsOneWidget);
    });

    testWidgets('Tiene enlace a registrarse', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      expect(find.text('Regístrate'), findsOneWidget);
    });

    testWidgets('Tiene enlace a recuperar contraseña',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      expect(find.text('¿Olvidaste tu contraseña?'), findsOneWidget);
    });

    testWidgets('Acepta entrada en campo de email', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      final textFields = find.byType(TextFormField);
      await tester.tap(textFields.first);
      await tester.pump();
      await tester.enterText(textFields.first, 'test@example.com');
      await tester.pumpAndSettle();
      expect(find.text('test@example.com'), findsWidgets);
    });

    testWidgets('Acepta entrada en campo de contraseña',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      final textFields = find.byType(TextFormField);
      await tester.tap(textFields.at(1));
      await tester.pump();
      await tester.enterText(textFields.at(1), 'Password123!');
      await tester.pumpAndSettle();
    });
  });
}
