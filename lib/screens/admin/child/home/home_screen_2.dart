import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: const MainLayout(),

    );
  }
}


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  bool _showSidebar = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _menuItems = [
    'Inicio',
    'Perfil',
    'Mensajes',
    'Configuración',
    'Ayuda',
  ];

  final List<IconData> _menuIcons = [
    Icons.home,
    Icons.person,
    Icons.message,
    Icons.settings,
    Icons.help,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
        title: const Text('Mi Aplicación'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      )
          : null,
      drawer: isSmallScreen ? _buildDrawer() : null,
      body: Column(
        children: [
          if (!isSmallScreen) // Encabezado solo en pantallas grandes
            Container(
              color: Colors.blue[100],
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(_showSidebar ? Icons.chevron_left : Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        _showSidebar = !_showSidebar;
                      });
                    },
                  ),
                  const Expanded(
                    child: Center(child: Text('Encabezado')),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 5),
          Expanded(
            child: Row(
              children: [
                // Barra lateral (visible solo en pantallas grandes cuando _showSidebar es true)
                if (!isSmallScreen && _showSidebar)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20), // Radio de los bordes
                    ),
                    width: 200, // Ancho fijo para el sidebar
                    child: _buildSidebarContent(),
                  ),
                if (!isSmallScreen && _showSidebar) const SizedBox(width: 5),

                // Contenido principal
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(20), // Radio de los bordes
                    ),
                    child: _buildContentSection(),
                  ),
                ),

                // Barra derecha (oculta en pantallas pequeñas)
                if (!isSmallScreen) const SizedBox(width: 5),
                if (!isSmallScreen)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(20), // Radio de los bordes
                    ),

                    width: 200, // Ancho fijo para la barra derecha
                    child: _buildRightSidebar(),
                  ),
              ],
            ),
          ),
          if (!isSmallScreen) const SizedBox(height: 5),
          if (!isSmallScreen) // Pie de página solo en pantallas grandes
            Container(
              color: Colors.red[100],
              height: MediaQuery.of(context).size.height * 0.05,
              child: const Center(child: Text('Pie de Página')),
            ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent() {
    return ListView(
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/1.jpeg'),
          child: ClipOval(
            child: Image.asset(
              'assets/1.jpeg',
              width: 60, // 2 * radius
              height: 60, // 2 * radius
              fit: BoxFit.cover, // Ajusta la imagen como "cover"
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(_menuItems.length, (index) {
          return ListTile(
            leading: Icon(_menuIcons[index], color: Colors.blue[800]),
            title: Text(_menuItems[index]),
            selected: _selectedIndex == index,
            selectedTileColor: Colors.blue[50],
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
          );
        }),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
          onTap: () {
            // Lógica para cerrar sesión
          },
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: _buildSidebarContent(),
    );
  }

  Widget _buildRightSidebar() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text('Widgets Adicionales', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...List.generate(10, (index) => Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Widget ${index + 1}'),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    switch (_selectedIndex) {
      case 0:
        return ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Contenido de ${_menuItems[_selectedIndex]} ${index + 1}'),
            ),
          ),
        );
      case 1:
        return const Center(child: Text('Contenido de Perfil', style: TextStyle(fontSize: 24)));
      case 2:
        return ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) => ListTile(
            title: Text('Mensaje ${index + 1}'),
            subtitle: Text('Contenido del mensaje...'),
            leading: const Icon(Icons.email),
          ),
        );
      case 3:
        return ListView(
          children: const [
            ListTile(title: Text('Configuración de cuenta')),
            ListTile(title: Text('Privacidad')),
            ListTile(title: Text('Notificaciones')),
          ],
        );
      case 4:
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('Sección de ayuda y soporte técnico', textAlign: TextAlign.center),
          ),
        );
      default:
        return const Center(child: Text('Sección no encontrada'));
    }
  }
}