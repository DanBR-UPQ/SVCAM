import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class CambiarCodigoPage extends StatefulWidget {
  const CambiarCodigoPage({super.key});

  @override
  State<CambiarCodigoPage> createState() => _CambiarCodigoPageState();
}

class _CambiarCodigoPageState extends State<CambiarCodigoPage> with TickerProviderStateMixin {
  // Código actual del usuario
  int? codigoPersonalActual;
  int? codigoPersonalNuevo;
  bool _codigoCambiado = false;
  bool _cargandoDatos = true;
  bool _cambiandoCodigo = false;
  
  // Instancia de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usuarioID = 'OQAdSwItMYPEx3v35uDY';
  
  // Animaciones
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    ));
    
    _animationController.forward();
    _pulseController.repeat(reverse: true);
    
    // Cargar código personal actual
    _cargarCodigoPersonal();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Cargar código personal desde Firestore
  Future<void> _cargarCodigoPersonal() async {
    try {
      final DocumentSnapshot userDoc = await _firestore
          .collection('Usuarios')
          .doc(_usuarioID)
          .get();
      
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          codigoPersonalActual = data['codigoPersonal'] as int?;
          _cargandoDatos = false;
        });
      } else {
        _mostrarError('Usuario no encontrado');
        setState(() {
          _cargandoDatos = false;
        });
      }
    } catch (e) {
      print('Error cargando código personal: $e');
      _mostrarError('Error al cargar los datos del usuario');
      setState(() {
        _cargandoDatos = false;
      });
    }
  }

  // Generar código personal único de 4 dígitos
  int _generarCodigoPersonal() {
    final random = Random();
    return 1000 + random.nextInt(9000); // Genera números entre 1000 y 9999
  }

  // Verificar si el código personal ya existe
  Future<bool> _codigoPersonalExiste(int codigo) async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('Usuarios')
          .where('codigoPersonal', isEqualTo: codigo)
          .get();
      
      return result.docs.isNotEmpty;
    } catch (e) {
      print('Error verificando código personal: $e');
      return false;
    }
  }

  // Generar código personal único
  Future<int> _generarCodigoPersonalUnico() async {
    int codigo;
    bool existe;
    
    do {
      codigo = _generarCodigoPersonal();
      existe = await _codigoPersonalExiste(codigo);
    } while (existe);
    
    return codigo;
  }

  // Actualizar código personal en Firestore
  Future<bool> _actualizarCodigoPersonal(int nuevoCodigo) async {
    try {
      await _firestore
          .collection('Usuarios')
          .doc(_usuarioID)
          .update({
        'codigoPersonal': nuevoCodigo,
      });
      
      return true;
    } catch (e) {
      print('Error actualizando código personal: $e');
      return false;
    }
  }

  void _mostrarConfirmacionCambio() {
    if (codigoPersonalActual == null) {
      _mostrarError('No se pudo cargar el código actual');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_outlined,
                  color: Color(0xFFEF4444),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Confirmar Cambio',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Estás seguro de que deseas cambiar tu código personal?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFEF4444).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Esta acción es irreversible. Tu código actual dejará de funcionar inmediatamente.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _cambiandoCodigo ? null : () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: _cambiandoCodigo ? null : () {
                Navigator.of(context).pop();
                _cambiarCodigo();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _cambiandoCodigo
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Cambiar Código'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cambiarCodigo() async {
    setState(() {
      _cambiandoCodigo = true;
    });

    try {
      // Generar nuevo código único
      final int nuevoCodigo = await _generarCodigoPersonalUnico();
      
      // Actualizar en Firestore
      final bool actualizado = await _actualizarCodigoPersonal(nuevoCodigo);
      
      if (actualizado) {
        setState(() {
          codigoPersonalNuevo = nuevoCodigo;
          _codigoCambiado = true;
          _cambiandoCodigo = false;
        });
        
        _mostrarExito('¡Código cambiado exitosamente!');
      } else {
        setState(() {
          _cambiandoCodigo = false;
        });
        _mostrarError('Error al cambiar el código. Intenta nuevamente.');
      }
    } catch (e) {
      setState(() {
        _cambiandoCodigo = false;
      });
      _mostrarError('Error al cambiar el código. Intenta nuevamente.');
      print('Error en _cambiarCodigo: $e');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 14),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 14),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _copiarCodigo(int codigo) {
    Clipboard.setData(ClipboardData(text: codigo.toString()));
    _mostrarExito('Código copiado al portapapeles');
  }

  void _resetearCambio() {
    setState(() {
      _codigoCambiado = false;
      codigoPersonalActual = codigoPersonalNuevo;
      codigoPersonalNuevo = null;
    });
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
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.sync_alt, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              'Cambiar Código',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Inicio',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_cargandoDatos) ...[
                      // Loading
                      _buildCargando(),
                    ] else if (codigoPersonalActual == null) ...[
                      // Error de carga
                      _buildErrorCarga(),
                    ] else if (!_codigoCambiado) ...[
                      // Código actual
                      _buildCodigoActual(),
                      const SizedBox(height: 32),
                      
                      // Advertencia
                      _buildAdvertencia(),
                      const SizedBox(height: 32),
                      
                      // Botones de acción
                      _buildBotonesAccion(),
                    ] else ...[
                      // Código cambiado exitosamente
                      _buildCodigoCambiado(),
                      const SizedBox(height: 32),
                      _buildBotonesFinales(),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCargando() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          const CircularProgressIndicator(
            color: Color(0xFF3B82F6),
          ),
          const SizedBox(height: 24),
          Text(
            'Cargando tu código personal...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCarga() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Color(0xFFEF4444),
          ),
          const SizedBox(height: 24),
          Text(
            'Error al cargar el código personal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'No se pudo conectar con la base de datos',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _cargandoDatos = true;
              });
              _cargarCodigoPersonal();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodigoActual() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF334155),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Tu código personal:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _copiarCodigo(codigoPersonalActual!),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      codigoPersonalActual.toString().padLeft(4, '0'),
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.content_copy,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Toca para copiar',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvertencia() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEF4444).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_outlined,
                color: Color(0xFFEF4444),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Importante',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAdvertenciaItem(
            Icons.lock_outline,
            'Tu código actual dejará de funcionar inmediatamente',
          ),
          _buildAdvertenciaItem(
            Icons.access_time,
            'El cambio es permanente e irreversible',
          ),
          _buildAdvertenciaItem(
            Icons.update,
            'Deberás actualizar a todos los que tengan tu código',
          ),
          _buildAdvertenciaItem(
            Icons.smartphone,
            'Asegúrate de memorizar o guardar el nuevo código',
          ),
        ],
      ),
    );
  }

  Widget _buildAdvertenciaItem(IconData icon, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFFEF4444),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonesAccion() {
    return Column(
      children: [
        Text(
          '¿Deseas cambiar tu código personal?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _cambiandoCodigo ? null : () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 20),
                label: const Text('No, mantener'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF64748B),
                  side: const BorderSide(color: Color(0xFF64748B)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _cambiandoCodigo ? null : _mostrarConfirmacionCambio,
                icon: _cambiandoCodigo 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.sync_alt, size: 20),
                label: Text(_cambiandoCodigo ? 'Cambiando...' : 'Sí, cambiar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _cambiandoCodigo ? Colors.grey : const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCodigoCambiado() {
    return Column(
      children: [
        // Nuevo código
        Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Tu nuevo código:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _copiarCodigo(codigoPersonalNuevo!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF059669), Color(0xFF10B981)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          codigoPersonalNuevo.toString().padLeft(4, '0'),
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 8,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.content_copy,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Toca para copiar',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBotonesFinales() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _copiarCodigo(codigoPersonalNuevo!),
            icon: const Icon(Icons.content_copy, size: 20),
            label: const Text('Copiar Nuevo Código'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _resetearCambio,
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Cambiar otro'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF3B82F6),
                  side: const BorderSide(color: Color(0xFF3B82F6)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home, size: 20),
                label: const Text('Ir al Inicio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF64748B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}