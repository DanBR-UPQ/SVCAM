import 'package:flutter/material.dart';

class SoporteTecnicoPage extends StatelessWidget{
  const SoporteTecnicoPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('Soporte Técnico'),
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