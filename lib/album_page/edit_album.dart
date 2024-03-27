import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dacn/album_page/album.dart';

import '../Widget/back_button.dart';
import '../storage/storage_service.dart';

class edit_AlbumPage extends StatefulWidget {
  String? album_name;
  edit_AlbumPage({
    super.key,
    this.album_name
  });
  static const routeName = 'notification';

  @override
  State<edit_AlbumPage> createState() => _edit_AlbumPageState();
}

class _edit_AlbumPageState extends State<edit_AlbumPage> {
  StorageService service = StorageService();
  final firestoreInstance = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _playlistname = TextEditingController() ;
  String name = '';
  String playlistname = '';
  String imageName = '';
  String? imagePath = '';
  String? image_url;






  Stream<QuerySnapshot> getdata() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .collection('songs').snapshots();
  }
  void getImg() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .collection('Albums')
        .doc(widget.album_name)
        .get();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDAFFFB),
      body: Column(
        children: [
          const SizedBox(height: 60,),
          Row(
            children: [
              Container(
                child: backButton(
                    onClick: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Album()));
                    }),
              ),

            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getdata(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('May be something wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    bool isChecked = data['value'] ?? false;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 50,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.network(data["imageUrl"], fit: BoxFit.cover),
                                ),
                                Container(
                                  width:250 ,
                                  child: Text(data['song_name'],
                                    maxLines: 1
                                    ,style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis
                                    ),),
                                ),
                              ],
                            ),
                            value: isChecked,
                            fillColor: MaterialStateProperty.resolveWith((states) {
                              if (!states.contains(MaterialState.selected)) {
                                return Colors.white;
                              }
                              return null;
                            }),
                            onChanged: (bool? value) async {
                              await FirebaseFirestore.instance.
                              collection('Users')
                                  .doc(currentUser!.email)
                                  .collection('songs')
                                  .doc(document.id).update(
                                  {'value': value}
                              );

                              print(data);
                              if(currentUser != null && currentUser!.email != null){
                                if (value == true) {

                                  await FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(currentUser!.email)
                                      .collection('Albums')
                                      .doc(widget.album_name)
                                      .collection('${widget.album_name}')
                                      .doc(data['song_name'])
                                      .set({
                                    'song_name': data['song_name'],
                                    'artist_name': data['artist_name'],
                                    'audioUrl': data['audioUrl'],
                                    'imageUrl': data["imageUrl"],
                                    'value': false,
                                    'status':true,
                                  });


                                  await FirebaseFirestore.instance
                                      .collection("Albums")
                                      .doc(widget.album_name)
                                      .collection(widget.album_name.toString())
                                      .doc(data['song_name'])
                                      .set({
                                    'song_name': data['song_name'],
                                    'artist_name': data['artist_name'],
                                    'audioUrl': data['audioUrl'],
                                    'imageUrl': data["imageUrl"],
                                    'value': false,
                                    'status':true,
                                  });
                                }
                              }

                            },
                          ),

                        ],
                      ),

                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}