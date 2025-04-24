import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para manejar JSON

class EstudiantesService extends ChangeNotifier {
  Future<void> crearEstudiante(
    context,
    _nombreController,
    _gradoController,
    _grupoController,
    _correoController,
    _telefonoController,
    _curpController,
    _usuarioController,
    _promedioController,
  ) async {
    final url = Uri.parse('http://192.168.1.70:8080/v1/Estudiantes/crear');
    final Map<String, dynamic> requestBody = {
      "id": 0, // El ID puede ser 0 si el servidor lo genera automáticamente
      "nombre": _nombreController,
      "grado": _gradoController.text,
      "grupo": _grupoController.text,
      "correo": _correoController.text,
      "telefono": _telefonoController.text,
      "curp": _curpController.text,
      "usuario": _usuarioController.text,
      "promedio": double.tryParse(_promedioController.text) ?? 0.0,
      "icono": "", // Puedes agregar un valor para el icono si es necesario
      
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
          content: Text('Estudiante creado'),
          duration: Duration(seconds: 3),
        ),
      );
      notifyListeners(); // Notificar a los listeners si es necesario
    } else {
      print('Error al crear el estudiante: ${response.statusCode}');
      throw Exception('Error al crear el nuevo estudiante');
    }
  }

  Future<List<List<dynamic>>> fetchEstudiantes() async {
    final url = Uri.parse(
      'http://192.168.1.70:8080/v1/estudiantes/obtenerEstudiantes',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Datos recibidos: $data'); // Depuración
      // Convierte los datos en una lista de listas
      return data.map<List<dynamic>>((estudiante) {
        return [
          estudiante['id'], // Asegúrate de que estas claves coincidan con las de tu API
          estudiante['nombre'],
          estudiante['grado'],
          estudiante['grupo'],
          estudiante['correo'],
          estudiante['telefono'],
          estudiante['curp'],
          estudiante['usuario'],
          estudiante['promedio'],
        ];
      }).toList();
    } else {
      print('Error al obtener los estudiantes: ${response.statusCode}');
      throw Exception('Error al obtener los estudiantes');
    }
  }
  
  Future<List<int>> usuarioExintes() async {
    final usuarios = await fetchEstudiantes();
    return usuarios.map<int>((usuario) => usuario[7] as int).toList();
  }


  Future<void> editarEstudiante(
    BuildContext context,
    int id,
    _nombreController,
    _gradoController,
    _grupoController,
    _correoController,
    _telefonoController,
    _curpController,
    _usuarioController,
    _promedioController,
  ) async {
    /*f (_nombreController.text.isEmpty ||
      _gradoController.text.isEmpty ||
      _grupoController.text.isEmpty ||
      _correoController.text.isEmpty ||
      _telefonoController.text.isEmpty ||
      _curpController.text.isEmpty ||
      _usuarioController.text.isEmpty ||
      _promedioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Por favor, completa todos los campos'),
        duration: Duration(seconds: 3),
      ),
      );
      return;
    }*/

   final url = Uri.parse('http://192.168.1.70:8080/v1/estudiantes/editar/$id');
    final Map<String, dynamic> requestBody = {
      "id": id, // Asegúrate de que el ID sea correcto
      "nombre": _nombreController.trim(),
      "grado": _gradoController.text,
      "grupo": _grupoController.text,
      "correo": _correoController.text,
      "telefono": _telefonoController.text,
      "curp": _curpController.text,
      "usuario": _usuarioController.text,
      "promedio": double.tryParse(_promedioController.text) ?? 0.0,
      "icono": "", // Puedes agregar un valor para el icono si es necesario
    };
    print(_usuarioController.text + " aqui");

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
            content: Text('Estudiante modificado'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fallo al editar el estudiante'),
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
   Future<List<int>> fetchEstudiantesIds() async {
    final usuarios = await fetchEstudiantes();
    return usuarios.map<int>((usuario) => usuario[0] as int).toList();
  }
  
}
