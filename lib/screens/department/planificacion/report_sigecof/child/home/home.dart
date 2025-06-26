import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado
          _buildHeader(theme, colors),
          const SizedBox(height: 24),

          // Tarjetas de métricas
          _buildMetricCards(context, colors),
          const SizedBox(height: 24),

          // Gráficos y sección principal
          _buildMainSection(theme, colors),
          const SizedBox(height: 24),

          // Acciones rápidas
          //_buildQuickActions(context, colors),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dirección General de Planificación Financiera",
          style: theme.textTheme.titleLarge?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Sistema Integrado de Gestión y Reportes Financieros",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colors.onSurface.withOpacity(0.8),
          ),
        ),
        const Divider(height: 40, thickness: 1),
      ],
    );
  }

  Widget _buildMetricCards(BuildContext context, ColorScheme colors) {
    final cardWidth = MediaQuery.of(context).size.width / 3 - 24;

    return Row(
      children: [
        _MetricCard(
          width: cardWidth,
          color: colors.primaryContainer,
          icon: Icons.attach_money,
          title: "Presupuesto Ejecutado",
          value: "Bs. 12,450,000",
          subtitle: "75% del total",
        ),
        const SizedBox(width: 12),
        _MetricCard(
          width: cardWidth,
          color: colors.secondaryContainer,
          icon: Icons.assignment_turned_in,
          title: "Reportes Aprobados",
          value: "128",
          subtitle: "Este mes",
        ),
        const SizedBox(width: 12),
        _MetricCard(
          width: cardWidth,
          color: colors.tertiaryContainer,
          icon: Icons.trending_up,
          title: "Variación Anual",
          value: "+8.2%",
          subtitle: "vs 2023",
        ),
      ],
    );
  }

  Widget _buildMainSection(ThemeData theme, ColorScheme colors) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Indicadores Clave",
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.bar_chart, size: 50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _IndicatorItem(
                          color: colors.primary,
                          title: "Planificación Aprobada",
                          value: "92%",
                        ),
                        _IndicatorItem(
                          color: colors.secondary,
                          title: "Ejecución Presupuestaria",
                          value: "78%",
                        ),
                        _IndicatorItem(
                          color: colors.tertiary,
                          title: "Reportes Pendientes",
                          value: "15",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Próximas actividades:",
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            _buildTimeline(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(ColorScheme colors) {
    return Column(
      children: [
        _TimelineItem(
          color: colors.primary,
          date: "15 Jun",
          title: "Cierre trimestral",
          description: "Reporte de ejecución Q2",
        ),
        _TimelineItem(
          color: colors.secondary,
          date: "22 Jun",
          title: "Revisión presupuestaria",
          description: "Comité de planificación",
        ),
        _TimelineItem(
          color: colors.tertiary,
          date: "30 Jun",
          title: "Envío a SIGECOF",
          description: "Documentación final",
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, ColorScheme colors) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ActionChip(
          avatar: Icon(Icons.add_chart, color: colors.onPrimary),
          label: const Text("Nuevo Reporte"),
          backgroundColor: colors.primary,
          labelStyle: TextStyle(color: colors.onPrimary),
          onPressed: () {},
        ),
        ActionChip(
          avatar: Icon(Icons.cloud_upload, color: colors.onSecondary),
          label: const Text("Subir a SIGECOF"),
          backgroundColor: colors.secondary,
          labelStyle: TextStyle(color: colors.onSecondary),
          onPressed: () {},
        ),
        ActionChip(
          avatar: Icon(Icons.history, color: colors.onTertiary),
          label: const Text("Históricos"),
          backgroundColor: colors.tertiary,
          labelStyle: TextStyle(color: colors.onTertiary),
          onPressed: () {},
        ),
        ActionChip(
          avatar: Icon(Icons.help, color: colors.onSurface),
          label: const Text("Ayuda"),
          backgroundColor: colors.surfaceVariant,
          labelStyle: TextStyle(color: colors.onSurface),
          onPressed: () {},
        ),
      ],
    );
  }
}

// Componentes reutilizables
class _MetricCard extends StatelessWidget {
  final double width;
  final Color color;
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _MetricCard({
    required this.width,
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 12),
              Text(title, style: theme.textTheme.bodySmall),
              Text(value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 4),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _IndicatorItem extends StatelessWidget {
  final Color color;
  final String title;
  final String value;

  const _IndicatorItem({
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title),
        ),
        Text(value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Color color;
  final String date;
  final String title;
  final String description;

  const _TimelineItem({
    required this.color,
    required this.date,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            alignment: Alignment.topCenter,
            child: Text(date,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                Text(description,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}