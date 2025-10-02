import 'package:flutter/material.dart';

import '../controller/Controller.dart';
import 'package:get/get.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              valueColor:
              AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Cargando información...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
