import 'package:flutter/material.dart';
import 'package:gestion_escolar/Service/usuario_service.dart';
import 'package:gestion_escolar/widgets/dialog.dart';
import 'package:gestion_escolar/widgets/menu.dart';
import 'package:gestion_escolar/widgets/snackbar.dart';

//codigo escritopor Alexis Gaecia Perez
class Usuarios extends StatefulWidget {
  const Usuarios({super.key});

  @override
  State<Usuarios> createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  String? seleccion; // Valor seleccionado
  final String rutas = 'usuarios';
  final usuarioService = UsuarioService();
  final snack = Snackbarll();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(141, 0, 0, 0),
        title: const Text('Usuarios', style: TextStyle(color: Colors.white)),
        actions: <Widget>[ShowDialog()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Lista de usuarios', style: TextStyle(fontSize: 30)),
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
            Expanded(
              child:
                  _tablaUsuarios(), // Asegúrate de que _tablaUsuarios devuelva un widget que pueda expandirse
            ),
          ],
        ),
      ),
      drawer: Menu(ruta: rutas),
    );
  }

  //dialogo que se abrera al presionar el boton de agregar o editar
  void _showDialog(String accion, usuario) {
    if (accion == 'Agregar') {
      _nombreController.clear();
      _contrasenaController.clear();
      _correoController.clear();
      seleccion = '1';
    } else if (usuario != null) {
      _nombreController.text = usuario[1];
      _correoController.text = usuario[2];
      seleccion = usuario[3].toString();
      _contrasenaController.clear();
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$accion usuario'),
          content: SingleChildScrollView(
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
                  controller: _correoController,
                  decoration: const InputDecoration(labelText: 'Correo'),
                ),
                TextField(
                  controller: _contrasenaController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true, // Ocultar texto para contraseñas
                ),
                _listaGrupos(),
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
                if (_correoController.text.isEmpty ||
                    _nombreController.text.isEmpty) {
                  snack.mostrarSnackBar( 'Por favor, no deje ningun campo vacio',context, );
                } else if (!RegExp(
                  r'^[^@]+@[^@]+\.[^@]+',
                ).hasMatch(_correoController.text)) {
                  snack.mostrarSnackBar('Por favor, ingresa un correo válido', context);
                } else {
                  if (accion == 'Agregar') {
                    if (_contrasenaController.text.isEmpty ||
                        _contrasenaController.text.length < 6) {
                      snack.mostrarSnackBar(
                        'Por favor, la contraseña debe de ser de minimo 6 caracteres',
                        context,
                      );
                    } else {
                      await usuarioService.crearUsuario(
                        context,
                        _nombreController,
                        _correoController,
                        _contrasenaController,
                        seleccion,
                      ); // Llamar al método para crear usuario
                      setState(() {});
                    }
                  } else {
                    if (_nombreController.text == usuario[1] &&
                        _correoController.text == usuario[2] &&
                        _contrasenaController.text.isEmpty) {
                      snack.mostrarSnackBar('No se modificó nada', context);
                    } else if (_contrasenaController.text.length < 6 && _contrasenaController.text.isNotEmpty) {
                      snack.mostrarSnackBar(
                        'Por favor, la contraseña debe de ser minimo de 6 caracteres',
                        context,
                      );
                    } else {
                      await usuarioService.editarUsuario(
                        context,
                        _nombreController,
                        _correoController,
                        _contrasenaController,
                        seleccion,
                        usuario[0],
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

  Widget _listaGrupos() {
    final grupos = [1, 2, 3]; // Lista de grupos

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return DropdownButton<String>(
          value:
              seleccion, // Asegúrate de que este valor coincida con los valores de la lista
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          underline: Container(height: 2, color: Colors.deepPurpleAccent),
          onChanged: (String? newValue) {
            setState(() {
              seleccion = newValue; // Actualiza el valor seleccionado
            });
          },
          items:
              grupos.map<DropdownMenuItem<String>>((int value) {
                return DropdownMenuItem<String>(
                  value: value.toString(), // Convertir a String
                  child: Text('Grupo $value'), // Etiqueta del grupo
                );
              }).toList(),
        );
      },
    );
  }

  Widget _tablaUsuarios() {
    return FutureBuilder<List<List<dynamic>>>(
      future: usuarioService.fetchUsuarios(),
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
          return const Center(child: Text('No hay usuarios disponibles'));
        } else {
          final usuarios = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortAscending: true,
                columnSpacing: 15,
                columns: const [
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text("Nombre")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("Acciones")),
                ],
                rows:
                    usuarios.map((usuario) {
                      return DataRow(
                        cells: [
                          DataCell(Text(usuario[0].toString())), // ID
                          DataCell(Text(usuario[1].toString())), // Nombre
                          DataCell(Text(usuario[2].toString())), // Email
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
          title: const Text('Eliminar usuario'),
          content: const Text('¿Estás seguro de eliminar este usuario?'),
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
                await usuarioService.eliminarUsuario(
                  id,
                  context,
                ); // Llamar al método para eliminar
                if (mounted) {
                  setState(() {}); // Refrescar la tabla después de eliminar
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
