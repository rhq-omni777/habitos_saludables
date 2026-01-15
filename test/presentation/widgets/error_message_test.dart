import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitos_saludables/presentation/widgets/error_message.dart';

void main() {
  group('ErrorMessage', () {
    testWidgets('No renderiza cuando el mensaje está vacío',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorMessage(message: ''),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('Renderiza mensaje de error', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorMessage(
              message: 'Credenciales inválidas',
            ),
          ),
        ),
      );

      expect(find.text('Credenciales inválidas'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('Renderiza botón de cerrar cuando onDismiss es proveído',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorMessage(
              message: 'Error',
              onDismiss: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('Llama onDismiss cuando se presiona cerrar',
        (WidgetTester tester) async {
      var dismissed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorMessage(
              message: 'Error',
              onDismiss: () {
                dismissed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      expect(dismissed, true);
    });

    testWidgets('Tiene fondo rojo', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorMessage(
              message: 'Error',
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Muestra múltiples líneas de error',
        (WidgetTester tester) async {
      const errorMessage = 'La contraseña debe tener:\n8+ caracteres\n'
          'Mayúsculas y minúsculas\nNúmeros y caracteres especiales';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorMessage(
              message: errorMessage,
            ),
          ),
        ),
      );

      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
