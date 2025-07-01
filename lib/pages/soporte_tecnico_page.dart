import 'package:flutter/material.dart';

class SoporteTecnicoPage extends StatelessWidget {
  const SoporteTecnicoPage({super.key});

  void _contactarSoporte(BuildContext context) {
    // Aquí iría la lógica real (correo, chat, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mensaje enviado a soporte técnico'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Soporte Técnico'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Preguntas Frecuentes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  ExpansionTile(
                    title: Text('¿Cómo genero un código para visitante?'),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Desde el menú principal, toca "Generar código", llena los campos y presiona el botón.'),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text('¿Puedo cancelar un código generado?'),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Sí, en la sección "Consultar códigos", puedes eliminar códigos activos.'),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text('¿Qué hacer si olvidé mi código personal?'),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Comunícate con el administrador del condominio para restablecer tu acceso.'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _contactarSoporte(context),
              icon: const Icon(Icons.support_agent),
              label: const Text('Contactar soporte'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Regresar'),
            )
          ],
        ),
      ),
    );
  }
}
