import 'package:flutter/material.dart';

class GenerarCodigoPage extends StatefulWidget {
  const GenerarCodigoPage({super.key});

  @override
  State<GenerarCodigoPage> createState() => _GenerarCodigoPageState();
}

class _GenerarCodigoPageState extends State<GenerarCodigoPage> {
  // Controladores para los campos de texto
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _usosController = TextEditingController();
  
  // Variables de estado
  String codigoGenerado = '----';
  bool _mostrarDetalles = false;
  String _detalleDescripcion = '';
  String _detalleUsos = '';

  // Datos de placeholder para demostración
  final List<Map<String, String>> _codigosPlaceholder = [
    {'codigo': '4938', 'descripcion': 'Acceso jardineros', 'usos': '5'},
    {'codigo': '7621', 'descripcion': 'Entrega paquetes', 'usos': '2'},
    {'codigo': '9054', 'descripcion': 'Visita familiar', 'usos': '3'},
    {'codigo': '1847', 'descripcion': 'Mantenimiento piscina', 'usos': '1'},
  ];

  void _mostrarConfirmacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar generación'),
          content: const Text('¿Deseas generar este código con la información proporcionada?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                
                // Generar un código aleatorio de los placeholders
                final randomIndex = DateTime.now().millisecondsSinceEpoch % _codigosPlaceholder.length;
                final nuevoCodigo = _codigosPlaceholder[randomIndex];
                
                setState(() {
                  codigoGenerado = nuevoCodigo['codigo']!;
                  _detalleDescripcion = _descripcionController.text.isEmpty 
                      ? nuevoCodigo['descripcion']! 
                      : _descripcionController.text;
                  _detalleUsos = _usosController.text.isEmpty
                      ? nuevoCodigo['usos']!
                      : _usosController.text;
                  _mostrarDetalles = true;
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Código generado exitosamente')),
                );
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _usosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Generar código'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const Text(
              'Descripción del código:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ej. Código para el jardinero',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cantidad de usos:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _usosController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ej. 1, 2, 5...',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _mostrarConfirmacion(context),
              icon: const Icon(Icons.lock_open),
              label: const Text('Generar código'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Código generado:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                codigoGenerado,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Cuadro de detalles (aparece solo al confirmar)
            if (_mostrarDetalles)
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detalles del código',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const Divider(thickness: 1),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.description, size: 20, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _detalleDescripcion,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.repeat, size: 20, color: Colors.grey),
                          const SizedBox(width: 10),
                          Text(
                            'Usos restantes: ${_detalleUsos}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Acción simulada de copiar
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    // Acción simulada de compartir
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Compartir'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Regresar'),
              ),
            )
          ],
        ),
      ),
    );
  }
}