import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dacn/home/played_page.dart';
import 'package:flutter/material.dart';

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  String name = '';
  Future getdata() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection('songs').get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffdde1),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 60, 20, 0),
            child: Card(
              child: TextField(
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffee9ca7), width: 2.0),
                    ),
                    iconColor: Colors.black,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintText: 'Search'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('songs').snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                          if (name.isEmpty) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0xffee9ca7),
                                      Color(0xffffdde1),
                                    ],
                                    begin: AlignmentDirectional.topCenter,
                                    end: Alignment.bottomCenter),
                              ),
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => playedPage(
                                        song_name: data['song_name'],
                                        imageUrl: data["imageUrl"],
                                        audioUrl: data["audioUrl"],
                                        artist_name: data["artist_name"],
                                        lyric: data["lyrics"],
                                      ),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  title: Text(
                                    data['song_name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    data['artist_name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      data['imageUrl'],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          if (data['song_name']
                              .toString()
                              .toLowerCase()
                              .startsWith(name.toLowerCase())) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0xffee9ca7),
                                      Color(0xffffdde1),
                                    ],
                                    begin: AlignmentDirectional.topCenter,
                                    end: Alignment.bottomCenter),
                              ),
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => playedPage(
                                        song_name: data['song_name'],
                                        imageUrl: data["imageUrl"],
                                        audioUrl: data["audioUrl"],
                                        artist_name: data["artist_name"],
                                        lyric: data["lyrics"],
                                      ),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  title: Text(
                                    data['song_name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    data['artist_name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      data['imageUrl'],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return Container();
                        });
              },
            ),
          ),
        ],
      ),
    );
  }
}
