import 'package:flutter/material.dart';

class BotonDeEmergenciaPage extends StatelessWidget{
  const BotonDeEmergenciaPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('Botón de emergencia'),
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