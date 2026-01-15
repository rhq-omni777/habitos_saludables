import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitos_saludables/config/providers/auth_state_provider.dart';
import 'package:habitos_saludables/core/validators/auth_validators.dart';
import 'package:habitos_saludables/domain/entities/auth_state.dart';
import 'package:habitos_saludables/presentation/widgets/index.dart';

/// Página de recuperación de contraseña
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  late TextEditingController _emailController;
  late GlobalKey<FormState> _formKey;
  String? _emailError;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      _emailError = AuthValidators.validateEmail(_emailController.text);
    });
  }

  void _handleResetPassword() {
    _validateEmail();

    if (_emailError == null && _emailController.text.isNotEmpty) {
      ref.read(authStateProvider.notifier).resetPassword(
            email: _emailController.text,
          );
      setState(() {
        _emailSent = true;
      });
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
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar contraseña'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _emailSent
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 64),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.shade100,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 64,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Correo enviado',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Hemos enviado un enlace de recuperación a:\n${_emailController.text}',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                      ),
                      const SizedBox(height: 48),
                      AuthButton(
                        text: 'Volver al login',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        'Recuperar acceso',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ingresa tu correo para recibir instrucciones',
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
                              validator: (_) => _emailError,
                              onChanged: (_) {
                                if (_emailError != null) {
                                  _validateEmail();
                                }
                              },
                            ),
                            const SizedBox(height: 24),
                            if (authState is AuthError)
                              ErrorMessage(
                                message: authState.message,
                              ),
                            const SizedBox(height: 24),
                            AuthButton(
                              text: 'Enviar enlace',
                              onPressed: _handleResetPassword,
                              isLoading: isLoading,
                              isEnabled: !isLoading,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Volver atrás',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
