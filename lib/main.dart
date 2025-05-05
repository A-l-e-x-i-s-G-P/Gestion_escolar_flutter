import 'package:flutter/material.dart';
import 'package:gestion_escolar/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Escolar',
      debugShowCheckedModeBanner: false,
      initialRoute: 'dashboard',
      routes: appRoutes,
    );

  }
}