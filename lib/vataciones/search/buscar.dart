import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/busqueda_controller.dart';
import '../interface/empleado.dart';

class BuscarEmpleadoTab extends StatelessWidget {
  const BuscarEmpleadoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final BusquedaController controller = Get.put(BusquedaController());
    final  _cedulaController = TextEditingController();


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // Campo de búsqueda con estilo moderno
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.lightBlueAccent.shade100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 180,
                    child: TextField(
                      onChanged: (query) {
                        controller.search(query);
                      },
                      //controller: _cedulaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Cédula,Nombre..',
                        labelText: 'Buscar',
                        labelStyle: const TextStyle(fontSize: 14),
                        prefixIcon: Icon(Icons.badge, size: 16, color: Colors.teal),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: controller.currentPage.value > 1
                              ? () => controller.previousPage()
                              : null,
                        ),
                        Text(
                          'Página ${controller.currentPage.value}',
                          style: TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: controller.currentPage.value * controller.pageSize <
                              controller.filteredEmpleados.length
                              ? () => controller.nextPage()
                              : null,
                        ),
                        Tooltip(
                          message: "Eliminar todos los usuarios",
                          child: IconButton(
                            icon: Icon(Icons.delete,color: Color.fromARGB(255, 255, 0, 0),),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Elimiar?"),
                                  content: Text("Desea Eliminar la base de datos?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                          // Cambiar estado
                                        controller.delete();
                                      },
                                      child: Text(
                                        'Confirmar',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Tooltip(
                          message: "Todos a SI VOTO",
                          child: IconButton(
                            icon: Icon(Icons.update,color: Colors.green),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Cambiar?"),
                                  content: Text("Desea cambiar todos a SI VOTO?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        controller.voto(true);// Cambiar estado
                                      },
                                      child: Text(
                                        'Confirmar',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Tooltip(
                          message: "Todos a NO VOTO",
                          child: IconButton(
                            icon: Icon(Icons.update,color: Color.fromARGB(255, 100, 0, 0)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Cambiar?"),
                                  content: Text("Desea cambiar todos a NO VOTO?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        controller.voto(false);// Cambiar estado
                                      },
                                      child: Text(
                                        'Confirmar',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Tooltip(
                          message: controller.filterStatus.value == FilterStatus.all
                              ? 'Todos'
                              : controller.filterStatus.value == FilterStatus.si
                              ? 'Si'
                              : 'No',
                          child: IconButton(
                            icon: controller.filterStatus.value == FilterStatus.all
                                ? Icon(Icons.people,color: Colors.blue)
                                : controller.filterStatus.value == FilterStatus.si
                                ? Icon(Icons.how_to_vote,color: Colors.green)
                                : Icon(Icons.block,color: Colors.red),
                            //Icon(Icons.update,color: Colors.yellow),
                            onPressed: controller.toggleFilter
                          ),
                        ),




                      ],
                    );
                  }),
                  /*ElevatedButton(
                    onPressed: controller.loading.value
                        ? null
                        : () => controller.buscarPorCedula(_cedulaController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      minimumSize: const Size(40, 40),
                      padding: EdgeInsets.zero,
                    ),
                    child: controller.loading.value
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                        : const Icon(Icons.search, size: 18),
                  ),*/
                ],
              ),
            ),

            const SizedBox(height: 30,),


            // Mensaje de estado
            Obx(() =>
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.37,
                  child: DropdownButtonFormField<String>(
                                // value: controller.list.value.isEmpty ? null : controller.rol.value,
                                items: controller.list.isEmpty
                    ? [const DropdownMenuItem(value: null, child: Text('Cargando Direcciones...'))]
                    : controller.list.map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      if (value != null) {
                        await controller.getEmpleadoDireccion(value);
                      }
                    },
                   decoration: InputDecoration(
                  labelText: 'Direccion',
                  prefixIcon: const Icon(Icons.assignment_ind_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                    ),
                    hint: const Text('Selecciona una Direccion'),
                    borderRadius: BorderRadius.circular(12),
                    icon: const Icon(Icons.arrow_drop_down),

                  ),
                ),
            ),

            const SizedBox(height: 30),

            // Lista de empleados (sin Expanded ni altura infinita)
            Obx(() {
             /* if (controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.empleados.isEmpty &&
                  controller.mensaje.value.isEmpty) {
                return const SizedBox();
              }*/
              final paginated = controller.getPaginatedEmpleados();
              return ListView.builder(
                shrinkWrap: true,
               // physics: const NeverScrollableScrollPhysics(),
                itemCount: paginated.length,
                itemBuilder: (context, index) {
                  Empleado empleado = paginated[index];
                  return EmployeCard(
                    empleado: empleado,
                    onVotoUpdated: (nuevoEstado) =>
                        controller.updateVotoStatus(empleado.id!, nuevoEstado),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class EmployeCard extends StatelessWidget {
  const EmployeCard({
    super.key,
    required this.empleado,
    required this.onVotoUpdated,
  });

  final Empleado empleado;
  final Function(bool) onVotoUpdated;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Mostrar diálogo de confirmación
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(empleado.voto! ? 'Anular voto' : 'Registrar voto'),
            content: Text(
              empleado.voto!
                  ? '¿Está seguro de marcar como NO VOTÓ a ${empleado.nombre}?'
                  : '¿Está seguro de marcar como VOTÓ a ${empleado.nombre}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onVotoUpdated(!empleado.voto!); // Cambiar estado
                },
                child: Text(
                  'Confirmar',
                  style: TextStyle(
                    color: empleado.voto! ? Colors.red : Colors.green,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: empleado.voto! ? Colors.green : Colors.red,
            radius: 16,
            child: Icon(
              empleado.voto! ? Icons.check : Icons.close,
              color: Colors.white,
              size: 14,
            ),
          ),
          title: Text(empleado.nombre!),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cédula: ${empleado.cedula}'),
              if (empleado.direccion != null)
                Text(
                  empleado.direccion!.direccion ?? '',
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          trailing: Chip(
            backgroundColor: empleado.voto! ? Colors.green[100] : Colors.red[100],
            label: Text(
              empleado.votostr ?? (empleado.voto! ? 'VOTÓ' : 'NO VOTO'),
              style: TextStyle(
                fontSize: 12,
                color: empleado.voto! ? Colors.green[800] : Colors.red[800],
              ),
            ),
          ),
        ),
      ),
    );
  }
}