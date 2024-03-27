import 'package:dacn/Widget/button_outline.dart';
import 'package:dacn/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Widget/button_widget.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xff64CCC5),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Color(0xffee9ca7),
              Color(0xffffdde1),
            ])
        ),

        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 180),
              Center(
                  child: Image.asset(
                'assets/images/tachnen1.png',
                color: const Color(0xffFFF0F5),
              )),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Music is what feelings sound like.',
                style: TextStyle(
                  // color: Colors.grey[800],

                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ButtonOutlineWidget(
                  text: 'Sign In',
                  onClick: () {
                    Navigator.of(context).pushNamed('/login');
                  }),
              const SizedBox(height: 20),
              ButtonWidget(
                  text: 'Sign Up',
                  onClick: () {
                    Navigator.of(context).pushNamed('/register');
                  }),
              const SizedBox(
                height: 250,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
