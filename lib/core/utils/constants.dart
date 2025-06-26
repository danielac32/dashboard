


import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract class AppStrings {
  // Roles de usuario
  static const String superAdmin = 'SUPER_ADMIN';
  static const String departmentAdmin = 'DEPARTMENT_ADMIN';
  static const String editor = 'EDITOR';
  static const String viewer = 'VIEWER';
  static const String guest = 'GUEST';
  static const String user = 'USER';
  static const String admin = 'ADMIN';

  // Departamentos

  static const String dgAdministracion = 'DIRECCIÓN GENERAL DE ADMINISTRACIÓN';
  static const String dgEgreso = 'DIRECCIÓN GENERAL DE EGRESO';
  static const String dgIngreso = 'DIRECCIÓN GENERAL DE INGRESO';
  static const String dgCuentaUnica = 'DIRECCIÓN GENERAL DE CUENTA ÚNICA';
  static const String dgTecnologiaInformacion = 'DIRECCIÓN GENERAL DE TECNOLOGÍA DE INFORMACIÓN';
  static const String dgPlanificacionAnalisisFinanciero = 'DIRECCIÓN GENERAL DE PLANIFICACIÓN Y ANÁLISIS FINANCIERO';
  //static const String dgRecaudacionIngreso = 'DIRECCIÓN GENERAL DE RECAUDACIÓN DE INGRESO';
  static const String dgRecursosHumanos = 'DIRECCIÓN GENERAL DE RECURSOS HUMANOS';
  static const String dgInversionesYValores = 'DIRECCIÓN GENERAL DE INVERSIONES Y VALORES';
  static const String dgConsultoriaJuridica = 'DIRECCIÓN GENERAL DE CONSULTORÍA JURÍDICA';


  // Secciones para permisos
  static const String organismosGobernacion = 'ORGANISMOS_GOBERNACION';
  static const String alcaldias = 'ALCALDIAS';
  static const String programacionFinanciera = 'PROGRAMACION_FINANCIERA';
  static const String resumenGestion = 'RESUMEN_GESTION';
  static const String noticias = 'NOTICIAS';
  static const String configuracion = 'CONFIGURACION';

  // Tipos de valores para programación financiera
  static const String presupuestoInicial = 'PRESUPUESprogramacionesFinancierasTO_INICIAL';
  static const String presupuestoFinal = 'PRESUPUESTO_FINAL';
  static const String gastoReal = 'GASTO_REAL';

  static var programacionFinancieras;

  //cargo
/*
  static const String analista="ANALISTA";
static const String director="DIRECTOR";
static const String asistente="ASISTENTE";
static const String coordinador="COORDINADOR";


 */
  static const String coordinador="COORDINADOR";
  static const String director_general="DIRECTOR GENERAL";
  static const String director_linea="DIRECTOR DE LINEA";
  static const String asistente="ASISTENTE";
  static const String analista="ANALISTA";
  static const String asesor="ASESOR";
  static const String consultor="CONSULTOR";
  static const String hp="HP";
  static const String otro="OTRO";
  static late String urlApi;//=dotenv.env['API_URL'];//'http://localhost:8085';
  static late String urlApiSigecof;
}

Future<String> getApiUrl() async {
  final String jsonString = await rootBundle.loadString('assets/config.json');
  final Map<String, dynamic> config = jsonDecode(jsonString);
  return config['api_url'];
}

Future<String> getApiUrlSigecof() async {
  final String jsonString = await rootBundle.loadString('assets/config.json');
  final Map<String, dynamic> config = jsonDecode(jsonString);
  return config['api_sigecof'];
}



class ConfigLoader {
  static late Map<String, dynamic> config;

  static Future<Map<String, dynamic>> loadConfig() async {
    final String jsonString = await rootBundle.loadString('assets/config.json');
    config = json.decode(jsonString);
    return config;
  }
}

bool isWeb() => kIsWeb;
bool isMobile() => !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
bool isDesktop() => !kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.linux);