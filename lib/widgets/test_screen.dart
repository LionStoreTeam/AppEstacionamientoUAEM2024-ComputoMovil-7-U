import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

Map<String, dynamic>? paymentIntent;

class DetallesCarrito extends StatefulWidget {
  const DetallesCarrito({super.key});

  @override
  State<DetallesCarrito> createState() => _DetallesCarritoState();
}

class _DetallesCarritoState extends State<DetallesCarrito>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      // El State funciona como TickerProvider al utilizar el mixin SingleTickerProviderStateMixin
      vsync: this,
      // Duración de 2 segundo
      duration: const Duration(seconds: 2),
    );

    // Definiemos el valor de inicio y fin para trasladar el cuadro de izquierda a derecha
    animation = Tween(begin: -20.0, end: 20.0).animate(controller)
      ..addListener(() {
        // Para indicar al widget que redibuje los elementos
        setState(() {});
      })
      ..addStatusListener((status) {
        // Al completar de izquierda a derecha retrocedemos
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }

        // Al completar de derecha a izquierda avanzamos
        if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    // Iniciamos la animación
    controller.forward();
  }

  double precioTotal = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // width: 300,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Gap(5),
                      Text(
                        "Puedes deslizar a la izquierda para eliminar",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(10),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 193,
        child: Container(
          decoration: const BoxDecoration(
              // border: Border.symmetric(
              //   horizontal: BorderSide(
              //     color: Color.fromARGB(248, 84, 159, 104),
              //   ),
              // ),
              color: Colors.blue),
          // color: const Color.fromARGB(182, 78, 82, 68),
          // child: Transform.translate(
          // Trasladamos el cuadro segun no indique el valor de la animación
          // offset: Offset(animation.value, 5),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(
                  'Total: 50}',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow.shade500,
                  ),
                ),
                Transform.translate(
                  // Trasladamos el cuadro segun no indique el valor de la animación
                  offset: Offset(animation.value, 5),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.amber),
                      splashFactory:
                          InkSparkle.constantTurbulenceSeedSplashFactory,
                    ),
                    onPressed: () => makePayment(context),
                    child: const Text(
                      'Comprar Libros',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  // Payment Methods
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        "amount": calculateAmount(amount).toString(),
        "currency": currency,
        'payment_method_types[]': 'card'
      };
      http.Response response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          "Authorization":
              "Bearer sk_test_51OEgmREA1R6Zi47nGn8RB0KLCCntx3tQKYpqU3XdyiGLKQG5Q7xhDLRKHw6l00V7GPx9NtBNcwyKzMnRk64rOnbw00r63V7YgY",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );
      log('Payment Intent Body->>> ${response.body.toString()}');
      return json.decode(response.body);
    } catch (err) {
      log('err charging user: ${err.toString()}');
    }
  }

  void makePayment(BuildContext context) async {
    try {
      paymentIntent = await createPaymentIntent('800', 'MXN');

      if (paymentIntent != null) {
        var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "MX",
          currencyCode: "MXN",
          testEnv: true,
        );
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!["client_secret"],
            style: ThemeMode.system,
            merchantDisplayName: "Cesar Tovar",
            googlePay: gpay,
          ),
        );
        displayPaymentSheet();
        // Mostrar alerta de éxito después de que el pago se haya completado
      } else {
        // print("Error: paymentIntent es nulo");
      }
    } catch (e) {
      // print("Error: $e");
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      // print("Donde");
      // ignore: use_build_context_synchronously
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Pago completado con éxito',
      );
    } catch (e) {
      // print("Failed");
      // ignore: use_build_context_synchronously
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Ha ocurrido un error al completar el pago.',
      );
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
