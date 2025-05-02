import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async'; // Para el Timer

class HomeController extends GetxController {
  final RxDouble _scrollOffset = 0.0.obs;
  final RxBool _showBackToTop = false.obs;
  final RxBool _isNavExpanded = false.obs;

  // Getters
  double get scrollOffset => _scrollOffset.value;
  bool get showBackToTop => _showBackToTop.value;
  bool get isNavExpanded => _isNavExpanded.value;

  // Métodos para actualizar el estado
  void updateScrollOffset(double offset) {
    _scrollOffset.value = offset;

    // Mostrar/ocultar botón "volver arriba"
    if (offset > 200 && !_showBackToTop.value) {
      _showBackToTop.value = true;
    } else if (offset <= 200 && _showBackToTop.value) {
      _showBackToTop.value = false;
    }

    // Expandir/contraer navbar
    if (offset > 50 && !_isNavExpanded.value) {
      _isNavExpanded.value = true;
    } else if (offset <= 50 && _isNavExpanded.value) {
      _isNavExpanded.value = false;
    }


  }

  void scrollToTop() {
    _scrollOffset.value = 0;
    _showBackToTop.value = false;
    _isNavExpanded.value = false;
  }
}



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
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController(viewportFraction: 1.0);
  bool _showBackToTop = false;
  bool _isNavExpanded = false;
  double _lastScrollPosition = 0;
  int _currentPage = 0;



  void _nextPage() {
    if (_currentPage < 2) { // Cambia 2 por (número de imágenes - 1)
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }


  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      // Mostrar/ocultar botón de volver arriba
      if (_scrollController.offset > 200 && !_showBackToTop) {
        setState(() {
          _showBackToTop = true;
        });
      } else if (_scrollController.offset <= 200 && _showBackToTop) {
        setState(() {
          _showBackToTop = false;
        });
      }

      // Efecto en el navbar al hacer scroll
      if (_scrollController.offset > 50 && !_isNavExpanded) {
        setState(() {
          _isNavExpanded = true;
        });
      } else if (_scrollController.offset <= 50 && _isNavExpanded) {
        setState(() {
          _isNavExpanded = false;
        });
      }

      // Guardar última posición de scroll
      _lastScrollPosition = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Espacio para el navbar fijo (para evitar solapamiento)
                SizedBox(height: _isNavExpanded ? 70 : 60),

                // Header con título pequeño (ahora está después del espacio del navbar)
                Container(
                  height: screenHeight * 0.1,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text(
                      'Blog Informativo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Carrusel (70% de la pantalla)
                Stack(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.7,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildCarouselItem('assets/1.jpeg', 'Título 1'),
                          _buildCarouselItem('assets/2.jpeg', 'Título 2'),
                          _buildCarouselItem('assets/3.jpeg', 'Título 3'),
                        ],
                      ),
                    ),

                    // Botón Siguiente
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        onPressed: _nextPage,
                        child: const Icon(Icons.chevron_right, color: Colors.black),
                      ),
                    ),

                    // Botón Anterior
                    Positioned(
                      left: 20,
                      bottom: 20,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        onPressed: _prevPage,
                        child: const Icon(Icons.chevron_left, color: Colors.black),
                      ),
                    ),

                    // Indicadores de página
                    Positioned(
                      bottom: 30,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                /*SizedBox(
                  height: screenHeight * 0.7,
                  child: PageView(
                    controller: PageController(viewportFraction: 1.0), // Asegura el tamaño completo
                    physics: const BouncingScrollPhysics(), // Efecto de desplazamiento
                    children: [
                      _buildCarouselItem('assets/1.jpeg', 'Título 1'),
                      _buildCarouselItem('assets/2.jpeg', 'Título 2'),
                      _buildCarouselItem('assets/3.jpeg', 'Título 3'),
                    ].map((widget) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Espacio entre items
                      child: widget,
                    )).toList(),
                  ),
                ),*/


                // Resto de las secciones (igual que antes)
                Container(
                  height: screenHeight * 0.3,
                  color: Colors.blue[50],
                  child: const Center(
                    child: Text(
                      'Sección introductoria',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),

                // Sección con imagen y texto "Nuestra Visión"
                Container(
                  padding: const EdgeInsets.all(40),
                  height: screenHeight * 0.6,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          'assets/2.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 40),
                      const Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nuestra Visión',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam in dui mauris. Vivamus hendrerit arcu sed erat molestie vehicula. Sed auctor neque eu tellus rhoncus ut eleifend nibh porttitor.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Sección de datos (60%)
                Container(
                  height: screenHeight * 0.6,
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Datos Importantes',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDataItem('100+', 'Publicaciones'),
                          _buildDataItem('50+', 'Noticias'),
                          _buildDataItem('10+', 'Años de experiencia'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Sección de resumen mensual (40%)
                Container(
                  height: screenHeight * 0.4,
                  color: Colors.blue[100],
                  padding: const EdgeInsets.all(40),
                  child: const Center(
                    child: Text(
                      'Resumen Mensual',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Sección con título y carrusel pequeño (50% + 15%)
                Column(
                  children: [
                    Container(
                      height: screenHeight * 0.5,
                      padding: const EdgeInsets.all(40),
                      child: const Center(
                        child: Text(
                          'Nuestros Proyectos',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.15,
                      child: PageView(
                        children: [
                          _buildMiniCarouselItem('Proyecto 1'),
                          _buildMiniCarouselItem('Proyecto 2'),
                          _buildMiniCarouselItem('Proyecto 3'),
                        ],
                      ),
                    ),
                  ],
                ),

                // Sección de noticias con cards
                Container(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      const Text(
                        'Últimas Noticias',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          _buildNewsCard(),
                          _buildNewsCard(),
                          _buildNewsCard(),
                          _buildNewsCard(),
                          _buildNewsCard(),
                          _buildNewsCard(),
                          _buildNewsCard(),
                          _buildNewsCard(),
                        ],
                      ),
                    ],
                  ),
                ),

                // Footer (50%)
                Container(
                  height: screenHeight * 0.5,
                  color: Colors.grey[800],
                  padding: const EdgeInsets.all(40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sobre Nosotros',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Información sobre la organización...',
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Publicaciones',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text('Últimas publicaciones...',
                                style: TextStyle(color: Colors.grey[300])),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'La Institución',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text('Información institucional...',
                                style: TextStyle(color: Colors.grey[300])),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Contáctanos',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text('Email: contacto@blog.com',
                                style: TextStyle(color: Colors.grey[300])),
                            Text('Teléfono: +123456789',
                                style: TextStyle(color: Colors.grey[300])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navbar fijo en la parte superior
          Navbar(),

          // Botón para volver arriba
          if (_showBackToTop)
            Positioned(
              bottom: 20,
              right: 50,
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                child: const Icon(Icons.arrow_upward),
              ),
            ),
        ],
      ),
    );
  }

  Widget Navbar(){
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: _isNavExpanded ? 70 : 60,
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const FlutterLogo(size: 40), // Logo
              const Spacer(),
              _buildNavLink('Inicio'),
              _buildNavLink('Nosotros'),
              _buildNavLink('Publicaciones'),
              _buildNavLink('Noticias'),
              _buildNavLink('Contáctanos'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }



/*
  Widget _buildCarouselItem(String image, String title) {
    return Stack(
      children: [

        Image.asset(
          image,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Container(
          color: Colors.black.withOpacity(0.4),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }*/
  Widget _buildCarouselItem(String imagePath, String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12), // Bordes redondeados
      child: Stack(
        fit: StackFit.expand, // Asegura que ocupe todo el espacio
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover, // Cubre todo el espacio disponible
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey,
              child: const Icon(Icons.error),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCarouselItem(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard() {
    return SizedBox(
      width: 250,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/2.jpeg',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Título de la Noticia',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Breve descripción de la noticia...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Leer más',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}