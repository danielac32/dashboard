

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'controller/controller.dart';
import 'model/support_model.dart';



class Soporte extends StatelessWidget {
  Soporte({Key? key}) : super(key: key);

  final UserSupportController controller = Get.put(UserSupportController());


  void _showDateRangeDialog(BuildContext context) {
    DateTime? _startDate;
    DateTime? _endDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(child: Text('Generar Reporte')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Fecha de inicio con DatePicker
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _startDate = picked;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.blue[800],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            children: [
                              Icon(Icons.calendar_today),
                              SizedBox(height: 8),
                              Text(
                                _startDate != null
                                    ? DateFormat('dd/MM/yyyy').format(_startDate!)
                                    : 'Desde',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Fecha de fin con DatePicker
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _endDate ?? DateTime.now(),
                            firstDate: _startDate ?? DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _endDate = picked;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[50],
                          foregroundColor: Colors.green[800],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            children: [
                              Icon(Icons.event),
                              SizedBox(height: 8),
                              Text(
                                _endDate != null
                                    ? DateFormat('dd/MM/yyyy').format(_endDate!)
                                    : 'Hasta',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Botón para generar reporte
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.analytics),
                        label: Text('Generar Reporte'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: (_startDate != null && _endDate != null)
                            ? () {
                          // Validar que la fecha final sea posterior
                          if (_endDate!.isBefore(_startDate!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('La fecha final debe ser posterior a la inicial'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Formatear y llamar al controller
                          final startStr = DateFormat('yyyy-MM-dd').format(_startDate!);
                          final endStr = DateFormat('yyyy-MM-dd').format(_endDate!);

                          controller.fetchReportByDateRange(startStr, endStr);
                          Navigator.of(context).pop();
                        }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  void _createSupport(BuildContext context) {
    // Variables para almacenar los valores de los campos
    String nombre = '';
    String descripcion = '';
    String departamento = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Crear Soporte'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Nombre del soporte',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    nombre = value;
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Ingrese una descripción',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    descripcion = value;
                  },
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Departamento',
                    hintText: 'Ingrese el departamento',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    departamento = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Crear el objeto con los datos ingresados
                      final support = {
                        "name": nombre,
                        "description": descripcion,
                        "departamento": departamento,
                      };



                      controller.createSupport(support);
                      // Cerrar el diálogo
                      Navigator.of(context).pop();

                      // Mostrar un mensaje de confirmación (opcional)
                      /*ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Impresora agregada correctamente'),
                          duration: Duration(seconds: 2),
                        ),
                      );*/
                    },
                    child: Text('Enviar'),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soporte Tecnico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createSupport(context),
          ),
          IconButton(
            icon: Icon(Icons.analytics),
            tooltip: 'Generar Reporte',
            onPressed: () => _showDateRangeDialog(context),
            // Para usar el selector nativo:
            // onPressed: () => _showNativeDateRangePicker(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Gráfico de barras
              Expanded(
                child: _buildBarChart(),
              ),

              const SizedBox(height: 20),

              // Lista de técnicos
              _buildUserList(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBarChart() {
    final userSupports = controller.userSupports;
    final maxSupport = userSupports.isNotEmpty
        ? userSupports.map((e) => e.supportCount).reduce((a, b) => a > b ? a : b)
        : 0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Cantidad de Soportes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxSupport * 1.1,
                  // Configuración simplificada sin tooltips
                  barTouchData: BarTouchData(
                    enabled: false, // Deshabilitar tooltips si causan problemas
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < userSupports.length) {
                            final user = userSupports[value.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Tooltip(
                                message: user.name,
                                child: Text(
                                  'T${value.toInt() + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: maxSupport > 10
                            ? (maxSupport / 5).ceil().toDouble()
                            : 2,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  barGroups: userSupports.asMap().entries.map((entry) {
                    final index = entry.key;
                    final user = entry.value;
                    final color = _getColorForIndex(index);

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: user.supportCount.toDouble(),
                          width: 20,
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Leyenda alternativa
            Wrap(
              spacing: 10,
              children: userSupports.asMap().entries.map((entry) {
                final index = entry.key;
                final user = entry.value;
                return Chip(
                  label: Text(
                    '${index + 1}: ${user.name} (${user.supportCount})',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getColorForIndex(index).withOpacity(0.2),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildUserList() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalle por Técnico',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150, // Altura fija con scroll
              child: ListView.builder(
                itemCount: controller.userSupports.length,
                itemBuilder: (context, index) {
                  final user = controller.userSupports[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getColorForIndex(index),
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(user.name),
                    subtitle: Text('${user.supportCount} soportes'),
                    trailing: Chip(
                      label: Text(
                        '${_calculatePercentage(controller.userSupports, user.supportCount).toStringAsFixed(1)}%',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _getColorForIndex(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }

  double _calculatePercentage(List<UserSupport> users, int userCount) {
    if (users.isEmpty) return 0;

    final total = users
        .map((user) => user.supportCount)
        .reduce((a, b) => a + b);

    return total > 0 ? (userCount / total * 100) : 0;
  }
}