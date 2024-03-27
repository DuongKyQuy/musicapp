import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dacn/home/searchPage.dart';
import 'package:dacn/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:dacn/storage/storage_page.dart';

import 'home_page.dart';

class indexPage extends StatefulWidget {
  const indexPage({super.key});

  @override
  State<indexPage> createState() => _indexPageState();
}

class _indexPageState extends State<indexPage> {
  int currentIndex = 0;
  List tabs = [
    const HomePage(),
    const searchPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(

        backgroundColor:  Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        items:const [
          ImageIcon(
            AssetImage('assets/images/Home.png'),
          ),
          Icon(Icons.search),
          Icon(Icons.person)
        ],
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: tabs[currentIndex],
    );
  }
}