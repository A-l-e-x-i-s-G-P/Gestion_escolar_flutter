import 'package:flutter/material.dart';
import 'package:gestion_escolar/widgets/dialog.dart';
import 'package:gestion_escolar/widgets/menu.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final String rutas = 'dashboard';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(141, 0, 0, 0),
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          ShowDialog()
        ],
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Dashboard'),
          ],
        ),
      ),
      drawer: Menu(ruta: rutas,)
    );
  }
}