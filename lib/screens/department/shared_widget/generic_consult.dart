
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/theme/app_theme.dart';

class GenericConsultButton extends StatelessWidget {
  /// Acción a realizar al presionar el botón de consulta
  final VoidCallback onConsult;

  /// Indica si está cargando
  final bool isLoading;

  const GenericConsultButton({
    super.key,
    required this.onConsult,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          ' ',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        if(isLoading) ...[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: 20,
              height: 20,
              /*child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.blue,
              ),*/
            ),
          )
        ] else...[
          Tooltip(
            message: 'Consultar',
            child: InkWell(
              onTap: onConsult,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppTheme.goldColor, // Puedes usar AppTheme.goldColor si lo pasas como parámetro
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
/*
GenericConsultButton(
  isLoading: miOtroController.cargando.value,
  onConsult: () {
    miOtroController.consultarDatos(
      miOtroController.fechaDesde.value,
      miOtroController.fechaHasta.value,
    );
  },
)
 */