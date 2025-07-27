import 'package:flutter/material.dart';

class ConsultarCodigosPage extends StatelessWidget {
  const ConsultarCodigosPage({super.key});

  final int codigoGenerado = 9999;

  final List<Map<String, dynamic>> codigosGenerados = const [
    {'codigo': '8888', 'descripcion': 'Invitado Juan', 'usos': 3},
    {'codigo': '2345', 'descripcion': 'Repartidor', 'usos': 1},
    {'codigo': '5678', 'descripcion': 'Técnico de mantenimiento', 'usos': 2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Consultar Códigos'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Código personal
            Text(
              'Código personal:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueGrey),
              ),
              child: Text(
                '$codigoGenerado',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),

            // Titulo
            Text(
              'Códigos generados:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),

            // Códigos
            Expanded(
              child: ListView.builder(
                itemCount: codigosGenerados.length,
                itemBuilder: (context, index) {
                  final codigo = codigosGenerados[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.lock, color: Colors.blue),
                      title: Text(
                        codigo['descripcion'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Código: ${codigo['codigo']} • Usos restantes: ${codigo['usos']}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}