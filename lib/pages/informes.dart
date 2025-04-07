import 'package:flutter/material.dart';
import 'package:gestion_escolar/widgets/dialog.dart';
import 'package:gestion_escolar/widgets/menu.dart';

class Informes extends StatefulWidget {
  const Informes({super.key});

  @override
  State<Informes> createState() => _InformesState();
}

class _InformesState extends State<Informes> {
  final String rutas = 'informes';
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(141, 0, 0, 0),
        title: const Text('Informes', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          ShowDialog()
        ],
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Informes'),
          ],
        ),
      ),
      drawer: Menu(ruta: rutas,)
    );
  }
}
