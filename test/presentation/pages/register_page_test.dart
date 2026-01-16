import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitos_saludables/presentation/pages/register_page.dart';
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
  group('RegisterPage', () {
    testWidgets('Renderiza campos de formulario de registro',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: RegisterPage(),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsWidgets);
      expect(find.text('Únete a nosotros'), findsOneWidget);
    });

    testWidgets('Muestra AppBar con título', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: RegisterPage(),
          ),
        ),
      );

      final appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);
      expect(
        find.descendant(of: appBar, matching: find.text('Crear cuenta')),
        findsOneWidget,
      );
    });

    testWidgets('Renderiza botón de crear cuenta', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: RegisterPage(),
          ),
        ),
      );

      expect(find.text('Crear cuenta'), findsWidgets);
    });

    testWidgets('Tiene enlace a iniciar sesión', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: RegisterPage(),
          ),
        ),
      );

      expect(find.text('Inicia sesión'), findsOneWidget);
    });

    testWidgets('Tiene campos para nombre, email, contraseña',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: RegisterPage(),
          ),
        ),
      );

      // Debería tener 4 TextFormFields: nombre, email, contraseña, confirmar
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('Acepta entrada en campo de nombre', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: RegisterPage(),
          ),
        ),
      );

      final nameField = find.byKey(const Key('register_name_field'));
      await tester.tap(nameField);
      await tester.pump();
      await tester.enterText(nameField, 'Juan Pérez');
      await tester.pumpAndSettle();
      expect(find.text('Juan Pérez'), findsWidgets);
    });

    testWidgets('Acepta entrada en campo de email', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: RegisterPage(),
          ),
        ),
      );

      final emailField = find.byKey(const Key('register_email_field'));
      await tester.tap(emailField);
      await tester.pump();
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();
    });

    testWidgets('Acepta entrada en campos de contraseña',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => _FakeAuthStateNotifier()),
          ],
          child: const MaterialApp(
            home: RegisterPage(),
          ),
        ),
      );

          final passwordField = find.byKey(const Key('register_password_field'));
          final confirmField = find.byKey(const Key('register_confirm_field'));

          await tester.tap(passwordField);
        await tester.pump();
        await tester.enterText(passwordField, 'Password123!');

        await tester.tap(confirmField);
        await tester.pump();
        await tester.enterText(confirmField, 'Password123!');
        await tester.pumpAndSettle();
    });
  });
}
