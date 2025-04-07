import 'package:flutter/material.dart';
//Codigo escrito por Alexis Garcia Perez
class AsignacionEstudiante extends StatefulWidget {
  const AsignacionEstudiante({super.key});

  @override
  State<AsignacionEstudiante> createState() => _AsignacionEstudianteState();
}

class _AsignacionEstudianteState extends State<AsignacionEstudiante> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asignaciones del alumno xxxxxxx'),
      ),
    );
  }
}