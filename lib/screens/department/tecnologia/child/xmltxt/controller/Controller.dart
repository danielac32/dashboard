import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../infrastructure/shared/alert.dart';
import '../../../service/service.dart';
import '../model/file_info.dart';
import '../model/list_dir_response.dart';
import '../model/list_process_response.dart';
import '../model/paginate.dart';
import '../response/deleteResponse.dart';

import 'package:file_picker/file_picker.dart';



class XmlTxtController extends GetxController {
  // Estados
  var xmlFiles = <FileInfo>[].obs; // Ahora contiene FileInfo directamente
  var resultados = <Map<String, dynamic>>[].obs;
  var totalPlanillas = 0.obs;
  var totalErrores = 0.obs;
  var isLoading = false.obs;
  var isProcessing = false.obs;




  var currentPage = 1.obs;
  var pageSize = 5.obs;
  var totalPages = 0.obs;
  var totalCount = 0.obs;
  var hasPrevious = false.obs;
  var hasNext = false.obs;
  final recaudaciones = <Data>[].obs;
  final paginationInfo = Pagination().obs;




  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchRecaudaciones(page: 1);
  }

  bool _validarDatoFile(Map<String, dynamic> data) {
    if (data['fecha'] == null || data['fecha'].toString().isEmpty) {

      SnackbarAlert.warning(
          title: "Error de validación",
          message: "El campo 'fecha' es obligatorio",
          durationSeconds: 1
      );
      return false;
    }

    if (data['banco'] == null || data['banco'].toString().isEmpty) {
      SnackbarAlert.warning(
          title: "Error de validación",
          message: "El campo 'banco' es obligatorio",
          durationSeconds: 1
      );
      return false;
    }

    if (data['estatus'] == null || data['estatus'].toString().isEmpty) {
      SnackbarAlert.warning(
          title: "Error de validación",
          message: "El campo 'estatus' es obligatorio",
          durationSeconds: 1
      );
      return false;
    }

    return true;
  }

  Future<void>insertFile(Map<String, dynamic> data)async{
    print(data);
    if (!_validarDatoFile(data)) {
      return;
    }
    try{
        final d = {
          "fecha_recaudacion": data["fecha"],
          "banco": data["banco"],
          "estatus": data["estatus"]
        };
        final res = await DgticService.post(
          'api/xmltxt/pg_upload_file', // Asegúrate que esta es la ruta correcta
          d,
        );

    }catch(e){
      print(e);
      SnackbarAlert.error(title: "Oops!", message: "No se pudo Insertar planilla", durationSeconds: 1);
    }
  }



  Future<void> consultarArchivos() async {
    isLoading.value = true;
    xmlFiles.clear();
    resultados.clear();

    //await Future.delayed(const Duration(seconds: 2));
    final apiResponse = await DgticService.get('api/xmltxt/list');
    if (apiResponse == null || apiResponse.isEmpty) {
      SnackbarAlert.warning(title: "Advertencia", message: "No se encontraron archivos", durationSeconds: 1);
      xmlFiles.clear();
      isLoading.value = false;
      return;
    }
    final res = ListDir.fromJson(apiResponse);
    if (res.res == null || res.res!.files == null || res.res!.files!.isEmpty) {
      SnackbarAlert.warning(title: "Advertencia", message: "No hay archivos disponibles", durationSeconds: 1);
      xmlFiles.clear();
      isLoading.value = false;
      return;
    }

    final foundFiles = res.res!.files!.map((str) {
      final fileInfo = FileInfo.fromString(str);
      debugPrint('found: ${fileInfo.name} | ${fileInfo.date} | ${fileInfo.size}');
      return fileInfo;
    }).toList();

    xmlFiles.assignAll(foundFiles);
    isLoading.value = false;
  }



  Future<void> deleteFile(int index) async {
    //resultados.removeWhere((file)=>)
      if (index < 0 || index >= xmlFiles.length) {
        SnackbarAlert.error(title: "Error!", message: "Archivo no se pudo eliminar: ${xmlFiles[index].name}", durationSeconds: 1);
        return;
      }
      final apiResponse = await DgticService.delete("api/xmltxt/deleteFile",queryParams: {
        "name": xmlFiles[index].name
      });
      final res = DeleteResponse.fromJson(apiResponse);
      if(res.success == true) {
        xmlFiles.removeAt(index);
        SnackbarAlert.success(message: "Archivo eliminado correctamente");
      }else{
        SnackbarAlert.error(title: "Error!", message: "Archivo no se pudo eliminar: ${xmlFiles[index].name}", durationSeconds: 1);
      }
  }




  Future<void> fetchRecaudaciones({int? page}) async {
    try {
      isLoading.value = true;

      if (page != null) {
        currentPage.value = page;
      }

      final response = await DgticService.get(
        'api/xmltxt/paginated',
        queryParams: {
          'page': currentPage.value.toString(),
          'pageSize': pageSize.value.toString(),
        },
      );

      final apiResponse = recaudacion.fromJson(response);

      // ¡IMPORTANTE! Asigna los datos a la variable observable
      recaudaciones.value = apiResponse.data ?? [];

      // También actualiza la paginación
      paginationInfo.value = apiResponse.pagination ?? Pagination();

      // Debug para verificar que los datos llegaron
      print('✅ Datos recibidos: ${apiResponse.data?.length ?? 0} registros');
      for (var re in apiResponse.data!) {
        print('    ${re.fechaRecaudacion}  ${re.banco} ${re.estatus}');
      }

    } catch (e) {
      print('❌ Excepción: $e');
      SnackbarAlert.error(
        title: "Error",
        message: "Error al cargar los datos: $e",
        durationSeconds: 2,
      );

      // Limpiar la lista en caso de error
      recaudaciones.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> prev() async {
    if (currentPage.value <= 1) return;
    await fetchRecaudaciones(page: currentPage.value - 1);
  }

  Future<void> next() async {
    await fetchRecaudaciones(page: currentPage.value + 1);
  }




  Future<void> subirArchivo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml'],
        allowMultiple: true, // Ya está en true ✅
      );

      if (result == null || result.files.isEmpty) return;

      isLoading.value = true;
      update();

      // Convertir todos los archivos a base64
      final List<Map<String, String>> filesData = [];

      for (final file in result.files) {
        if (file.bytes == null) continue; // Saltar si no hay bytes

        final base64Content = base64Encode(file.bytes!);
        filesData.add({
          'filename': file.name,
          'content': base64Content,
        });
      }

      // Preparar cuerpo del request con múltiples archivos
      final body = {
        'files': filesData, // ← clave "files", no "file"
      };

      final response = await DgticService.upload('api/xmltxt/upload', body: body);

      isLoading.value = false;

      if (response != null && response is List && response.isNotEmpty) {
        SnackbarAlert.success(message: "${filesData.length} archivos subidos correctamente");
        await consultarArchivos();
      } else {
        SnackbarAlert.error(
          title: "Error!",
          message: "Falló la subida: ${response?['message'] ?? 'Desconocido'}",
          durationSeconds: 1,
        );
      }
    } catch (e, stack) {
      isLoading.value = false;
      SnackbarAlert.error(
        title: "Error!",
        message: "No se pudieron subir los archivos: $e",
        durationSeconds: 1,
      );
      debugPrint("Error al subir archivos: $e\nStack: $stack");
    } finally {
      isLoading.value = false;
      update();
    }
  }



  Future<void> subirArchivo2() async {
    late String  nameFile;
    try {
      // Abrir selector de archivos
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml'], // Solo permitir .xml
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) {
        // Usuario canceló
        return;
      }

      final file = result.files.first;
      nameFile=file.name;
      // Mostrar carga
      isLoading.value = true;
      update(); // Forzar actualización del botón
      // Aquí usas XmlService para subir el archivo
      // Suponiendo que tienes un método `uploadFile` que acepta `Uint8List` o `List<int>`

      final base64Image = base64Encode(file.bytes!);
      // Preparar cuerpo del request
      final body = {
        'file': {
          'filename': file.name,
          'content': base64Image,
        }
      };
      // Usamos el método postImage del MediaService
      final response = await DgticService.upload('api/xmltxt/upload', body: body);

      isLoading.value = false;

      if (response != null && response['success'] == true) {
        SnackbarAlert.success(message: "Archivo '${file.name}' subido correctamente");
        // Opcional: vuelve a consultar los archivos para actualizar la lista
        await consultarArchivos();
      } else {
        SnackbarAlert.error(title: "Error!", message: "Falló la subida: ${response?['message'] ?? 'Desconocido'}", durationSeconds: 1);
      }
    } catch (e) {
      isLoading.value = false;
      SnackbarAlert.error(title: "Error!", message: "No se pudo subir el archivo: $e : $nameFile", durationSeconds: 1);
      debugPrint("Error al subir archivo: $e");
    } finally {
      isLoading.value = false;
      update(); // Asegura que el botón vuelva al estado normal
    }
  }



  Future<void> procesarArchivos() async {
    if (xmlFiles.isEmpty) {
      SnackbarAlert.warning(title: "Advertencia", message: "No hay archivos disponibles", durationSeconds: 1);
      return;
    }

    isProcessing.value = true;

    try {
      final apiResponse = await DgticService.get('api/xmltxt/process');

      final res = ListProcess.fromJson(apiResponse);

      // ✅ Convertimos los objetos Resultados a Map<String, dynamic>
      if (res.resultados != null && res.resultados!.isNotEmpty) {
        final List<Map<String, dynamic>> mappedResults = res.resultados!
            .map((resultado) => resultado.toJson())
            .toList();

        resultados.assignAll(mappedResults);
      } else {
        SnackbarAlert.warning(title: "Advertencia", message: "No hay archivos disponibles", durationSeconds: 1);
      }

      totalPlanillas.value = res.totalPlanillas ?? 0;
      totalErrores.value = res.totalErrores ?? 0;

      SnackbarAlert.success(message: "Se procesaron ${resultados.length} archivos");
    } catch (e) {
      SnackbarAlert.error(title: "Error!", message: "Ocurrió un error al procesar: $e", durationSeconds: 1);
      debugPrint("Error al procesar archivos: $e");
    } finally {
      isProcessing.value = false;
    }
  }
}