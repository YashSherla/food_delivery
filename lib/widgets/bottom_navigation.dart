import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/pages/home_page.dart';
import 'package:food_delivery/pages/order_page.dart';
import 'package:food_delivery/pages/profile_page.dart';
import 'package:food_delivery/pages/wallet_page.dart';

class BottomNavigationWidgets extends StatefulWidget {
  const BottomNavigationWidgets({super.key});

  @override
  State<BottomNavigationWidgets> createState() =>
      _BottomNavigationWidgetsState();
}

class _BottomNavigationWidgetsState extends State<BottomNavigationWidgets> {
  int currentTabIndex = 0;
  late List<Widget> pages;
  late Widget currentpage;
  late HomePage home;
  late OrderPage order;
  late WalletPage wallet;
  late ProfilePage profile;
  @override
  void initState() {
    home = const HomePage();
    order = const OrderPage();
    wallet = const WalletPage();
    profile = const ProfilePage();
    pages = [home, order, wallet, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (value) {
          setState(() {
            currentTabIndex = value;
            log(currentTabIndex.toString());
          });
        },
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        items: [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_bag,
            color: Colors.white,
          ),
          Icon(
            Icons.wallet,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            color: Colors.white,
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
