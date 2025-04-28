import 'package:flutter/material.dart';

class ButtonSubmit extends StatelessWidget {
  final VoidCallback onPressed;

  const ButtonSubmit({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text('Entrar'),
    );
  }
}