import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async'; // Para el Timer



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  HomePage(),

    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _showBackToTopButton = _scrollController.offset > 400;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Contenido principal con secciones
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Sección 1: Banner principal
                _buildBannerSection(),

                // Sección 2: Noticias destacadas
                _buildNewsSection(),

                // Sección 3: Galería de imágenes
                _buildGallerySection(),

                // Sección 4: Eventos próximos
                _buildEventsSection(),

                // Sección 5: Testimonios
                _buildTestimonialsSection(),

                const SizedBox(height: 100), // Espacio final
              ],
            ),
          ),

          // Botón para volver al inicio
          if (_showBackToTopButton)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                child: const Icon(Icons.arrow_upward),
                backgroundColor: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }

  // Sección 1: Banner
  Widget _buildBannerSection() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        image: const DecorationImage(
          image: NetworkImage('https://picsum.photos/800/300'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          'Bienvenido a nuestra App',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sección 2: Noticias
  Widget _buildNewsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Últimas Noticias',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: Image.network(
                            'https://picsum.photos/300/200?random=$index',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Título de noticia ${index + 1}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Sección 3: Galería
  Widget _buildGallerySection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Galería de Imágenes',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://picsum.photos/200/200?random=$index',
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Sección 4: Eventos
  Widget _buildEventsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Próximos Eventos',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...List.generate(3, (index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.event, color: Colors.blue),
                title: Text('Evento importante ${index + 1}'),
                subtitle: Text('Fecha: ${DateTime.now().add(Duration(days: index * 7))}'),
                trailing: const Icon(Icons.arrow_forward),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Sección 5: Testimonios
  Widget _buildTestimonialsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lo que dicen nuestros usuarios',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: PageView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.format_quote, size: 30, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text(
                        'Esta es una excelente aplicación. Me ha ayudado mucho en mi día a día. Recomendada 100%.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '- Usuario ${index + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}