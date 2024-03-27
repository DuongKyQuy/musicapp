import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dacn/home/home_page.dart';
import 'package:dacn/profile/info_playlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../Widget/back_button.dart';



class showPlaylist extends StatefulWidget {
  const showPlaylist({super.key});

  @override
  State<showPlaylist> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<showPlaylist> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _playlistname = TextEditingController();
  String playlistname = '';
  String name = '';


  void submit() async {
    final enteredName = _playlistname.text;
    if (enteredName.isNotEmpty) {
      setState(() {
        playlistname = enteredName;
      });


      Navigator.of(context).pop(enteredName);

    }
  }
  Future<String?> openDialog()=>showDialog<String>(context: context,
    builder: (context)=>AlertDialog(
      title: const Text(' Playlist Name'),
      content: SizedBox(
        height: 150,
        child: Column(
          children: [
            TextField(
              controller: _playlistname,
              decoration: const InputDecoration(
                  hintText: 'Enter your Playlist Name'
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: (){

          submit();

        }, child: const Text('Submit'))
      ],
    ),);

  Future getdata() async {
    if (currentUser != null && currentUser!.email != null) {
      QuerySnapshot qn = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .collection('Playlist')
          .get();
      return qn.docs;
    }
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
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: backButton(
                            onClick: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => indexPageHome()));
                            }),
                      ),
                      Container(
                        margin:const  EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: const Text('Playlist',style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff363434)
                        ),),
                      ),
                      IconButton(
                          onPressed: () async {
                            final name = await openDialog();
                            if (name == null || name.isEmpty) return;
                            setState(() {
                              this.name = name;
                            });
                            playlistname = name;
                            print(playlistname);
                            await FirebaseFirestore.instance
                                .collection("Users")
                                .doc(currentUser!.email)
                                .collection('Playlist')
                                .doc('[$playlistname]')
                                .set({
                              'playlist_name' : playlistname,
                            });
                            await FirebaseFirestore.instance
                                .collection("Users")
                                .doc(currentUser!.email)
                                .collection('Playlist')
                                .doc('[$playlistname]')
                                .collection('[$playlistname]')
                                .doc('intro')
                                .set(
                                {
                                  'song_name': 'intro',
                                  // quy
                                  'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/dacnmusic.appspot.com/o/Avatars%2Fq.jpg?alt=media&token=459e2c4a-8857-4cce-9ad2-6aa6248b8f34',
                                  'audioUrl': 'https://firebasestorage.googleapis.com/v0/b/dacnmusic.appspot.com/o/Musics%2F1%20second%20of%20silence%20(The%20Beginning).mp3?alt=media&token=93fc3729-6096-4ba9-9ca8-e988240cd8f6',
                                  'artist_name': 'intro',
                                  'lyrics': ''
                                });

                            await FirebaseFirestore.instance
                                .collection("Playlist")
                                .doc(currentUser!.email)
                                .collection('[$playlistname]')
                                .doc('intro')
                                .set({
                              'playlist_name' : '[Default]',
                            });

                            await FirebaseFirestore.instance
                                .collection("Playlist")
                                .doc(currentUser!.email)
                                .collection('[$playlistname]')
                                .doc('intro')
                                .set(
                                {

                                  'song_name': 'intro',
                                  // quy
                                  'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/dacnmusic.appspot.com/o/Avatars%2Fq.jpg?alt=media&token=459e2c4a-8857-4cce-9ad2-6aa6248b8f34',
                                  'audioUrl': 'https://firebasestorage.googleapis.com/v0/b/dacnmusic.appspot.com/o/Musics%2F1%20second%20of%20silence%20(The%20Beginning).mp3?alt=media&token=93fc3729-6096-4ba9-9ca8-e988240cd8f6',
                                  'artist_name': 'intro',
                                  'lyrics': ''
                                });

                            setState(() {

                            });
                          },
                          iconSize: 40,
                          icon: const Icon(Icons.add, color: Colors.white,)                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        // Sử dụng .data() thay vì .data
                        Map<String, dynamic> playlist_name = snapshot.data[index].data();


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
                                            .collection('Playlist')
                                            .doc('[${playlist_name["playlist_name"]}]')
                                            .delete();


                                        final collectionRef = FirebaseFirestore.instance
                                            .collection("Playlist")
                                            .doc(currentUser!.email)
                                            .collection('[${playlist_name["playlist_name"]}]');

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
                                    builder: (context)=>infoPlaylist(
                                      playlist_name:playlist_name["playlist_name"],


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
                                      color: Color(0xffffdde1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),

                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                        ),
                                        const SizedBox(width: 15,),
                                        Text(playlist_name["playlist_name"],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500
                                          ),),

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