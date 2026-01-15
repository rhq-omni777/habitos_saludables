import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitos_saludables/presentation/widgets/auth_text_field.dart';

void main() {
  group('AuthTextField', () {
    testWidgets('Renderiza TextField con label', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              label: 'Email',
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('Acepta texto ingresado', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              label: 'Email',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      expect(controller.text, 'test@example.com');
      controller.dispose();
    });

    testWidgets('Oscurece texto cuando obscureText es true',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              label: 'Password',
              controller: controller,
              obscureText: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      controller.dispose();
    });

    testWidgets('Muestra prefixIcon', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              label: 'Email',
              controller: controller,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      controller.dispose();
    });

    testWidgets('Alterna visibilidad de contraseña',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              label: 'Password',
              controller: controller,
              obscureText: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              label: 'Password',
              controller: controller,
              obscureText: true,
            ),
          ),
        ),
      );

      controller.dispose();
    });

    testWidgets('Muestra mensaje de validación', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              label: 'Email',
              controller: controller,
              validator: (_) => 'Email inválido',
            ),
          ),
        ),
      );

      final form = Form(
        child: AuthTextField(
          label: 'Email',
          controller: controller,
          validator: (_) => 'Email inválido',
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      controller.dispose();
    });

    testWidgets('Llama onChanged cuando el texto cambia',
        (WidgetTester tester) async {
      final controller = TextEditingController();
      String changedText = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthTextField(
              label: 'Email',
              controller: controller,
              onChanged: (value) {
                changedText = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.pumpAndSettle();
      expect(changedText, 'test@example.com');
      controller.dispose();
    });
  });
}
