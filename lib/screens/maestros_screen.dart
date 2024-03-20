import 'package:estacionamiento_uaem/screens/disponibilidad_screen.dart';
import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';

class MaestrosScreen extends StatefulWidget {
  const MaestrosScreen({super.key});

  @override
  State<MaestrosScreen> createState() => _MaestrosScreenState();
}

class _MaestrosScreenState extends State<MaestrosScreen> {
  bool _archivoSubido = false;
  bool _mostrarBotonSubir = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd9e6ed),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text("Bienvenido Maestro"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo.shade600,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_sharp),
              onPressed: () => Navigator.of(context).pop(),
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
            const SizedBox(height: 40),
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
                "Soy Maestro",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              "Comprueba tu identificación",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (_mostrarBotonSubir)
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.green.shade800),
                ),
                onPressed:
                    _archivoSubido ? null : () => _mostrarAlertDialog(context),
                child: const Text(
                  "Subir identificación",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (_archivoSubido)
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blue.shade700),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DisponibilidadScreen()));
                },
                icon: const Icon(Icons.remove_red_eye_outlined,
                    color: Colors.white),
                label: const Text(
                  "Ver Disponibilidad",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _mostrarAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Archivo subido'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                setState(() {
                  _archivoSubido = true;
                  _mostrarBotonSubir = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
