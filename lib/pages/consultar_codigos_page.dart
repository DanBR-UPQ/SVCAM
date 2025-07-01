import 'package:flutter/material.dart';

class ConsultarCodigosPage extends StatelessWidget{
  const ConsultarCodigosPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('Consultar Códigos'),
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
