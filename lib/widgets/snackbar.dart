import 'package:flutter/material.dart';

//Codigo escrito por Alexis Garcia Perez
class Snackbarll {
 
  void mostrarSnackBar(String mensaje, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(mensaje)),
  );
}
  
}
