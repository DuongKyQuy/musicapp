import 'dart:io';

import 'package:dacn/home/home_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widget/back_button.dart';
import '../storage/storage_service.dart';

class add_AlbumPage extends StatefulWidget {
  const add_AlbumPage({super.key});
  static const routeName = 'notification';

  @override
  State<add_AlbumPage> createState() => _add_AlbumPageState();
}

class _add_AlbumPageState extends State<add_AlbumPage> {
  StorageService service = StorageService();
  final firestoreInstance = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _playlistname = TextEditingController() ;
  String name = '';
  String playlistname = '';
  String imageName = '';
  String? imagePath = '';
  String? image_url;

  Future _btnUploadImages() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any
    );
    if(result == null) {
      print('Error: No file selected');
    } else {
      final path = result.files.single.path;
      imagePath = path;
      final fileName = result.files.single.name;
      setState(() {
        imageName = fileName; // Cập nhật imageName và giao diện người dùng
      });
    }
  }

  finalUpload() async {
    // Upload tệp lên Firebase Storage
    var uploadFileImage = service.uploadFileImgAlbum(imageName, imagePath!);
    Reference storageRef = FirebaseStorage.instance.ref('ImagesAlbum').child(
        imageName);
    final UploadTask uploadTask = storageRef.putFile(File(imagePath!));

    // Lấy URL sau khi tải lên hoàn thành
    await uploadFileImage.whenComplete(() async {
      final url = await storageRef.getDownloadURL();
      image_url = url;
      print('URL của tệp: $image_url');
    });
  }
  Future<String?> openDialog()=>showDialog<String>(context: context,
      builder: (context)=>AlertDialog(
        title: const Text('Add Album'),
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              TextField(
                controller: _playlistname,
                decoration: const InputDecoration(
                    hintText: 'Enter your Album name'
                ),
              ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: SizedBox(
                  width: 100,
                  child: Text( 'Image: $imageName' ,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const  TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: ElevatedButton(
                    onPressed: (){_btnUploadImages();},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      // side: const BorderSide(color: Colors.white, width: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Upload',
                      style: TextStyle(fontSize: 18, color: Color(0xffee9ca7),fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ],
      ),),
      actions: [
        TextButton(onPressed: (){
          submit();
        }, child: const Text('Submit'))
      ],
    ),);

  void submit() async {
    final enteredName = _playlistname.text;
    if (enteredName.isNotEmpty) {
      setState(() {
        playlistname = enteredName;
      });
      await finalUpload();
      Navigator.of(context).pop(enteredName);
    }
  }
  Stream<QuerySnapshot> getdata() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .collection('songs').snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffee9ca7),
      body: Column(
        children: [
          const SizedBox(height: 50,),
          Row(
            children: [
              Container(
                child: backButton(
                    onClick: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => indexPageHome()));
                    }
                ),
              ),

            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () async {
                    },
                    iconSize: 40,
                    icon: Image.asset('assets/images/Sort_icon.png', color: Colors.black,)
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
                    },
                    iconSize: 70,
                    icon: Image.asset('assets/images/Add.png', color:Colors.black)
                ),
              ],
            ),
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
                                    // color: Color(0xff9BBEC8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.network(data["imageUrl"], fit: BoxFit.cover),
                                ),
                                Container(
                                  width:250,
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
                            onChanged: (bool? value) async{
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(currentUser!.email)
                                  .collection('songs').doc(document.id).update(
                                  {'value': value}
                              );

                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(currentUser!.email)
                                  .collection("Albums")
                                  .doc(_playlistname.text)
                                  .set({
                                'album_name': _playlistname.text,
                                'url_imgAlbum': image_url,
                              });

                              await FirebaseFirestore.instance
                                  .collection("Albums")
                                  .doc(_playlistname.text)
                                  .set({
                                'album_name': _playlistname.text,
                                'url_imgAlbum': image_url,
                              });

                              print(data);
                              if(currentUser != null && currentUser!.email != null){
                                if (value == true) {
                                  await FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(currentUser!.email)
                                      .collection('Albums')
                                      .doc(_playlistname.text)
                                      .collection(_playlistname.text)
                                      .doc(data['song_name'])
                                      .set({
                                    'song_name': data['song_name'],
                                    'artist_name': data['artist_name'],
                                    'audioUrl': data['audioUrl'],
                                    'imageUrl': image_url,
                                    'lyrics':data['lyrics'],
                                    'value': false,
                                  });


                                  await FirebaseFirestore.instance
                                      .collection("Albums")
                                      .doc(_playlistname.text)
                                      .collection(_playlistname.text)
                                      .doc(data['song_name'])
                                      .set({
                                    'song_name': data['song_name'],
                                    'artist_name': data['artist_name'],
                                    'audioUrl': data['audioUrl'],
                                    'imageUrl': image_url,
                                    'lyrics':data['lyrics'],
                                    'value': false,
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