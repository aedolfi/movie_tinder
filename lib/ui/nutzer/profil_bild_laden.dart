import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:movie_tinder/services/storage.dart';
import 'package:movie_tinder/shared/colors.dart';

class BildLaden extends StatefulWidget {
  final MyUser user;
  BildLaden(this.user);
  @override
  _BildLadenState createState() => _BildLadenState();
}

class _BildLadenState extends State<BildLaden> {

  PickedFile _imageFile;
  ImagePicker _picker = ImagePicker();
  File file;
  String error;
  bool laden=false;


  Future<void> getImage(ImageSource source)async{
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        error='Upload fehlgeschlagen';
      });
     print(e);
    }
    if (_imageFile!= null){
      try {
        setState(() {
          laden =true;
        });
        String name=widget.user.uid;
        print('NAME: $name');
        File savedImage = File(_imageFile.path);
        String url = await StorageService().uploadImage(name, savedImage);
        MyUser newUser = widget.user;
        newUser.pic= url;
        await DatabaseService(widget.user.uid).updateUser(newUser);
      } on Exception catch (e) {
        print(e);
        setState(() {
          error= 'Upload fehlgeschlagen';
        });
      }
    }
    Navigator.pop(context);

  }



  @override
  Widget build(BuildContext context) {
    return laden?
    AlertDialog(
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            error== null? CircularProgressIndicator(): Text(error, style: errorStyle,)
          ]
      ),
      actions: error==null? null :  [
        TextButton(
          child: Text('Zurück'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ):
    AlertDialog(
      title: Text('Profilbild ändern', style: TextStyle(color: Theme.of(context).primaryColor),),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Lade ein neues Profilbild hoch.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: (){
          getImage(ImageSource.gallery);
        }, child: Text('Aus Galerie')),
        TextButton(onPressed: (){
          getImage(ImageSource.camera);
        }, child: Text('Kamera')),
        TextButton(
          child: Text('Abbrechen'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
