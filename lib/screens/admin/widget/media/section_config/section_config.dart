
import 'package:flutter/material.dart';
import '../child/alcadias/alcaldias_content.dart';
import '../child/noticias/noticias.dart';
import '../child/organismo/organismo_content.dart';
import '../child/programacion_financiera/programacion_financiera.dart';
import '../child/resumen/resumen.dart';


class SectionConfig {
  final String key;
  final String displayName;
  final IconData icon;
  final Widget Function(BuildContext) builder;

  SectionConfig({
    required this.key,
    required this.displayName,
    required this.icon,
    required this.builder,
  });
}

class SectionManager {
  static final Map<String, SectionConfig> _sections = {};

  static void registerSection(SectionConfig config) {
    _sections[config.key] = config;
  }

  static SectionConfig? getSection(String key) {
    return _sections[key];
  }

  static List<SectionConfig> get allSections => _sections.values.toList();
}


void registerAppSections() {
  SectionManager.registerSection(
    SectionConfig(
      key: 'ORGANISMOS_GOBERNACION',
      displayName: 'Organismos',
      icon: Icons.account_balance,
      builder: (context) => const OrganismosContent(),
    ),
  );

  SectionManager.registerSection(
    SectionConfig(
      key: 'ALCALDIAS',
      displayName: 'Alcaldías',
      icon: Icons.location_city,
      builder: (context) => const AlcaldiasContent(),
    ),
  );

  SectionManager.registerSection(
    SectionConfig(
      key: 'PROGRAMACION_FINANCIERA',
      displayName: 'Programación Financiera',
      icon: Icons.attach_money,
      builder: (context) => const ProgramacionFinancieraContent(),
    ),
  );

  SectionManager.registerSection(
    SectionConfig(
      key: 'RESUMEN_GESTION',
      displayName: 'Resumen de Gestión',
      icon: Icons.summarize,
      builder: (context) => const ResumenGestionContent(),
    ),
  );

  SectionManager.registerSection(
    SectionConfig(
      key: 'NOTICIAS',
      displayName: 'Noticias',
      icon: Icons.newspaper,
      builder: (context) => const NoticiasContent(),
    ),
  );
}
