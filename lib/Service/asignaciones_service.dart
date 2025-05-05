import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_escolar/widgets/snackbar.dart';
import 'package:http/http.dart' as http;

//Codigo escrito por Alexis Garcia Perez
class AsignacionesService extends ChangeNotifier {
  final snack = Snackbarll();
  Future<List<List<dynamic>>> fetchAsignaciones() async {
    final url = Uri.parse('http://192.168.0.44:8080/v1/asignaciones/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      //  print('Datos recibidos: $data'); // Depuración
      // Convierte los datos en una lista de listas
      return data.map<List<dynamic>>((asignaciones) {
        return [
          asignaciones['id'], // Asegúrate de que estas claves coincidan con las de tu API
          asignaciones['titulo'],
          asignaciones['descripcion'],
        ];
      }).toList();
    } else {
      // ignore: avoid_print
      print('Error al obtener las asignaciones: ${response.statusCode}');
      throw Exception('Error al obtener los usuarios');
    }
  }

  Future<bool> eliminarAsignacion(int id) async {
    final url = Uri.parse(
      'http://192.168.0.44:8080/v1/asignaciones/eliminar/$id',
    );
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print('object');
      return false;
    }
  }

  Future<void> crearAsignacion(
    context,
    tituloContorller,
    descripcionController,
  ) async {
    final url = Uri.parse('http://192.168.0.44:8080/v1/asignacion/crear');
    final Map<String, dynamic> requestBody = {
      "id": 0, // El ID puede ser 0 si el servidor lo genera automáticamente
      "titulo": tituloContorller.text,
      "descripcion": descripcionController.text,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.of(context).pop(); // Cerrar el diálogo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Asignacion creado'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fallo al crear asignacion'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> editarAsignacion(
    BuildContext context,
    TextEditingController tituloController,
    TextEditingController descipcioncontroller,
    int id,
  ) async {
    if (tituloController.text.isEmpty || descipcioncontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final url = Uri.parse('http://192.168.0.44:8080/v1/asignacion/editar/$id');
    final Map<String, dynamic> requestBody = {
      "titulo": tituloController.text,
      "descripcion": descipcioncontroller.text,
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Asignacion modificado'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fallo al editar la asignación'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
