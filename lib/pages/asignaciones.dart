import 'package:flutter/material.dart';
import 'package:gestion_escolar/Service/asignaciones_service.dart';
import 'package:gestion_escolar/widgets/dialog.dart';
import 'package:gestion_escolar/widgets/menu.dart';
import 'package:gestion_escolar/widgets/snackbar.dart';

//Codigo escrito por Alexis Garcia Perez
class Asignaciones extends StatefulWidget {
  const Asignaciones({super.key});

  @override
  State<Asignaciones> createState() => _AsignacionesState();
}

class _AsignacionesState extends State<Asignaciones> {
  final TextEditingController _tituloContorller = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  AsignacionesService asignacionesService = AsignacionesService();
  final String rutas = 'asignaciones';
  final snack = Snackbarll();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(141, 0, 0, 0),
        title: const Text(
          'Asignaciones',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[ShowDialog()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Lista de asignaciones', style: TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            IconButton(
              onPressed: () {
                 _showDialog('Agregar', []);
              },
              icon: const Icon(
                Icons.add,
                size: 30,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  const Color.fromARGB(255, 221, 221, 221),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                shadowColor: WidgetStateProperty.all<Color>(
                  const Color.fromARGB(255, 0, 0, 0),
                ),
                elevation: WidgetStateProperty.all<double>(5.0),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _tablaAsignaciones()),
          ],
        ),
      ),
      drawer: Menu(ruta: rutas),
    );
  }

  Widget _tablaAsignaciones() {
    return FutureBuilder<List<List<dynamic>>>(
      future: asignacionesService.fetchAsignaciones(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<List<dynamic>>> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // Muestra un indicador de carga
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          ); // Muestra el error si ocurre
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay asignaciones disponibles'));
        } else {
          final asignacion = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dataRowMinHeight: 50,
                dataRowMaxHeight: 65,
                columnSpacing: 10,
                sortAscending: true,
                columns: const [
                  DataColumn(label: Text("ID")),
                  DataColumn(
                    label: Text("Titulo"),
                    columnWidth: MaxColumnWidth(
                      FixedColumnWidth(120),
                      FixedColumnWidth(330),
                    ),
                  ),
                  DataColumn(
                    label: Text("Descripción"),
                    columnWidth: MaxColumnWidth(
                      FixedColumnWidth(120),
                      FixedColumnWidth(380),
                    ),
                  ),
                  DataColumn(label: Text("Acciones")),
                ],
                rows:
                    asignacion.map((usuario) {
                      return DataRow(
                        cells: [
                          DataCell(Text(usuario[0].toString())), 
                          DataCell(Text(usuario[1].toString())), 
                          DataCell(Text(usuario[2].toString())), 
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                     _showDialog('Editar', usuario);
                                  },
                                  icon: const Icon(Icons.edit),
                                  color: Colors.blue,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _eliminar(usuario[0]);
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
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
        }
      },
    );
  }

  void _eliminar(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar asignación'),
          content: const Text('¿Estás seguro de eliminar esta asignación?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final eliminado = await asignacionesService
                      .eliminarAsignacion(id);
                  if (!mounted) return;
                  if (eliminado) {
                    // ignore: use_build_context_synchronously
                    snack.mostrarSnackBar('Asignación eliminada con exito', context);
                    setState(() {});
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  } else {
                    // ignore: use_build_context_synchronously
                    snack.mostrarSnackBar('Error al eliminar asignación', context);
                  }
                } catch (e) {
                  if (!mounted) return;
                  // ignore: use_build_context_synchronously
                  snack.mostrarSnackBar('Error: $e', context);
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(String accion, usuario) {
    if (accion == 'Agregar') {
      _tituloContorller.clear();
      _descripcionController.clear();
    } else if (usuario != null) {
      _tituloContorller.text = usuario[1];
      _descripcionController.text = usuario[2];
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$accion asignación'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _tituloContorller,
                  decoration: const InputDecoration(
                    labelText: 'Titulo de la asignacion',
                  ),
                ),
                TextField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripcion'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                //validar campos
                if (_tituloContorller.text.isEmpty ||
                    _descripcionController.text.isEmpty) {
                  snack.mostrarSnackBar( 'Por favor, no deje ningun campo vacio',context, );
                } else {
                  if (accion == 'Agregar') {
                      await asignacionesService.crearAsignacion(
                        context,
                        _tituloContorller,
                        _descripcionController
                      ); // Llamar al método para crear usuario
                      setState(() {});
                  } else {
                    if (_tituloContorller.text == usuario[1] &&
                        _descripcionController.text == usuario[2]) {
                      snack.mostrarSnackBar('No se modificó nada', context);
                    } else {
                      await asignacionesService.editarAsignacion(
                        context,
                        _tituloContorller,
                        _descripcionController,
                        usuario[0]
                      );
                      setState(() {});
                    }
                  }
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

}
