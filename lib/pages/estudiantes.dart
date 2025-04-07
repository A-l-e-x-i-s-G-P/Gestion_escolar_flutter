import 'package:flutter/material.dart';
import 'package:gestion_escolar/widgets/dialog.dart';
import 'package:gestion_escolar/widgets/menu.dart';
import 'package:http/http.dart' as http;
//import 'dart:convert'; // Para manejar JSON
import 'package:gestion_escolar/Service/estudiantes_service.dart';
import 'package:gestion_escolar/Service/usuario_service.dart';

class Estudiantes extends StatefulWidget {
  const Estudiantes({super.key});

  @override
  State<Estudiantes> createState() => _EstudiantesState();
}

class _EstudiantesState extends State<Estudiantes> {
  final EstudiantesService _estudiantesService = EstudiantesService();
  final UsuarioService _usuarioService = UsuarioService();
  late Future<List<int>> idsFuture,
      usuariosExitentesFuture,
      idsEstudiantesFuture;

  @override
  void initState() {
    super.initState();
    idsFuture = _usuarioService.fetchUsuarioIds();
    idsEstudiantesFuture = _estudiantesService.fetchEstudiantesIds();
    usuariosExitentesFuture = _estudiantesService.usuarioExintes();
  }

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _gradoController = TextEditingController();
  final TextEditingController _grupoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _curpController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _promedioController =TextEditingController(); // Agregado para el icono

  final String rutas = 'estudiantes';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(141, 0, 0, 0),
        title: const Text('Estudiantes', style: TextStyle(color: Colors.white)),
        actions: <Widget>[ShowDialog()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Lista de Estudiantes', style: TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            IconButton(
              onPressed: () {
                _showDialog(
                  'Agregar',
                  0,
                ); // Cambiado de 'usuario' a 'estudiante'
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
            Expanded(
              child:
                  tablaEstudiantes(), // Asegúrate de que _tablaEstudiantes devuelva un widget que pueda expandirse
            ),
          ],
        ),
      ),
      drawer: Menu(ruta: rutas),
    );
  }

  Widget tablaEstudiantes() {
    return FutureBuilder<List<List<dynamic>>>(
      future: _estudiantesService.fetchEstudiantes(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<List<dynamic>>> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay Estudiantes disponibles'));
        } else {
          final estudiantes = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortAscending: true,
                columns: const [
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text("Nombre")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("Grado")),
                  DataColumn(label: Text("Grupo")),
                  DataColumn(label: Text("Telefono")),
                  DataColumn(label: Text("CURP")),
                  DataColumn(label: Text("Usuario")),
                  DataColumn(label: Text("Promedio")),
                  DataColumn(label: Text("Acciones")),
                ],
                rows:
                    estudiantes.map((estudiante) {
                      return DataRow(
                        cells: [
                          DataCell(Text(estudiante[0].toString())),
                          DataCell(Text(estudiante[1].toString())),
                          DataCell(Text(estudiante[2].toString())),
                          DataCell(Text(estudiante[3].toString())),
                          DataCell(Text(estudiante[4].toString())),
                          DataCell(Text(estudiante[5].toString())),
                          DataCell(Text(estudiante[6].toString())),
                          DataCell(Text(estudiante[7].toString())),
                          DataCell(Text(estudiante[8].toString())),

                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _showDialog('Editar', estudiante);
                                  },
                                  icon: const Icon(Icons.edit),
                                  color: Colors.blue,
                                ),
                                IconButton(
                                  onPressed: () {},
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

  //dialogo que se abrera al presionar el boton de agregar
  void _showDialog(String accion, estudiante) {
    print('Usuario: $estudiante'); // Agregado para depuración
    if (accion == 'Agregar') {
      _nombreController.clear();
      _gradoController.clear();
      _grupoController.clear();
      _correoController.clear();
      _telefonoController.clear();
      _curpController.clear();
      // _usuarioController.clear();
      _promedioController.clear(); // Agregado para el icono
    } else if (estudiante != null && estudiante is List) {
      _nombreController.text = estudiante[1].toString();
      _gradoController.text = estudiante[2].toString();
      _grupoController.text = estudiante[3].toString();
      _correoController.text = estudiante[4].toString();
      _telefonoController.text = estudiante[5].toString();
      _curpController.text = estudiante[6].toString();
      _usuarioController.text = estudiante[7].toString();
      _promedioController.text =
          estudiante[8].toString(); // Agregado para el icono
    } else {
      throw Exception('Invalid usuario format');
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$accion usuario'),
          // Cambiado de 'usuario' a 'estudiante'
          content: SingleChildScrollView(
            // Agregado para evitar desbordamientos
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                  ),
                ),
                TextField(
                  controller: _gradoController,
                  decoration: const InputDecoration(labelText: 'Grado'),
                ),
                TextField(
                  controller: _grupoController,
                  decoration: const InputDecoration(labelText: 'Grupo'),
                ),

                TextField(
                  controller: _correoController,
                  decoration: const InputDecoration(labelText: 'Correo'),
                ),
                TextField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(labelText: 'Telefono'),
                ),
                TextField(
                  controller: _curpController,
                  decoration: const InputDecoration(labelText: 'CURP'),
                ),
                FutureBuilder<List<int>>(
                  future: idsFuture,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<List<int>> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No hay IDs disponibles');
                    } else if (accion == 'Agregar') {
                      return DropdownButtonFormField<int>(
                        value: snapshot.data!.first,
                        items:
                            snapshot.data!
                                .map(
                                  (int id) => DropdownMenuItem<int>(
                                    value: id,
                                    child: Text('ID: $id'),
                                  ),
                                )
                                .toList(),
                        onChanged: (int? newValue) {
                          _usuarioController.text = newValue.toString();
                        },
                        decoration: const InputDecoration(
                          labelText: 'Usuario ID',
                        ),
                      );
                    } else {
                      return DropdownButtonFormField<int>(
                        value: snapshot.data!.first,
                        items:
                            snapshot.data!
                                .map(
                                  (int id) => DropdownMenuItem<int>(
                                    value: id,
                                    child: Text('ID: $id'),
                                  ),
                                )
                                .toList(),
                        onChanged: (int? newValue) {
                          _usuarioController.text = newValue.toString();
                        },
                        decoration: const InputDecoration(
                          labelText: 'Usuario ID',
                        ),
                      );
                    }
                  },
                ),
                TextField(
                  controller: _promedioController,
                  decoration: const InputDecoration(labelText: 'Promedio'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                //await _crearUsuario(); // Llamar al método para crear el usuario
                final List<int> usuariosExistentes =
                    await usuariosExitentesFuture;
                final List<int> idsEstudiantes = await idsEstudiantesFuture;
                if (_usuarioController.text.isNotEmpty &&
                    int.tryParse(_usuarioController.text) != null &&
                    usuariosExistentes.contains(
                      int.parse(_usuarioController.text),
                    ) &&
                    !(idsEstudiantes.contains(
                      estudiante is List ? estudiante[0] : estudiante,
                    ))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'El usuario ya está registrado como estudiante',
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                } else if (usuariosExistentes.contains(
                      int.tryParse(_usuarioController.text) ?? -1,
                    ) &&
                    (idsEstudiantes.contains(estudiante[0]))) {
                  if (accion == 'Agregar') {
                    await _estudiantesService.crearEstudiante(
                      context,
                      _nombreController.text.isNotEmpty
                          ? _nombreController.text
                          : 'Nombre no proporcionado',
                      _gradoController.text.isNotEmpty
                          ? _gradoController.text
                          : 'Grado no proporcionado',
                      _grupoController.text.isNotEmpty
                          ? _grupoController.text
                          : 'Grupo no proporcionado',
                      _correoController.text.isNotEmpty
                          ? _correoController.text
                          : 'Correo no proporcionado',
                      _telefonoController.text.isNotEmpty
                          ? _telefonoController.text
                          : 'Teléfono no proporcionado',
                      _curpController.text.isNotEmpty
                          ? _curpController.text
                          : 'CURP no proporcionado',
                      _usuarioController.text.isNotEmpty
                          ? _usuarioController.text
                          : 'Usuario no proporcionado',
                      _promedioController.text.isNotEmpty
                          ? _promedioController.text
                          : 'Promedio no proporcionado',
                      // Agregado par el icono;
                      // Agregado para el icono
                      // Add the missing argument (e.g., a new TextEditingController)
                    ); // Llamar al método para crear estudiante
                    setState(() {});
                  } else {
                    await _estudiantesService.editarEstudiante(
                      context,
                      estudiante[0],
                      _nombreController.text.isNotEmpty
                          ? _nombreController.text
                          : 'Nombre no proporcionado',
                      _gradoController.text.isNotEmpty
                          ? _gradoController.text
                          : 'Grado no proporcionado',
                      _grupoController.text.isNotEmpty
                          ? _grupoController.text
                          : 'Grupo no proporcionado',
                      _correoController.text.isNotEmpty
                          ? _correoController.text
                          : 'Correo no proporcionado',
                      _telefonoController.text.isNotEmpty
                          ? _telefonoController.text
                          : 'Teléfono no proporcionado',
                      _curpController.text.isNotEmpty
                          ? _curpController.text
                          : 'CURP no proporcionado',
                      _usuarioController.text.isNotEmpty
                          ? _usuarioController.text
                          : 'Usuario no proporcionado',
                      _promedioController.text.isNotEmpty
                          ? _promedioController.text
                          : 'Promedio no proporcionado',

                      // ID del estudiante a editar
                      // Agregado par el icono;
                    );

                    setState(() {});
                  }
                } else if ((idsEstudiantes.contains(
                      estudiante is List ? estudiante[0] : estudiante,
                    )) ||
                    usuariosExitentesFuture == 0) {
                  if (accion == 'Agregar') {
                    await _estudiantesService.crearEstudiante(
                      context,
                      _nombreController.text.isNotEmpty
                          ? _nombreController.text
                          : 'Nombre no proporcionado',
                      _gradoController.text.isNotEmpty
                          ? _gradoController.text
                          : 'Grado no proporcionado',
                      _grupoController.text.isNotEmpty
                          ? _grupoController.text
                          : 'Grupo no proporcionado',
                      _correoController.text.isNotEmpty
                          ? _correoController.text
                          : 'Correo no proporcionado',
                      _telefonoController.text.isNotEmpty
                          ? _telefonoController.text
                          : 'Teléfono no proporcionado',
                      _curpController.text.isNotEmpty
                          ? _curpController.text
                          : 'CURP no proporcionado',
                      _usuarioController.text.isNotEmpty
                          ? _usuarioController.text
                          : 'Usuario no proporcionado',
                      _promedioController.text.isNotEmpty
                          ? _promedioController.text
                          : 'Promedio no proporcionado',
                      // Agregado par el icono;
                      // Agregado para el icono
                      // Add the missing argument (e.g., a new TextEditingController)
                    ); // Llamar al método para crear estudiante
                    setState(() {});
                    print('Estudiante creado correctamente: ');
                  } else {
                    await _estudiantesService.editarEstudiante(
                      context,
                      estudiante[0],
                      _nombreController.text.isNotEmpty ? _nombreController.text : 'Nombre no proporcionado',
                        _gradoController.text.isNotEmpty ? _gradoController.text : 'Grado no proporcionado',
                        _grupoController.text.isNotEmpty ? _grupoController.text : 'Grupo no proporcionado',
                        _correoController.text.isNotEmpty ? _correoController.text : 'Correo no proporcionado',
                        _telefonoController.text.isNotEmpty ? _telefonoController.text : 'Teléfono no proporcionado',
                        _curpController.text.isNotEmpty ? _curpController.text : 'CURP no proporcionado',
                        _usuarioController.text.isNotEmpty ? _usuarioController.text : 'Usuario no proporcionado',
                        _promedioController.text.isNotEmpty ? _promedioController.text : 'Promedio no proporcionado',
                      // ID del estudiante a editar
                      // Agregado par el icono;
                    );
                    setState(() {});
                  }
                } else if (accion == 'Agregar') {
                  await _estudiantesService.crearEstudiante(
                    context,
                    _nombreController.text.isNotEmpty ? _nombreController.text : 'Nombre no proporcionado',
                        _gradoController.text.isNotEmpty ? _gradoController.text : 'Grado no proporcionado',
                        _grupoController.text.isNotEmpty ? _grupoController.text : 'Grupo no proporcionado',
                        _correoController.text.isNotEmpty ? _correoController.text : 'Correo no proporcionado',
                        _telefonoController.text.isNotEmpty ? _telefonoController.text : 'Teléfono no proporcionado',
                        _curpController.text.isNotEmpty ? _curpController.text : 'CURP no proporcionado',
                        _usuarioController.text.isNotEmpty ? _usuarioController.text : 'Usuario no proporcionado',
                        _promedioController.text.isNotEmpty ? _promedioController.text : 'Promedio no proporcionado',
                  ); // Llamar al método para crear estudiante
                  setState(() {});
                  print('Estudiante creado correctamente');
                } else {
                  await _estudiantesService.editarEstudiante(
                    context,
                    estudiante[0],
                    _nombreController.text.isNotEmpty ? _nombreController.text : 'Nombre no proporcionado',
                        _gradoController.text.isNotEmpty ? _gradoController.text : 'Grado no proporcionado',
                        _grupoController.text.isNotEmpty ? _grupoController.text : 'Grupo no proporcionado',
                        _correoController.text.isNotEmpty ? _correoController.text : 'Correo no proporcionado',
                        _telefonoController.text.isNotEmpty ? _telefonoController.text : 'Teléfono no proporcionado',
                        _curpController.text.isNotEmpty ? _curpController.text : 'CURP no proporcionado',
                        _usuarioController.text.isNotEmpty ? _usuarioController.text : 'Usuario no proporcionado',
                        _promedioController.text.isNotEmpty ? _promedioController.text : 'Promedio no proporcionado',
                    // ID del estudiante a editar
                    // Agregado par el icono;
                  );
                  setState(() {});
                }
              },
              child: const Text('Aceptar'),
            ), //textButton
          ],
        );
      },
    );
  }

  //dialogo que se abrera al presionar el boton de editar

  void _eliminar(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar estudiante'),
          content: const Text('¿Estás seguro de eliminar este estudiante?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar el diálogo
                await _eliminarEstudiante(id); // Llamar al método para eliminar
                setState(() {}); // Refrescar la tabla después de eliminar
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminarEstudiante(int id) async {
    final url = Uri.parse(
      'http://192.168.0.44:8080/v1/estudiantes/eliminar/$id',
    );
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Estudiante eliminado correctamente');
      setState(() {});
    } else {
      print('Error al eliminar el Estudiante: ${response.statusCode}');
      throw Exception('Error al eliminar el estudiante');
    }
  }
}
