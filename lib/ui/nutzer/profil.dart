import 'package:flutter/material.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/auth.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:movie_tinder/ui/CircularImage.dart';
import 'package:movie_tinder/ui/loading.dart';
import 'package:movie_tinder/ui/nutzer/profil_bild_laden.dart';
import 'package:movie_tinder/ui/nutzer/user_name.dart';
import 'package:provider/provider.dart';



class Profil extends StatefulWidget {
  final Function toggle;
  Profil({this.toggle});
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {

  String myFriends = '';

  Future<String>_getFriends(MyUser user) async{
    if(myFriends=='' && user !=  null){
      DatabaseService databaseService= DatabaseService(user.uid);
      for(String uid in user.friends){
        myFriends += (await databaseService.userAtUid(uid)).name.trim() +', ';
      }
    }
    return myFriends;
  }
  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);


    return (user==null)? Loading(): Scaffold(
      body: ListView(
        children: [
              InkWell(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (_) => BildLaden(user),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: user.pic==''?
                      Icon(Icons.add_photo_alternate_rounded, size: 250, color: Theme.of(context).secondaryHeaderColor,):
                  CircleImage(radius: 250,
                  image: user.pic),
                ),
              ),
          UserName(),
          FutureBuilder(
            future: _getFriends(user),
              builder: (context, snapshot){
              if(snapshot.hasData){
                return ListTile(
                  title: Text(myFriends),
                  subtitle: Text('Freunde'),
                );
              }else{
                return ListTile( title: SizedBox(height: 50,),);
              }
              }),
          ListTile(
            title: Text(user.mail),
          ),
          ListTile(title: Text('Ausloggen'), trailing: Icon(Icons.sensor_door_outlined),
          onTap: (){
            AuthService().signOut();
            Navigator.pop(context);
          },)
        ],
      ),
    );
  }
}
