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
      title: 'My App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'dashboard',
      routes: appRoutes,
    );
    //https://prod.liveshare.vsengsaas.visualstudio.com/join?012416219D458AF12245981C86B8A50E40BF
  }
}