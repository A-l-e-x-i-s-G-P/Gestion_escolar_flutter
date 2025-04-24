import 'package:flutter/material.dart';
import 'package:gestion_escolar/Service/asignaciones_service.dart';
import 'package:gestion_escolar/Service/asingacion_estudiante_service.dart';
import 'package:gestion_escolar/widgets/snackbar.dart';

//Codigo escrito por Alexis GArcia Perez
class AsignacionEstudiante extends StatefulWidget {
  const AsignacionEstudiante({super.key});

  @override
  State<AsignacionEstudiante> createState() => _AsignacionEstudianteState();
}

class _AsignacionEstudianteState extends State<AsignacionEstudiante> {
  int id2 = 0;
  final _asignacionController = TextEditingController();
  final _calificacionController = TextEditingController();
  final asignacionE = AsingacionEstudianteService();
  final listaAsignacion = AsignacionesService();
  final snack = Snackbarll();
  @override
  Widget build(BuildContext context) {
    // Obtener los argumentos pasados desde la navegación
    final argumentos = ModalRoute.of(context)?.settings.arguments as Map;
    // Extraer los valores específicos del mapa
    final id = argumentos['id'];
    final nombre = argumentos['nombre'];
    id2 = id;
    return Scaffold(
      appBar: AppBar(
        //boton de regresar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            asignacionE.actualizarProm(id2);
            
            Navigator.pushReplacementNamed(context, 'estudiantes');
          },
        ),
        title: Text('Asignaciones de $nombre', style: TextStyle(fontSize: 17)),
      ),
      body: Column(
        children: [
          IconButton(
            onPressed: () {
              _showDialog();
            },
            icon: Icon(Icons.add),
            iconSize: 30,
          ),
          FutureBuilder(
            future: asignacionE.obtenerUA(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error al cargar las asignaciones'));
              } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                return Center(child: Text('No hay asignaciones disponibles'));
              }
              final asignaciones = snapshot.data as List;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(
                    10,
                  ), // Correctly applying padding here
                  child: DataTable(
                    columnSpacing: 10,
                    border: TableBorder.all(
                      color: const Color.fromARGB(255, 21, 30, 38),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    headingRowColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 21, 30, 38),
                    ),
                    headingTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    columns: const [
                      DataColumn(
                        label: Text('Estudiante'),
                        columnWidth: MaxColumnWidth(
                          FixedColumnWidth(100),
                          FixedColumnWidth(130),
                        ),
                      ), // Título 1
                      DataColumn(label: Text('Id asignacion')),
                      DataColumn(
                        label: Text('Asignación '),
                        columnWidth: MaxColumnWidth(
                          FixedColumnWidth(200),
                          FixedColumnWidth(230),
                        ),
                      ), // Título 2
                      DataColumn(label: Text('Calificación')), // Título 3
                      DataColumn(label: Text('Fecha')), // Título 4
                      DataColumn(label: Text('Acciones')), // Título Acciones
                    ],
                    rows:
                        asignaciones.map((asignacion) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(nombre), // Campo 1
                              ),
                              DataCell(Text(asignacion[4].toString())),
                              DataCell(
                                Text(asignacion[1].toString()), // Campo 2
                              ),
                              DataCell(
                                Text(asignacion[2].toString()), // Campo 3
                              ),
                              DataCell(
                                Text(asignacion[3].toString()), // Campo 4
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.blue,
                                      onPressed: () {
                                        _showDialog();
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () async {
                                        if (await asignacionE
                                            .eliminarAsignacion(
                                              asignacion[4],
                                              id2,
                                            )) {
                                          snack.mostrarSnackBar(
                                            'Asignación eliminada',
                                            // ignore: use_build_context_synchronously
                                            context,
                                          );
                                        } else {
                                          snack.mostrarSnackBar(
                                            'Error al eliminar la asignación',
                                            // ignore: use_build_context_synchronously
                                            context,
                                          );
                                        }

                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String mensaje = 'Seleccione una asignación';
  void _showDialog() {
    String selectedDate =
        '${DateTime.now().year}-${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month}-${DateTime.now().day}';
    mensaje = 'Seleccione una asignación';
    _asignacionController.clear();
    _calificacionController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Asignación'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95, // Limitar el ancho
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mostrar un selector de asignación
                  FutureBuilder(
                    future: listaAsignacion.fetchAsignaciones(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error al cargar las asignaciones');
                      } else if (!snapshot.hasData ||
                          (snapshot.data as List).isEmpty) {
                        return Text('No hay asignaciones disponibles');
                      }
                      final asignaciones = snapshot.data as List;
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: mensaje,
                          border: OutlineInputBorder(),
                        ),
                        items:
                            asignaciones.map((asignacion) {
                              return DropdownMenuItem<String>(
                                value: asignacion[0].toString(),
                                child: Text(asignacion[1].toString()),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _asignacionController.text = value!;
                            mensaje =
                                asignaciones
                                    .firstWhere(
                                      (asignacion) =>
                                          asignacion[0].toString() == value,
                                    )[1]
                                    .toString();
                          });
                        },
                        isExpanded: true,
                      );
                    },
                  ),
                  TextField(
                    controller: _calificacionController,
                    decoration: InputDecoration(labelText: 'Calificación'),
                  ),
                  SizedBox(
                    height: 250, // Limitar la altura del calendario
                    child: CalendarDatePicker(
                      initialDate: DateTime.parse(selectedDate),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      onDateChanged: (selectedDate1) {
                        selectedDate =
                            '${selectedDate1.year}-${selectedDate1.month}-${selectedDate1.day}';
                        // Manejar la fecha seleccionada
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await asignacionE.crearAsignacion(
                  id2,
                  int.parse(_asignacionController.text),
                  int.parse(_calificacionController.text),
                  selectedDate,
                  context,
                );
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
