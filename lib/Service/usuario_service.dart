import 'package:flutter/material.dart';
import 'package:gestion_escolar/widgets/snackbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para manejar JSON

//Codigo escrito por Alexis Garcia Perez
class UsuarioService extends ChangeNotifier {
  final snack = Snackbarll();
  Future<List<List<dynamic>>> fetchUsuarios() async {
    final url = Uri.parse('http://192.168.0.44:8080/v1/usuarios/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      //  print('Datos recibidos: $data'); // Depuración
      // Convierte los datos en una lista de listas
      return data.map<List<dynamic>>((usuario) {
        return [
          usuario['id'], // Asegúrate de que estas claves coincidan con las de tu API
          usuario['nombre'],
          usuario['correo'],
          usuario['grupoFK'],
        ];
      }).toList();
    } else {
      // ignore: avoid_print
      print('Error al obtener los usuarios: ${response.statusCode}');
      throw Exception('Error al obtener los usuarios');
    }
  }

  Future<void> crearUsuario(
    context,
    nombreController,
    correoController,
    contrasenaController,
    seleccion,
  ) async {
    if (nombreController.text.isEmpty ||
        correoController.text.isEmpty ||
        contrasenaController.text.isEmpty ||
        seleccion == null) {
      snack.mostrarSnackBar('Por favor, completa todos los campos', context);
      return;
    }
    final url = Uri.parse('http://192.168.0.44:8080/v1/Usuarios/crear');
    final Map<String, dynamic> requestBody = {
      "id": 0, // El ID puede ser 0 si el servidor lo genera automáticamente
      "nombre": nombreController.text,
      "correo": correoController.text,
      "contrasena": contrasenaController.text,
      "grupoFK": int.parse(seleccion!),
      "icono": "", // Puedes agregar un valor para el icono si es necesario
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.of(context).pop(); // Cerrar el diálogo
      snack.mostrarSnackBar('Usuario creado', context);
    } else {
      snack.mostrarSnackBar('Fallo al crear usuario', context);
    }
  }

  Future<void> editarUsuario(
    BuildContext context,
    TextEditingController nombreController,
    TextEditingController correoController,
    TextEditingController contrasenaController,
    String? seleccion,
    int id,
  ) async {
    if (nombreController.text.isEmpty ||
        correoController.text.isEmpty ||
        seleccion == null) {
      snack.mostrarSnackBar('Por favor, completa todos los campos', context);
      return;
    }

    final url = Uri.parse('http://192.168.0.44:8080/v1/usuarios/editar/$id');
    final Map<String, dynamic> requestBody = {
      "nombre": nombreController.text,
      "correo": correoController.text,
      "contrasena": contrasenaController.text,
      "grupoFK": seleccion,
    };

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Close the dialog
        }
        // ignore: use_build_context_synchronously
        snack.mostrarSnackBar('Usuario modificado', context);
      } else {
        // ignore: use_build_context_synchronously
        snack.mostrarSnackBar('Fallo al editar el usuario', context);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      snack.mostrarSnackBar('Error: ${e.toString()}', context);
    }
  }

  Future<void> eliminarUsuario(int id, BuildContext context) async {
    final url = Uri.parse('http://192.168.0.44:8080/v1/usuarios/eliminar/$id');

    try {
      final response = await http.delete(url);

      if (!context.mounted) return; // Ensure the widget is still mounted

      if (response.statusCode == 200 || response.statusCode == 201) {
        snack.mostrarSnackBar('Usuario eliminado correctamente', context);
      } else {
        snack.mostrarSnackBar('Usuario no eliminado', context);
      }
    } catch (e) {
      if (context.mounted) {
        snack.mostrarSnackBar('Error: ${e.toString()}', context);
      }
    }
  }

  Future<List<int>> fetchUsuarioIds() async {
    final usuarios = await fetchUsuarios();
    final ids = usuarios.map<int>((usuario) => usuario[0] as int).toList();
    ids.add(0); // Agrega un 0 al arreglo
    return ids;
  }
}
