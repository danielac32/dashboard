import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core_system/screens/auth/controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
              Colors.deepPurple.shade900,
              Colors.indigo.shade900,
            ]
                : [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo y título
                _buildHeader(context),
                const SizedBox(height: 40),

                // Card con el formulario
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey.shade900.withOpacity(0.8)
                        : Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      // Campo de email
                      _buildEmailField(context),
                      const SizedBox(height: 20),

                      // Campo de contraseña
                      _buildPasswordField(context),
                      const SizedBox(height: 10),

                      // Olvidé mi contraseña
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Navegar a recuperación de contraseña
                          },
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Botón de login
                      _buildLoginButton(context),
                      const SizedBox(height: 30),

                      // Divider
                      _buildDivider(context),
                      const SizedBox(height: 30),

                      // Botón de registro
                      _buildRegisterButton(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        /*Image.asset(
          'assets/logo.png', // Reemplaza con tu logo
          height: 100,
          width: 100,
        ),
        const SizedBox(height: 20),*/
        Text(
          'Bienvenido',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        Text(
          'Inicia sesión para continuar',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Correo electrónico',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: loginController.emailController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email_outlined,
                color: Theme.of(context).colorScheme.primary),
            hintText: 'tucorreo@example.com',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 16),
          ),
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contraseña',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => TextField(
          controller: loginController.passwordController,
          obscureText: !loginController.isPasswordVisible.value,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline,
                color: Theme.of(context).colorScheme.primary),
            suffixIcon: IconButton(
              icon: Icon(
                loginController.isPasswordVisible.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
              ),
              onPressed: loginController.togglePasswordVisibility,
            ),
            hintText: '••••••••',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 16),
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        )),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Obx(() {
      if (loginController.isLoading.value) {
        return const CircularProgressIndicator();
      }
      return ElevatedButton(
        onPressed: loginController.submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Iniciar sesión',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    });
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'o',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return OutlinedButton(
      onPressed: loginController.register,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        'Crear una cuenta',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}