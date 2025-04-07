import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para manejar JSON

class RegisterService extends ChangeNotifier {
  Future<void> crearCuenta(
    context,
    _nombreController,
    _grupoFkController,
    _correoController,
  ) async {
    final url = Uri.parse('http://192.168.0.44:8080/v1/Usuarios/crear');
    final Map<String, dynamic> requestBody = {
      "id": 0, // El ID puede ser 0 si el servidor lo genera automáticamente
      "nombre": _nombreController,
      "correo": _correoController.text,
      "grupo": _grupoFkController.text,
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
          content: Text('Cuenta creada con éxito'),
          duration: Duration(seconds: 3),
        ),
      );
      notifyListeners(); // Notificar a los listeners si es necesario
    } else {
      print('Error al crear cuenta: ${response.statusCode}');
      throw Exception('Error al crear cuenta: ${response.statusCode}');
    }
  }

}
