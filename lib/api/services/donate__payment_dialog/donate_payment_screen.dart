// import 'dart:async';

// import 'package:estacionamiento_uaem/api/services/stripe_payment/stripe_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:gap/gap.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:connectivity/connectivity.dart';

// class DonatePaymentScreen extends StatefulWidget {
//   const DonatePaymentScreen({super.key});

//   @override
//   State<DonatePaymentScreen> createState() => _DonatePaymentScreenState();
// }

// class _DonatePaymentScreenState extends State<DonatePaymentScreen> {
//   final TextEditingController _amountController = TextEditingController();
//   String userEnteredAmount = '';
//   bool paymentProcessing = false;
//   int decorationIndex = 0; // Índice para rastrear la decoración actual
//   late Timer timer; // Temporizador para cambiar la decoración
//   late SharedPreferences prefs;

//   List<String> donationHistory = [];

//   @override
//   void initState() {
//     super.initState();
//     initSharedPreferences();
//     // Inicia el temporizador en el initState para que comience cuando se construya el widget
//     timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
//       // Cambia la decoración cada 5 segundos
//       setState(() {
//         decorationIndex = (decorationIndex + 1) % decorationButtonPay.length;
//       });
//     });
//   }

//   Future<void> initSharedPreferences() async {
//     prefs = await SharedPreferences.getInstance();
//     donationHistory = prefs.getStringList('donation_history') ?? [];
//   }

//   Future<void> saveDonationToHistory(String amount, bool success) async {
//     String status = success ? 'Success' : 'Failed';
//     String donationInfo = '$amount MXN - $status';
//     donationHistory.add(donationInfo);
//     await prefs.setStringList('donation_history', donationHistory);
//   }

//   Future<void> showToast(String message) async {
//     await Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.black,
//       textColor: Colors.white,
//     );
//   }

//   Future<void> handlePayment(
//       Future<void> Function(BuildContext) paymentFunction) async {
//     // Validar el monto aquí
//     int? amount = int.tryParse(userEnteredAmount);
//     if (paymentProcessing) {
//       showToast('Pantalla de cobro en proceso');
//       return;
//     }
//     if (amount == null || amount < 30 || amount > 999) {
//       // Muestra un mensaje de error o toma la acción apropiada
//       Fluttertoast.showToast(
//           msg: "Debes ingresar un monto de \n\$30 MXN hasta \$999 MXN",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           backgroundColor: Colors.black,
//           textColor: Colors.white,
//           fontSize: 16.0);
//       return;
//     }

//     setState(() {
//       paymentProcessing = true;
//     });

//     try {
//       await paymentFunction(context);
//       await saveDonationToHistory(userEnteredAmount, true);
//     } catch (e) {
//       await saveDonationToHistory(userEnteredAmount, false);
//     } finally {
//       setState(() {
//         paymentProcessing = false;
//       });
//     }
//   }

//   List<BoxDecoration> decorationButtonPay = [];

//   @override
//   void dispose() {
//     // Cancela el temporizador al cerrar el widget para evitar pérdida de recursos
//     timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Donaciones",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 35,
//             letterSpacing: 0.3,
//           ),
//         ),
//         leading: Builder(
//           builder: (BuildContext context) {
//             return IconButton(
//               icon: const Icon(
//                 Icons.arrow_back,
//                 size: 30,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             );
//           },
//         ),
//         backgroundColor: Colors.black,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Gap(15),
//                   Container(
//                     decoration: const BoxDecoration(
//                       border: BorderDirectional(
//                         bottom: BorderSide(width: 2),
//                       ),
//                     ),
//                     child: const Text(
//                       "❦ Contribuir con:",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const Gap(15),
//                   TextField(
//                     maxLines: 1,
//                     minLines: 1,
//                     maxLength: 3,
//                     controller: _amountController,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                     ],
//                     decoration: const InputDecoration(
//                       labelText: 'Ingresa la cantidad a Donar (\$ MXN)',
//                       labelStyle: TextStyle(
//                         fontSize: 17,
//                       ),
//                       hintText: 'A partir de \$30 MXN hasta \$999 MXN',
//                       hintStyle: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 16,
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 1.5,
//                         ),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(5),
//                         ),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         userEnteredAmount = value;
//                       });
//                     },
//                   ),
//                   const Gap(20),
//                   GestureDetector(
//                     onTap: () async {
//                       var connectivityResult =
//                           await Connectivity().checkConnectivity();

//                       if (connectivityResult == ConnectivityResult.none) {
//                         showToast(
//                             'Es necesario que estés conectado a Internet para realizar una Donación');
//                       } else {
//                         handlePayment((context) =>
//                             StripePaymentHandle30MXN.stripeMakePayment(
//                                 context, userEnteredAmount));
//                       }
//                     },
//                     child: Container(
//                       height: 50,
//                       width: 319,
//                       // Cambiar decoración del contenedor de manera automática cada 5 segundos
//                       decoration: const BoxDecoration(color: Colors.black87),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Icon(
//                             Icons.monetization_on_outlined,
//                             color: Colors.greenAccent.shade400,
//                           ),
//                           const Text(
//                             "Donar Ahora  💸",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 0.7,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const Gap(10),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
