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


//===========================================================================
//                                  APPBAR
//===========================================================================


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      
//===========================================================================
//                                  BODY
//===========================================================================

      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header con gradiente y animación
              _buildAnimatedHeader(),
              
              // Estadísticas rápidas
              //_buildQuickStats(),
              
              // Contenido principal
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildAllFunctionsGrid(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


//===========================================================================
//                                  WIDGETS
//===========================================================================



  Widget _buildAnimatedHeader() {
    return Container(
      width: double.infinity,
      height: 231,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 16, 31, 71),
            Color.fromARGB(255, 27, 72, 144),
            Color.fromARGB(255, 16, 31, 71),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: CircuitPatternPainter(),
            ),
          ),

          // Coso del perfil y config
          Positioned(
            top: 12,
            right: 12,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/perfilPage');
                  },
                  icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
                  tooltip: 'Perfil',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/configuracionPage');
                  },
                  icon: const Icon(Icons.settings_outlined, color: Colors.white),
                  tooltip: 'Configuración',
                ),
              ],
            ),
          ),

          // Logo, nombre, etc
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1200),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Image.asset(
                        'assets/images/logoSVCAM.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                const Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const Text(
                  'Daniel',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Seguridad inteligente para tu condominio',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
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


//===========================================================================
//                                  WIDGETS BODY
//===========================================================================


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
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = cardWidth * 1.13; // 1.13 veces más largo que ancho
        
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
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.fill;

    const spacingX = 60.0;
    const spacingY = 40.0;
    const connectorLength = 20.0;

    for (double x = 0; x < size.width; x += spacingX) {
      for (double y = 0; y < size.height; y += spacingY) {
        final start = Offset(x, y);

        
        canvas.drawCircle(start, 2, dotPaint);

        final horizontalEnd = Offset(x + connectorLength, y);
        final verticalEnd = Offset(x, y + connectorLength);

       
        canvas.drawLine(start, horizontalEnd, paint);
        canvas.drawLine(start, verticalEnd, paint);

        
        if (x + spacingX < size.width && y + spacingY < size.height) {
          final elbow = Offset(x + connectorLength, y + spacingY);
          canvas.drawLine(horizontalEnd, elbow, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
