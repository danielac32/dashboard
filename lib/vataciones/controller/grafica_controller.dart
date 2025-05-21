import 'package:core_system/vataciones/interface/direccion_response.dart';
import 'package:core_system/vataciones/interface/empleado.dart';
import 'package:get/get.dart';

import '../interface/voto_direccion.dart';
import '../service/votaciones_service.dart';

class GraficaController extends GetxController {
  // Estado de la gráfica seleccionada (0 = circular, 1 = barras)
  var graficaIndex = 0.obs;

  // Datos de votos y direcciones
  var votosData = <VotoDireccion>[].obs;
  var direcciones = <Direccion>[].obs;

  // Estado de carga
  var isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await refreshData(); // Carga inicial de datos
  }

  // Método público para recargar datos
  Future<void> refreshData() async {
    isLoading.value = true;
    votosData.clear();
    direcciones.clear();

    try {
      final dirResponse = await VotacionService.get("votacion/empleado/direccion/");
      final resDir = DireccionResponse.fromJson(dirResponse);
      final List<Direccion>? listaDirecciones = resDir.direcciones;

      if (listaDirecciones != null && listaDirecciones.isNotEmpty) {
        direcciones.value = listaDirecciones;

        for (var dir in direcciones) {
          final apiResponse =
          await VotacionService.get("votacion/empleado/count/${dir.direccion}");
          if (apiResponse != null) {
            final resNum = VotoDireccion.fromJson(apiResponse);
            votosData.add(resNum);
          } else {
            print("La respuesta para ${dir.direccion} fue nula");
          }
        }
      }
    } catch (e) {
      print("Error al cargar datos: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Cambiar gráfica
  void setGraficaIndex(int index) {
    graficaIndex.value = index;
  }
}