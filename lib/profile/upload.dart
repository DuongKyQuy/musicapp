import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dacn/storage/storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Widget/back_button.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _songName = TextEditingController();
  final TextEditingController _artistName = TextEditingController();
  final TextEditingController _lyrics = TextEditingController();

  StorageService service = StorageService();
  final firestoreInstance = FirebaseFirestore.instance;

  String? imagePath = '';
  String imageName = '';

  String? audioPath = '';
  String audioName  = '';
  late String audio_url ;
  late String image_url;
  bool _loading = false;

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

  Future _btnUploadAudio() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any
    );
    if(result == null) {
      print('Error: No file selected');
    } else {
      final path = result.files.single.path;
      audioPath = path;
      final fileName = result.files.single.name;

      setState(() {
        audioName = fileName;
      });

    }
  }

  finalUpload() async {
    setState(() {
      _loading = true; // Bắt đầu sự kiện loading
    });
    // Upload tệp lên Firebase Storage
    var uploadFileImage = service.uploadFileImage(imageName, imagePath!);
    Reference storageRef = FirebaseStorage.instance.ref('Images').child(imageName);
    final UploadTask uploadTask = storageRef.putFile(File(imagePath!));

    // Lấy URL sau khi tải lên hoàn thành
    await uploadFileImage.whenComplete(() async {
      final url = await storageRef.getDownloadURL();
      image_url = url;
      print('URL của tệp: $image_url');
    });


    // Upload tệp lên Firebase Storage
    var uploadFileAudio = service.uploadFileMusic(audioName, audioPath!);
    Reference audioRef = FirebaseStorage.instance.ref('Musics').child(audioName);
    final UploadTask uploadAudio = audioRef.putFile(File(audioPath!));

    // Lấy URL sau khi tải lên hoàn thành
    await uploadFileAudio.whenComplete(() async {
      final urlAudio = await audioRef.getDownloadURL();
      audio_url = urlAudio;
      print('URL của tệp: $audio_url');
    });
    var data= {
      "song_name": _songName.text,
      "artist_name" : _artistName.text,
      "lyrics":_lyrics.text,
      "imageUrl": image_url,
      "audioUrl": audio_url,
      "value": false,
      "status": false,
    };
    firestoreInstance.collection("songs").doc().set(data).whenComplete(() {
      Navigator.of(context).pushNamed(
          '/storage');
    });
    if(currentUser != null && currentUser!.email !=null ){
      firestoreInstance
          .collection("Users")
          .doc(currentUser!.email)
          .collection('songs').doc().set(data).whenComplete(() {
        Navigator.of(context).pushNamed(
            '/storage');
      });
    }
    setState(() {
      _loading = false; // Kết thúc sự kiện loading
    });
    print('Created success');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          child: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
                color: const Color(0xffffdde1),

            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 45,),
                    backButton(
                        onClick: () {
                          Navigator.pop(context);
                        }),
                    Stack(
                      children: [

                        Container(margin: const EdgeInsets.fromLTRB(25, 100, 20, 30),
                          width: 350,
                          height: 500,
                          decoration: BoxDecoration(
                            // border:Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(20),
                            color:Colors.black
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                const SizedBox(height: 60,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      child: SizedBox(
                                        width: 200,
                                        child: Text( 'Image: $imageName' ,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const  TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: ElevatedButton(
                                          onPressed: (){_btnUploadImages();},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: const BorderSide(color: Colors.white, width: 2),
                                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: const Text(
                                            'Upload',
                                            style: TextStyle(fontSize: 15, color: Color(0xffee9ca7),),
                                          )),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const  EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      child: SizedBox(
                                        width: 200,
                                        child: Text('Audio: $audioName',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: ElevatedButton(
                                          onPressed: (){_btnUploadAudio();},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: const BorderSide(color: Colors.white, width: 2),
                                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: const Text(
                                            'Upload',
                                            style: TextStyle(fontSize: 15, color: Color(0xffee9ca7),),
                                          )),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xffee9ca7),
                                        // border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(12)),
                                    child:  Padding(
                                      padding: const EdgeInsets.only(left: 20.0),
                                      child: TextField(
                                        style: const TextStyle(
                                            color: Colors.white
                                        ),
                                        controller: _songName,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter Song Name',
                                          hintStyle: TextStyle(color:Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:  Color(0xffee9ca7),
                                        // border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(12)),
                                    child:  Padding(
                                      padding: const EdgeInsets.only(left: 20.0),
                                      child: TextField(
                                        style: const TextStyle(
                                            color: Colors.white
                                        ),
                                        controller: _artistName,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter Artist Name',
                                          hintStyle: TextStyle(color:Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xffee9ca7),
                                        // border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(12)),
                                    child:  Padding(
                                      padding: const EdgeInsets.only(left: 20.0),
                                      child: TextField(
                                        minLines: 1,
                                        maxLines: 1000,
                                        style: const TextStyle(
                                            color: Colors.white
                                        ),
                                        controller: _lyrics,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Lyrics Is Here',
                                          hintStyle: TextStyle(color:Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50,),


                              ],
                            ),
                          ),
              ),

            Positioned(
              left: 105,
              top: 50,
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  // border:Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(20),
                  color:Color(0xffee9ca7),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Upload Song',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],

                ),
              ),
            ),

            ],
          ),
          Container(
            child: ElevatedButton(
                onPressed: (){
                  finalUpload();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 15, color: Color(0xffee9ca7),),
                )),

          ),
          ],
        ),
    ),
    ),
    ),
    )
    );
  }
}