import 'package:flutter/material.dart';

class TextFieldEmail extends StatelessWidget {
  final TextEditingController controller;

  const TextFieldEmail({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Correo Electrónico',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        prefixIcon: const Icon(Icons.email),
      ),
    );
  }
}