import 'package:flutter/material.dart';

import '../../../core/config/theme/app_theme.dart';

class GenericDownloadButton extends StatelessWidget {
  /// Acción a ejecutar al presionar el botón
  //final Future<void> Function()? onDownload;
  final VoidCallback onDownload;
  /// Indica si está cargando
  final bool isLoading;

  const GenericDownloadButton({
    super.key,
    required this.onDownload,
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
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.blue,
              ),
            ),
          )
        else ...[
          Tooltip(
            message: 'Descargar reporte',
            child: InkWell(
              onTap: onDownload,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppTheme.goldColor, // Puedes cambiar por AppTheme.goldColor si lo pasas como parámetro
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.download,
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
GenericDownloadButton(
  isLoading: miOtroController.cargando.value,
  onDownload: () async {
    await miOtroController.descargarReporte();
  },
)
 */