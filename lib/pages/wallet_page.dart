import 'dart:convert';
import 'dart:developer';
import 'package:food_delivery/constants/app_constants.dart';
import 'package:food_delivery/services/database.dart';
import 'package:food_delivery/services/local_database.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String? wallet, id;
  int? add;
  TextEditingController amountcontroller = TextEditingController();

  getUserWalletData() async {
    wallet = await SharedPerf().getUserWallet();
    id = await SharedPerf().getUserq();
    setState(() {});
  }

  ontheload() async {
    await getUserWalletData();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wallet == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Wallet',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
                    child: Row(
                      children: [
                        Image.network(
                          'https://raw.githubusercontent.com/shivam22rkl/FoodDeliveryApp-From-Scratch/main/images/wallet.png',
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            Text(
                              "Balance",
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              "\$" + wallet.toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("Add Money",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            makePayment('100');
                          },
                          child: moneytype(
                            price: 100,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                            onTap: () {
                              makePayment('200');
                            },
                            child: moneytype(price: 200)),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            makePayment('500');
                          },
                          child: moneytype(
                            price: 500,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            makePayment('2000');
                          },
                          child: moneytype(
                            price: 2000,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        openEdit();
                        makePayment(amountcontroller.text);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(400, 60),
                        backgroundColor: Color(0xFF008080),
                      ),
                      child: Text(
                        "Add Money",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget moneytype({required int price}) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(2))),
      child: Text(
        "\$" + price.toString(),
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'INR');
      log('payment intent ' + paymentIntent.toString());

      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],

              // applePay: const PaymentSheetApplePay(
              //   merchantCountryCode: '+92',
              // ),
              // googlePay: const PaymentSheetGooglePay(
              //     testEnv: true,
              //     currencyCode: "US",
              //     merchantCountryCode: "+92"),
              style: ThemeMode.dark,
              merchantDisplayName: 'Food Delivery App',
              // displayName: 'Food Delivery App',
            ),
          )
          .then(
            (value) {},
          );

      displayPaymentSheet(amount);
    } catch (e) {
      log(e.toString());
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        "amount": (int.parse(amount) * 100).toString(),
        "currency": currency,
        "payment_method_types[]": "card",
      };
      var res = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      log("This create payment function" + res.body.toString());
      return jsonDecode(res.body);
    } catch (e) {
      log(e.toString());
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      log("this display payment sheet" + amount);
      add = int.parse(wallet!) + int.parse(amount);
      await SharedPerf().saveUserWallet(add.toString());
      Database().updateWallet(id: id!, newFeild: add.toString());
      await getUserWalletData();

      await Stripe.instance.presentPaymentSheet().then(
        (value) async {
          log("payment success");
          log(value.toString());
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              content: Text("Payment Success"),
            ),
          );
          paymentIntent = null;
        },
      ).onError((error, stackTrace) {
        log(error.toString());
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Center(child: Text("Cancelled ")),
              ));
    } catch (e) {
      log(e.toString());
    }
  }

  Future openEdit() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel)),
                        SizedBox(
                          width: 60.0,
                        ),
                        Center(
                          child: Text(
                            "Add Money",
                            style: TextStyle(
                              color: Color(0xFF008080),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Amount"),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38, width: 2.0),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: amountcontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Enter Amount'),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          makePayment(amountcontroller.text);
                        },
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xFF008080),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                            "Pay",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}
