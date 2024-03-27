import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dacn/Widget/back_button.dart';
import 'package:dacn/storage/storage_service.dart';

class ArtistRegister extends StatefulWidget {
  const ArtistRegister({super.key});

  @override
  State<ArtistRegister> createState() => _ArtistRegisterState();
}

class _ArtistRegisterState extends State<ArtistRegister> {
  StorageService service = StorageService();
  String? avtPath = '';
  String avtName='';
  late String avt_url;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _phoneNumberController = TextEditingController();
  Future signUp() async {
    String username = _userNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    // String phoneNumber = _phoneNumberController.text;

    UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);

    if(userCredential != null ){
      createUserDocumnet(userCredential);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Stack(
          children: [
            Container(

              width: 330,
              height: 80,
              decoration: const BoxDecoration(
                  color:  Colors.greenAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20))

              ),
              child: const Row(

                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Congratulation!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text('User is successfully created!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
      Navigator.pushNamed(context, "/index");
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Stack(
          children: [
            Container(
              width: 330,
              height: 80,
              decoration: const BoxDecoration(
                  color:  Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20))

              ),
              child: const Row(

                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ERROR!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text('Create Failed!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    }
  }

  Future _btnUploadAvt() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any
    );
    if(result == null){
      print('Error: No file selected');
    }else {
      final path = result.files.single.path;
      avtPath = path;
      final fileName = result.files.single.name;
      avtName = fileName;
    }
  }


  Future<void> createUserDocumnet(UserCredential userCredential) async {
    var uploadFileAvt = service.uploadFileAvt(avtName, avtPath!);
    Reference storageRef = FirebaseStorage.instance.ref('Avatars').child(avtName);
    final UploadTask uploadTask = storageRef.putFile(File(avtPath!));

    //Lấy URL
    await uploadFileAvt.whenComplete(() async {
      final url = await storageRef.getDownloadURL();
      avt_url = url;
      print('URL của tệp $avt_url');
    });
    var data = {
      'email': userCredential.user!.email,
      'username': _userNameController.text,
      // 'phoneNumber' : _phoneNumberController.text,
      "role": true,
      "avt": avt_url,
    };
    if (userCredential.user != null) {
      await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).
      set(data);
    }

  }
  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    // _phoneNumberController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffee9ca7),
                  Color(0xffffdde1),
                ])),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height:870,
            child: Column(
              children: [
                const SizedBox(height: 45,),
                backButton(
                    onClick: () {
                      Navigator.of(context).pushNamed(
                          '/back');
                    }),
                const SizedBox(height: 110),
                Container(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        //Hello again!
                        const Text('Registered Artist', style:TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                        ),),
                        const SizedBox(
                          height: 30,
                        ),

                        //FullName text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextField(
                                style:  const TextStyle(
                                    color: Color(0xff176B87)
                                ),
                                controller: _userNameController,
                                decoration: const  InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Full Name',
                                  hintStyle: TextStyle(color:Colors.black,fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        //Email text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextField(
                                style: const TextStyle(
                                    color: Color(0xff176B87)
                                ),
                                controller: _emailController,
                                decoration: const  InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color:Colors.black,fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),


                        const SizedBox(
                          height: 20,
                        ), //Password text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color:Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            child:  Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child:  TextField(
                                obscureText: true,
                                style: const TextStyle(
                                    color: Color(0xff176B87)
                                ),
                                controller: _passwordController,
                                decoration: const  InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  hintStyle: TextStyle(color:Colors.black,fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          width: 340,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color:Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text('Image: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: ElevatedButton(
                                    onPressed: (){_btnUploadAvt();},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const               Color(0xffee9ca7),
                                      side: const BorderSide(color: Colors.black54, width: 2),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 22),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Text(
                                      'Upload',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        //sign in button
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: (){
                              signUp();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(color:Colors.black,
                                  // border: Border.all
                                  //   (color:Colors.white,width: 1
                                  // ),
                                  borderRadius: BorderRadius.circular(8)),
                              child:const Center(
                                  child:   Text(
                                    'Sign Up',
                                    style:  TextStyle(color:Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        //link register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: const Text(
                                  'If you are a user!',
                                  style: TextStyle(color: Colors.black)),
                            ),


                            Padding(
                              padding: const EdgeInsets.all(0),
                              child:GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, "/register");
                                },

                                child: Container(
                                  // margin: const EdgeInsets.only(right: 30),
                                  child:const Text(
                                    'Click here!',

                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )],
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
