import 'package:flutter/material.dart';
import 'package:svcam_v_0_0_1/pages/boton_de_emergencia_page';
import 'package:svcam_v_0_0_1/pages/configuracion_page.dart';
import 'package:svcam_v_0_0_1/pages/historial_page';
import 'package:svcam_v_0_0_1/pages/cambiar_codigo_page';
import 'package:svcam_v_0_0_1/pages/generar_codigo_page';
import 'package:svcam_v_0_0_1/pages/consultar_codigos_page';
import 'package:svcam_v_0_0_1/pages/soporte_tecnico_page';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'SVCAM v0.0.1'),
      routes: {
        '/generarCodigoPage': (context) => GenerarCodigoPage(),
        '/cambiarCodigoPage': (context) => CambiarCodigoPage(),
        '/historialPage': (context) => HistorialPage(),
        '/botonDeEmergenciaPage': (context) => BotonDeEmergenciaPage(),
        '/consultarCodigosPage': (context) => ConsultarCodigosPage(),
        '/soporteTecnicoPage': (context) => SoporteTecnicoPage(),
        '/configuracionPage': (context) => ConfiguracionPage(),
      },
    );
  }
}



// ----------------- MAIN ----------------- 
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.home))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10, width: 10),
            Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
              ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              
              
              
                  Column( // COLUMNA 1
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [ 
                      GestureDetector( // GENERAR CODIGO BOTÓN
                        onTap: () {
                          Navigator.pushNamed(context, '/generarCodigoPage');
                        },
                        child: Container(
                          height: 170,
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.deepPurple[100],
                          ),
                          child: Center(child: Text('Generar Código')),
                        ),
                      ),
              
                      SizedBox(height: 20, width: 20),
                      GestureDetector( // CAMBIAR CODIGO BOTÓN
                        onTap: () {
                          Navigator.pushNamed(context, '/cambiarCodigoPage');
                        },
                        child: Container(
                          height: 170,
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.deepPurple[100],
                          ),
                          child: Center(child: Text('Cambiar Código')),
                        ),
                      ),

                      SizedBox(height: 20, width: 20),
                      GestureDetector( // CONSULTAR CÓDIGOS BOTÓN
                        onTap: () {
                          Navigator.pushNamed(context, '/consultarCodigosPage');
                        },
                        child: Container(
                          height: 170,
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.deepPurple[100],
                          ),
                          child: Center(child: Text('Consultar Códigos')),
                        ),
                      ),
                  ],
                  ),
              
              
                  SizedBox(height: 20, width: 20),
                  Column( // COLUMNA 2
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [ 
                      GestureDetector( // HISTORIAL BOTÓN
                        onTap: () {
                          Navigator.pushNamed(context, '/historialPage');
                        },
                        child: Container(
                          height: 170,
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.deepPurple[100],
                          ),
                          child: Center(child: Text('Historial')),
                        ),
                      ),
              
                      SizedBox(height: 20, width: 20),
                      GestureDetector( // BOTÓN DE EMERGENCIA BOTÓN
                        onTap: () {
                          Navigator.pushNamed(context, '/botonDeEmergenciaPage');
                        },
                        child: Container(
                          height: 170,
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.deepPurple[100],
                          ),
                          child: Center(child: Text('Botón de Emergencia')),
                        ),
                      ),

                      SizedBox(height: 20, width: 20),
                      GestureDetector( // SOPORTE TÉCNICO BOTÓN
                        onTap: () {
                          Navigator.pushNamed(context, '/soporteTecnicoPage');
                        },
                        child: Container(
                          height: 170,
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.deepPurple[100],
                          ),
                          child: Center(child: Text('Soporte Técnico')),
                        ),
                      ),

                  ], // Colum children
                  ),
                
                ], // Row children
              ),
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}