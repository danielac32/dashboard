import 'package:core_system/vataciones/service/votaciones_service.dart';
import 'package:get/get.dart';

import '../interface/empleado.dart';
import 'grafica_controller.dart';



class BusquedaController extends GetxController {
  var loading = false.obs;
  var mensaje = ''.obs;
  var empleados = <Empleado>[].obs;
  var filteredEmpleados = <Empleado>[].obs;
  var searchQuery = ''.obs;
  var currentPage = 1.obs;
  final int pageSize = 8;

  var votaronCount = 0.obs;
  var noVotaronCount = 0.obs;
  var total=0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    print("cargando usuarios");
    await loadInitialData();
  }

  Future<void> loadInitialData() async {
    final apiResponse = await VotacionService.get("votacion/empleado");
    final res=EmpleadoResponse.fromJson(apiResponse);

    empleados.value = res.empleado ?? [];
    filteredEmpleados.value = empleados;
   /* for(final em in empleados){
       print('${em.cedula} - ${em.voto}');
    }

    */

    // Inicializar contadores
    int votaron = 0;
    int noVotaron = 0;
    int totalp=0;
    // Recorrer la lista y contar
    for (var empleado in empleados.value) {
      if (empleado.voto == true) {
        votaron++;
      } else {
        noVotaron++;
      }
      totalp++;
    }

    // Actualizar las variables reactivas
    votaronCount.value = votaron;
    noVotaronCount.value = noVotaron;
    total.value=totalp;
    //print( votaron);
    //print( noVotaron);
    loading.value = false;
  }

  void search(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredEmpleados.value = empleados;
    } else {
      filteredEmpleados.value = empleados
          .where((emp) =>
      emp.nombre?.toLowerCase().contains(query.toLowerCase()) == true ||
          emp.cedula?.toString().contains(query) == true)
          .toList();
    }
    currentPage.value = 1; // Reiniciamos la página al buscar
  }

  List<Empleado> getPaginatedEmpleados() {
    if (filteredEmpleados.isEmpty) return [];

    final start = (currentPage.value - 1) * pageSize;
    final end = start + pageSize;
    return filteredEmpleados.sublist(
      start,
      end > filteredEmpleados.length ? filteredEmpleados.length : end,
    );
  }

  void nextPage() {
    if (currentPage.value * pageSize < filteredEmpleados.length) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }

  Future<void> deleteEmpleado(int id) async {
    try {
      // Primero intentamos eliminar en el servidor
      await VotacionService.delete("votacion/empleado", id: id);
      // Si tiene éxito, eliminamos localmente
      empleados.removeWhere((emp) => emp.id == id);
      filteredEmpleados.removeWhere((emp) => emp.id == id);

      // Ajustar paginación si es necesario
      if (getPaginatedEmpleados().isEmpty && currentPage.value > 1) {
        previousPage();
      }

      mensaje('Empleado eliminado correctamente');
    } catch (e) {
      mensaje('Error al eliminar empleado');
      print('Error al eliminar empleado: $e');
      rethrow;
    }
  }

  Future<void> refreshEmpleados() async {
    try {
      loading(true);
      final apiResponse = await VotacionService.get("votacion/empleado");
      final res = EmpleadoResponse.fromJson(apiResponse);





      empleados.value = res.empleado ?? [];
      filteredEmpleados.value = empleados;
      currentPage.value = 1;

      int votaron = 0;
      int noVotaron = 0;
      int totalp=0;
      // Recorrer la lista y contar
      for (var empleado in empleados.value) {
        if (empleado.voto == true) {
          votaron++;
        } else {
          noVotaron++;
        }
        totalp++;
      }

      // Actualizar las variables reactivas
      votaronCount.value = votaron;
      noVotaronCount.value = noVotaron;
      total.value=totalp;
      //print( votaron);
      //print( noVotaron);
      mensaje('Datos actualizados');
      print('Empleados actualizados: ${empleados.length}');
    } catch (e) {
      mensaje('Error al actualizar empleados');
      print('Error en refreshEmpleados: $e');
      rethrow;
    } finally {
      loading(false);
    }
  }


  Future<void> updateVotoStatus(int empleadoId, bool voto) async {
    try{
      await VotacionService.update("votacion/empleado/$empleadoId", data: {'voto': voto, 'votostr': voto ? 'VOTÓ' : 'NO VOTO'});
      refreshEmpleados();
      Get.find<GraficaController>().refreshData();
    }catch(e){
      print('Error en updateVotoStatus: $e');
      rethrow;
    }
  }
  /*
  Future<void> updateVotoStatus(int empleadoId, bool voto) async {
    try {
      loading(true);
      await VotacionService.update(
        "votacion/empleado/$empleadoId",
        data: {'voto': voto, 'votostr': voto ? 'VOTÓ' : 'NO VOTO'}, id: 1,
      );

      // Actualizar localmente
      final index = empleados.indexWhere((emp) => emp.id == empleadoId);
      if (index != -1) {
        empleados[index] = empleados[index].copyWith(
          voto: voto,
          votostr: voto ? 'VOTÓ' : 'NO VOTO',
        );
        filteredEmpleados.refresh();
      }

      mensaje('Estado de voto actualizado');
    } catch (e) {
      mensaje('Error al actualizar voto');
      print('Error en updateVotoStatus: $e');
      rethrow;
    } finally {
      loading(false);
    }
  }*/





}