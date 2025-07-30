import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class GenerarCodigoPage extends StatefulWidget {
  const GenerarCodigoPage({super.key});

  @override
  State<GenerarCodigoPage> createState() => _GenerarCodigoPageState();
}

class _GenerarCodigoPageState extends State<GenerarCodigoPage> with TickerProviderStateMixin {
  // Controladores para los campos de texto
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _usosController = TextEditingController();
  
  // Variables de estado
  String codigoGenerado = '----';
  bool _mostrarDetalles = false;
  String _detalleDescripcion = '';
  String _detalleUsos = '';
  String _tipoSeleccionado = 'visita';
  bool _guardandoEnDB = false;
  
  // Animaciones
  late AnimationController _animationController;
  late AnimationController _codeAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _codeAnimation;

  // Instancia de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usuarioID = 'OQAdSwItMYPEx3v35uDY';

  final Map<String, Map<String, dynamic>> _tiposAcceso = {
    'visita': {
      'nombre': 'Visita',
      'icono': Icons.person,
      'color': Color(0xFF10B981),
    },
    'delivery': {
      'nombre': 'Delivery',
      'icono': Icons.local_shipping,
      'color': Color(0xFF3B82F6),
    },
    'servicio': {
      'nombre': 'Servicio',
      'icono': Icons.build,
      'color': Color(0xFF8B5CF6),
    },
    'emergencia': {
      'nombre': 'Emergencia',
      'icono': Icons.emergency,
      'color': Color(0xFFEF4444),
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _codeAnimationController = AnimationController(
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
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _codeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _codeAnimationController,
      curve: Curves.bounceOut,
    ));
    
    _animationController.forward();
  }


//===========================================================================
//                    LÓGICA DE GENERAR / GUARDAR CÓDIGO
//===========================================================================


  // Generar codigo
  int _generarCodigoUnico() {
    final random = Random();
    return 1000 + random.nextInt(9000);
  }

  // Verificar si el codigo ya está en firebase
  Future<bool> _codigoExiste(int codigo) async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('codigos')
          .where('codigo', isEqualTo: codigo)
          .where('esValido', isEqualTo: true)
          .get();
      
      return result.docs.isNotEmpty;
    } catch (e) {
      print('Error verificando código: $e');
      return false;
    }
  }

  // Generar codigo
  Future<int> _generarCodigoUnicoEnDB() async {
    int codigo;
    bool existe;
    
    do {
      codigo = _generarCodigoUnico();
      existe = await _codigoExiste(codigo);
    } while (existe);
    
    return codigo;
  }

  // Guardar codigo en base de datos
  Future<bool> _guardarCodigoEnFirestore(int codigo) async {
    try {
      await _firestore.collection('codigos').add({
        'codigo': codigo,
        'descripcion': _descripcionController.text.trim(),
        'esValido': true,
        'fechaCreacion': FieldValue.serverTimestamp(),
        'tipo': _tipoSeleccionado,
        'usos': 0,
        'usosMax': int.parse(_usosController.text),
        'usuarioID': _usuarioID,
      });
      
      return true;
    } catch (e) {
      print('Error guardando código: $e');
      return false;
    }
  }

  void _mostrarConfirmacion(BuildContext context) {
    if (_descripcionController.text.trim().isEmpty || 
        _usosController.text.trim().isEmpty ||
        int.tryParse(_usosController.text.trim()) == null ||
        int.parse(_usosController.text.trim()) <= 0) {
      _mostrarError('Por favor, complete todos los campos correctamente');
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
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.help_outline,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 9),
              const Text(
                'Confirmar generación',
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
                '¿Deseas generar este código con la siguiente información?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              _buildConfirmationDetail('Tipo', _tiposAcceso[_tipoSeleccionado]!['nombre']),
              _buildConfirmationDetail('Descripción', _descripcionController.text),
              _buildConfirmationDetail('Usos', _usosController.text),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: _guardandoEnDB ? null : () {
                Navigator.of(context).pop();
                _generarCodigo();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _guardandoEnDB 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Generar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfirmationDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Color(0xFF3B82F6),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generarCodigo() async {
    setState(() {
      _guardandoEnDB = true;
    });

    try {
      // Generar codigo unico
      final int nuevoCodigo = await _generarCodigoUnicoEnDB();
      
      // Guardar en Firestore
      final bool guardadoExitoso = await _guardarCodigoEnFirestore(nuevoCodigo);
      
      if (guardadoExitoso) {
        setState(() {
          codigoGenerado = nuevoCodigo.toString();
          _detalleDescripcion = _descripcionController.text.trim();
          _detalleUsos = _usosController.text.trim();
          _mostrarDetalles = true;
          _guardandoEnDB = false;
        });
        
        _codeAnimationController.reset();
        _codeAnimationController.forward();
        
        _mostrarExito('¡Código generado y guardado exitosamente!');
      } else {
        setState(() {
          _guardandoEnDB = false;
        });
        _mostrarError('Error al guardar el código. Intenta nuevamente.');
      }
    } catch (e) {
      setState(() {
        _guardandoEnDB = false;
      });
      _mostrarError('Error al generar el código. Intenta nuevamente.');
      print('Error en _generarCodigo: $e');
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

  void _copiarCodigo() {
    Clipboard.setData(ClipboardData(text: codigoGenerado));
    _mostrarExito('Código copiado al portapapeles');
  }

  void _compartirCodigo() {
    final mensaje = '''
CÓDIGO DE ACCESO GENERADO

Código: $codigoGenerado
Descripción: $_detalleDescripcion
Usos disponibles: $_detalleUsos
Tipo: ${_tiposAcceso[_tipoSeleccionado]!['nombre']}

Generado por SVCAM - Sistema de Control de Acceso
    ''';
    
    // Aquí puedes implementar la lógica de compartir usando share_plus
    _mostrarExito('Preparando para compartir...');
    print('Mensaje a compartir: $mensaje'); // Para debug
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _usosController.dispose();
    _animationController.dispose();
    _codeAnimationController.dispose();
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
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.qr_code_2, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              'Generar Código',
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
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selector de tipo
                _buildTipoSelector(),
                const SizedBox(height: 24),
                
                // Formulario
                _buildFormulario(),
                const SizedBox(height: 32),
                
                // Botón generar
                _buildGenerarButton(),
                const SizedBox(height: 32),
                
                // Resultado del código
                _buildCodigoResult(),
                
                // Detalles del código
                if (_mostrarDetalles) ...[
                  const SizedBox(height: 24),
                  _buildDetallesCodigo(),
                ],
                
                // Botones de acción
                if (_mostrarDetalles) ...[
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de acceso:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _tiposAcceso.entries.map((entry) {
            final tipo = entry.key;
            final info = entry.value;
            final isSelected = _tipoSeleccionado == tipo;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _tipoSeleccionado = tipo;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? info['color'].withOpacity(0.1) : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? info['color'] : const Color(0xFF334155),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      info['icono'],
                      color: isSelected ? info['color'] : Colors.white.withOpacity(0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      info['nombre'],
                      style: TextStyle(
                        color: isSelected ? info['color'] : Colors.white.withOpacity(0.7),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFormulario() {
    return Column(
      children: [
        _buildTextField(
          label: 'Descripción del código:',
          controller: _descripcionController,
          hint: 'Ej. Visita de Juan, Delivery Amazon...',
          icon: Icons.description_outlined,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Cantidad de usos:',
          controller: _usosController,
          hint: 'Ej. 1, 2, 5...',
          icon: Icons.repeat,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            prefixIcon: Icon(icon, color: const Color(0xFF3B82F6)),
            filled: true,
            fillColor: const Color(0xFF1E293B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenerarButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _guardandoEnDB ? null : () => _mostrarConfirmacion(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: _guardandoEnDB ? Colors.grey : const Color(0xFF10B981),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: _guardandoEnDB
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Generando...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_open_outlined, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Generar Código',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildCodigoResult() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF334155),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Código generado:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _codeAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _codeAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      codigoGenerado,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetallesCodigo() {
    return AnimatedOpacity(
      opacity: _mostrarDetalles ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _tiposAcceso[_tipoSeleccionado]!['color'].withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _tiposAcceso[_tipoSeleccionado]!['icono'],
                  color: _tiposAcceso[_tipoSeleccionado]!['color'],
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Detalles del código',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetalleItem(
              Icons.label_outline,
              'Tipo',
              _tiposAcceso[_tipoSeleccionado]!['nombre'],
            ),
            _buildDetalleItem(
              Icons.description_outlined,
              'Descripción',
              _detalleDescripcion,
            ),
            _buildDetalleItem(
              Icons.repeat,
              'Usos disponibles',
              _detalleUsos,
            ),
            _buildDetalleItem(
              Icons.access_time,
              'Generado',
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} - ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalleItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.white.withOpacity(0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _copiarCodigo,
                icon: const Icon(Icons.content_copy, size: 20),
                label: const Text('Copiar'),
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
              child: OutlinedButton.icon(
                onPressed: _compartirCodigo,
                icon: const Icon(Icons.share, size: 20),
                label: const Text('Compartir'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF10B981),
                  side: const BorderSide(color: Color(0xFF10B981)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF64748B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Regresar al Inicio',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}