
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dacn/home/played_albumHome.dart';
import 'package:dacn/profile/showplaylist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Widget/back_button.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../home/played_page.dart';



class infoPlaylist extends StatefulWidget {
  String? playlist_name;

  infoPlaylist({
    super.key,
    this.playlist_name,
  });

  @override
  State<infoPlaylist> createState() => _playlistnameState();
}

class _playlistnameState extends State<infoPlaylist> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }


  Future getdata() async {
    if (currentUser != null && currentUser!.email != null) {
      QuerySnapshot qn = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .collection('Playlist')
          .doc('[${widget.playlist_name}]')
          .collection('[${widget.playlist_name}]')
          .get();
      return qn.docs;
    }
  }



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffee9ca7),
                  Color(0xffffdde1),
                ])),
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
                  const SizedBox(height: 30,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: backButton(
                            onClick: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => showPlaylist()));
                            }),
                      ),

                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 30, 130, 0),
                            child: Text('${widget.playlist_name}', style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff363434)
                            ),),
                          ),
                        ],
                      ),
                      // Container(
                      //   margin: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                      //   child: IconButton(onPressed: (){
                      //     Navigator.push(context, MaterialPageRoute(
                      //         // builder: (context)=>edit_PlaylistPage(
                      //             playlist_name: widget.playlist_name
                      //         )
                      //     )
                      //     );
                      //   },
                      //       icon: const Icon(Icons.edit
                      //         ,size: 40,
                      //         color: Colors.white,
                      //       )),
                      // ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        // Sử dụng .data() thay vì .data
                        Map<String, dynamic> songData = snapshot.data[index].data();
                        Map<String, dynamic> DataImage = snapshot.data[index].data();
                        Map<String, dynamic> DataAudio = snapshot.data[index].data();
                        Map<String, dynamic> artisData = snapshot.data[index].data();
                        Map<String, dynamic> lyricData = snapshot.data[index].data();




                        return InkWell(
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Slidable(
                          endActionPane: ActionPane(
                          motion: const StretchMotion(),
                            children: [
                              SlidableAction(

                                onPressed: ((context) async {
                                  if(currentUser != null && currentUser!.email != null){


                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(currentUser!.email)
                                        .collection('Playlist')
                                        .doc('[${widget.playlist_name}]')
                                        .collection('[${widget.playlist_name}]')
                                        .doc(songData['song_name'])
                                        .delete();


                                    await FirebaseFirestore.instance
                                        .collection("Playlist")
                                        .doc(currentUser!.email)
                                        .collection('[${widget.playlist_name}]')
                                        .doc(songData['song_name'])
                                        .delete();
                                    setState(() {});
                                  }
                                }),
                                backgroundColor: Colors.black,
                                icon: Icons.delete_outline,
                              ),
                              SlidableAction(

                                onPressed: ((context) async {
                                  final url = Uri.parse(songData['audioUrl']);
                                  final response = await http.get(url);
                                  final bytes = response.bodyBytes;

                                  final temp = await getTemporaryDirectory();
                                  final path = '${temp.path}/${songData['song_name']}.mp3';
                                  File(path).writeAsBytesSync(bytes);

                                  Share.shareFiles([path], text:'${songData['song_name']}' );


                                }),
                                backgroundColor: Colors.white,
                                icon: Icons.share,
                              ),


                            ]
                          ),
                          child:Container(
                                width: 400,
                                height: 90,
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                decoration:  BoxDecoration(
                                  color: const Color(0xffffdde1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          DataImage["imageUrl"],
                                          fit: BoxFit.cover,
                                          width: 80,
                                          height: 80,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            songData["song_name"],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            artisData["artist_name"],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                          ),
                                          child: ElevatedButton(
                                              onPressed: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => playedPage(
                                                      song_name: songData["song_name"],
                                                      imageUrl: DataImage["imageUrl"],
                                                      audioUrl: DataAudio["audioUrl"],
                                                      artist_name: artisData["artist_name"],
                                                      lyric: lyricData["lyrics"],

                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: const CircleBorder(), //<-- SEE HERE
                                                  backgroundColor: Colors.black,
                                                  shadowColor: Color(0xff00000040)
                                              ),

                                              child: const Icon(Icons.play_arrow_rounded, color: Colors.white,)),
                                        ),


                                      ],
                                    )
                                  ],
                                ),
                              ),
                          ),
                            ],
                          ),
                        );


                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>  playedAlbumsHome(
                                  album_name: currentUser!.email,
                                  collection: 'Playlist',
                                  collection2: '[${widget.playlist_name}]',
                                ),
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(), //<-- SEE HERE
                              padding: const EdgeInsets.all(20),
                              backgroundColor: Colors.black,
                            ),

                            child: const Icon(Icons.play_arrow_rounded)),
                      ),
                    ],
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