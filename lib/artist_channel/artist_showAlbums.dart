import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dacn/album_page/edit_album.dart';
import 'package:dacn/home/home_page.dart';
import 'package:dacn/home/played_albumHome.dart';
import 'package:flutter/material.dart';

import '../Widget/back_button.dart';
import '../home/played_page.dart';


class artistshowAlbum extends StatefulWidget {
  String? email,album_name,imageUrl;

  artistshowAlbum({
    super.key,

    this.album_name,
    this.imageUrl,
    this.email,
  });

  @override
  State<artistshowAlbum> createState() => _artistshowAlbumState();
}

class _artistshowAlbumState extends State<artistshowAlbum> {

  @override
  void initState() {
    super.initState();
  }


  Future getdata() async {
    print(widget.email);
    print(widget.album_name);
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.email)
        .collection('Albums')
        .doc('${widget.album_name}')
        .collection('${widget.album_name}')
        .get();
    return qn.docs;
  }



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xffee9ca7),
          ),
          child:SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(height: 30,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: backButton(
                          onClick: () {
                            Navigator.pop(context);
                          }),
                    ),


                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                      child: IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=>edit_AlbumPage(
                                album_name: widget.album_name
                            )
                        )
                        );
                      },
                          icon: const Icon(Icons.favorite_outline
                            ,size: 40,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Text(widget.album_name!,
                          style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white ,
                              fontWeight: FontWeight.w500
                          ),
                          maxLines: 1,
                        ),
                      ),
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
                      return Stack(
                        children: [

                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 170, 0, 0),
                            padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                            height: 700,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xffffdde1),
                                  Color(0xffee9ca7),
                                ],
                                    begin: AlignmentDirectional.topCenter,
                                    end: Alignment.bottomCenter
                                ),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight:  Radius.circular(20),)
                            ),
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
                                return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context)=>playedPage(
                                            song_name:songData["song_name"],
                                            imageUrl: DataImage["imageUrl"],
                                            audioUrl: DataAudio["audioUrl"],
                                            artist_name: artisData["artist_name"],
                                            lyric: lyricData["lyrics"],
                                          )
                                      )
                                      );
                                    },
                                    child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 400,
                                          height: 70,
                                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                          decoration:  BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(4)
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.all(10),
                                                height: 50,
                                                width: 50.0,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Image.network(DataImage["imageUrl"], fit: BoxFit.cover),
                                              ),
                                              const SizedBox(width: 15,),
                                              Text(songData["song_name"],
                                                style:  TextStyle(
                                                    color: Colors.grey[850],
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    overflow: TextOverflow.ellipsis
                                                ),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                );
                              },
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: -50,
                            child: SizedBox(
                              width: 400,
                              height: 400,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: ClipRRect(
                                        borderRadius:  BorderRadius.circular(20),
                                        child: Image.network(
                                          widget.imageUrl!, fit: BoxFit.cover, width: 200,height: 200,
                                        )),
                                  ),

                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 20,
                            top: 110,
                            child:    Container(
                              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>  playedAlbumsHome(
                                        album_name: widget.album_name,
                                        collection: 'Albums',
                                        collection2:  widget.album_name,
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
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          )
      ),
    );
  }

}