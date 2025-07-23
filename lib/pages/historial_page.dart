import 'package:flutter/material.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedFilter = 'Todos';

  final List<Map<String, dynamic>> _historialData = [
    {
      'fecha': '01/07/2025',
      'hora': '08:30',
      'codigo': '1234',
      'usosIniciales': 5,
      'usosRestantes': 3,
      'descripcion': 'Visita de Juan',
      'estado': 'activo',
      'tipo': 'visita'
    },
    {
      'fecha': '30/06/2025',
      'hora': '14:10',
      'codigo': '5678',
      'usosIniciales': 3,
      'usosRestantes': 0,
      'descripcion': 'Repartidor Amazon',
      'estado': 'completado',
      'tipo': 'delivery'
    },
    {
      'fecha': '29/06/2025',
      'hora': '11:45',
      'codigo': '9876',
      'usosIniciales': 2,
      'usosRestantes': 1,
      'descripcion': 'Servicio técnico',
      'estado': 'activo',
      'tipo': 'servicio'
    },
    {
      'fecha': '28/06/2025',
      'hora': '17:20',
      'codigo': '1111',
      'usosIniciales': 1,
      'usosRestantes': 0,
      'descripcion': 'Electricista',
      'estado': 'completado',
      'tipo': 'servicio'
    },
  ];

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
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 49, 176, 170),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.history, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              'Historial de Accesos',
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
        child: Column(
          children: [
            // Header con estadísticas
            //_buildStatsHeader(),
            
            const SizedBox(height: 14),
            // Filtros
            _buildFiltersSection(),
            
            // Lista de historial
            Expanded(
              child: _buildHistorialList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader() {
    final totalAccesos = _historialData.length;
    final codigosActivos = _historialData.where((item) => item['estado'] == 'activo').length;
    final codigosCompletados = _historialData.where((item) => item['estado'] == 'completado').length;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF3B82F6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', '$totalAccesos', Icons.analytics, Colors.white),
          _buildStatItem('Activos', '$codigosActivos', Icons.check_circle, const Color(0xFF10B981)),
          _buildStatItem('Completados', '$codigosCompletados', Icons.done_all, const Color(0xFF64748B)),
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
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersSection() {
    final filters = ['Todos', 'Activos', 'Completados', 'Visitas', 'Servicios', 'Delivery'];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtrar por:',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = _selectedFilter == filter;
                
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF334155),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialList() {
    final filteredData = _getFilteredData();
    
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Registros (${filteredData.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final item = filteredData[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: _buildHistorialCard(item, index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialCard(Map<String, dynamic> item, int index) {
    final isActivo = item['estado'] == 'activo';
    final progress = item['usosRestantes'] / item['usosIniciales'];
    
    Color getTypeColor(String tipo) {
      switch (tipo) {
        case 'visita': return const Color(0xFF10B981);
        case 'delivery': return const Color(0xFF3B82F6);
        case 'servicio': return const Color(0xFF8B5CF6);
        default: return const Color(0xFF64748B);
      }
    }

    IconData getTypeIcon(String tipo) {
      switch (tipo) {
        case 'visita': return Icons.person;
        case 'delivery': return Icons.local_shipping;
        case 'servicio': return Icons.build;
        default: return Icons.help;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActivo ? getTypeColor(item['tipo']).withOpacity(0.3) : const Color(0xFF334155),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header de la tarjeta
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: getTypeColor(item['tipo']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    getTypeIcon(item['tipo']),
                    color: getTypeColor(item['tipo']),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['descripcion'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item['fecha']} • ${item['hora']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActivo ? const Color(0xFF10B981).withOpacity(0.1) : const Color(0xFF64748B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isActivo ? 'ACTIVO' : 'COMPLETADO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isActivo ? const Color(0xFF10B981) : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Información del código
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.qr_code, color: Color(0xFF3B82F6), size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Código: ${item['codigo']}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Usos: ${item['usosRestantes']} de ${item['usosIniciales']} restantes',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Barra de progreso circular
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Stack(
                      children: [
                        CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(0.1),
                          ),
                        ),
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isActivo ? getTypeColor(item['tipo']) : const Color(0xFF64748B),
                          ),
                        ),
                        Center(
                          child: Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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

  List<Map<String, dynamic>> _getFilteredData() {
    switch (_selectedFilter) {
      case 'Activos':
        return _historialData.where((item) => item['estado'] == 'activo').toList();
      case 'Completados':
        return _historialData.where((item) => item['estado'] == 'completado').toList();
      case 'Visitas':
        return _historialData.where((item) => item['tipo'] == 'visita').toList();
      case 'Servicios':
        return _historialData.where((item) => item['tipo'] == 'servicio').toList();
      case 'Delivery':
        return _historialData.where((item) => item['tipo'] == 'delivery').toList();
      default:
        return _historialData;
    }
  }
}