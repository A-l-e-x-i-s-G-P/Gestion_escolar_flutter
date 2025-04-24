import 'package:gestion_escolar/Service/asignaciones_service.dart';
import 'package:gestion_escolar/widgets/snackbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AsingacionEstudianteService {
  final asignaciones = AsignacionesService();
  final snack = Snackbarll();
  int contador = 0;
  int suma = 0;
  Future<List<dynamic>> obtenerUA(usuarioid) async {
    List asingacionU = [];
    final asignacion = AsignacionesService();
    final datos =
        await asignacion
            .fetchAsignaciones(); // Asegúrate de que esto devuelva un arreglo bidimensional
    final url = Uri.parse('http://192.168.1.70:8080/v1/estudiantes/obtenerFK');
    final response = await http.get(url);
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    // Iterar sobre los datos
    for (int i = 0; i < data.length; i++) {
      if (data[i][0] == usuarioid) {
        // Buscar en 'datos' si el id coincide con data[i][1]
        final matchingDato = datos.firstWhere(
          (dato) =>
              dato[0] ==
              data[i][1], // dato[0] es el id en el arreglo bidimensional
          orElse: () => [],
        );
        // Si hay coincidencia, reemplazar data[i][1] con el título (dato[1])
        if (matchingDato != []) {
          int fk = data[i][1];
          data[i].add(fk);
          data[i][1] =
              matchingDato[1]; // dato[1] es el título en el arreglo bidimensional
          suma = suma + (data[i][2] as int);
        }
        asingacionU.add(data[i]);
        contador++;
      }
    }
    actualizarProm(usuarioid);
    return asingacionU;
  }

  Future<void> crearAsignacion(
    int idUsuario,
    int idAsignacion,
    int califiacion,
    String fecha,
    context,
  ) async {
    final url = Uri.parse(
      'http://192.168.1.70:8080/v1/asignarAsignacionEstudiante/$idAsignacion/$idUsuario/$califiacion/$fecha',
    );
    var response;
    bool asignacionExistente = false;
    //llamar obtenrUA
    final datos = await obtenerUA(idUsuario);
    for (int i = 0; i < datos.length; i++) {
      if (datos[i][4] == idAsignacion) {
        asignacionExistente = true;
      }
    }
    if (asignacionExistente) {
      snack.mostrarSnackBar('Asignación ya existe para el estudiante', context);
    } else {
      response = await http.post(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        snack.mostrarSnackBar('Asignación creada exitosamente', context);
      } else {
        snack.mostrarSnackBar(
          'Error al crear la asignación ${response.statusCode}',
          context,
        );
      }
    }
  }

  Future<bool> eliminarAsignacion(int asignacionFK, int estudianteFK) async {
    final url = Uri.parse(
      'http://192.168.1.70:8080/v1/eliminarAsignacionEstudiantes/$asignacionFK/$estudianteFK',
    );
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error al eliminar la asignación: $e');
      return false;
    }
  }

  Future<void> actualizarProm(usuarioid) async {
    double promedio = suma / contador;
    final urlProm = Uri.parse(
      'http://192.168.1.70:8080/v1/Promedio/editar/$usuarioid',
    );
    final Map<String, dynamic> requestBody = {"promedio": promedio};
    final responseProm = await http.put(
      urlProm,
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );
    if (responseProm.statusCode == 200 || responseProm.statusCode == 201) {
      // ignore: avoid_print
      print('Promedio actualizado exitosamente');
    } else {
      // ignore: avoid_print
      print('Error al actualizar el promedio ${responseProm.statusCode}');
    }
  }

  // Future<bool> editarAsignacion(
  //   int asignacionFK,
  //   int estudianteFK,
  //   int califiacion,
  //   String fecha,
  // ) async {
  //   final url = Uri.parse('http://192.168.1.70:8080/v1/
  // }
}
