import 'package:flutter/material.dart';

class ConfiguracionPage extends StatefulWidget {
  const ConfiguracionPage({super.key});

  @override
  State<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> with TickerProviderStateMixin {
  bool notificacionesActivas = true;
  bool modoOscuro = true; // Ya está en modo oscuro por defecto
  bool autenticacionBiometrica = false;
  bool alertasEmergencia = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        title: const Text(
          'Configuración',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home_outlined, color: Colors.white),
            tooltip: 'Inicio',
          )
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header con gradiente
              //_buildAnimatedHeader(),
              
              // Contenido principal
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Seguridad', Icons.security),
                    const SizedBox(height: 16),
                    _buildSecuritySection(),
                    
                    const SizedBox(height: 24),
                    _buildSectionTitle('Notificaciones', Icons.notifications_outlined),
                    const SizedBox(height: 16),
                    _buildNotificationsSection(),
                    
                    const SizedBox(height: 24),
                    _buildSectionTitle('Personalización', Icons.palette_outlined),
                    const SizedBox(height: 16),
                    _buildPersonalizationSection(),
                    
                    const SizedBox(height: 24),
                    _buildSectionTitle('General', Icons.settings_outlined),
                    const SizedBox(height: 16),
                    _buildGeneralSection(),
                    
                    const SizedBox(height: 32),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return _buildConfigCard([
      _buildSwitchTile(
        'Autenticación Biométrica',
        'Usar huella dactilar o Face ID',
        Icons.fingerprint,
        autenticacionBiometrica,
        const Color(0xFF10B981),
        (value) => setState(() => autenticacionBiometrica = value),
      ),
      _buildListTile(
        'Cambiar Código Maestro',
        'Actualizar código de seguridad principal',
        Icons.lock_outline,
        const Color(0xFF3B82F6),
        () {
          // Navegar a cambio de código maestro
        },
      ),
      _buildListTile(
        'Historial de Seguridad',
        'Ver intentos de acceso y alertas',
        Icons.history,
        const Color(0xFFF59E0B),
        () {
          // Navegar a historial de seguridad
        },
      ),
    ]);
  }

  Widget _buildNotificationsSection() {
    return _buildConfigCard([
      _buildSwitchTile(
        'Notificaciones Push',
        'Recibir alertas del sistema',
        Icons.notifications_outlined,
        notificacionesActivas,
        const Color(0xFF8B5CF6),
        (value) => setState(() => notificacionesActivas = value),
      ),
      _buildSwitchTile(
        'Alertas de Emergencia',
        'Notificaciones críticas de seguridad',
        Icons.emergency,
        alertasEmergencia,
        const Color(0xFFEF4444),
        (value) => setState(() => alertasEmergencia = value),
      ),
    ]);
  }

  Widget _buildPersonalizationSection() {
    return _buildConfigCard([
      _buildListTile(
        'Tema de la Aplicación',
        'Modo oscuro (Recomendado)',
        Icons.dark_mode_outlined,
        const Color(0xFF64748B),
        () {
          // Mostrar opciones de tema
        },
      ),
      _buildListTile(
        'Idioma',
        'Español (México)',
        Icons.language_outlined,
        const Color(0xFF10B981),
        () {
          // Mostrar selector de idioma
        },
      ),
    ]);
  }

  Widget _buildGeneralSection() {
    return _buildConfigCard([
      _buildListTile(
        'Privacidad y Datos',
        'Gestionar información personal',
        Icons.privacy_tip_outlined,
        const Color(0xFF8B5CF6),
        () {
          // Mostrar configuración de privacidad
        },
      ),
      _buildListTile(
        'Términos y Condiciones',
        'Revisar políticas de uso',
        Icons.description_outlined,
        const Color(0xFF64748B),
        () {
          // Mostrar términos
        },
      ),
      _buildListTile(
        'Información de la App',
        'Versión 0.1 - Build 2024.1',
        Icons.info_outline,
        const Color(0xFF3B82F6),
        () {
          // Mostrar información de la app
        },
      ),
    ]);
  }

  Widget _buildConfigCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Color iconColor,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: iconColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: iconColor,
            activeTrackColor: iconColor.withOpacity(0.3),
            inactiveThumbColor: const Color(0xFF64748B),
            inactiveTrackColor: const Color(0xFF334155),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: iconColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: () {
              // Función para guardar configuración
              _showSaveDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.save_outlined),
            label: const Text(
              'Guardar Configuración',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(
                color: Color(0xFF334155),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.arrow_back_outlined),
            label: const Text(
              'Regresar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Color(0xFF10B981)),
              SizedBox(width: 12),
              Text(
                'Configuración Guardada',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          content: Text(
            'Los cambios han sido aplicados correctamente.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Entendido',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
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