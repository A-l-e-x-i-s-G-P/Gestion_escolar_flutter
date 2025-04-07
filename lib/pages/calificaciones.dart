import 'package:flutter/material.dart';
import 'package:gestion_escolar/Service/estudiantes_service.dart';
import 'package:gestion_escolar/widgets/dialog.dart';
import 'package:gestion_escolar/widgets/menu.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//Codigo escrito por Alexis Garcia Perez
class Calificaciones extends StatefulWidget {
  const Calificaciones({super.key});

  @override
  State<Calificaciones> createState() => _CalificacionesState();
}

class _CalificacionesState extends State<Calificaciones> {
  final EstudiantesService _estudiantesService = EstudiantesService();
  final String rutas = 'calificaciones';

  // Datos de ejemplo para el gráfico de barras
  List<_StudentAverage> studentAverages = [];
  @override
  void initState() {
    super.initState();
    _loadStudentAverages();
  }

  void _loadStudentAverages() async {
    final estudiantes = await _estudiantesService.fetchEstudiantes();
    setState(() {
      studentAverages =
          estudiantes
              .map<_StudentAverage>(
                (estudiante) => _StudentAverage(estudiante[1], estudiante[8], estudiante[0]),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(141, 0, 0, 0),
        title: const Text(
          'Calificaciones',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[ShowDialog()],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Permite desplazamiento vertical
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Permite desplazamiento horizontal
          child: RotatedBox(
            quarterTurns: 1, // Rota el gráfico 90 grados en sentido horario
            child: SizedBox(
              width:
                  studentAverages.length *
                  40.0, // Ajusta automáticamente según el contenido
              height: MediaQuery.of(context).size.width * 0.97,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(labelRotation: -90),
                primaryYAxis: NumericAxis(maximum: 100),
                legend: Legend(isVisible: false),
                series: <CartesianSeries<_StudentAverage, String>>[
                  ColumnSeries<_StudentAverage, String>(
                    dataSource: studentAverages,
                    xValueMapper: (_StudentAverage student, _) => '${student.id} ${student.name}',
                    yValueMapper:
                        (_StudentAverage student, _) => student.average,
                    name: 'Promedio',
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      angle: -90,
                    ),
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Menu(ruta: rutas),
    );
  }
}

class _StudentAverage {
  _StudentAverage(this.name, this.average, this.id);
  final String name;
  final double average;
  final int id;
}
