import 'dart:async';

import 'package:estacionamiento_uaem/api/map.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DisponibilidadScreen extends StatefulWidget {
  const DisponibilidadScreen({Key? key}) : super(key: key);

  @override
  State<DisponibilidadScreen> createState() => _DisponibilidadScreenState();
}

class _DisponibilidadScreenState extends State<DisponibilidadScreen> {
  late Timer _timer;
  int _seconds = 0;
  bool isRunning = false;
  bool showTotalPrice = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _seconds++;
      });
    });
    setState(() {
      isRunning = true;
    });
  }

  void _stopTimer() {
    if (_timer.isActive) {
      _timer.cancel();
      setState(() {
        showTotalPrice = true;
      });
    }
  }

  double _calculateTotalPrice() {
    // Precio por minuto: 20 centavos (0.20 pesos)
    const pricePerMinute = 0.20;
    // Convertir segundos a minutos
    double minutes = _seconds / 60;
    // Calcular precio total
    double totalPrice = minutes * pricePerMinute;
    return totalPrice;
  }

  // void _resetTimer() {
  //   _timer.cancel();
  //   setState(() {
  //     _seconds = 0;
  //     _isRunning = false;
  //   });
  // }

  String _formatTime(int time) {
    String formattedTime = '';

    int hours = time ~/ 3600;
    int minutes = (time % 3600) ~/ 60;
    int seconds = time % 60;

    formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  double _calculatePrice() {
    return (_seconds / 60) * 0.20; // 20¢ por minuto
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  final Map<String, bool> _cajonesDisponibles = {
    "Cajón 1": true,
    "Cajón 2": false,
    "Cajón 3": false,
    "Cajón 4": true,
  };

  bool _mostrarBotonIngresar = false;
  bool _mostrarColumn = true;

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
              if (_mostrarColumn)
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
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.w700,
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
                      const Gap(20),
                      Text(
                        "El temporizador....",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const Gap(20),

                      Text(
                        'Precio acumulado: \$${_calculatePrice().toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Gap(20),
                      Text(
                        'Tiempo transcurrido: ${_formatTime(_seconds)}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Gap(20),

                      ElevatedButton(
                        onPressed: _stopTimer,
                        child: const Text('Detener'),
                      ),
                      const Gap(20),

                      if (showTotalPrice)
                        Text(
                          'Precio Total: \$${_calculateTotalPrice().toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20),
                        ),

                      // const SizedBox(height: 10),
                      // ElevatedButton(
                      //   onPressed: _resetTimer,
                      //   child: const Text('Reiniciar'),
                      // ),
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


// https://pub.dev/packages/ticket_widget
// https://pub.dev/packages/ticket_widget/example
// https://flutterawesome.com/tag/ticket/
