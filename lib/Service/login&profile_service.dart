// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_escolar/widgets/snackbar.dart';
import 'package:http/http.dart' as http;
//Codigo escrito por Alexis Garcia Perez
class LoginProfileService extends ChangeNotifier {
  final snack = Snackbarll();
  Future<Map<String, dynamic>> loginUsuario(
    String correoController,
    String contrasenaController,
  ) async {
    final url = Uri.parse('http://192.168.0.44:8080/user/login/');
    final Map<String, dynamic> requestBody = {
      "correo": correoController,
      "contrasena": contrasenaController,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data; // Return the user object directly
    } else {
      return {}; // Return an empty map instead of null
    }
  }

  Future<void> editarUsuario(data, context) async {
    String nombre = data['nombre'];
    String correo = data['correo'];
    int seleccion = data['grupoFK'];
    String contrasena = data['contrasena'];
    int id = data['id'];

    final url = Uri.parse('http://192.168.0.44:8080/v1/usuarios/editar/$id');
    final Map<String, dynamic> requestBody = {
      "nombre": nombre,
      "correo": correo,
      "contrasena": contrasena,
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
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
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
}
