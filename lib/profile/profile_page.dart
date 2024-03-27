import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dacn/album_page/add_album.dart';
import 'package:dacn/album_page/album.dart';
import 'package:dacn/profile/showFavorite.dart';
import 'package:dacn/profile/showplaylist.dart';
import 'package:dacn/profile/upload.dart';
import 'package:dacn/storage/storage_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final User? currentUser = FirebaseAuth.instance.currentUser;
  late bool check;

  Future<String?> getUserName() async {
    if (currentUser != null && currentUser!.email != null) {
      final DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser!.email!)
          .get();
      final userDataMap = userData.data();
      if (userDataMap != null) {
        return userDataMap["username"];
      }
    }
    return null; // Trả về null nếu không thể lấy tên người dùng
  }

  Future<String?> getUserAvatar() async {
    if (currentUser != null && currentUser!.email != null) {
      final DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser!.email)
          .get();
      final userAvatar = userData.data();
      if (userAvatar != null) {
        return userAvatar["avt"];
      }
    }
    return null;
  }

  Future<String> getRole() async {
    if (currentUser != null && currentUser!.email != null) {
      final DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser!.email!)
          .get();
      final userRole = userData.data();
      if (userRole != null) {
        print(userRole["role"].runtimeType) ;
        check = userRole["role"];

      }
    }
    return 'null'; // Trả về null nếu không lấy được giá trị "role"
  }




  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamed("/welcome");
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(currentUser != null && currentUser!.email != null){

      return Scaffold(
        backgroundColor:  const Color(0xffffdde1),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 50,),
              Container(
                margin: const EdgeInsets.fromLTRB(2, 25, 0, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child:  FutureBuilder<String?>(
                          future: getUserAvatar(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasData) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(snapshot.data ?? '',
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              );
                            } else {
                              return const Text('ERROR');
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Column(
                        children: [
                          FutureBuilder<String?>(
                            future: getUserName(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasData) {
                                return SizedBox(
                                  width: 60,
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    snapshot.data ?? 'Tên người dùng không có',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              } else {
                                return const Text('Không thể lấy tên người dùng');
                              }
                            },
                          ),

                          const SizedBox(height: 10,),
                          SizedBox(
                            width: 120,
                            child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              currentUser!.email ?? 'Người dùng chưa đăng nhập',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),),
                          )
                        ],
                      ),
                      const SizedBox(width: 20,),
                      IconButton(
                          onPressed: ()  {
                            signOut();
                          },
                          icon: Image.asset('assets/images/logout.png', width: 20,height: 20,color:Colors.black))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Container(
                width: 350,
                height: 2,
                color: const  Color(0xffee9ca7),
              ),
              const SizedBox(height: 20,),


              FutureBuilder<String>(
                future: getRole(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    final role = snapshot.data;
                    if (check == true) {
                      // Nếu role là true, hiển thị trang Artist
                      return   Container(
                        margin: const EdgeInsets.fromLTRB(45, 25, 0, 0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => UploadPage()));
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xffffdde1),
                                              Color(0xffee9ca7),
                                            ]),
                                      ),
                                      child: Image.asset('assets/images/btnupload.png'),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => storagePage()));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      width: 150,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xffffdde1),
                                              Color(0xffee9ca7),
                                            ]),
                                      ),
                                      child: Image.asset('assets/images/stogare.png'),
                                    ),
                                  ),

                                ],
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => add_AlbumPage()));
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xffffdde1),
                                              Color(0xffee9ca7),
                                            ]),
                                      ),
                                      child: Image.asset('assets/images/add_album.png'),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Album()));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      width: 150,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xffffdde1),
                                              Color(0xffee9ca7),
                                            ]),
                                      ),
                                      child: Image.asset('assets/images/Vector.png'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).pushNamed('/showFav');
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xffffdde1),
                                              Color(0xffee9ca7),
                                            ]),
                                      ),
                                      child: Image.asset('assets/images/fav_album.png'),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => showPlaylist()));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      width: 150,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xffffdde1),
                                              Color(0xffee9ca7),
                                            ]),
                                      ),
                                      child: Image.asset('assets/images/playlist.png'),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      // Nếu role không phải true, hiển thị trang User
                      return   Container(
                        margin: const EdgeInsets.fromLTRB(45, 0, 20, 0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => showlistFav()));
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xffffdde1),
                                              Color(0xffee9ca7),

                                            ]),
                                      ),
                                      child: Image.asset('assets/images/favsong.png'),
                                    ),
                                  ),

                              const SizedBox(height: 20,),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => showPlaylist()));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      width: 150,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xffffdde1),
                                              Color(0xffee9ca7),

                                            ]),
                                      ),
                                      child: Image.asset('assets/images/add_playlist.png'),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  } else {
                    return const Text('Không thể lấy role');
                  }
                },
              )
            ],
          ),
        ),

      );
    }else {
      return Scaffold(
        backgroundColor: const  Color(0xffee9ca7),
        body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You must log in.',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: const Text('Login'),
                ),
              ],
            )
        ),
      );
    }
  }
}