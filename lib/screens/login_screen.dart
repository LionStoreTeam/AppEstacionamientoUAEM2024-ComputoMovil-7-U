import 'package:estacionamiento_uaem/screens/administrativos_screen.dart';
import 'package:estacionamiento_uaem/screens/alumnos_screen.dart';
import 'package:estacionamiento_uaem/screens/maestros_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd9e6ed),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text("Bienvenido"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo.shade600,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_sharp),
              onPressed: () => _onBackButtonPressed(context),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/park2.png"),
                  fit: BoxFit.fill,
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdministrativosScreen(),
                  ),
                );
              },
              child: Text(
                "Soy Administrativo",
                style: TextStyle(
                  color: Colors.blue.shade100,
                  fontSize: 22,
                ),
              ),
            ),
            const Gap(30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MaestrosScreen(),
                  ),
                );
              },
              child: Text(
                "Soy Maestro",
                style: TextStyle(
                  color: Colors.blue.shade100,
                  fontSize: 22,
                ),
              ),
            ),
            const Gap(30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AlumnosScreen(),
                  ),
                );
              },
              child: Text(
                "Soy Alumno",
                style: TextStyle(
                  color: Colors.blue.shade100,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
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
