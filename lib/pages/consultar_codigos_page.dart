import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConsultarCodigosPage extends StatefulWidget {
  const ConsultarCodigosPage({super.key});

  @override
  State<ConsultarCodigosPage> createState() => _ConsultarCodigosPageState();
}

class _ConsultarCodigosPageState extends State<ConsultarCodigosPage> with TickerProviderStateMixin {
  // Código personal del usuario
  final codigoPersonal = '9999';
  
  // Lista de códigos generados con información más detallada
  final List<Map<String, dynamic>> codigosGenerados = [
    {
      'codigo': '8888',
      'descripcion': 'Invitado Juan',
      'usos': 3,
      'usosOriginales': 5,
      'tipo': 'visita',
      'fechaCreacion': '25/07/2025',
      'activo': true,
    },
    {
      'codigo': '2345',
      'descripcion': 'Repartidor Amazon',
      'usos': 1,
      'usosOriginales': 2,
      'tipo': 'delivery',
      'fechaCreacion': '24/07/2025',
      'activo': true,
    },
    {
      'codigo': '5678',
      'descripcion': 'Técnico de mantenimiento',
      'usos': 0,
      'usosOriginales': 2,
      'tipo': 'servicio',
      'fechaCreacion': '23/07/2025',
      'activo': false,
    },
    {
      'codigo': '1234',
      'descripcion': 'Visita familiar',
      'usos': 2,
      'usosOriginales': 3,
      'tipo': 'visita',
      'fechaCreacion': '22/07/2025',
      'activo': true,
    },
  ];

  // Tipos de acceso con iconos y colores
  final Map<String, Map<String, dynamic>> tiposAcceso = {
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

  // Animaciones
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

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
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _copiarCodigo(String codigo) {
    Clipboard.setData(ClipboardData(text: codigo));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 14),
            Text('Código $codigo copiado'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _mostrarDetallesCodigo(Map<String, dynamic> codigo) {
    showDialog(
      context: context,
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
                  color: tiposAcceso[codigo['tipo']]!['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  tiposAcceso[codigo['tipo']]!['icono'],
                  color: tiposAcceso[codigo['tipo']]!['color'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Detalles del Código',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Código', codigo['codigo']),
              _buildDetailRow('Descripción', codigo['descripcion']),
              _buildDetailRow('Tipo', tiposAcceso[codigo['tipo']]!['nombre']),
              _buildDetailRow('Usos restantes', '${codigo['usos']}/${codigo['usosOriginales']}'),
              _buildDetailRow('Fecha creación', codigo['fechaCreacion']),
              _buildDetailRow('Estado', codigo['activo'] ? 'Activo' : 'Expirado'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _copiarCodigo(codigo['codigo']);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Copiar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.list_alt, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              'Consultar Códigos',
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
                    // Código personal
                    _buildCodigoPersonal(),
                    const SizedBox(height: 32),
                    
                    // Header de códigos generados
                    _buildHeaderCodigosGenerados(),
                    const SizedBox(height: 16),
                    
                    // Lista de códigos generados
                    _buildListaCodigosGenerados(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

Widget _buildCodigoPersonal() {
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
              onTap: () => _copiarCodigo(codigoPersonal),
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
                      codigoPersonal.toString(),
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

  Widget _buildHeaderCodigosGenerados() {
    final codigosActivos = codigosGenerados.where((c) => c['activo']).length;
    
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Códigos Generados',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$codigosActivos activos de ${codigosGenerados.length} códigos',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF10B981).withOpacity(0.3),
            ),
          ),
          child: Text(
            '$codigosActivos activos',
            style: const TextStyle(
              color: Color(0xFF10B981),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListaCodigosGenerados() {
    if (codigosGenerados.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: codigosGenerados.asMap().entries.map((entry) {
        final index = entry.key;
        final codigo = entry.value;
        
        return AnimatedContainer(
          duration: Duration(milliseconds: 200 + (index * 100)),
          margin: const EdgeInsets.only(bottom: 12),
          child: _buildCodigoCard(codigo),
        );
      }).toList(),
    );
  }

  Widget _buildCodigoCard(Map<String, dynamic> codigo) {
    final tipoInfo = tiposAcceso[codigo['tipo']]!;
    final isActive = codigo['activo'];
    final usosRestantes = codigo['usos'];
    // final porcentajeUso = (codigo['usosOriginales'] - usosRestantes) / codigo['usosOriginales'];
    
    return GestureDetector(
      onTap: () => _mostrarDetallesCodigo(codigo),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive 
                ? tipoInfo['color'].withOpacity(0.3) 
                : const Color(0xFF334155),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Icono y tipo
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: tipoInfo['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    tipoInfo['icono'],
                    color: tipoInfo['color'],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Información principal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        codigo['descripcion'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Código: ${codigo['codigo']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF3B82F6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${tipoInfo['nombre']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Estado y flecha
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive 
                            ? const Color(0xFF10B981).withOpacity(0.1)
                            : const Color(0xFFEF4444).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isActive ? 'Activo' : 'Expirado',
                        style: TextStyle(
                          color: isActive 
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF64748B),
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Información de usos
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Usos restantes',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${codigo['usos']}/${codigo['usosOriginales']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF334155),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: (1 - (usosRestantes / codigo['usosOriginales'])).toDouble(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: usosRestantes > 0 
                                  ? tipoInfo['color']
                                  : const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  codigo['fechaCreacion'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF64748B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.code_off,
              size: 48,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No hay códigos generados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los códigos que generes aparecerán aquí',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}