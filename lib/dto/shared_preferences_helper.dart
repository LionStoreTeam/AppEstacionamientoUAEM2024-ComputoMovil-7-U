import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Método estático para guardar el tipo de usuario seleccionado
  static Future<void> saveTipoUsuario(String tipoUsuario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tipoUsuario', tipoUsuario);
  }

  // Método estático para cargar el tipo de usuario seleccionado
  static Future<String?> loadTipoUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('tipoUsuario');
  }

  static Future<void> loadSavedData(
      TextEditingController nombrePropietario,
      TextEditingController matriculaDeControl,
      TextEditingController modeloDelCarroMoto,
      TextEditingController placasDelCarroMoto,
      TextEditingController colorDelCarroMoto,
      TextEditingController telefonoController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nombrePropietario.text = prefs.getString('nombrePropietario') ?? '';
    matriculaDeControl.text = prefs.getString('matriculaDeControl') ?? '';
    modeloDelCarroMoto.text = prefs.getString('modeloCarroMoto') ?? '';
    placasDelCarroMoto.text = prefs.getString('placasCarroMoto') ?? '';
    colorDelCarroMoto.text = prefs.getString('colorCarroMoto') ?? '';
    telefonoController.text = prefs.getString('telefono') ?? '';
  }

  static Future<void> saveData(
      TextEditingController nombrePropietario,
      TextEditingController matriculaDeControl,
      TextEditingController modeloDelCarroMoto,
      TextEditingController placasDelCarroMoto,
      TextEditingController colorDelCarroMoto,
      TextEditingController telefonoController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nombrePropietario', nombrePropietario.text);
    prefs.setString('matriculaDeControl', matriculaDeControl.text);
    prefs.setString('modeloCarroMoto', modeloDelCarroMoto.text);
    prefs.setString('placasCarroMoto', placasDelCarroMoto.text);
    prefs.setString('colorCarroMoto', colorDelCarroMoto.text);
    prefs.setString('telefono', telefonoController.text);
  }

  static Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('nombrePropietario');
    prefs.remove('matriculaDeControl');
    prefs.remove('modeloCarroMoto');
    prefs.remove('placasCarroMoto');
    prefs.remove('colorCarroMoto');
    prefs.remove('telefono');
  }
}




// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesHelper {
//   static Future<void> loadSavedData(
//       TextEditingController tipoDeUsuarioAdministrativo,
//       TextEditingController tipoDeUsuarioMaestro,
//       TextEditingController tipoDeUsuarioAlumno,
//       TextEditingController nombrePropietario,
//       TextEditingController modeloDelCarroMoto,
//       TextEditingController placasDelCarroMoto,
//       TextEditingController colorDelCarroMoto,
//       TextEditingController telefonoController) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     tipoDeUsuarioAdministrativo.text =
//         prefs.getString('tipoDeUsuarioAdministrativo') ?? '';
//     tipoDeUsuarioMaestro.text = prefs.getString('tipoDeUsuarioMaestro') ?? '';
//     tipoDeUsuarioAlumno.text = prefs.getString('tipoDeUsuarioAlumno') ?? '';
//     nombrePropietario.text = prefs.getString('nombrePropietario') ?? '';
//     modeloDelCarroMoto.text = prefs.getString('modeloCarroMoto') ?? '';
//     placasDelCarroMoto.text = prefs.getString('placasCarroMoto') ?? '';
//     colorDelCarroMoto.text = prefs.getString('colorCarroMoto') ?? '';
//     telefonoController.text = prefs.getString('telefono') ?? '';
//   }

//   static Future<void> saveData(
//       TextEditingController tipoDeUsuarioAdministrativo,
//       TextEditingController tipoDeUsuarioMaestro,
//       TextEditingController tipoDeUsuarioAlumno,
//       TextEditingController nombrePropietario,
//       TextEditingController modeloDelCarroMoto,
//       TextEditingController placasDelCarroMoto,
//       TextEditingController colorDelCarroMoto,
//       TextEditingController telefonoController) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString(
//         'tipoDeUsuarioAdministrativo', tipoDeUsuarioAdministrativo.text);
//     prefs.setString('tipoDeUsuarioMaestro', tipoDeUsuarioMaestro.text);
//     prefs.setString('tipoDeUsuarioAlumno', tipoDeUsuarioAlumno.text);
//     prefs.setString('nombrePropietario', nombrePropietario.text);
//     prefs.setString('modeloCarroMoto', modeloDelCarroMoto.text);
//     prefs.setString('placasCarroMoto', placasDelCarroMoto.text);
//     prefs.setString('colorCarroMoto', colorDelCarroMoto.text);
//     prefs.setString('telefono', telefonoController.text);
//   }

//   static Future<void> clearData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('nombrePropietario');
//     prefs.remove('modeloCarroMoto');
//     prefs.remove('placasCarroMoto');
//     prefs.remove('colorCarroMoto');
//     prefs.remove('telefono');
//   }
// }