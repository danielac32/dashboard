import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core_system/screens/auth/controller/login_controller.dart';

import '../../core/config/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.jpeg'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade900,
              Colors.grey.shade800,
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
                //_buildHeader(context),
                const SizedBox(height: 40),

                // Card con el formulario
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity( 0.3 ),
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
                              color: AppTheme.goldColor,
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
        Icon(
          Icons.account_circle,
          size: 80,
          color: Colors.blue.shade200,
        ),
        const SizedBox(height: 20),
        Text(
          'Bienvenido',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color:  Colors.white,
          ),
        ),
        Text(
          'Inicia sesión para continuar',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade400,
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
            color: Colors.grey.shade300,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: loginController.emailController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email_outlined,
                color: AppTheme.goldColor),
            hintText: 'tucorreo@example.com',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey.shade700.withOpacity(0.7),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 16),
          ),
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            color: Colors.white,
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
            color: Colors.grey.shade300,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => TextField(
          controller: loginController.passwordController,
          obscureText: !loginController.isPasswordVisible.value,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline,
                color: AppTheme.goldColor),
            suffixIcon: IconButton(
              icon: Icon(
                loginController.isPasswordVisible.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppTheme.goldColor.withOpacity(0.8),
              ),
              onPressed: loginController.togglePasswordVisibility,
            ),
            hintText: '••••••••',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey.shade700.withOpacity(0.7),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 16),
          ),
          style: TextStyle(
            color: Colors.white,
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
          backgroundColor: AppTheme.goldColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          //shadowColor: Colors.blue.shade900,
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
            color: Colors.grey.shade600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'o',
            style: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.shade600,
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
          color: AppTheme.goldColor,
          width: 1.5,
        ),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.transparent,
      ),
      child: Text(
        'Crear una cuenta',
        style: TextStyle(
          color: AppTheme.goldColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}