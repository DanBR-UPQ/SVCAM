import 'package:flutter/material.dart';
import 'package:svcam_v_0_0_1/pages/boton_de_emergencia_page.dart';
import 'package:svcam_v_0_0_1/pages/configuracion_page.dart';
import 'package:svcam_v_0_0_1/pages/historial_page.dart';
import 'package:svcam_v_0_0_1/pages/cambiar_codigo_page.dart';
import 'package:svcam_v_0_0_1/pages/generar_codigo_page.dart';
import 'package:svcam_v_0_0_1/pages/consultar_codigos_page.dart';
import 'package:svcam_v_0_0_1/pages/perfil_page.dart';
import 'package:svcam_v_0_0_1/pages/soporte_tecnico_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SVCAM - Control de Acceso',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: const MyHomePage(title: 'SVCAM v0.1'),
      routes: {
        '/generarCodigoPage': (context) => GenerarCodigoPage(),
        '/cambiarCodigoPage': (context) => CambiarCodigoPage(),
        '/historialPage': (context) => HistorialPage(),
        '/botonDeEmergenciaPage': (context) => BotonDeEmergenciaPage(),
        '/consultarCodigosPage': (context) => ConsultarCodigosPage(),
        '/soporteTecnicoPage': (context) => SoporteTecnicoPage(),
        '/configuracionPage': (context) => ConfiguracionPage(),
        '/perfilPage': (context) => PerfilPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int codigoPersonal = 1234;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.security, size: 24),
            const SizedBox(width: 8),
            Text(widget.title),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/configuracionPage');
            },
            icon: const Icon(Icons.settings),
            tooltip: 'Configuración',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Parte de arriba
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.apartment,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sistema de Control de Acceso',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bienvenido al panel de administración',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            
            // Parte principal
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                            //ACCIONES PRINCIPALES
                  _buildSectionTitle('Acciones Principales'),
                  const SizedBox(height: 16),
                  _buildQuickActionsGrid(),
                  
                  const SizedBox(height: 30),
                  
                            // GESTIÓN
                  _buildSectionTitle('Gestión del Sistema'),
                  const SizedBox(height: 16),
                  _buildManagementGrid(),
                  
                  const SizedBox(height: 30),
                  
                            // SOPORTE
                  _buildSectionTitle('Soporte y Configuración'),
                  const SizedBox(height: 16),
                  _buildSupportGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




// Titulo
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C3E50),
        ),
      ),
    );
  }

// Acciones Principales
  Widget _buildQuickActionsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildMenuCard(
            title: 'Generar\nCódigo',
            icon: Icons.qr_code_2,
            color: const Color(0xFF4CAF50),
            onTap: () => Navigator.pushNamed(context, '/generarCodigoPage'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMenuCard(
            title: 'Botón de\nEmergencia',
            icon: Icons.emergency,
            color: const Color(0xFFFF5722),
            onTap: () => Navigator.pushNamed(context, '/botonDeEmergenciaPage'),
          ),
        ),
      ],
    );
  }

// Gestión
  Widget _buildManagementGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMenuCard(
                title: 'Cambiar\nCódigo',
                icon: Icons.edit_note,
                color: const Color(0xFF2196F3),
                onTap: () => Navigator.pushNamed(context, '/cambiarCodigoPage'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMenuCard(
                title: 'Consultar\nCódigos',
                icon: Icons.search,
                color: const Color(0xFF9C27B0),
                onTap: () => Navigator.pushNamed(context, '/consultarCodigosPage'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMenuCard(
                title: 'Historial\nde Accesos',
                icon: Icons.history,
                color: const Color(0xFFFF9800),
                onTap: () => Navigator.pushNamed(context, '/historialPage'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(), // Espacio vacío para mantener simetría
            ),
          ],
        ),
      ],
    );
  }

// Soporte
  Widget _buildSupportGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildMenuCard(
            title: 'Soporte\nTécnico',
            icon: Icons.support_agent,
            color: const Color(0xFF607D8B),
            onTap: () => Navigator.pushNamed(context, '/soporteTecnicoPage'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(), // Espacio vacío para mantener simetría
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}