import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dacn/Widget/back_button.dart';
import 'package:dacn/storage/storage_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_service/audio_service.dart';

import 'home_page.dart';

class index extends StatefulWidget {
  const index({super.key});

  @override
  State<index> createState() => _indexPageHometate();
}

class _indexPageHometate extends State<index> {
  int currenrIndex = 2;
  List tabs = [
    const HomePage(),
    const storagePage(),
    playedAlbumsHome(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xff2c3d5b),
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          ImageIcon(
            AssetImage('assets/images/Home.png'),
          ),
          Icon(Icons.search),
          Icon(Icons.person)
        ],
        onTap: (index) {
          setState(() {
            currenrIndex = index;
          });
        },
      ),
      body: tabs[currenrIndex],
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
  const PositionData(this.position, this.bufferedPosition, this.duration);
}

class playedAlbumsHome extends StatefulWidget {
  String? album_name, collection, collection2;
  playedAlbumsHome(
      {super.key, this.album_name, this.collection, this.collection2});

  @override
  State<playedAlbumsHome> createState() => _playedAlbumsHomeState();
}

class _playedAlbumsHomeState extends State<playedAlbumsHome> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final AudioPlayer player = AudioPlayer();
  List<AudioSource>? _playlist;
  bool _isShuffling = false; // Thêm biến để theo dõi trạng thái shuffling

  Future<List<Map<String, dynamic>>> getdata() async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection(widget.collection.toString())
        .doc('${widget.album_name}')
        .collection(widget.collection2.toString())
        .get();

    print(widget.collection2);
    return qn.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();

    getdata().then((playlistData) {
      _playlist = playlistData.map((songData) {
        return AudioSource.uri(
          Uri.parse(songData['audioUrl']),
          tag: MediaItem(
              id: playlistData.length.toString(),
              title: songData['song_name'],
              artist: songData['artist_name'],
              artUri: Uri.parse(songData['imageUrl'])),
        );
      }).toList();
      if (_isShuffling) {
        _playlist!.shuffle();
      }

      final playlist = player.setAudioSource(
        ConcatenatingAudioSource(
          children: _playlist ?? [],
        ),
      );

      player.setLoopMode(LoopMode.all);
      player.setAudioSource(playlist as AudioSource);
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
  // Future<void> initNotification() async {
  //   await JustAudioBackground.init(
  //     androidNotificationChannelId: 'com.example.myapp.channel.audio', // Thay đổi channel ID
  //     androidNotificationChannelName: 'Audio playback',
  //     androidNotificationOngoing: true,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Color(0xffee9ca7),
              Color(0xffffdde1),
        ])),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: backButton(onClick: () {
                        Navigator.pop(context);
                      }),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 20),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _isShuffling = !_isShuffling;
                            getdata().then((playlistData) {
                              _playlist = playlistData.map((songData) {
                                return AudioSource.uri(
                                  Uri.parse(songData['audioUrl']),
                                  tag: MediaItem(
                                    id: playlistData.length.toString(),
                                    title: songData['song_name'],
                                    artist: songData['artist_name'],
                                    artUri: Uri.parse(songData['imageUrl']),
                                  ),
                                );
                              }).toList();

                              if (_isShuffling) {
                                _playlist!.shuffle();
                              }

                              final playlist = player.setAudioSource(
                                ConcatenatingAudioSource(
                                  children: _playlist ?? [],
                                ),
                              );

                              player.setLoopMode(LoopMode.all);
                              player.setAudioSource(playlist as AudioSource);
                            });
                          });
                        },
                        iconSize: 40,
                        color: Colors.white,
                        icon: _isShuffling
                            ? const Icon(Icons.shuffle_rounded)
                            : const Icon(Icons.shuffle_rounded,
                                color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                StreamBuilder<SequenceState?>(
                    stream: player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence.isEmpty ?? true) {
                        return const SizedBox();
                      }
                      final metadata = state!.currentSource!.tag as MediaItem;
                      return MediaMetadata(
                          imageUrl: metadata.artUri.toString(),
                          title: metadata.title,
                          artist: metadata.artist ?? '');
                    }),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 340,
                  child: StreamBuilder<PositionData>(
                      stream: _positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        return Container(
                          padding: const EdgeInsets.all(0),
                          child: ProgressBar(
                              barHeight: 8,
                              baseBarColor: Colors.white,
                              bufferedBarColor: Colors.grey[300],
                              progressBarColor: Colors.grey[900],
                              thumbColor:  Colors.grey[850],
                              timeLabelTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600
                              ),
                              progress: positionData?.position ?? Duration.zero,
                              buffered:
                                  positionData?.bufferedPosition ?? Duration.zero,
                              onSeek: player.seek,
                              total: positionData?.duration ?? Duration.zero),
                        );
                      }),
                ),
                const SizedBox(
                  height: 0,
                ),
                Controls(audioPlayer: player),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MediaMetadata extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;

  const MediaMetadata(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.artist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(2, 4),
              blurRadius: 4,
            ),
          ], borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          artist,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class Controls extends StatelessWidget {
  final AudioPlayer audioPlayer;
  const Controls({Key? key, required this.audioPlayer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: audioPlayer.seekToPrevious,
            iconSize: 60,
            color: Colors.grey[850],
            icon: const Icon(Icons.skip_previous_rounded)),
        StreamBuilder<PlayerState>(
            stream: audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (!(playing ?? false)) {
                return IconButton(
                    onPressed: audioPlayer.play,
                    iconSize: 80,
                    color: Colors.grey[850],
                    icon: const Icon(Icons.play_arrow_rounded));
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                    onPressed: audioPlayer.pause,
                    iconSize: 80,
                    color: Colors.grey[850],
                    icon: const Icon(Icons.pause_rounded));
              }
              return  Icon(
                Icons.play_arrow_rounded,
                size: 80,
                color: Colors.grey[850],
              );
            }),
        IconButton(
            onPressed: audioPlayer.seekToNext,
            iconSize: 60,
            color: Colors.grey[850],
            icon: const Icon(Icons.skip_next_rounded)),
      ],
    );
  }
}
