import 'package:flutter/material.dart';
import 'package:gestion_escolar/Service/login&profile_service.dart';
import 'package:gestion_escolar/widgets/snackbar.dart';
import 'package:gestion_escolar/widgets/textfield.dart';
import 'dart:convert';

//codigo escrito por ALexis GArcia Perez
// ignore: prefer_typing_uninitialized_variables
Map<String, dynamic> datos = {};
Map<String, dynamic> datos2 = {};

class Profile extends StatefulWidget {
  const Profile({super.key});

  void guardar(dynamic data) {
    datos = data;
    datos2 = jsonDecode(jsonEncode(datos)); // Copia profunda
  }

  bool validar() {
    return datos.isEmpty;
  }

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginProfileService profileService = LoginProfileService();
  final snack = Snackbarll();
  @override
  Widget build(BuildContext context) {
    _nameController.text = datos['nombre'];
    _emailController.text = datos['correo'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(141, 0, 0, 0),
        title: const Text('Perfil', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: SingleChildScrollView(
          // Agregado para permitir el desplazamiento
          child: Center(
            child: Column(
              children: [
                Text(
                  'Edita tu perfil',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Textfield(
                  icon: Icons.person_outline_rounded,
                  placeholder: 'Nombre',
                  textController: _nameController,
                ),
                const SizedBox(height: 20),
                Textfield(
                  icon: Icons.email_outlined,
                  placeholder: 'Correo',
                  textController: _emailController,
                ),
                const SizedBox(height: 20),
                Textfield(
                  icon: Icons.lock_outline,
                  placeholder: 'Contraseña',
                  textController: _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isEmpty) {
                      snack.mostrarSnackBar( 'El nombre no puede estar vacío', context);
                      return;
                    }
                    if (RegExp( r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',).hasMatch(_emailController.text) ==false) {
                      snack.mostrarSnackBar('Email invalido', context);
                      return;
                    }
                    datos['nombre'] = _nameController.text;
                    datos['correo'] = _emailController.text;
                    datos['contrasena'] = _passwordController.text;
                    if (datos['nombre'] == datos2['nombre'] &&
                        datos['correo'] == datos2['correo'] &&
                        _passwordController.text.isEmpty) {
                      snack.mostrarSnackBar('No se modificó nada', context);
                    } else if (datos['contrasena'] == datos2['contrasena']) {
                      snack.mostrarSnackBar('No se puede asignar la misma contraseña', context);
                    } else if(_passwordController.text.length<6){
                      snack.mostrarSnackBar('Por favor, la contraseña no puede ser menor a 6 caracteres', context);
                    }else {
                      profileService.editarUsuario(datos, context);
                    }
                  },
                  child: const Text('Guardar'),
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
