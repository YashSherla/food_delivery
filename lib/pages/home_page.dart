import 'package:flutter/material.dart';
import 'package:food_delivery/pages/details_page.dart';
import 'package:food_delivery/services/database.dart';
import 'package:food_delivery/widgets/gobal_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool pizza = false, burger = false, salad = false, ice = false;
  Stream? getFoodDetails;

  getFood() async {
    getFoodDetails = await Database().getFoodDetails(name: 'Pizza');
    setState(() {});
  }

  @override
  void initState() {
    getFood();
    super.initState();
  }

  Widget showProductItems() {
    return StreamBuilder(
        stream: getFoodDetails,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(
                                      name: data['Name'],
                                      image: data['Img'],
                                      price: data['Price'],
                                      description: data['Details'],
                                    )));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    data['Img'],
                                    height: 150,
                                    width: 150,
                                  ),
                                ),
                                Text(
                                  data['Name'],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                Text(data['Details']),
                                Text(
                                  '\$' + data['Price'].toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  Widget showVerticalProductItems() {
    return StreamBuilder(
        stream: getFoodDetails,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    return Container(
                      margin: EdgeInsets.all(10),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  data['Img'],
                                  height: 140,
                                  width: 140,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      data['Name'],
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Text(
                                    data['Details'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '\$' + data['Price'].toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hello Yash', style: GobalWidgets.mainText()),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.shopping_cart))
                  ],
                ),
                Text('Delicious Food', style: GobalWidgets.mainText()),
                Text(
                  'Discover and Get Great Food',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                showItems(),
                SizedBox(height: 10),
                Container(height: 270, child: showProductItems()),
                SizedBox(height: 10),
                Container(height: 270, child: showVerticalProductItems())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showItems() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () async {
            burger = true;
            salad = false;
            ice = false;
            pizza = false;
            getFoodDetails = await Database().getFoodDetails(name: 'Burger');

            setState(() {});
          },
          child: GobalWidgets().imageConatiner(
              'https://raw.githubusercontent.com/shivam22rkl/Food-Delivery-App-From-Scratch/main/images/burger.png',
              burger ? Colors.black : Colors.white,
              burger ? Colors.white : Colors.black),
        ),
        GestureDetector(
          onTap: () async {
            burger = false;
            salad = false;
            ice = true;
            pizza = false;
            getFoodDetails = await Database().getFoodDetails(name: 'Ice-cream');
            setState(() {});
          },
          child: GobalWidgets().imageConatiner(
              'https://raw.githubusercontent.com/shivam22rkl/Food-Delivery-App-From-Scratch/main/images/ice-cream.png',
              ice ? Colors.black : Colors.white,
              ice ? Colors.white : Colors.black),
        ),
        GestureDetector(
          onTap: () async {
            burger = false;
            salad = false;
            ice = false;
            pizza = true;
            getFoodDetails = await Database().getFoodDetails(name: 'Pizza');
            setState(() {});
          },
          child: GobalWidgets().imageConatiner(
              'https://raw.githubusercontent.com/shivam22rkl/Food-Delivery-App-From-Scratch/main/images/pizza.png',
              pizza ? Colors.black : Colors.white,
              pizza ? Colors.white : Colors.black),
        ),
        GestureDetector(
          onTap: () async {
            burger = false;
            salad = true;
            ice = false;
            pizza = false;
            getFoodDetails = await Database().getFoodDetails(name: 'Salad');
            setState(() {});
          },
          child: GobalWidgets().imageConatiner(
              'https://raw.githubusercontent.com/shivam22rkl/Food-Delivery-App-From-Scratch/main/images/salad.png',
              salad ? Colors.black : Colors.white,
              salad ? Colors.white : Colors.black),
        ),
      ],
    );
  }
}
