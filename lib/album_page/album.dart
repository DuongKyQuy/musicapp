import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dacn/album_page/info_album.dart';
import 'package:dacn/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Widget/back_button.dart';



class Album extends StatefulWidget {
  const Album({super.key});

  @override
  State<Album> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<Album> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  Future getdata() async {
    if (currentUser != null && currentUser!.email != null) {
      QuerySnapshot qn = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .collection('Albums')
          .get();
      return qn.docs;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffee9ca7),
      body: Container(
        height: double.infinity,
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
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: backButton(
                            onClick: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => indexPageHome()));
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Text('Album',style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff363434)
                        ),),
                      ),
                      IconButton(
                          onPressed: () async {
                          },
                          iconSize: 40,
                          icon: Image.asset('assets/images/Sort_icon.png',color: Colors.white,)
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        // Sử dụng .data() thay vì .data
                        Map<String, dynamic> AlbumName = snapshot.data[index].data();
                        Map<String, dynamic> AlbumImage = snapshot.data[index].data();

                        for (var key in AlbumName.keys) {
                          var value = AlbumName[key];
                          print('Key: $key, Value: $value');
                        }

                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                            child: Slidable(
                              endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(

                                      onPressed: ((context) async {
                                        if(currentUser != null && currentUser!.email != null){


                                          await FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(currentUser!.email)
                                            .collection('Albums')
                                            .doc(AlbumName['album_name'])
                                            .delete();


                                          final collectionRef = FirebaseFirestore.instance
                                            .collection("Albums")
                                            .doc(AlbumName['album_name'])
                                            .collection(AlbumName['album_name']);

                                          // Xóa tất cả các tài liệu trong subcollection
                                          QuerySnapshot querySnapshot = await collectionRef.get();
                                          for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
                                            await documentSnapshot.reference.delete();
                                          }

                                          // Xóa subcollection chính nó
                                          await collectionRef.parent!.delete();
                                          setState(() {});
                                        }
                                     }),
                                  backgroundColor: Colors.black,
                                  icon: Icons.delete_outline,
                              ),]
                            ),
                            child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context)=>infoAlbum(
                                    album_name:AlbumName["album_name"],
                                    imageUrl: AlbumImage["url_imgAlbum"],

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
                                  height: 90,
                                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  decoration:  BoxDecoration(
                                    // gradient: const LinearGradient(colors: [
                                    //
                                    //   Color(0xff4176A2),
                                    //   Color(0xff73bbc9),
                                    // ],
                                    //     begin: AlignmentDirectional.topCenter,
                                    //     end: Alignment.bottomCenter
                                    // ),
                                    color:Color(0xffffdde1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            AlbumImage["url_imgAlbum"],
                                            fit: BoxFit.cover,
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15,),
                                      Container(
                                        width: 250,
                                        child: Text(AlbumName["album_name"],
                                          maxLines: 1,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis
                                          ),),
                                      ),

                                    ],
                                  ),

                                ),
                              ],
                            ),
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