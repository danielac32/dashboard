
import 'package:flutter/material.dart';



class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SIGECOF - SENIAT',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Procesamiento de archivos XML',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue.shade700,
          ),
        ),
      ],
    );
  }
}
