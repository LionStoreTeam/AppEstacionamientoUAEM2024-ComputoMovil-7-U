import 'package:estacionamiento_uaem/dto/registro_datos_administrativos.dart';
import 'package:estacionamiento_uaem/dto/shared_preferences_helper.dart';
import 'package:estacionamiento_uaem/screens/administrativos_screen.dart';
import 'package:estacionamiento_uaem/screens/alumnos_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _adminEnabled = true;
  bool _teacherEnabled = true;
  bool _studentEnabled = true;
  bool _resetEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadButtonStates();
    super.initState();
    SharedPreferencesHelper.loadSavedData(nombrePropietario, modeloDelCarroMoto,
        placasDelCarroMoto, colorDelCarroMoto, telefonoController);
    // Cargar el estado del botón "Restablecer" al inicio de la pantalla
    _loadResetButtonState();
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

  void _loadButtonStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _adminEnabled = prefs.getBool('adminEnabled') ?? true;
      _teacherEnabled = prefs.getBool('teacherEnabled') ?? true;
      _studentEnabled = prefs.getBool('studentEnabled') ?? true;
    });
  }

  // Método para cargar el estado del botón "Restablecer" desde SharedPreferences
  void _loadResetButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _resetEnabled = prefs.getBool('resetEnabled') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "Bienvenido",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.7,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red.shade700,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_sharp),
              color: Colors.white,
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
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/park_sinfondo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Gap(40),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black87,
                      width: 3,
                    ),
                  ),
                ),
                child: const Text(
                  "Ingresar",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Gap(60),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      _adminEnabled ? Colors.red.shade400 : Colors.grey),
                ),
                onPressed: _adminEnabled
                    ? () {
                        _disableButtons('admin');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdministrativosScreen(),
                          ),
                        );
                      }
                    : null,
                label: Text(
                  "Soy Administrativo",
                  style: TextStyle(
                    color: Colors.red.shade50,
                    fontSize: 22,
                  ),
                ),
                icon: Icon(
                  Icons.text_snippet_outlined,
                  color: Colors.red.shade50,
                ),
              ),
              const Gap(30),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      _teacherEnabled ? Colors.red.shade400 : Colors.grey),
                ),
                onPressed: _teacherEnabled
                    ? () {
                        _disableButtons('teacher');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const RegistroDatosAdministrativos(),
                          ),
                        );
                      }
                    : null,
                label: Text(
                  "Soy Maestro",
                  style: TextStyle(
                    color: Colors.red.shade50,
                    fontSize: 22,
                  ),
                ),
                icon: Icon(
                  Icons.border_color_outlined,
                  color: Colors.red.shade50,
                ),
              ),
              const Gap(30),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      _studentEnabled ? Colors.red.shade400 : Colors.grey),
                ),
                onPressed: _studentEnabled
                    ? () {
                        _disableButtons('student');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AlumnosScreen(),
                          ),
                        );
                      }
                    : null,
                label: Text(
                  "Soy Alumno",
                  style: TextStyle(
                    color: Colors.red.shade50,
                    fontSize: 22,
                  ),
                ),
                icon: Icon(
                  Icons.school_outlined,
                  color: Colors.red.shade50,
                ),
              ),
              const Gap(30),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black87),
                ),
                onPressed: () {
                  clearData();
                  _resetButtons();
                },
                label: Text(
                  "Restablecer",
                  style: TextStyle(
                    color: Colors.red.shade50,
                    fontSize: 22,
                  ),
                ),
                icon: Icon(
                  Icons.replay_sharp,
                  color: Colors.red.shade50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _disableButtons(String activeButton) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (activeButton != 'admin') {
        _adminEnabled = false;
        prefs.setBool('adminEnabled', _adminEnabled);
      }
      if (activeButton != 'teacher') {
        _teacherEnabled = false;
        prefs.setBool('teacherEnabled', _teacherEnabled);
      }
      if (activeButton != 'student') {
        _studentEnabled = false;
        prefs.setBool('studentEnabled', _studentEnabled);
      }
    });
  }

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

  void _resetButtons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _adminEnabled = true;
      _teacherEnabled = true;
      _studentEnabled = true;
      _resetEnabled = true;
    });
    // Guardar el estado del botón "Restablecer" en SharedPreferences
    prefs.setBool('resetEnabled', _resetEnabled);
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