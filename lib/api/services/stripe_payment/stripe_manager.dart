import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ContextHolder {
  BuildContext context;

  ContextHolder(this.context);
}

class StripePaymentHandle30MXN {
  static Map<String, dynamic>? paymentIntent;

  static Future<void> stripeMakePayment(
      BuildContext context, String amount) async {
    try {
      final contextHolder = ContextHolder(context);
      paymentIntent = await createPaymentIntent(amount, 'MXN');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  billingDetails: const BillingDetails(
                      name: 'YOUR NAME',
                      email: 'YOUREMAIL@gmail.com',
                      phone: 'YOUR NUMBER',
                      address: Address(
                          city: 'YOUR CITY',
                          country: 'YOUR COUNTRY',
                          line1: 'YOUR ADDRESS 1',
                          line2: 'YOUR ADDRESS 2',
                          postalCode: 'YOUR PINCODE',
                          state: 'YOUR STATE')),
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.system,
                  merchantDisplayName: 'CesarTovar'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      await displayPaymentSheet(contextHolder);
    } catch (e) {
      // print(e.toString());
    }
  }

  static Future<void> displayPaymentSheet(ContextHolder contextHolder) async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      // Mostrar dialog de éxito
      showPaymentResultDialog(contextHolder, success: true);
    } on Exception catch (e) {
      if (e is StripeException) {
        // print('Error from Stripe: ${e.error.localizedMessage}');
        // Manejar errores aquí
        showPaymentResultDialog(contextHolder, success: false);
      } else {}
    }
  }

//create Payment
  static createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

//calculate Amount
  static calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}

void showPaymentResultDialog(ContextHolder contextHolder,
    {required bool success}) {
  String title = success ? 'Tikcet Pagado!' : '¡Falló el Pago!';
  String message = success
      ? 'El pago se realizó con éxito.'
      : 'No se completó de manera correcta el pago. Puedes volver a intentarlo de nuevo.';

  QuickAlert.show(
    context: contextHolder.context,
    type: success ? QuickAlertType.success : QuickAlertType.error,
    title: title,
    text: message,
    confirmBtnText: 'De Acuerdo',
    confirmBtnColor: Colors.purple.shade900,
    backgroundColor: Colors.white,
  );
}
