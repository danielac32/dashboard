
enum MenuOption {
  createUser,
  users,
  page1,
  page2,
  page3,
  cmsSettings;

  String get label {
    switch (this) {
      case MenuOption.createUser:
        return 'Crear Usuario';
      case MenuOption.users:
        return 'Usuarios';
      case MenuOption.page1:
        return 'Página 1';
      case MenuOption.page2:
        return 'Página 2';
      case MenuOption.page3:
        return 'Página 3';
      case MenuOption.cmsSettings:
        return 'Configuración CMS';
    }
  }
}

enum Directorate {
  direccionGeneralAdministracion,
  direccionGeneralEgreso,
  direccionGeneralIngreso,
  direccionGeneralCuentaUnica,
  direccionGeneralTecnologiaInformacion,
  direccionGeneralPlanificacionAnalisisFinanciero,
  direccionGeneralRecaudacionIngreso,
  direccionGeneralRecursosHumanos,
  direccionGeneralInversionesYValores,
  direccionGeneralConsultoriaJuridica;

  String get label {
    switch (this) {
      case Directorate.direccionGeneralAdministracion:
        return 'DIRECCIÓN GENERAL DE ADMINISTRACIÓN';
      case Directorate.direccionGeneralEgreso:
        return 'DIRECCIÓN GENERAL DE EGRESO';
      case Directorate.direccionGeneralIngreso:
        return 'DIRECCIÓN GENERAL DE INGRESO';
      case Directorate.direccionGeneralCuentaUnica:
        return 'DIRECCIÓN GENERAL DE CUENTA ÚNICA';
      case Directorate.direccionGeneralTecnologiaInformacion:
        return 'DIRECCIÓN GENERAL DE TECNOLOGÍA DE INFORMACIÓN';
      case Directorate.direccionGeneralPlanificacionAnalisisFinanciero:
        return 'DIRECCIÓN GENERAL DE PLANIFICACIÓN Y ANÁLISIS FINANCIERO';
      case Directorate.direccionGeneralRecaudacionIngreso:
        return 'DIRECCIÓN GENERAL DE RECAUDACIÓN DE INGRESO';
      case Directorate.direccionGeneralRecursosHumanos:
        return 'DIRECCIÓN GENERAL DE RECURSOS HUMANOS';
      case Directorate.direccionGeneralInversionesYValores:
        return 'DIRECCIÓN GENERAL DE INVERSIONES Y VALORES';
      case Directorate.direccionGeneralConsultoriaJuridica:
        return 'DIRECCIÓN GENERAL DE CONSULTORÍA JURÍDICA';
      default:
        return 'DESCONOCIDO';
    }
  }
}


enum Position {
  COORDINADOR,
  DIRECTOR_GENERAL,
  DIRECTOR_LINEA,
  ASISTENTE,
  ANALISTA,
  ASESOR,
  CONSULTOR,
  HP,
  OTRO;

  String get label {
    switch (this) {
      case Position.COORDINADOR:
        return "COORDINADOR";
      case Position.DIRECTOR_GENERAL:
        return "DIRECTOR GENERAL";
      case Position.DIRECTOR_LINEA:
        return "DIRECTOR DE LINEA";
      case Position.ASISTENTE:
        return "ASISTENTE";
      case Position.ANALISTA:
        return "ANALISTA";
      case Position.ASESOR:
        return "ASESOR";
      case Position.CONSULTOR:
        return "CONSULTOR";
      case Position.HP:
        return "HP"; // Si HP es un acrónimo, puedes dejarlo igual o expandirlo según el contexto.
      case Position.OTRO:
        return "OTRO";
    }
  }
}

enum Role {
  SUPER_ADMIN,
  ADMIN,
  USER,
  VIEWER,
  GUEST;



  String get label {
    switch (this) {
      case Role.SUPER_ADMIN:
        return 'SUPER_ADMIN';
      case Role.ADMIN:
        return 'ADMIN';
      case Role.USER:
        return 'USER';
      case Role.VIEWER:
        return 'VIEWER';
      case Role.GUEST:
        return 'GUEST';
    }
  }
}