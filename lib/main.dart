import 'package:dacn/album_page/add_album.dart';
import 'package:dacn/album_page/album.dart';
import 'package:dacn/home/home_page.dart';
import 'package:dacn/home/index_page.dart';
import 'package:dacn/pages/artist_register.dart';
import 'package:dacn/pages/index_profile.dart';
import 'package:dacn/profile/profile_page.dart';
import 'package:dacn/profile/showFavorite.dart';
import 'package:dacn/profile/upload.dart';
import 'package:dacn/storage/storage_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dacn/pages/login_page.dart';
import 'package:dacn/pages/register_page.dart';
import 'package:dacn/pages/welcome_page.dart';
import 'package:dacn/transition/transition_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import 'api/firebase_api.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();


  // This is the last thing you need to add.
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyA8QGSINWKZstspI5fRQtJmOewPomctuGw",
          appId: "1:46344465241:android:37b8fd7f56c3894af9ba48",
          messagingSenderId: "46344465241",
          projectId: "dacnmusic",
          storageBucket:"dacnmusic.appspot.com",)
  );
  await FirebaseApi().initNotifications();
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  // runApp(MaterialApp(home:showlistFav() ,));
  runApp(_MyApp());
}

class _MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    initialRoute: '/welcome',
    onGenerateRoute: (route) => onGenerateRoute(route),
  );

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return CustomPageRoute(
          child: const LoginPage(),
          settings: settings,
        );
      case '/register':
        return CustomPageRoute(
          child: const signUp(),
          direction: AxisDirection.left,
          settings: settings,
        );
      case '/artist':
        return CustomPageRoute(
          child: const ArtistRegister(),
          settings: settings,
        );
      case '/home':
        return CustomPageRoute(
          child: const HomePage(),
          direction: AxisDirection.up,
          settings: settings,
        );
      case '/index':
        return CustomPageRoute(
          child: const indexPage(),
          direction: AxisDirection.up,
          settings: settings,
        );
      case '/index_profile':
        return CustomPageRoute(
          child: const indexProfilePage(),
          direction: AxisDirection.up,
          settings: settings,
        );
      case '/back':
        return CustomPageRoute(
          child: const WelcomePage(),
          direction: AxisDirection.right,
          settings: settings,
        );
      case '/upload':
        return CustomPageRoute(
          child: const UploadPage(),

          settings: settings,
        );
      case '/storage':
        return CustomPageRoute(
          child: const storagePage(),

          settings: settings,
        );
      case '/profile':
        return CustomPageRoute(
          child: const ProfilePage(),

          settings: settings,
        );
      case '/addAlbum':
        return CustomPageRoute(
          child: const add_AlbumPage(),
          direction: AxisDirection.left,
          settings: settings,
        );
      case '/Albums':
        return CustomPageRoute(
          child: const Album(),
          direction: AxisDirection.left,
          settings: settings,
        );
      case '/showFav':
        return CustomPageRoute(
          child: const showlistFav(),
          direction: AxisDirection.left,
          settings: settings,
        );
      case '/welcome':
      default:
        return CustomPageRoute(
          child: const WelcomePage(),
          settings: settings,
        );
    }
  }
}