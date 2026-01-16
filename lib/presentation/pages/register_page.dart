import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitos_saludables/config/providers/auth_state_provider.dart';
import 'package:habitos_saludables/core/validators/auth_validators.dart';
import 'package:habitos_saludables/domain/entities/auth_state.dart';
import 'package:habitos_saludables/presentation/widgets/index.dart';

/// Página de registro de usuario
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late GlobalKey<FormState> _formKey;
  late Map<String, String?> _validationErrors;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _validationErrors = {};
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _validationErrors = AuthValidators.validateRegisterForm(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
    });
  }

  void _handleRegister() {
    _validateForm();

    if (_validationErrors.isEmpty) {
      ref.read(authStateProvider.notifier).register(
            name: _nameController.text,
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
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Únete a nosotros',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Crea una cuenta para empezar',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        key: const Key('register_name_field'),
                        label: 'Nombre completo',
                        hint: 'Juan Pérez',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.person_outlined),
                        validator: (_) => _validationErrors['name'],
                        onChanged: (_) {
                          if (_validationErrors.containsKey('name')) {
                            _validateForm();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        key: const Key('register_email_field'),
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
                        key: const Key('register_password_field'),
                        label: 'Contraseña',
                        hint: 'Mínimo 8 caracteres',
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
                      const SizedBox(height: 16),
                      AuthTextField(
                        key: const Key('register_confirm_field'),
                        label: 'Confirmar contraseña',
                        hint: 'Repite tu contraseña',
                        controller: _confirmPasswordController,
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        validator: (_) => _validationErrors['confirmPassword'],
                        onChanged: (_) {
                          if (_validationErrors.containsKey('confirmPassword')) {
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
                        text: 'Crear cuenta',
                        onPressed: _handleRegister,
                        isLoading: isLoading,
                        isEnabled: !isLoading,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes cuenta? ',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Inicia sesión',
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
