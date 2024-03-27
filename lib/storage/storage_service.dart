import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadFileMusic(String fileName, String filePath) async {
    File file = File(filePath);
    try {
      await firebaseStorage.ref('Musics/$fileName').putFile(file).then((p0)  {
        print('Upload successfully');
      });
    }catch(e) {
      print("Error: $e");
    }
  }

  Future<void> uploadFileImage(String fileName, String filePath) async {
    File file = File(filePath);
    try {
      await firebaseStorage.ref('Images/$fileName').putFile(file).then((p0) {
        print('Upload Images');
      });
    }catch(e){
      print("Error: $e");
    }
  }

  Future<void> uploadFileAvt(String fileName, String filePath) async {
    File file = File(filePath);
    try {
      await firebaseStorage.ref('Avatars/$fileName').putFile(file).then((p0) {
        print('Upload Avatar');
      });
    }catch(e){
      print('Error: $e');
    }
  }
  Future<void> uploadFileImgAlbum(String fileName, String filePath) async {
    File file = File(filePath);
    try {
      await firebaseStorage.ref('ImagesAlbum/$fileName').putFile(file).then((p0) {
        print('Upload Img Album');
      });
    }catch(e){
      print('Error: $e');
    }
  }


  Future<ListResult> listFiles() async {
    ListResult listResult = await firebaseStorage.ref('Musics').listAll();
    return listResult;
  }
}