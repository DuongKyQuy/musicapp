import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dacn/storage/storage_page.dart';
import 'package:flutter/material.dart';
import 'package:dacn/profile/profile_page.dart';

import '../home/home_page.dart';

class indexProfilePage extends StatefulWidget {
  const indexProfilePage({super.key});

  @override
  State<indexProfilePage> createState() => _indexProfilePageState();
}

class _indexProfilePageState extends State<indexProfilePage> {
  int currenrIndex = 0;
  List tabs = [
    const ProfilePage(),
    const storagePage(),
    const HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(

        backgroundColor:  const Color(0xff2c3d5b),
        animationDuration: const Duration(milliseconds: 300),
        items:const [
          Icon(Icons.person),

          Icon(Icons.search),
          ImageIcon(
            AssetImage('assets/image/Home.png'),
          ),
        ],
        onTap: (index){
          setState(() {
            currenrIndex = index;
          });
        },
      ),
      body: tabs[currenrIndex],
    );
  }
}