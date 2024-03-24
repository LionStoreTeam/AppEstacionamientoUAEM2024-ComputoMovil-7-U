import 'dart:async';

import 'package:estacionamiento_uaem/api/map.dart';
import 'package:estacionamiento_uaem/login/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DisponibilidadScreen extends StatefulWidget {
  const DisponibilidadScreen({Key? key}) : super(key: key);

  @override
  State<DisponibilidadScreen> createState() => _DisponibilidadScreenState();
}

class _DisponibilidadScreenState extends State<DisponibilidadScreen> {
  int _seconds = 5 * 60;
  Timer? _timer;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (_isTimerRunning) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          stopTimer();
          showTimeUpAlert();
        }
      });
    });

    setState(() {
      _isTimerRunning = true;
    });
  }

  void stopTimer() {
    if (!_isTimerRunning) return;

    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  String getFormattedTime() {
    int hours = _seconds ~/ 3600;
    int minutes = (_seconds % 3600) ~/ 60;
    int seconds = _seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void showTimeUpAlert() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "¡Tiempo Agotado!",
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Se ha agotado el tiempo para elegir un cajón de estacionamiento.",
            style: TextStyle(
              color: Colors.amber.shade50,
              fontSize: 19,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              child: const Text(
                "Salir",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  final Map<String, bool> _cajonesDisponibles = {
    "Cajón 1": true,
    "Cajón 2": false,
    "Cajón 3": false,
    "Cajón 4": true,
    // "Cajon 5": true,
    // "Cajon 6": true,
    // "Cajon 7": false,
    // "Cajon 8": false,
  };

  bool _mostrarBotonIngresar = false;
  bool _mostrarColumn = true;

  @override
  Widget build(BuildContext context) {
    String formattedTime = getFormattedTime();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Disponibilidad"),
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
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_mostrarColumn)
                Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Tiempo restante para elegir un cajón de estacionamiento disponible.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.purple.shade900,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            letterSpacing: 0.7,
                          ),
                        ),
                        const Gap(15),
                        Container(
                          width: MediaQuery.of(context).size.width - 70,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blueAccent.shade700,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 3, top: 3, left: 5, right: 5),
                            child: Center(
                              child: Text(
                                'Tiempo restante: $formattedTime',
                                style: TextStyle(
                                  color: Colors.cyan.shade50,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
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
                                        child:
                                            _buildCajon(context, cajonNombre),
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
                                        child:
                                            _buildCajon(context, cajonNombre),
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
                                        child:
                                            _buildCajon(context, cajonNombre),
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
              if (_mostrarBotonIngresar)
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Puedes revisar las calles y estacionamientos que se encuentran dentro de la universidad.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.purple.shade900,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const Gap(30),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MapEstacionamiento()));
                        },
                        label: const Text('Mostrar Mapa'),
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 20,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
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
                Navigator.of(context).pop(true); // Reservar
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
        _mostrarBotonIngresar = true; // Mostrar el botón "Ingresar"
        _mostrarColumn = false; // Ocultar el segundo Column
      });
    }
  }
}
