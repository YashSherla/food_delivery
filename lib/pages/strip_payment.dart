// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// Map<String, dynamic>? paymentIntent;

// Future<void> makePayment(String amount) async {
//   try {
//     paymentIntent = await createPaymentIntent(amount, 'INR');
//     //Payment Sheet
//     await Stripe.instance
//         .initPaymentSheet(
//             paymentSheetParameters: SetupPaymentSheetParameters(
//                 paymentIntentClientSecret: paymentIntent!['client_secret'],
//                 // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
//                 // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
//                 style: ThemeMode.dark,
//                 merchantDisplayName: 'Adnan'))
//         .then((value) {});

//     ///now finally display payment sheeet
//     displayPaymentSheet(amount);
//   } catch (e, s) {
//     print('exception:$e$s');
//   }
// }

// displayPaymentSheet(String amount) async {
//   try {
//     await Stripe.instance.presentPaymentSheet().then((value) async {
//       // ignore: use_build_context_synchronously
//       showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       children: const [
//                         Icon(
//                           Icons.check_circle,
//                           color: Colors.green,
//                         ),
//                         Text("Payment Successfull"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ));
//       // ignore: use_build_context_synchronously

//       paymentIntent = null;
//     }).onError((error, stackTrace) {
//       print('Error is:--->$error $stackTrace');
//     });
//   } on StripeException catch (e) {
//     print('Error is:---> $e');
//     showDialog(
//         context: context,
//         builder: (_) => const AlertDialog(
//               content: Text("Cancelled "),
//             ));
//   } catch (e) {
//     print('$e');
//   }
// }

// //  Future<Map<String, dynamic>>
// createPaymentIntent(String amount, String currency) async {
//   try {
//     Map<String, dynamic> body = {
//       'amount': "2000",
//       'currency': currency,
//       'payment_method_types[]': 'card'
//     };

//     var response = await http.post(
//       Uri.parse('https://api.stripe.com/v1/payment_intents'),
//       headers: {
//         'Authorization': 'Bearer $secretKey',
//         'Content-Type': 'application/x-www-form-urlencoded'
//       },
//       body: body,
//     );
//     // ignore: avoid_print
//     print('Payment Intent Body->>> ${response.body.toString()}');
//     return jsonDecode(response.body);
//   } catch (err) {
//     // ignore: avoid_print
//     print('err charging user: ${err.toString()}');
//   }
// }
