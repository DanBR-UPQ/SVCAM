import 'package:flutter/material.dart';

class BotonDeEmergenciaPage extends StatelessWidget {
  const BotonDeEmergenciaPage({super.key});

  void _enviarAlerta(BuildContext context) {
    // Aquí va la lógica real para enviar alerta
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Alerta enviada a seguridad!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Botón de emergencia'),
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Usar solo en caso de emergencia real',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _enviarAlerta(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.sos, size: 32),
              label: const Text(
                'CONTACTAR SEGURIDAD',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}
