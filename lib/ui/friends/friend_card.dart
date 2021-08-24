import 'package:flutter/material.dart';
import 'package:movie_tinder/logic/common_matches.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:movie_tinder/ui/CircularImage.dart';
import 'package:movie_tinder/ui/friends/common_matches.dart';
import 'package:movie_tinder/ui/friends/show_pic.dart';

class FriendCard extends StatefulWidget {
  final String friendString;
  final MyUser user;
  FriendCard({this.friendString, this.user});

  @override
  _FriendCardState createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  MyUser friend;
  List<String> commonMatches = <String>[];

  Future<MyUser> _getFriend()async{
    if (friend == null) {
      friend = await DataBaseServiceMatch().userAtUid(widget.friendString);
      setState(() {
      
      });
      setState(() {
        commonMatches = sharedMatches(widget.user, friend);
      });
    }
    return friend;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getFriend(),
        builder: (context, snapshot){
      if(snapshot.hasData){
        return Card(
          child: ListTile(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CommonMatches(commonMatches: commonMatches, user: widget.user,))),
            leading:friend.pic==''? Icon(Icons.perm_identity_rounded, size: 40,
              color: Theme.of(context).secondaryHeaderColor,):
            InkWell(
              onTap: (){
                showDialog(context: context,
                    builder: (_)=>ShowPicture(friend));
              },
              child: Hero(
                tag: friend.pic,
                child: CircleImage(
                  radius: 40,
                  image: friend.pic,
                ),
              ),
            ),
            title: Text(friend.name),
            subtitle: Text('Ihr habt ${commonMatches.length} gemeinsame Matches'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
          ),
        );
      }else{
        return Card(child: SizedBox(height: 60,),);
      }
    });
  }
}
