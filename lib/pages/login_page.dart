import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dacn/home/index_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widget/back_button.dart';
import '../home/home_page.dart';
import '../service/auth_service_google.dart';
import 'fogot_pw.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Stack(
            children: [
              Container(
                width: 330,
                height: 80,
                decoration: const BoxDecoration(
                    color: Color(0xff419c5d),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Congratulation!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Login Successfully',
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
        Navigator.of(context).pushNamed('/index');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Stack(
          children: [
            Container(
              width: 330,
              height: 80,
              decoration: const BoxDecoration(
                  color: Color(0xff64CCC5),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ERROR!',
                          style: TextStyle(
                              color: Color(0xff5c6960),
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Login Failed!',
                          style: TextStyle(
                            color: Color(0xff5c6960),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: 870,
                child: Column(
                  children: [
                    const SizedBox(height: 45),
                    backButton(onClick: () {
                      Navigator.of(context).pushNamed('/back');
                    }),
                    const SizedBox(height: 140),
                    Container(
                      child: Center(
                        child: Column(children: [
                          //Hello again!
                          const SizedBox(
                            height: 55,
                          ),
                          const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),

                          const SizedBox(
                            height: 40,
                          ),
                          //Email text
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color:  Colors.white),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextField(
                                  style:
                                      const TextStyle(color: Colors.black),
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Email',
                                    hintStyle:
                                        TextStyle(color: Colors.black,fontSize: 15),

                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ), //Password text
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.white),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextField(
                                  obscureText: true,
                                  style:
                                      const TextStyle(color: Colors.black),
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    hintStyle:
                                    TextStyle(color: Colors.black,fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //link register
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: const Text('Forgot Password?',
                                    style: TextStyle(color: Colors.black, fontSize: 14)),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 30),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return FogotPasswordPage();
                                    }));
                                  },
                                  child: const Text(
                                    'Click here',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //sign in button
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                signIn();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    color:  Colors.black,
                                    // border: Border.all(
                                    //     color: Colors.white, width: 1),
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Center(
                                    child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )),
                              ),
                            ),
                          ),
                          const SizedBox(height: 140),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  UserCredential gg = await AuthService().signInWithGoogle();
                                  if (gg != null && gg.user != null) {

                                    var data = {
                                      'email': gg.user!.email,
                                      'username': "Guest",
                                      "role": false,
                                      "avt": "https://firebasestorage.googleapis.com/v0/b/music-3ab6b.appspot.com/o/Avatars%2FFB_IMG_1697286654747.jpg?alt=media&token=cfd3cbec-5040-4312-ac35-dbaa6f261bb5",
                                    };
                                    await FirebaseFirestore.instance.collection("Users").doc(gg.user!.email).
                                    set(data);
                                    // Đăng nhập thành công
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Stack(
                                        children: [
                                          Container(
                                            width: 330,
                                            height: 80,
                                            decoration: const BoxDecoration(
                                              color: Colors.greenAccent,
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                            ),
                                            child: const Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'Congratulation!',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      Text(
                                                        'Login Successfully',
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
                                    Navigator.of(context).pushNamed('/index'); // Chuyển hướng đến trang Home
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Image.asset('assets/images/gg.jpg', height: 40, width:40),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Or',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const indexPage()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 2),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: const Text(
                                    'Continue a guest',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
