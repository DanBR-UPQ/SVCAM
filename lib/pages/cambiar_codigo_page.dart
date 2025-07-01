import 'package:flutter/material.dart';

class CambiarCodigoPage extends StatelessWidget{
  const CambiarCodigoPage({super.key});

  final int codigoPersonal = 1234;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('Cambiar Código Personal'),
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }
          , icon: Icon(Icons.home))
        ],
      ), // appbar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Su código actual: $codigoPersonal'),
            Text('¿Desea cambiar su código?'),
            Text('Nota: Esta acción es Irreversible'),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                  onPressed: (){
              
                  },
                  child: Text('Sí'),
                ),
                ElevatedButton(
                  onPressed: (){
              
                  },
                  child: Text('No'),
                ),
                ]
              ),
            ), // Row
            
          ],
        ) // center
      ), // body
    ); // return
  } // widget
} // class