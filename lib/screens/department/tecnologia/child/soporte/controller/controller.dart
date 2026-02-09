import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';

import '../../../../../../infrastructure/entities/user_response.dart';
import '../../../../../../infrastructure/shared/alert.dart';
import '../../../../../../infrastructure/shared/storage.dart';
import '../../../service/service.dart';
import '../model/support_model.dart';

class UserSupportController extends GetxController {
  final RxList<UserSupport> _userSupports = <UserSupport>[].obs;
  List<UserSupport> get userSupports => _userSupports;

  final RxBool isLoading = false.obs;
  final RxString selectedDate = ''.obs;
  final RxString lastUpdate = ''.obs;
  Timer? timer;


  final RxString selectedDateRange = ''.obs;
  final RxInt totalSupports = 0.obs;


  // Formatear fecha como dd/MM/yyyy
  String _formatDateDMY(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  @override
  void dispose() {
    print('I am disposed');
    timer!.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    timer!.cancel();
    super.onClose();
    print('I am closed');
  }


  @override
  void onInit() {
    super.onInit();
    selectedDate.value = _formatDateDMY(DateTime.now());

    lastUpdate.value = 'Nunca';
    fetchSupports();
    timer = Timer.periodic(const Duration(seconds: 75), (Timer t) {// 2 minutos de refresco
      print('⏰ Timer ejecutándose - Consultando API...');
      fetchSupports();
    });
  }



  bool _validarDatosSupport(Map<String, dynamic> data) {
    if (data['name'] == null || data['name'].toString().isEmpty) {

      SnackbarAlert.error(
          title: "Error de validación",
          message: "El campo 'nombre' es obligatorio",
          durationSeconds: 1
      );
      return false;
    }

    if (data['description'] == null || data['description'].toString().isEmpty) {
      SnackbarAlert.error(
          title: "Error de validación",
          message: "El campo 'descripcion' es obligatorio",
          durationSeconds: 1
      );
      return false;
    }

    if (data['departamento'] == null || data['departamento'].toString().isEmpty) {
      SnackbarAlert.error(
          title: "Error de validación",
          message: "El campo 'departamento' es obligatorio",
          durationSeconds: 1
      );
      return false;
    }

    return true;
  }


  Future<void>createSupport(Map<String, dynamic> supportData)async{
    if (!_validarDatosSupport(supportData)) {
      return;
    }
    User? user = LocalStorage.getUser();
    print("${supportData['name']} - ${supportData['description']} - ${supportData['departamento']} - ${user?.email}");

    try{
      final support = {
        "name": supportData['name'],
        "description": supportData['description'],
        "departamento": supportData['departamento'],
        "email": user?.email
      };
      final res = await DgticService.post(
        'api/soporte/add2', // Asegúrate que esta es la ruta correcta
        support,
      );
    }catch(e){
      print(e);
      SnackbarAlert.error(title: "Oops!", message: "No se pudo crear el soporte", durationSeconds: 1);
    }
    fetchSupports();
  }


  // Método principal para obtener datos de la API
  Future<void> fetchSupports() async {
    // Evitar múltiples llamadas simultáneas
    if (isLoading.value) {
      print('⚠️ Ya hay una consulta en proceso, omitiendo...');
      return;
    }

    isLoading.value = true;
    print('📡 Consultando API para fecha: ${selectedDate.value}');

    try {
      // Llamar al servicio
      final response = await DgticService.get(
        'api/soporte/by-user-date',
        queryParams: {'date': selectedDate.value},
      );
      final apiResponse = Autogenerate.fromJson(response);

      print('📋 Usuarios encontrados: ${apiResponse.users?.length ?? 0}');
      if (apiResponse.users != null) {
        for (var user in apiResponse.users!) {
          print('   👤 ${user.name}: ${user.supportCount} soportes');
        }
      }

      // 4. Llenar la lista de UserSupport
      if (apiResponse.users != null && apiResponse.users!.isNotEmpty) {
        _userSupports.value = apiResponse.users!
            .map((user) => UserSupport(
          name: user.name ?? 'Sin nombre',
          supportCount: user.supportCount ?? 0,
        )).toList();
      } else {
        print('⚠️ No se encontraron usuarios en la respuesta');
        _userSupports.clear();

        SnackbarAlert.warning(
          title: "Sin datos",
          message: "No se encontraron soportes para esta fecha",
          durationSeconds: 2,
        );
      }
    } catch (e) {
      print('❌ Error al consultar API: $e');
      SnackbarAlert.error(
        title: "Error de conexión",
        message: "No se pudo obtener los datos del servidor",
        durationSeconds: 3,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReportByDateRange(String startDate, String endDate) async {
    try {
      isLoading.value = true;

      // Generar nombre del archivo
      final fileName = "Reporte_Soportes_${DateTime.now().millisecondsSinceEpoch}.xlsx";

      // Mostrar mensaje de progreso
      SnackbarAlert.info(
        title: "Descargando reporte",
        message: "Por favor espere...",
        durationSeconds: 1,
      );

      // Descargar el reporte
      await DgticService.downloadExcelReport(
        startDate: startDate,
        endDate: endDate,
        fileName: fileName,
      );

      // Mostrar mensaje de éxito
      SnackbarAlert.success(
        title: "Éxito",
        message: "Reporte descargado correctamente",
        durationSeconds: 2,
      );

    } catch (e) {
      print('❌ Error al descargar reporte: $e');
      SnackbarAlert.error(
        title: "Error",
        message: "No se pudo descargar el reporte: ${e.toString()}",
        durationSeconds: 3,
      );
    } finally {
      isLoading.value = false;
    }
  }



}



/*final supports = [
      CreateSupport(
          name: 'impresora',
          description: 'No imprime en color',
          userId: 1,
          departamento: 'TI'
      ),
      CreateSupport(
          name: 'monitor',
          description: 'Pantalla con líneas verticales',
          userId: 1,
          departamento: 'Sistemas'
      ),
      CreateSupport(
          name: 'teclado',
          description: 'Tecla Enter no funciona',
          userId: 3,
          departamento: 'Soporte'
      ),
      CreateSupport(
          name: 'impresora',
          description: 'Atascamiento de papel',
          userId: 4,
          departamento: 'TI'
      ),
      CreateSupport(
          name: 'impresora',
          description: 'No conecta por WiFi',
          userId: 2,
          departamento: 'Redes'
      ),
      CreateSupport(
          name: 'impresora',
          description: 'Falta de tinta frecuente',
          userId: 3,
          departamento: 'TI'
      ),
    ];

    int successCount = 0;
    int errorCount = 0;
    //final apiResponse = await DgticService.get('api/soporte/add');

    try {
      for (var support in supports) {
        try {
          final res = await DgticService.post(
            'api/soporte/add', // Asegúrate que esta es la ruta correcta
            support.toMap(),
          );

          successCount++;
          print('Soporte creado: ${support.name}');
        } catch (e) {
          errorCount++;
          print('Error creando soporte ${support.name}: $e');
        }
      }

      if (errorCount == 0) {
        SnackbarAlert.success(
            title: "Éxito!",
            message: "Se crearon $successCount soportes correctamente",
            durationSeconds: 2
        );
      } else {
        SnackbarAlert.warning(
            title: "Parcial",
            message: "Se crearon $successCount de ${supports.length} soportes. $errorCount fallaron.",
            durationSeconds: 3
        );
      }

    } catch (e) {
      print(e);
      SnackbarAlert.error(
          title: "Error!",
          message: "Error general al crear soportes",
          durationSeconds: 2
      );
    } finally {

    }
*/