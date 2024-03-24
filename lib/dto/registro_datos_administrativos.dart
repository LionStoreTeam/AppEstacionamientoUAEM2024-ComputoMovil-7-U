// import 'package:firebase_auth/firebase_auth.dart';
import 'package:estacionamiento_uaem/dto/shared_preferences_helper.dart';
import 'package:estacionamiento_uaem/login/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistroDatosAdministrativos extends StatefulWidget {
  const RegistroDatosAdministrativos({Key? key}) : super(key: key);

  @override
  State<RegistroDatosAdministrativos> createState() =>
      _RegistroDatosAdministrativosState();
}

class _RegistroDatosAdministrativosState
    extends State<RegistroDatosAdministrativos> {
  @override
  void initState() {
    super.initState();
    SharedPreferencesHelper.loadSavedData(nombrePropietario, modeloDelCarroMoto,
        placasDelCarroMoto, colorDelCarroMoto, telefonoController);
  }

  // final User? user = FirebaseAuth.instance.currentUser;
  TextEditingController nombrePropietario = TextEditingController();
  TextEditingController modeloDelCarroMoto = TextEditingController();
  // TextEditingController numInteriorController = TextEditingController();
  // TextEditingController codigoPostalController = TextEditingController();
  TextEditingController placasDelCarroMoto = TextEditingController();
  TextEditingController colorDelCarroMoto = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController nombreController =
      TextEditingController(); // nombre registrado con la cuenta
  // TextEditingController correoController = TextEditingController();

  bool isEditing = false;
  bool hasChanges = false; // Nueva variable para rastrear cambios

  // Método para cargar los datos guardados en SharedPreferences
  void loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombrePropietario.text = prefs.getString('nombrePropietario') ?? '';
      modeloDelCarroMoto.text = prefs.getString('modeloCarroMoto') ?? '';
      // numInteriorController.text = prefs.getString('numInterior') ?? '';
      // codigoPostalController.text = prefs.getString('codigoPostal') ?? '';
      placasDelCarroMoto.text = prefs.getString('placasCarroMoto') ?? '';
      colorDelCarroMoto.text = prefs.getString('colorCarroMoto') ?? '';
      telefonoController.text = prefs.getString('telefono') ?? '';
      // nombreController.text = user?.displayName ?? '';
      // correoController.text = user?.email ?? '';
    });
  }

  // Método para validar si los campos son números
  bool isNumeric(String value) {
    if (value.isEmpty) {
      return false;
    }
    return double.tryParse(value) != null;
  }

// // Método para validar el código postal
//   bool isPostalCodeValid(String value) {
//     return value.length == 5 && isNumeric(value);
//   }

  // Método para validar el número de Teléfono
  bool isTelefonoCodeValid(String value) {
    return value.length == 10 && isNumeric(value);
  }

// Método para validar si los campos están vacíos
  bool areFieldsEmpty() {
    return nombrePropietario.text.isEmpty ||
        modeloDelCarroMoto.text.isEmpty ||
        // numInteriorController.text.isEmpty ||
        // !isPostalCodeValid(codigoPostalController.text) ||
        placasDelCarroMoto.text.isEmpty ||
        colorDelCarroMoto.text.isEmpty ||
        !isTelefonoCodeValid(telefonoController.text);
  }

  // Nueva variable para rastrear si todos los campos están vacíos
  bool areAllFieldsEmpty() {
    return nombrePropietario.text.isEmpty &&
        modeloDelCarroMoto.text.isEmpty &&
        // numInteriorController.text.isEmpty &&
        // codigoPostalController.text.isEmpty &&
        placasDelCarroMoto.text.isEmpty &&
        colorDelCarroMoto.text.isEmpty &&
        telefonoController.text.isEmpty;
  }

  // Nueva variable para rastrear si todos los campos están llenos
  bool areAllFieldsNotEmpty() {
    return nombrePropietario.text.isNotEmpty &&
        modeloDelCarroMoto.text.isNotEmpty &&
        // numInteriorController.text.isNotEmpty &&
        // codigoPostalController.text.isNotEmpty &&
        placasDelCarroMoto.text.isNotEmpty &&
        colorDelCarroMoto.text.isNotEmpty &&
        telefonoController.text.isNotEmpty;
  }

  // Método para guardar los datos en SharedPreferences
  void saveData() async {
    // Validar que los campos numéricos solo contengan números
    // if (!isNumeric(numInteriorController.text)) {
    //   Fluttertoast.showToast(
    //     msg: 'El Número Interior solo deben contener números',
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //   );

    //   return;
    // }

    // // Validar el código postal
    // if (!isPostalCodeValid(codigoPostalController.text)) {
    //   Fluttertoast.showToast(
    //     msg: 'El Código postal debe ser de 5 dígitos',
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //   );
    //   return;
    // }

    // Validar que los campos numéricos solo contengan números
    if (!isTelefonoCodeValid(telefonoController.text)) {
      Fluttertoast.showToast(
        msg: 'El Número de Teléfono debe ser de 10 dígitos',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    if (areFieldsEmpty()) {
      Fluttertoast.showToast(
        msg: 'Todos los campos son obligatorios',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    SharedPreferencesHelper.saveData(nombrePropietario, modeloDelCarroMoto,
        placasDelCarroMoto, colorDelCarroMoto, telefonoController);

    // Muestra el Toast al guardar si hay cambios
    if (hasChanges) {
      Fluttertoast.showToast(
        msg: 'Modificaciones guardadas',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      hasChanges = false; // Reinicia la variable después de mostrar el Toast
      setState(() {
        isEditing = false; // Deshabilita la edición después de guardar
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Sin modificaciones',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      setState(() {
        isEditing = false; // Deshabilita la edición después de guardar
      });
    }
  }

  // Método para limpiar los datos de los TextField y SharedPreferences
  void clearData() {
    SharedPreferencesHelper.clearData();
    setState(() {
      nombrePropietario.text = '';
      modeloDelCarroMoto.text = '';
      placasDelCarroMoto.text = '';
      colorDelCarroMoto.text = '';
      telefonoController.text = '';
    });
  }

  void continuar() {
    // Validar que los campos numéricos solo contengan números
    if (!isTelefonoCodeValid(telefonoController.text)) {
      Fluttertoast.showToast(
        msg: 'El Número de Teléfono debe ser de 10 dígitos',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    } else {
      saveData();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    //---- CONSTRUCTOR PARA OBTENER LOS DATOS DEL USUARIO ---- //
    // final User? user = FirebaseAuth.instance.currentUser;

//---- MÉTODO PARA OBTENER LOS DOS PRIMEROS NOMBRES DEL USUARIO ---- //

    // ignore: unused_element
    String getFirstTwoNames(String fullName) {
      if (fullName.isEmpty) {
        return '';
      }

      List<String> nameFragments = fullName.split(' ');

      if (nameFragments.length >= 2) {
        return '${nameFragments[0]} ${nameFragments[1]}';
      } else {
        // Si el nombre completo tiene menos de dos fragmentos, regresa el nombre completo.
        return fullName;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Datos Administrativos",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red.shade700,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                // color: Colors.grey.shade200,
                size: 35,
              ),
              onPressed: () => Navigator.pop(context),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/park_sinfondo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // TextFields para el nombre y el correo (deshabilitados)
              // buildDisabledTextField(
              //     "Nombre", nombreController, user?.displayName ?? ''),
              // buildDisabledTextField(
              //     "Correo", correoController, user?.email ?? ''),

              // TextFields para la información de dirección y teléfono
              buildTextField("Nombre del Propietario", nombrePropietario),
              buildTextField("Modelo del Auto/Moto", modeloDelCarroMoto),
              // buildTextField("Número de Matricula", numInteriorController),
              // buildTextField(
              //     "Código Postal - 5 Dígitos", codigoPostalController),
              buildTextField("Placas de Auto/Moto", placasDelCarroMoto),
              buildTextField("Color de Auto/Moto", colorDelCarroMoto),
              buildTextField("Teléfono", telefonoController),

              const SizedBox(height: 20),

              // Botones Guardar, Editar y Limpiar Datos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                    ),
                    onPressed: isEditing ? () => saveData() : null,
                    child: const Text(
                      'Guardar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                    ),
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    child: const Text(
                      'Editar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Gap(10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                    ),
                    onPressed: areAllFieldsEmpty()
                        ? null
                        : clearData, // Deshabilitar si todos los campos están vacíos
                    child: const Text(
                      'Restablecer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                ),
                onPressed: areAllFieldsNotEmpty() ? continuar : null,
                child: const Text(
                  'Continuar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        onChanged: (value) {
          setState(() {
            hasChanges = true;
          });
        },
        cursorColor: Colors.red.shade900,
        cursorOpacityAnimates: true,
        autofocus: true,
        decoration: InputDecoration(
            labelText: labelText,
            floatingLabelStyle: TextStyle(
                color: Colors.red.shade900, fontWeight: FontWeight.w700),
            hintText: 'Ingrese $labelText',
            hoverColor: Colors.red.shade900,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 4),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 4),
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 4),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade700, width: 4),
              borderRadius: BorderRadius.circular(12),
            )),
      ),
    );
  }

  Widget buildDisabledTextField(
      String labelText, TextEditingController controller, String value) {
    return TextField(
      controller: controller,
      enabled: false,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: value,
      ),
    );
  }
}
