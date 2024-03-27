import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dacn/home/played_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dacn/home/home_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Widget/back_button.dart';

class storagePage extends StatefulWidget {
  const storagePage({super.key});

  @override
  State<storagePage> createState() => _storagePageState();
}

class _storagePageState extends State<storagePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future getdata() async {
    if (currentUser != null && currentUser!.email != null) {
      QuerySnapshot qn = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .collection('songs')
          .get();
      return qn.docs;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffee9ca7),
              Color(0xffffdde1),
            ]),
        ),
        child: FutureBuilder(
          future: getdata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: backButton(onClick: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => indexPageHome()));
                        }),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
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

                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => playedPage(
                                            song_name: songData["song_name"],
                                            imageUrl: DataImage["imageUrl"],
                                            audioUrl: DataAudio["audioUrl"],
                                            artist_name:
                                                artisData["artist_name"],
                                            lyric: lyricData["lyrics"],
                                          )));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Slidable(
                                  endActionPane: ActionPane(
                                      motion: const StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: ((context) async {
                                            if (currentUser != null &&
                                                currentUser!.email != null) {
                                              await FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(currentUser!.email)
                                                  .collection('songs')
                                                  .doc(songData["song_name"])
                                                  .delete();

                                              await FirebaseFirestore.instance
                                                  .collection('songs')
                                                  .doc(songData["song_name"])
                                                  .delete();

                                              setState(() {});
                                            }
                                          }),
                                          backgroundColor: Colors.redAccent,
                                          icon: Icons.delete_outline,
                                        ),
                                      ]),
                                  child: Container(
                                    width: 400,
                                    height: 70,
                                    margin: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    decoration: BoxDecoration(
                                      color: Color(0xffffdde1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          height: 50,
                                          width: 50.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Image.network(
                                              DataImage["imageUrl"],
                                              fit: BoxFit.cover),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          width: 250,
                                          child: Text(
                                            songData["song_name"],
                                            maxLines: 1,
                                            style:  TextStyle(
                                                color: Colors.grey[850],
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
