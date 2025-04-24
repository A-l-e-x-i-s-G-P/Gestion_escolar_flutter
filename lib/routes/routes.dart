//archivo para configurar las rutas del proyecto
import 'package:flutter/material.dart';
import 'package:gestion_escolar/pages/asignacion_estudiante.dart';
import 'package:gestion_escolar/pages/dashboard.dart';
import 'package:gestion_escolar/pages/login.dart';
import 'package:gestion_escolar/pages/estudiantes.dart'; 
import 'package:gestion_escolar/pages/calificaciones.dart';
import 'package:gestion_escolar/pages/asignaciones.dart';
import 'package:gestion_escolar/pages/informes.dart';
import 'package:gestion_escolar/pages/profile.dart';
import 'package:gestion_escolar/pages/usuarios.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'login': ( context) => const Login(),
  'dashboard': ( context) => const Dashboard(),
  'estudiantes': (context) => const Estudiantes(),
  'calificaciones': ( context) => const Calificaciones(),
  'asignaciones': ( context) => const Asignaciones(),
  'informes': ( context) => const Informes(),
  'usuarios': ( context) => const Usuarios(),
  'profile': ( context) => const Profile(),
  'asignacionEstudiante': (context) => AsignacionEstudiante(),
};
