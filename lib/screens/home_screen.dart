// import 'package:firebase_auth/firebase_auth.dart';
import 'package:estacionamiento_uaem/dto/shared_preferences_helper.dart';
import 'package:estacionamiento_uaem/login/sign_in_screen.dart';
import 'package:estacionamiento_uaem/screens/disponibilidad_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SharedPreferencesHelper.loadSavedData(
      nombrePropietario,
      modeloDelCarroMoto,
      placasDelCarroMoto,
      colorDelCarroMoto,
      telefonoController,
      matriculaDeControl,
    );
    // Cargar el tipo de usuario seleccionado al iniciar la pantalla
    SharedPreferencesHelper.loadTipoUsuario().then((value) {
      if (value != null) {
        setState(() {
          tipoUsuarioSeleccionado = value;
        });
      }
    });
  }

  // final User? user = FirebaseAuth.instance.currentUser;
  TextEditingController nombrePropietario = TextEditingController();
  TextEditingController matriculaDeControl = TextEditingController();
  TextEditingController modeloDelCarroMoto = TextEditingController();
  // TextEditingController numInteriorController = TextEditingController();
  // TextEditingController codigoPostalController = TextEditingController();
  TextEditingController placasDelCarroMoto = TextEditingController();
  TextEditingController colorDelCarroMoto = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController nombreController =
      TextEditingController(); // nombre registrado con la cuenta
  // TextEditingController correoController = TextEditingController();

  // Opciones para el DropdownButton
  final List<String> opcionesTipoUsuario = [
    "Administrativo",
    "Maestro",
    "Alumno"
  ];

  // Opción seleccionada por defecto
  String tipoUsuarioSeleccionado = "Administrativo";

  bool isEditing = false;
  bool hasChanges = false; // Nueva variable para rastrear cambios
  // Declarar la variable para verificar si los datos han sido guardados
  bool datosGuardados = false;

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
        matriculaDeControl.text.isEmpty ||
        !isTelefonoCodeValid(telefonoController.text);
  }

  // Método para guardar los datos en SharedPreferences
  void saveData() async {
    SharedPreferencesHelper.saveData(
        nombrePropietario,
        modeloDelCarroMoto,
        placasDelCarroMoto,
        colorDelCarroMoto,
        telefonoController,
        matriculaDeControl);

    if (areFieldsEmpty()) {
      Fluttertoast.showToast(
        msg: 'Todos los campos son obligatorios',
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
    // Establecer hasChanges en false después de guardar los datos
    hasChanges = false;
    // Actualizar datosGuardados a true después de guardar los datos
    datosGuardados = true;
    setState(() {}); // Actualizar el estado para reflejar el cambio
  }

  // // Método para limpiar los datos de los TextField y SharedPreferences
  // void clearData() {
  //   SharedPreferencesHelper.clearData();
  //   setState(() {
  //     nombrePropietario.text = '';
  //     modeloDelCarroMoto.text = '';
  //     placasDelCarroMoto.text = '';
  //     colorDelCarroMoto.text = '';
  //     telefonoController.text = '';
  //   });
  // }

  void continuar() {
    SharedPreferencesHelper.saveData(
        nombrePropietario,
        modeloDelCarroMoto,
        placasDelCarroMoto,
        colorDelCarroMoto,
        telefonoController,
        matriculaDeControl);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DisponibilidadScreen()));
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
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "Registro",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black87,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                // color: Colors.grey.shade200,
                size: 35,
              ),
              onPressed: () => _onBackButtonPressed(context),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/park3.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Gap(30),

              Text(
                "Para poder ingresar y seleccionar un cajón de estacionamiento es necesario que se registre y/o verifique siempre sus datos y los del Vehículo/Motocicleta.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
              Divider(
                color: Colors.grey.shade700,
                thickness: 1,
              ),
              const Gap(30),
              Text(
                textAlign: TextAlign.center,
                "Seleccione el tipo de usuario de acuerdo a su perfil.",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(15),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red.shade700, width: 3.5)),
                child: DropdownButton<String>(
                  value: tipoUsuarioSeleccionado,
                  padding: const EdgeInsets.all(8.0),
                  focusColor: Colors.red.shade50,
                  icon: const Icon(
                    Icons.arrow_downward,
                  ),
                  iconEnabledColor: Colors.red.shade700,
                  iconDisabledColor: Colors.grey,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.red.shade700,
                  ),
                  items: opcionesTipoUsuario.map((String opcion) {
                    return DropdownMenuItem<String>(
                      value: opcion,
                      child: Text(opcion),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        tipoUsuarioSeleccionado = newValue;
                      });
                      // Guardar el tipo de usuario seleccionado
                      SharedPreferencesHelper.saveTipoUsuario(newValue);
                    }
                  },
                ),
              ),
              const Gap(15),
              // TextFields para el nombre y el correo (deshabilitados)
              // buildDisabledTextField(
              //     "Nombre", nombreController, user?.displayName ?? ''),
              // buildDisabledTextField(
              //     "Correo", correoController, user?.email ?? ''),

              // TextFields para la información de dirección y teléfono
              buildTextFieldNombreColor(
                  "Nombre del Propietario", nombrePropietario),
              buildTextFieldMatriculaControl(
                  "Matricula De Control", matriculaDeControl),
              buildTextFieldModelo(
                  "Modelo del Vehículo/Motocicleta", modeloDelCarroMoto),
              // buildTextField("Número de Matricula", numInteriorController),
              // buildTextField(
              //     "Código Postal - 5 Dígitos", codigoPostalController),
              buildTextFieldPlacas(
                  "Placas del Vehículo/Motocicleta", placasDelCarroMoto),
              buildTextFieldNombreColor(
                  "Color del Vehículo/Motocicleta", colorDelCarroMoto),
              buildTextFieldTelefono("Teléfono", telefonoController),

              const SizedBox(height: 20),

              // Botones Guardar, Editar y Limpiar Datos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900,
                    ),
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    child: const Text(
                      'Comprobar Datos',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900,
                    ),
                    onPressed: isEditing ? () => saveData() : null,
                    child: const Text(
                      'Guardar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.red.shade700,
                  //   ),
                  //   onPressed: areAllFieldsEmpty()
                  //       ? null
                  //       : clearData, // Deshabilitar si todos los campos están vacíos
                  //   child: const Text(
                  //     'Restablecer',
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
              const Gap(20),
              // ElevatedButton.icon(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.red.shade700,
              //   ),
              //   onPressed: datosGuardados ? continuar : null,
              //   label: const Text(
              //     'Continuar',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   icon: const Icon(
              //     Icons.arrow_forward,
              //     color: Colors.white,
              //   ),
              // ),
              GestureDetector(
                onTap: datosGuardados ? continuar : null,
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                    color: datosGuardados == false
                        ? Colors.grey.shade800
                        : Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "Continuar",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.car_rental_rounded,
                              color: Colors.red.shade200,
                              size: 30,
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.red.shade200,
                              size: 30,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                },
                child: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldNombreColor(
      String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLength: 10,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(
              RegExp(r'[a-zA-Z]')), // Solo letras// Solo números
        ],
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
            hintText: 'Ingrese el $labelText',
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

  Widget buildTextFieldMatriculaControl(
      String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLength: 8,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(8), // Límite de 10 caracteres
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Solo números
        ],
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
            hintText: 'Ingrese su Matricula a 8 dígitos',
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

  Widget buildTextFieldModelo(
      String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLength: 10,
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
            hintText: 'Ingrese el modelo a 10 caracteres',
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

  Widget buildTextFieldPlacas(
      String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLength: 7,
        inputFormatters: <TextInputFormatter>[
          // Límite de 10 caracteres
          FilteringTextInputFormatter.allow(
              RegExp(r'[0-9-a-zA-Z]')), // Solo números
        ],
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
            hintText: 'Ingrese las placas a 7 caracteres',
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

  Widget buildTextFieldTelefono(
      String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLength: 10,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(10), // Límite de 10 caracteres
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Solo números
        ],
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
            hintText: 'Ingrese un número celular a 10 dígitos',
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

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Salir de la aplicación"),
          content: const Text("¿Quieres salir de la aplicación?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: const Text("Si"),
            ),
          ],
        );
      },
    );
    return exitApp;
  }
}
