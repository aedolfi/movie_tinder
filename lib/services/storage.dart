import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


class StorageService{


  //upload image
  Future<String> uploadImage(String name, File image) async{
    final ref = FirebaseStorage.instance.ref().child('profil_pics/$name.jpg');
    String url;
    await ref.putFile(image);
    url = await ref.getDownloadURL();
    return url;
  }

  Future<String> uploadPoster(String name, File image) async{
    final ref = FirebaseStorage.instance.ref().child('poster/$name.jpg');
    String url;
    await ref.putFile(image);
    url = await ref.getDownloadURL();
    return url;
  }




}

