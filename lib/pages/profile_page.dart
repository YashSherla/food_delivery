import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_delivery/pages/login.dart';
import 'package:food_delivery/pages/signup_page.dart';
import 'package:food_delivery/services/firebase.dart';
import 'package:food_delivery/services/local_database.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name, email;
  getuserdetails() async {
    name = await SharedPerf().getUserName();
    log(name.toString());
    email = await SharedPerf().getUserEmail();
    setState(() {});
  }

  @override
  void initState() {
    getuserdetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width, 105)),
                  gradient: const LinearGradient(
                    colors: [
                      Colors.orange,
                      Colors.red,
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 140.0, left: 140),
                child: Material(
                  elevation: 15.0,
                  borderRadius: BorderRadius.circular(100),
                  child: const CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(
                        'https://img.freepik.com/premium-photo/blue-circle-with-man-it_745528-17131.jpg?w=1380'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          listTitle(
            "Name",
            name!,
            const Icon(Icons.person),
          ),
          const SizedBox(
            height: 30,
          ),
          listTitle(
            "Email",
            email!,
            const Icon(Icons.mail),
          ),
          const SizedBox(
            height: 30,
          ),
          listTitle(
            "Terms and Conditions",
            "Read Carefully",
            const Icon(Icons.privacy_tip),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
              onTap: () {
                deleteAcc();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpPage()));
              },
              child:
                  listTitleButton("Delete Account", const Icon(Icons.delete))),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
              onTap: () {
                logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: listTitleButton("Logout", const Icon(Icons.logout))),
        ],
      ),
    );
  }
}

Widget listTitle(String title, String subtitle, Icon icon) {
  return Card(
    margin: const EdgeInsets.only(left: 10, right: 20),
    color: Colors.white,
    elevation: 5.0,
    child: ListTile(
      leading: Icon(
        icon.icon,
        color: Colors.black,
        size: 35,
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

Widget listTitleButton(String title, Icon icon) {
  return Card(
    margin: const EdgeInsets.only(left: 10, right: 20),
    color: Colors.white,
    elevation: 5.0,
    child: ListTile(
      leading: Icon(
        icon.icon,
        color: Colors.black,
        size: 35,
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    ),
  );
}
