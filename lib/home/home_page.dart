import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dacn/home/played_page.dart';
import 'package:dacn/home/searchPage.dart';
import 'package:dacn/home/show_album.dart';
import 'package:dacn/home/show_artist.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dacn/profile/profile_page.dart';

class indexPageHome extends StatefulWidget {
  const indexPageHome({super.key});

  @override
  State<indexPageHome> createState() => _indexPageHometate();
}

class _indexPageHometate extends State<indexPageHome> {
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
        backgroundColor: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          ImageIcon(
            AssetImage('assets/images/Home.png'),
          ),
          Icon(Icons.search),
          Icon(Icons.person)
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: tabs[currentIndex],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int myCurrentIndex = 0;

  Future getdata() async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('songs')
        .orderBy('song_name', descending: true)
        .get();
    return qn.docs;
  }

  Future getArtist() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection('Users').get();
    return qn.docs;
  }

  Future getAlbum() async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('Albums')
        .orderBy('album_name', descending: true)
        .get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    int index = 1;
    final items = <Widget>[
      const ImageIcon(
        AssetImage('assets/image/Home.png'),
      ),
      const Icon(Icons.search),
      const Icon(Icons.person)
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xffffdde1),
        body: Container(
          height: double.infinity,
          // decoration: const BoxDecoration(
          //     gradient: LinearGradient(colors: [
          //       Color(0xff454442),
          //       // Color(0xff2c3d5b),
          //     ])
          // ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 45, 20, 0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImageIcon(
                        AssetImage('assets/images/tachnen1.png'),
                        size: 78,
                        color: Colors.black
                      ),
                      // Text('Sound', style: TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold )),
                      Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            size: 30,
                            color: Colors.black,
                          ),
                          // SizedBox(width: 10),
                          // Icon(Icons.settings, size: 30,color: Color(0xff176B87)),
                        ],
                      )
                    ],
                  ),
                ),
                FutureBuilder(
                  future: getdata(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'New Songs',
                                style: TextStyle(
                                  color: Color(0xff593B3F),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.hasData
                                  ? min(10, snapshot.data.length)
                                  : 0,
                              itemBuilder: (context, index) {
                                // Sử dụng .data() thay vì .data
                                Map<String, dynamic> songData =
                                    snapshot.data[index].data();
                                Map<String, dynamic> DataImage =
                                    snapshot.data[index].data();
                                Map<String, dynamic> DataAudio =
                                    snapshot.data[index].data();
                                Map<String, dynamic> artisData =
                                    snapshot.data[index].data();
                                Map<String, dynamic> lyricData =
                                    snapshot.data[index].data();
                                return Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => playedPage(
                                                song_name:
                                                    songData["song_name"],
                                                imageUrl: DataImage["imageUrl"],
                                                audioUrl: DataAudio["audioUrl"],
                                                artist_name:
                                                    artisData["artist_name"],
                                                lyric: lyricData["lyrics"],
                                              ),
                                            ));
                                      },
                                      child: Container(
                                        width: 220,
                                        height: 70,
                                        margin: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 20),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffee9ca7),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: ClipOval(
                                                child: Image.network(
                                                  DataImage["imageUrl"],
                                                  fit: BoxFit.cover,
                                                  height: 60,
                                                  width: 60.0,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width: 120,
                                              child: Text(
                                                songData["song_name"],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                FutureBuilder(
                  future: getArtist(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Popular Artists',
                                style: TextStyle(
                                    color: Color(0xff593B3F),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.hasData
                                  ? min(10, snapshot.data.length)
                                  : 0,
                              itemBuilder: (context, index) {
                                // Sử dụng .data() thay vì .data
                                Map<String, dynamic> avtData =
                                    snapshot.data[index].data();
                                Map<String, dynamic> username =
                                    snapshot.data[index].data();
                                Map<String, dynamic> email =
                                    snapshot.data[index].data();
                                Map<String, dynamic> role =
                                    snapshot.data[index].data();
                                bool checkrole = role['role'];
                                if (checkrole == true) {
                                  return Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      showArtist(
                                                          artist_name: username[
                                                              "username"],
                                                          imageUrl:
                                                              avtData["avt"],
                                                          email:
                                                              email['email'])));
                                        },
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 20, 0, 10),
                                                child: ClipOval(
                                                  child: Image.network(
                                                    avtData["avt"],
                                                    fit: BoxFit.cover,
                                                    height: 150,
                                                    width: 150.0,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 25),
                                              Container(
                                                margin: const EdgeInsets.fromLTRB(
                                                    22, 0, 0, 20),
                                                // child: Center(
                                                child: Text(
                                                  username["username"],
                                                  style: const TextStyle(
                                                    color: Color(0xff99656D),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    // fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                FutureBuilder(
                  future: getAlbum(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Album Hot',
                                  style: TextStyle(
                                      color: Color(0xff593B3F),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Container(
                              height: 290,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.hasData
                                    ? min(10, snapshot.data.length)
                                    : 0,
                                itemBuilder: (context, index) {
                                  // Sử dụng .data() thay vì .data
                                  Map<String, dynamic> album_name =
                                      snapshot.data[index].data();
                                  Map<String, dynamic> url_imgAlbum =
                                      snapshot.data[index].data();
                                  return Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      showAlbum(
                                                        album_name: album_name[
                                                            "album_name"],
                                                        imageUrl: url_imgAlbum[
                                                            "url_imgAlbum"],
                                                      )));
                                        },
                                        child: Container(
                                          width: 180,
                                          height: 230,
                                          margin: const EdgeInsets.fromLTRB(
                                              20, 0, 0, 30),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                              gradient: const LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    Color(0xffffdde1),
                                                    Color(0xffee9ca7),
                                                  ])),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    url_imgAlbum[
                                                        "url_imgAlbum"],
                                                    fit: BoxFit.cover,
                                                    height: 180,
                                                    width: 180.0,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                width: 180,
                                                child: Center(
                                                  child: Text(
                                                    album_name["album_name"],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
