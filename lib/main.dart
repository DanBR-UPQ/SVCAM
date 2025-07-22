import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:svcam_v_0_0_1/pages/boton_de_emergencia_page.dart';
import 'package:svcam_v_0_0_1/pages/configuracion_page.dart';
import 'package:svcam_v_0_0_1/pages/historial_page.dart';
import 'package:svcam_v_0_0_1/pages/cambiar_codigo_page.dart';
import 'package:svcam_v_0_0_1/pages/generar_codigo_page.dart';
import 'package:svcam_v_0_0_1/pages/consultar_codigos_page.dart';
import 'package:svcam_v_0_0_1/pages/perfil_page.dart';
import 'package:svcam_v_0_0_1/pages/soporte_tecnico_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          seedColor: const Color(0xFF1E3A8A),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF1E293B),
          foregroundColor: Colors.white,
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int codigoPersonal = 1234;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shield_outlined, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/perfilPage');
            },
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Perfil',
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/configuracionPage');
            },
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Configuración',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header con gradiente y animación
              _buildAnimatedHeader(),
              
              // Estadísticas rápidas
              _buildQuickStats(),
              
              // Contenido principal
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildAllFunctionsGrid(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF3B82F6),
            Color(0xFF1E40AF),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Patrón de fondo
          Positioned.fill(
            child: CustomPaint(
              painter: CircuitPatternPainter(),
            ),
          ),
          // Contenido principal
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1200),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.security,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sistema de Control de Acceso',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Seguridad inteligente para tu condominio',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Códigos Activos', '12', Icons.qr_code, const Color(0xFF10B981)),
          _buildStatItem('Accesos Hoy', '34', Icons.login, const Color(0xFF3B82F6)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF3B82F6),
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAllFunctionsGrid() {
    return Column(
      children: [
        // Primera fila
        Row(
          children: [
            Expanded(
              child: _buildMenuCard(
                title: 'Generar Código',
                icon: Icons.qr_code_2,
                color: const Color(0xFF10B981),
                onTap: () => Navigator.pushNamed(context, '/generarCodigoPage'),
                height: 120,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMenuCard(
                title: 'Emergencia',
                icon: Icons.emergency,
                color: const Color(0xFFEF4444),
                onTap: () => Navigator.pushNamed(context, '/botonDeEmergenciaPage'),
                height: 120,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Segunda fila
        Row(
          children: [
            Expanded(
              child: _buildMenuCard(
                title: 'Cambiar Código',
                icon: Icons.edit_note,
                color: const Color(0xFF3B82F6),
                onTap: () => Navigator.pushNamed(context, '/cambiarCodigoPage'),
                height: 120,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMenuCard(
                title: 'Consultar Códigos',
                icon: Icons.search,
                color: const Color(0xFF8B5CF6),
                onTap: () => Navigator.pushNamed(context, '/consultarCodigosPage'),
                height: 120,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Tercera fila
        Row(
          children: [
            Expanded(
              child: _buildMenuCard(
                title: 'Historial',
                icon: Icons.history,
                color: const Color(0xFFF59E0B),
                onTap: () => Navigator.pushNamed(context, '/historialPage'),
                height: 120,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMenuCard(
                title: 'Soporte',
                icon: Icons.support_agent,
                color: const Color(0xFF64748B),
                onTap: () => Navigator.pushNamed(context, '/soporteTecnicoPage'),
                height: 120,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isHighlighted = false,
    double height = 120,
  }) {
    // Calculamos el ancho aproximado para hacer el container 1.2 veces más largo que ancho
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = cardWidth * 1.2; // 1.2 veces más largo que ancho
        
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: cardHeight,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF334155),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: color.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: 32,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CircuitPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Crear un patrón de circuito simple
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 3; j++) {
        final x = (size.width / 4) * i;
        final y = (size.height / 2) * j;
        
        // Líneas horizontales
        path.moveTo(x, y);
        path.lineTo(x + 30, y);
        
        // Líneas verticales
        path.moveTo(x, y);
        path.lineTo(x, y + 20);
        
        // Pequeños círculos en las conexiones
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}