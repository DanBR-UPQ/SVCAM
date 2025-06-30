import 'package:flutter/material.dart';

class ConfiguracionPage extends StatelessWidget{
  const ConfiguracionPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('Configuración'),
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }
          , icon: Icon(Icons.home))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bienvenido a la página de configuración'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Regresar'),
            )
          ],
        )
      ),
    );
  }
}