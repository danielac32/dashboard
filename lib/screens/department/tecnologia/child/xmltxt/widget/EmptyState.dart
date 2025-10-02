import 'package:flutter/material.dart';
import '../controller/Controller.dart';
import 'package:get/get.dart';


class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Colors.blue.shade200,
          ),
          const SizedBox(height: 20),
          Text(
            'No hay archivos disponibles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Presiona el botón "Consultar XML" para buscar archivos SENIAT en el servidor',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}