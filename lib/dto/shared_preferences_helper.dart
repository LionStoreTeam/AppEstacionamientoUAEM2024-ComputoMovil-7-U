import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> loadSavedData(
      TextEditingController nombrePropietario,
      TextEditingController modeloDelCarroMoto,
      TextEditingController placasDelCarroMoto,
      TextEditingController colorDelCarroMoto,
      TextEditingController telefonoController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nombrePropietario.text = prefs.getString('nombrePropietario') ?? '';
    modeloDelCarroMoto.text = prefs.getString('modeloCarroMoto') ?? '';
    placasDelCarroMoto.text = prefs.getString('placasCarroMoto') ?? '';
    colorDelCarroMoto.text = prefs.getString('colorCarroMoto') ?? '';
    telefonoController.text = prefs.getString('telefono') ?? '';
  }

  static Future<void> saveData(
      TextEditingController nombrePropietario,
      TextEditingController modeloDelCarroMoto,
      TextEditingController placasDelCarroMoto,
      TextEditingController colorDelCarroMoto,
      TextEditingController telefonoController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nombrePropietario', nombrePropietario.text);
    prefs.setString('modeloCarroMoto', modeloDelCarroMoto.text);
    prefs.setString('placasCarroMoto', placasDelCarroMoto.text);
    prefs.setString('colorCarroMoto', colorDelCarroMoto.text);
    prefs.setString('telefono', telefonoController.text);
  }

  static Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('nombrePropietario');
    prefs.remove('modeloCarroMoto');
    prefs.remove('placasCarroMoto');
    prefs.remove('colorCarroMoto');
    prefs.remove('telefono');
  }
}
