import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitos_saludables/config/providers/auth_state_provider.dart';
import 'package:habitos_saludables/core/validators/auth_validators.dart';
import 'package:habitos_saludables/domain/entities/auth_state.dart';
import 'package:habitos_saludables/presentation/widgets/index.dart';

/// Página de inicio de sesión
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKey;
  late Map<String, String?> _validationErrors;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _validationErrors = {};
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _validationErrors = AuthValidators.validateLoginForm(
        email: _emailController.text,
        password: _passwordController.text,
      );
    });
  }

  void _handleLogin() {
    _validateForm();

    if (_validationErrors.isEmpty) {
      ref.read(authStateProvider.notifier).login(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = ref.watch(isLoadingProvider);

    ref.listen(authStateProvider, (previous, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
          ),
        );
      }

      // Navegar si está autenticado
      if (next is AuthAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });

    String errorMessage = '';
    if (authState is AuthError) {
      errorMessage = authState.message;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Bienvenido',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Inicia sesión para continuar',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 48),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        label: 'Correo electrónico',
                        hint: 'ejemplo@correo.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: (_) => _validationErrors['email'],
                        onChanged: (_) {
                          if (_validationErrors.containsKey('email')) {
                            _validateForm();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        label: 'Contraseña',
                        hint: 'Tu contraseña',
                        controller: _passwordController,
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        validator: (_) => _validationErrors['password'],
                        onChanged: (_) {
                          if (_validationErrors.containsKey('password')) {
                            _validateForm();
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      if (errorMessage.isNotEmpty)
                        ErrorMessage(
                          message: errorMessage,
                          onDismiss: () {
                            // Limpiar error
                          },
                        ),
                      const SizedBox(height: 24),
                      AuthButton(
                        text: 'Iniciar sesión',
                        onPressed: _handleLogin,
                        isLoading: isLoading,
                        isEnabled: !isLoading,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/forgot-password');
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes cuenta? ',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                      child: Text(
                        'Regístrate',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
