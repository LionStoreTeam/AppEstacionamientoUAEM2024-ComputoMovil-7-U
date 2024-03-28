import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:estacionamiento_uaem/api/map.dart';
import 'package:estacionamiento_uaem/api/services/stripe_payment/stripe_manager.dart';
import 'package:estacionamiento_uaem/dto/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:intl/intl.dart';

// Clase para representar una opción en el DropdownButton
class DropdownOption {
  final String text;
  final String price;
  final int timerDuration;

  DropdownOption(this.text, this.price, this.timerDuration);

  // Sobrescribir el operador == para comparar las opciones de forma adecuada
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DropdownOption &&
        other.text == text &&
        other.price == price &&
        other.timerDuration == timerDuration;
  }

  // Sobrescribir el hashCode para que sea coherente con el operador ==
  @override
  int get hashCode => text.hashCode ^ price.hashCode ^ timerDuration.hashCode;
}

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
  DropdownOption? _selectedOption;
  late Timer _timer;
  int _secondsRemaining = 0;
  bool _dropdownEnabled = true;
  bool paymentProcessing = false;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
    cargarDatosGuardados();
    cargarTipoUsuario();
  }

  String? tipoUsuario;
  TextEditingController nombrePropietarioController = TextEditingController();
  TextEditingController matriculaDeControlController = TextEditingController();
  TextEditingController modeloDelCarroMotoController = TextEditingController();
  TextEditingController placasDelCarroMotoController = TextEditingController();
  TextEditingController colorDelCarroMotoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  // FIN Sección de métodos para el temporizador y el precio

// ------

  void _updateTimer(Timer timer) {
    if (_secondsRemaining > 0) {
      setState(() {
        _secondsRemaining--;
      });
    } else {
      setState(() {
        _dropdownEnabled =
            true; // Habilita el DropdownButton cuando el temporizador termina
      });
    }
  }

  void _startTimer(int duration) {
    setState(() {
      _secondsRemaining = duration;
      _dropdownEnabled =
          false; // Deshabilita el DropdownButton cuando se inicia el temporizador
    });
  }

  void _handlePagoPressed() {
    // Realizar alguna acción al presionar el botón "Pagar"
    setState(() {
      horaDeSalida = DateFormat.Hms().format(DateTime.now());
    });
  }

  String getFormattedTime() {
    int hours = _secondsRemaining ~/ 3600;
    int minutes = (_secondsRemaining % 3600) ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> showToast(String message) async {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  Future<void> handlePayment(
      Future<void> Function(BuildContext) paymentFunction) async {
    // Validar el monto aquí
    if (paymentProcessing) {
      showToast('Pantalla de cobro en proceso');
      return;
    }

    setState(() {
      paymentProcessing = true;
    });

    try {
      await paymentFunction(context);
    } finally {
      setState(() {
        paymentProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = getFormattedTime();
    // Define las opciones del DropdownButton
    List<DropdownOption> dropdownOptions = [
      DropdownOption('1 hora', '12', 10),
      DropdownOption('2 horas', '24', 2 * 60 * 60),
      DropdownOption('3 horas', '36', 3 * 60 * 60),
      DropdownOption('4 hora', '48', 4 * 60 * 60),
      DropdownOption('5 horas', '60', 5 * 60 * 60),
      DropdownOption('6 horas', '72', 6 * 60 * 60),
      DropdownOption('7 hora', '84', 7 * 60 * 60),
      DropdownOption('8 horas', '96', 8 * 60 * 60),
      DropdownOption('9 horas', '108', 9 * 60 * 60),
      DropdownOption('10 hora', '120', 10 * 60 * 60),
      DropdownOption('11 horas', '132', 11 * 60 * 60),
      DropdownOption('12 horas', '144', 12 * 60 * 60),
    ];
    return Scaffold(
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
                      "Para iniciar debes seleccionar el número de horas que deseas reservar el cajón de estacionamiento.",
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
                      "El precio por hora para la estancia dentro del cajón de estacionamiento es de \$12.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                    const Gap(5),
                    Divider(
                      color: Colors.grey.shade700,
                      thickness: 1,
                    ),
                    const Gap(30),
                    Text(
                      "Puedes elegir cómo mínimo 1 hora y máximo 12 horas de disponibilidad.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                    const Gap(30),
                    Text(
                      "Después de seleccionar la cantidad de horas deseadas se mostrara el botón para realizar pagos en línea.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const Gap(20),
                    DropdownButton<DropdownOption>(
                      hint: const Text('Cantidad Horas'),
                      value: _selectedOption,
                      onChanged: _dropdownEnabled
                          ? (DropdownOption? newValue) {
                              setState(() {
                                _selectedOption = newValue;
                                // Inicia el temporizador cuando se selecciona una opción
                                _startTimer(newValue!.timerDuration);
                              });
                            }
                          : null, // Deshabilita el DropdownButton si _dropdownEnabled es false
                      items: dropdownOptions.map((option) {
                        return DropdownMenuItem<DropdownOption>(
                          value: option,
                          child: Text(option.text),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width - 90,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.transparent,
                          border: Border.all(color: Colors.redAccent.shade700),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                blurRadius: 3,
                                blurStyle: BlurStyle.outer,
                                color: Colors.redAccent.shade100)
                          ]),
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
                    if (_selectedOption != null)
                      ElevatedButton.icon(
                          style: ButtonStyle(
                            side: MaterialStatePropertyAll(
                                BorderSide(color: Colors.greenAccent.shade700)),
                            shadowColor: MaterialStatePropertyAll(
                              Colors.greenAccent.shade100,
                            ),
                            elevation: const MaterialStatePropertyAll(1),
                          ),
                          onPressed: () async {
                            var connectivityResult =
                                await Connectivity().checkConnectivity();
                            _handlePagoPressed();
                            if (connectivityResult == ConnectivityResult.none) {
                              showToast(
                                  'Es necesario que estés conectado a Internet para realizar una Donación');
                            } else {
                              handlePayment(
                                (context) =>
                                    StripePaymentHandle30MXN.stripeMakePayment(
                                  context,
                                  _selectedOption!.price,
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.monetization_on,
                            color: Colors.greenAccent.shade700,
                          ),
                          label: const Text(
                            "Pagar en línea",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    const Gap(40),
                    const Text(
                      textAlign: TextAlign.center,
                      'Una vez seleccionada la cantidad de horas el "Precio Total" se mostrará en la parte final de su Ticket.',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const Gap(20),
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
                                horaDeSalida),
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
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                        child: Text(
                          'Precio Total: ${_selectedOption != null ? '\$${_selectedOption!.price}' : 'Seleccione una opción'}',
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
