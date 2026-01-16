import 'package:flutter/material.dart';

/// Página principal tras autenticación
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: const Center(
        child: Text('Bienvenido a Hábitos Saludables'),
      ),
    );
  }
}
