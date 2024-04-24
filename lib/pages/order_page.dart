import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_delivery/services/database.dart';
import 'package:food_delivery/services/local_database.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    super.key,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Stream? foodcart;
  String? id, wallet;
  int total = 0;

  getCartFood() async {
    id = await SharedPerf().getUserq();

    wallet = await SharedPerf().getUserWallet();

    log("This is id" + id!);

    log("This is wallet" + wallet!);

    setState(() {});
  }

  onload() async {
    await getCartFood();

    if (id != null) {
      foodcart = await Database().getFoodCart(id: id!);
      setState(() {});
      log("Food cart stream initialized.");
    } else {
      log("ID is null, can't fetch food cart.");
    }
  }

  @override
  void initState() {
    onload();
    super.initState();
  }

  Widget showProductItems() {
    return StreamBuilder(
      stream: foodcart,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child:
                CircularProgressIndicator(), // Display a loading spinner while waiting for data.
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
                "Error: ${snapshot.error}"), // Display error message if there's an error.
          );
        }

        if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
          var docs = snapshot.data.docs;
          // Safely access the data if it's not null.
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index];
              total = total + int.parse(data['price']);
              log(total.toString());
              return Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 90,
                        width: 40,
                        child: Center(
                          child: Text(
                            data['qty'].toString(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        "img/salad2.png",
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name'],
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${data['price'].toString()}", // Ensure that price is displayed with a dollar sign.
                            style: const TextStyle(
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
          );
        } else {
          return const Center(
            child: Text(
                "No products available."), // Show a message when there's no data.
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Center(
                child: Text(
                  'Food Order',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: showProductItems()),
              const Spacer(),
              const Divider(
                color: Colors.black,
              ),
              Row(
                children: [
                  Text("Total Price",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      )),
                  Spacer(),
                  Text(
                    "\$" + total.toString(),
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fixedSize: const Size(300, 50),
                    backgroundColor: Colors.black),
                onPressed: () async {
                  int amount = int.parse(wallet.toString()) - total;
                  await SharedPerf().saveUserWallet(amount.toString());
                  Database().updateWallet(id: id!, newFeild: amount.toString());
                },
                icon: const Icon(
                  Icons.check_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'CHECKOUT',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
