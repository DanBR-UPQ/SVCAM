import 'package:flutter/material.dart';

class ConfiguracionPage extends StatefulWidget {
  const ConfiguracionPage({super.key});

  @override
  State<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  bool notificacionesActivas = true;
  bool modoOscuro = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text(
            'Ajustes generales',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          SwitchListTile(
            title: const Text('Notificaciones'),
            subtitle: const Text('Recibir alertas y avisos del sistema'),
            value: notificacionesActivas,
            onChanged: (value) {
              setState(() {
                notificacionesActivas = value;
              });
            },
          ),

          SwitchListTile(
            title: const Text('Modo oscuro'),
            subtitle: const Text('Cambiar a tema oscuro'),
            value: modoOscuro,
            onChanged: (value) {
              setState(() {
                modoOscuro = value;
              });
            },
          ),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            subtitle: const Text('Español'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Puedes abrir una pantalla de selección de idioma
            },
          ),

          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Cambiar contraseña'),
            onTap: () {
              // Redirige a pantalla de cambio de contraseña (si aplica)
            },
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacidad'),
            onTap: () {
              // Mostrar términos o configuración de privacidad
            },
          ),

          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Regresar'),
            ),
          ),
        ],
      ),
    );
  }
}
