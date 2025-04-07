import 'package:flutter/material.dart';
import 'package:gestion_escolar/Service/login&profile_service.dart';
import 'package:gestion_escolar/pages/profile.dart';
import 'package:gestion_escolar/widgets/snackbar.dart';
import 'package:gestion_escolar/widgets/textfield.dart';
//Codigo escrito por Alexis Garcia Perez
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginProfileService loginService = LoginProfileService();
  final snack = Snackbarll();
  void _login() async {
    final email = emailController.text;
    final password = passwordController.text;
    final data = await loginService.loginUsuario(
      emailController.text,
      passwordController.text,
    );

    // Add your login logic here
    if (email.isNotEmpty && password.isNotEmpty) {
      //validar que el correo se de tipo email con expresiones regulares
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        // ignore: use_build_context_synchronously
        snack.mostrarSnackBar('Por favor ingresa un correo válido', context);
        return;
      } else if (data.isNotEmpty) {
        // ignore: use_build_context_synchronously
        snack.mostrarSnackBar('Se inicio sesion como $email', context);
        data['contrasena'] = password;
        //se llamara la clase profile de profile.dart con su metodo guardar(data)
        Profile profile = Profile();
        profile.guardar(data);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, 'dashboard');
      } else {
        // ignore: use_build_context_synchronously
        snack.mostrarSnackBar('Sesion incorrecta', context);
      }
    } else {
      // ignore: use_build_context_synchronously
      snack.mostrarSnackBar('Por favor llena los campos', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            //sombra un poco mas oscura
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: const Color.fromARGB(
                  255,
                  204,
                  204,
                  204,
                  // ignore: deprecated_member_use
                ).withOpacity(0.5),
                spreadRadius: 10,
                blurRadius: 13,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: Colors.black, width: 7),

            borderRadius: BorderRadius.circular(10),
          ),

          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Iniciar sesión',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Textfield(
                icon: Icons.alternate_email_sharp,
                placeholder: 'Email',
                textController: emailController,
                isPassword: false,
              ),
              //contraseña
              Textfield(
                icon: Icons.lock_outline,
                placeholder: 'Contraseña',
                textController: passwordController,
                isPassword: true,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shadowColor: const Color.fromARGB(255, 63, 1, 1),
                  elevation: 5,
                ),
                onPressed: _login,
                child: const Text(
                  'Iniciar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              //Codigo inutil
              //  const SizedBox(height: 20),
              //  Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
              //  children: [
              //    const Text("¿olvidaste tu contraseña?"),
              //  ],
              //  ),
            ],
          ),
        ),
      ),
    );
  }
}
