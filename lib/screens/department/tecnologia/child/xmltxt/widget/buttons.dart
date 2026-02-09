

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/Controller.dart';





class ButtonsWidget extends StatelessWidget {
  const ButtonsWidget({
    super.key,
    required this.controller,
  });

  final XmlTxtController controller;


  void _insert(BuildContext context) {
    String fecha = '';
    String banco = '';
    String estatus = '';

    // Definir colores para mejor contraste
    final backgroundColor = Colors.blue.shade50;
    final textColor = Colors.grey.shade800; // Color principal para texto
    final titleColor = Colors.blue.shade900; // Color para títulos
    final subtitleColor = Colors.grey.shade700; // Color para subtítulos
    final labelColor = Colors.blue.shade800; // Color para labels
    final hintColor = Colors.grey.shade600; // Color para hint text

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: backgroundColor,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5,
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Título con botón de cerrar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Insertar en Postgre',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: titleColor, // Color más oscuro para el título
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 20, color: textColor),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Formulario en fila para ahorrar espacio
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Fecha',
                              labelStyle: TextStyle(color: labelColor), // Label oscuro
                              hintText: 'Fecha de Recaudación',
                              hintStyle: TextStyle(color: hintColor), // Hint más claro
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade600),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              fillColor: Colors.white, // Fondo blanco para los campos
                              filled: true,
                            ),
                            style: TextStyle(color: textColor), // Color del texto ingresado
                            onChanged: (value) => fecha = value,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Banco',
                              labelStyle: TextStyle(color: labelColor),
                              hintText: 'Banco',
                              hintStyle: TextStyle(color: hintColor),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade600),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            style: TextStyle(color: textColor),
                            onChanged: (value) => banco = value,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Estatus',
                              labelStyle: TextStyle(color: labelColor),
                              hintText: 'Ingrese el estatus',
                              hintStyle: TextStyle(color: hintColor),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade600),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            style: TextStyle(color: textColor),
                            onChanged: (value) => estatus = value,
                          ),
                        ),
                      ],
                    ),

                    // Botones de acción
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.blue.shade600), // Borde azul
                              foregroundColor: Colors.blue.shade700, // Texto azul
                            ),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () async {
                              final insert = {
                                "fecha": fecha,
                                "banco": banco,
                                "estatus": estatus,
                              };
                              await controller.insertFile(insert);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Colors.blue.shade700, // Fondo azul oscuro
                              foregroundColor: Colors.white, // Texto blanco
                            ),
                            child: Text(
                              'Enviar',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Sección de la tabla
                    SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400), // Borde más visible
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white, // Fondo blanco para la sección de tabla
                      ),
                      child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Registros Existentes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: titleColor, // Mismo color que el título principal
                                ),
                              ),
                              Text(
                                'Página ${controller.currentPage.value}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtitleColor, // Usar el color de subtítulo
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),

                          // Tabla
                          Column(
                            children: [
                              // Encabezado de la tabla
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade500)),
                                  color: Colors.blue.shade100, // Fondo azul claro para encabezado
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Fecha',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade900, // Azul oscuro
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Banco',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade900,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Estatus',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade900,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Cuerpo de la tabla
                              if (controller.recaudaciones.isEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 32),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.table_chart_outlined,
                                          size: 48,
                                          color: Colors.grey.shade500, // Icono más visible
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'No hay datos disponibles',
                                          style: TextStyle(
                                            color: subtitleColor, // Usar color de subtítulo
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                ...controller.recaudaciones.map((recaudacion) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      color: Colors.white, // Fondo blanco para filas
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            recaudacion.fechaRecaudacion ?? '',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: textColor, // Color principal de texto
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            recaudacion.banco ?? 'N/A',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: 8),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getEstatusColor(recaudacion.estatus ?? 0),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              recaudacion.estatus?.toString() ?? '',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                            ],
                          ),

                          // Controles de paginación
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: controller.currentPage.value <= 1
                                      ? null
                                      : () async {
                                    await controller.prev();
                                  },
                                  icon: Icon(Icons.arrow_back, size: 16),
                                  label: Text('Anterior'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: controller.currentPage.value <= 1
                                        ? Colors.grey.shade300
                                        : Colors.blue.shade700,
                                    foregroundColor: controller.currentPage.value <= 1
                                        ? Colors.grey.shade600
                                        : Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),

                                Text(
                                  '${controller.recaudaciones.length} registros',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: subtitleColor, // Color de subtítulo
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                ElevatedButton.icon(
                                  onPressed: !(controller.paginationInfo.value.hasNext ?? false)
                                      ? null
                                      : () async {
                                    await controller.next();
                                  },
                                  icon: Icon(Icons.arrow_forward, size: 16),
                                  label: Text('Siguiente'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: !(controller.paginationInfo.value.hasNext ?? false)
                                        ? Colors.grey.shade300
                                        : Colors.blue.shade700,
                                    foregroundColor: !(controller.paginationInfo.value.hasNext ?? false)
                                        ? Colors.grey.shade600
                                        : Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// Función auxiliar para colores según el estatus
  Color _getEstatusColor(int estatus) {
    switch (estatus) {
      case 11:
        return Colors.green.shade600;
      case 1:
        return Colors.blue.shade600;
      case 10:
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ctrl = controller;
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: [
          ElevatedButton(
            onPressed: ctrl.isLoading.value ? null : ctrl.subirArchivo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade800,
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ctrl.isLoading.value)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blue,
                      ),
                    ),
                  )
                else
                  const Icon(Icons.search, size: 24),
                const SizedBox(width: 8),
                Text(
                  ctrl.isLoading.value ? 'Buscando...' : 'Abrir',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: ctrl.isLoading.value ? null : ctrl.consultarArchivos,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade800,
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ctrl.isLoading.value)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blue,
                      ),
                    ),
                  )
                else
                  const Icon(Icons.verified, size: 24),
                const SizedBox(width: 8),
                Text(
                  ctrl.isLoading.value ? 'Buscando...' : 'Consultar XML',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: ctrl.xmlFiles.isEmpty || ctrl.isProcessing.value
                ? null
                : ctrl.procesarArchivos,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade50,
              foregroundColor: Colors.green.shade800,
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.isProcessing.value)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.green,
                      ),
                    ),
                  )
                else
                  const Icon(Icons.cloud_upload, size: 24),
                const SizedBox(width: 8),
                Text(
                  controller.isProcessing.value
                      ? 'Procesando...'
                      : 'Procesar Archivos',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: ()=> _insert(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade50,
              foregroundColor: Colors.green.shade800,
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Icon(Icons.upload, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Insertar en Pg',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
