import 'dart:async';

import 'package:estacionamiento_uaem/api/map.dart';
import 'package:estacionamiento_uaem/dto/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl

DateTime now = DateTime.now(); // Obtiene la fecha y hora actual

String formattedDate =
    "${now.day}-${now.month}-${now.year}"; // Formatea la fecha como dd-mm-yyyy
String horaDeEntrada =
    DateFormat.Hms().format(now); // Formatea la hora como hh:mm:ss

String horaDeSalida = "--:--:--"; // Formatea la hora como hh:mm:ss

class ProcesoFinalScreen extends StatefulWidget {
  const ProcesoFinalScreen({super.key});

  @override
  State<ProcesoFinalScreen> createState() => _ProcesoFinalScreenState();
}

class _ProcesoFinalScreenState extends State<ProcesoFinalScreen> {
  String? tipoUsuario;
  TextEditingController nombrePropietarioController = TextEditingController();
  TextEditingController matriculaDeControlController = TextEditingController();
  TextEditingController modeloDelCarroMotoController = TextEditingController();
  TextEditingController placasDelCarroMotoController = TextEditingController();
  TextEditingController colorDelCarroMotoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();
    cargarDatosGuardados();
    cargarTipoUsuario();
  }

  Future<void> cargarDatosGuardados() async {
    await SharedPreferencesHelper.loadSavedData(
      nombrePropietarioController,
      modeloDelCarroMotoController,
      placasDelCarroMotoController,
      colorDelCarroMotoController,
      telefonoController,
      matriculaDeControlController,
    );
    setState(() {}); // Actualiza la UI con los datos cargados
  }

  Future<void> cargarTipoUsuario() async {
    tipoUsuario = await SharedPreferencesHelper.loadTipoUsuario();
    setState(() {}); // Actualiza la UI con el tipo de usuario cargado
  }

  // INICIO Sección de métodos para el temporizador y el precio
  late Timer _timer;
  int _seconds = 0;
  bool isRunning = false;
  bool showTotalPrice = false;

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
        horaDeSalida = DateFormat.Hms()
            .format(DateTime.now()); // Actualiza la hora de salida
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
  // FIN Sección de métodos para el temporizador y el precio

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black87,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "Pantalla De Pago",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.white)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MapEstacionamiento()));
                          },
                          label: const Text(
                            'Mostrar Mapa',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700),
                          ),
                          icon: const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 25,
                            color: Colors.black87,
                          ),
                        ),
                        const Gap(5),
                        GestureDetector(
                          onTap: () => showInfoViewMap(context),
                          child: Icon(
                            Icons.info_outlined,
                            color: Colors.redAccent.shade100,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    const Gap(5),
                    Divider(
                      color: Colors.red.shade50,
                      thickness: 2,
                    ),
                    const Gap(20),
                    Text(
                      "El Temporizador y Precio acumulado se inician de manera automática a partir de que fue seleccionado el cajón de estacionamiento.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red.shade100,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: 0.7,
                      ),
                    ),
                    const Gap(20),
                    Text(
                      "El precio por minuto para la estancia dentro del cajón de estacionamiento es de 20¢.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                    const Gap(20),
                    Text(
                      'Precio Acumulado: \$${_calculatePrice().toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Gap(20),
                    Text(
                      'Tiempo Transcurrido: ${_formatTime(_seconds)}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Gap(40),
                    const Text(
                      textAlign: TextAlign.center,
                      'Para terminar la estancia y mostrar el "Precio Total" dentro del tricket, presiona el botón "Terminar y Pagar".',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const Gap(20),
                    ElevatedButton.icon(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white)),
                      onPressed: _stopTimer,
                      label: const Text(
                        'Terminar y Pagar',
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w700),
                      ),
                      icon: Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.greenAccent.shade700,
                      ),
                    ),
                    const Gap(25),
                    if (showTotalPrice)
                      ElevatedButton.icon(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                        ),
                        onPressed: () {},
                        icon: Icon(
                          Icons.monetization_on_sharp,
                          color: Colors.greenAccent.shade700,
                          size: 25,
                        ),
                        label: const Text(
                          "Pagar En Linea",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black87,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    const Gap(25),
                    // const SizedBox(height: 10),
                    // ElevatedButton(
                    //   onPressed: _resetTimer,
                    //   child: const Text('Reiniciar'),
                    // ),
                  ],
                ),
              ),
              TicketWidget(
                color: Colors.white,
                width: MediaQuery.of(context).size.width - 50,
                height: MediaQuery.of(context).size.height,
                isCornerRounded: true,
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/uaem.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 150,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/park_sinfondo2.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: Text(
                            'Ticket del Estacionamiento',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ticketDetailsWidget(
                              'Propietario',
                              nombrePropietarioController.text,
                              'Fecha Actual',
                              formattedDate,
                            ),
                            const Gap(20),
                            ticketDetailsWidget(
                                'Matricula De Control',
                                matriculaDeControlController.text,
                                'Hora/Entrada',
                                horaDeEntrada),
                            const Gap(20),
                            ticketDetailsWidget(
                                'Placas',
                                placasDelCarroMotoController.text,
                                'Hora/Salida  ',
                                horaDeSalida), // Añadir hora de salida aquí
                            const Gap(20),
                            ticketDetailsWidget(
                                'Modelo Au/Mo',
                                modeloDelCarroMotoController.text,
                                "Color Au/Mo ",
                                colorDelCarroMotoController.text),
                          ],
                        ),
                      ),
                      const Gap(40),
                      if (showTotalPrice)
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          child: Text(
                            'Precio Total: \$${_calculateTotalPrice().toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 50.0, left: 30.0, right: 30.0),
                        child: Container(
                          width: 250.0,
                          height: 60.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/barcode.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          textAlign: TextAlign.center,
                          'Para pagos en efectivo los precios con terminación menor a 50¢ serán redondeados a 0¢, para precios con terminación mayor a 50¢ serán redondeados a la cantidad mayor.',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Center(
                          child: Text(
                        '¡ Ten un buen viaje !',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showInfoViewMap(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Ver el mapa",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "Si tienes dudas de la ubicación, los estacionamientos, las calles y avenidas, puedes revisar el mapa dentro de la UAEM.",
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("De Acuerdo"),
              ),
            ],
          );
        });
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}
