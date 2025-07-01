import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return EgresosHomeScreen();
  }
}


class EgresosHomeScreen extends StatelessWidget {
  const EgresosHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('Dirección General de Egresos'),
        centerTitle: true,
        elevation: 0,
      ),*/
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen Estadístico
            _buildSummaryCards(),
            const SizedBox(height: 24),

            // Título de sección
            const Text(
              'Gestión de Órdenes de Pago',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Pestañas de navegación
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Pendientes'),
                        Tab(text: 'Pagadas'),
                        Tab(text: 'Con Retenciones'),
                      ],
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildPendingOrders(),
                          _buildPaidOrders(),
                          _buildRetentionOrders(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para crear nueva orden
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _SummaryCard(
            title: 'Órdenes Pendientes',
            value: '24',
            color: Colors.orange,
            icon: Icons.pending_actions,
          ),
          _SummaryCard(
            title: 'Órdenes Pagadas',
            value: '156',
            color: Colors.green,
            icon: Icons.check_circle,
          ),
          _SummaryCard(
            title: 'Con Retenciones',
            value: '42',
            color: Colors.blue,
            icon: Icons.account_balance,
          ),
          _SummaryCard(
            title: 'Monto Total',
            value: '\$1,250,000',
            color: Colors.purple,
            icon: Icons.attach_money,
          ),
        ],
      ),
    );
  }

  Widget _buildPendingOrders() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _OrderItem(
          status: 'Pendiente',
          amount: 12500.00,
          beneficiary: 'Proveedor ${index + 1}',
          date: '15/06/2023',
          statusColor: Colors.orange,
        );
      },
    );
  }

  Widget _buildPaidOrders() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _OrderItem(
          status: 'Pagada',
          amount: 18700.00,
          beneficiary: 'Contratista ${index + 1}',
          date: '10/06/2023',
          statusColor: Colors.green,
        );
      },
    );
  }

  Widget _buildRetentionOrders() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _OrderItem(
          status: 'Retención',
          amount: 25300.00,
          beneficiary: 'Consultor ${index + 1}',
          date: '05/06/2023',
          statusColor: Colors.blue,
          hasRetention: true,
          retentionAmount: 253.00,
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final String status;
  final double amount;
  final String beneficiary;
  final String date;
  final Color statusColor;
  final bool hasRetention;
  final double? retentionAmount;

  const _OrderItem({
    required this.status,
    required this.amount,
    required this.beneficiary,
    required this.date,
    required this.statusColor,
    this.hasRetention = false,
    this.retentionAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: statusColor,
                ),
                Text(
                  '\$${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              beneficiary,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fecha: $date',
                  style: const TextStyle(color: Colors.grey),
                ),
                if (hasRetention && retentionAmount != null)
                  Text(
                    'Retención: \$${retentionAmount!.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}