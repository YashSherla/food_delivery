import 'package:flutter/material.dart';
import 'package:food_delivery/pages/signup_page.dart';
import 'package:food_delivery/widgets/onboarding_content.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPages extends StatefulWidget {
  const OnBoardingPages({super.key});

  @override
  State<OnBoardingPages> createState() => _OnBoardingPagesState();
}

class _OnBoardingPagesState extends State<OnBoardingPages> {
  int currentINdex = 0;
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 750,
            child: PageView.builder(
              controller: _pageController,
              itemCount: content.length,
              onPageChanged: (value) {
                setState(() {
                  currentINdex = value;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      content[index].imageUrl,
                      height: 450,
                      width: MediaQuery.of(context).size.width / 1.5,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      content[index].name,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      content[index].description,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SmoothPageIndicator(
              controller: _pageController, count: content.length),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if (currentINdex == content.length - 1) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ));
              }
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut);
            },
            child: Text(
              currentINdex == content.length - 1 ? "Start" : "Next",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50), backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
