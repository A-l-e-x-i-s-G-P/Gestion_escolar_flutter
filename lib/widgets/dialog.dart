import 'package:flutter/material.dart';
import 'package:gestion_escolar/pages/profile.dart';
//Codigo escrito por Alexis Garcia Perez
class ShowDialog extends StatelessWidget {
  const ShowDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.person),
      color: Colors.white,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          const Color.fromARGB(103, 33, 149, 243),
        ),
        elevation: WidgetStateProperty.all(4),
        shadowColor: WidgetStateProperty.all(
          const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Perfil'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: const Text('Ver perfil'),
                    onTap: () {
                      Profile profile = Profile();
                      if (profile.validar()) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          'login',
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, 'profile');
                      }
                    },
                  ),
                  ListTile(
                    title: const Text('Cerrar sesión'),
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        'login',
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Cancelar'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
