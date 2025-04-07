import 'package:flutter/material.dart';
//Codigo escrito por Alexis Garcia Perez
class Menu extends StatefulWidget {
  
  const Menu({
    super.key,
    required this.ruta,
    });
    final String ruta;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
    String get rutas1 => widget.ruta;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 130,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(141, 0, 0, 0)),
              child: Text('Menú', style: TextStyle(fontSize: 30),),
            ),
          ),
          ListTile(
            tileColor: widget.ruta == 'asignaciones' ? const Color.fromARGB(255, 107, 107, 107) : null,
            //toma de desicion cuando se esta en la ruta de asignaciones de que no se pueda acceder a la misma por medio del menu
            title: widget.ruta == 'asignaciones' ? Text('Asignaciones', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), ),) : const Text('Asignaciones'),
            onTap: () {
              if (widget.ruta != 'asignaciones') {
                Navigator.pushReplacementNamed(context, 'asignaciones');
              }
            },
          ),
          ListTile(
            tileColor: widget.ruta == 'calificaciones' ? const Color.fromARGB(255, 107, 107, 107) : null,
            title: widget.ruta == 'calificaciones' ? Text('Calificaciones', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), ),) : const Text('Calificaciones'),
            onTap: () {
              if (widget.ruta != 'calificaciones') {
                Navigator.pushReplacementNamed(context, 'calificaciones');
              }
            },
          ),
          ListTile(
            tileColor: widget.ruta == 'estudiantes' ? const Color.fromARGB(255, 107, 107, 107) : null,
            title: widget.ruta == 'estudiantes' ? Text('Estudiantes', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), ),) : const Text('Estudiantes'),
            onTap: () {
              if (widget.ruta!= 'estudiantes') {
                Navigator.pushReplacementNamed(context, 'estudiantes');
              }
            },
          ),
          ListTile(
            tileColor: widget.ruta == 'dashboard' ? const Color.fromARGB(255, 107, 107, 107) : null,
            //toma de desicion cuando se esta en la ruta de dashboar de que no se pueda acceder a la misma por medio del menu
            title: widget.ruta == 'dashboard' ? Text('Dashboard', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), ),) : const Text('Dashboard'),
            onTap: () {
              if (widget.ruta != 'dashboard') {
                Navigator.pushReplacementNamed(context, 'dashboard');
              }
            },
          ),
          ListTile(
            tileColor: widget.ruta == 'informes' ? const Color.fromARGB(255, 107, 107, 107) : null,
            title: widget.ruta == 'informes' ? Text('Informes', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), ),) : const Text('Informes'),
            onTap: () {
              if (widget.ruta != 'informes') {
                Navigator.pushReplacementNamed(context, 'informes');
              }
            },
          ),
          ListTile(
            tileColor: widget.ruta == 'usuarios' ? const Color.fromARGB(255, 107, 107, 107) : null,
            title: widget.ruta == 'usuarios' ? Text('Usuarios', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), ),) : const Text('Usuarios'),
            onTap: () {
              if (widget.ruta != 'usuarios') {
                Navigator.pushReplacementNamed(context, 'usuarios');
              }
            },
          ),
        ],
      ),
    );
  }
}
