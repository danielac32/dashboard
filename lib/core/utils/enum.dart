
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
        return 'Dirección General de Administración';
      case Directorate.direccionGeneralEgreso:
        return 'Dirección General de Egreso';
      case Directorate.direccionGeneralIngreso:
        return 'Dirección General de Ingreso';
      case Directorate.direccionGeneralCuentaUnica:
        return 'Dirección General de Cuenta Única';
      case Directorate.direccionGeneralTecnologiaInformacion:
        return 'Dirección General de Tecnología de Información';
      case Directorate.direccionGeneralPlanificacionAnalisisFinanciero:
        return 'Dirección General de Planificación y Análisis Financiero';
      case Directorate.direccionGeneralRecaudacionIngreso:
        return 'Dirección General de Recaudación de Ingreso';
      case Directorate.direccionGeneralRecursosHumanos:
        return 'Dirección General de Recursos Humanos';
      case Directorate.direccionGeneralInversionesYValores:
        return 'Dirección General de Inversiones y Valores';
      case Directorate.direccionGeneralConsultoriaJuridica:
        return 'Dirección General de Consultoría Jurídica';
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
        return "Coordinador";
      case Position.DIRECTOR_GENERAL:
        return "Director General";
      case Position.DIRECTOR_LINEA:
        return "Director de Línea";
      case Position.ASISTENTE:
        return "Asistente";
      case Position.ANALISTA:
        return "Analista";
      case Position.ASESOR:
        return "Asesor";
      case Position.CONSULTOR:
        return "Consultor";
      case Position.HP:
        return "HP"; // Si HP es un acrónimo, puedes dejarlo igual o expandirlo según el contexto.
      case Position.OTRO:
        return "Otro";
    }
  }
}

enum Role {
  SUPER_ADMIN,
  ADMIN,
  USER;

  String get label {
    switch (this) {
      case Role.SUPER_ADMIN:
        return 'Super Admin';
      case Role.ADMIN:
        return 'Admin';
      case Role.USER:
        return 'User';
    }
  }
}