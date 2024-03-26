import 'package:estacionamiento_uaem/screens/proceso_final_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DisponibilidadScreen extends StatefulWidget {
  const DisponibilidadScreen({Key? key}) : super(key: key);

  @override
  State<DisponibilidadScreen> createState() => _DisponibilidadScreenState();
}

class _DisponibilidadScreenState extends State<DisponibilidadScreen> {
  final Map<String, bool> _cajonesDisponibles = {
    "Cajón 1": true,
    "Cajón 2": false,
    "Cajón 3": false,
    "Cajón 4": true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Disponibilidad",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red.shade700,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_sharp),
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.white,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      Text(
                        "Los cajones marcados en color verde se ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.purple.shade900,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const Gap(15),
                      const Gap(40),
                      Text(
                        "Disponibilidad Estacionamiento 1",
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.purple.shade900,
                            width: 4,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _cajonesDisponibles.keys
                                      .map((cajonNombre) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: _buildCajon(context, cajonNombre),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(30),
                  Column(
                    children: [
                      Text(
                        "Disponibilidad Estacionamiento 2",
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.purple.shade900,
                            width: 4,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _cajonesDisponibles.keys
                                      .map((cajonNombre) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: _buildCajon(context, cajonNombre),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(30),
                  Column(
                    children: [
                      Text(
                        "Disponibilidad Estacionamiento 3",
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.purple.shade900,
                            width: 4,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _cajonesDisponibles.keys
                                      .map((cajonNombre) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: _buildCajon(context, cajonNombre),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildCajon(BuildContext context, String cajonNombre) {
    final disponible = _cajonesDisponibles[cajonNombre] ?? false;
    Color color = disponible ? Colors.green.shade700 : Colors.red.shade900;
    return GestureDetector(
      onTap: () {
        if (disponible) {
          _showReservarDialog(context, cajonNombre);
        } else {
          _estacionamientoOcupado(context);
        }
      },
      child: Container(
        height: 100,
        width: 90,
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
            width: 4,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              disponible ? Icons.car_repair : Icons.car_crash_rounded,
              color: color,
              size: 40,
            ),
            const SizedBox(height: 5),
            Text(
              cajonNombre,
              style: TextStyle(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _estacionamientoOcupado(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¡ Cajón Ocupado !"),
          content: const Text(
              "Esté cajón está ocupado, por favor selecciona uno disponible en color verde."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("De Acuerdo"),
            ),
          ],
        );
      },
    );
  }

  void _showReservarDialog(BuildContext context, String cajonNombre) async {
    bool reservar = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¡ Cajón Disponible !"),
          content: const Text("¿Deseas reservar esté cajón?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ProcesoFinalScreen())); // Reservar
              },
              child: const Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No reservar
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (reservar) {
      setState(() {
        _cajonesDisponibles[cajonNombre] = false; // Cambiar a cajón a reservado
      });
    }
  }
}


// https://pub.dev/packages/ticket_widget
// https://pub.dev/packages/ticket_widget/example
