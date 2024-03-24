// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    //   // Cargar los datos guardados al inicio de la pantalla
    loadSavedData();
  }

  // final User? user = FirebaseAuth.instance.currentUser;
  TextEditingController calleController = TextEditingController();
  TextEditingController coloniaController = TextEditingController();
  TextEditingController numInteriorController = TextEditingController();
  TextEditingController codigoPostalController = TextEditingController();
  TextEditingController ciudadController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController correoController = TextEditingController();

  bool isEditing = false;
  bool hasChanges = false; // Nueva variable para rastrear cambios

  // @override
  // void initState() {
  //   super.initState();
  //   // Cargar los datos guardados al inicio de la pantalla
  // }

  // Método para cargar los datos guardados en SharedPreferences
  void loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      calleController.text = prefs.getString('calle') ?? '';
      coloniaController.text = prefs.getString('colonia') ?? '';
      numInteriorController.text = prefs.getString('numInterior') ?? '';
      codigoPostalController.text = prefs.getString('codigoPostal') ?? '';
      ciudadController.text = prefs.getString('ciudad') ?? '';
      estadoController.text = prefs.getString('estado') ?? '';
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

// Método para validar el código postal
  bool isPostalCodeValid(String value) {
    return value.length == 5 && isNumeric(value);
  }

  // Método para validar el número de Teléfono
  bool isTelefonoCodeValid(String value) {
    return value.length == 10 && isNumeric(value);
  }

// Método para validar si los campos están vacíos
  bool areFieldsEmpty() {
    return calleController.text.isEmpty ||
        coloniaController.text.isEmpty ||
        numInteriorController.text.isEmpty ||
        !isPostalCodeValid(codigoPostalController.text) ||
        ciudadController.text.isEmpty ||
        estadoController.text.isEmpty ||
        !isTelefonoCodeValid(telefonoController.text);
  }

  // Nueva variable para rastrear si todos los campos están vacíos
  bool areAllFieldsEmpty() {
    return calleController.text.isEmpty &&
        coloniaController.text.isEmpty &&
        numInteriorController.text.isEmpty &&
        codigoPostalController.text.isEmpty &&
        ciudadController.text.isEmpty &&
        estadoController.text.isEmpty &&
        telefonoController.text.isEmpty;
  }

  // Método para guardar los datos en SharedPreferences
  void saveData() async {
    // Validar que los campos numéricos solo contengan números
    if (!isNumeric(numInteriorController.text)) {
      Fluttertoast.showToast(
        msg: 'El Número Interior solo deben contener números',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return;
    }

    // Validar el código postal
    if (!isPostalCodeValid(codigoPostalController.text)) {
      Fluttertoast.showToast(
        msg: 'El Código postal debe ser de 5 dígitos',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('calle', calleController.text);
    prefs.setString('colonia', coloniaController.text);
    prefs.setString('numInterior', numInteriorController.text);
    prefs.setString('codigoPostal', codigoPostalController.text);
    prefs.setString('ciudad', ciudadController.text);
    prefs.setString('estado', estadoController.text);
    prefs.setString('telefono', telefonoController.text);

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
  void clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      calleController.text = '';
      coloniaController.text = '';
      numInteriorController.text = '';
      codigoPostalController.text = '';
      ciudadController.text = '';
      estadoController.text = '';
      telefonoController.text = '';
    });

    // Borrar los datos almacenados en SharedPreferences
    prefs.remove('calle');
    prefs.remove('colonia');
    prefs.remove('numInterior');
    prefs.remove('codigoPostal');
    prefs.remove('ciudad');
    prefs.remove('estado');
    prefs.remove('telefono');
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
        title: const Text("Datos Usuario"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... Otros widgets existentes ...
              // CircleAvatar para la imagen del usuario
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
              buildTextField("Nombre del Propietario", calleController),
              buildTextField("Número de Placas", coloniaController),
              buildTextField("Número de Matricula", numInteriorController),
              buildTextField(
                  "Código Postal - 5 Dígitos", codigoPostalController),
              buildTextField("Modelo de Auto/Moto", ciudadController),
              buildTextField("Color de Auto/Moto", estadoController),
              buildTextField("Teléfono", telefonoController),

              const SizedBox(height: 20),

              // Botones Guardar, Editar y Limpiar Datos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: isEditing ? () => saveData() : null,
                    child: const Text('Guardar'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    child: const Text('Editar'),
                  ),
                  const Gap(10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: areAllFieldsEmpty()
                        ? null
                        : clearData, // Deshabilitar si todos los campos están vacíos
                    child: const Text('Restablecer'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      enabled: isEditing,
      onChanged: (value) {
        setState(() {
          hasChanges = true;
        });
      },
      decoration: InputDecoration(
        labelText: labelText,
        hintText: 'Ingrese su $labelText',
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
