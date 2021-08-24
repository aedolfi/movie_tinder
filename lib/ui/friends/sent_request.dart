import 'package:flutter/material.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:movie_tinder/ui/CircularImage.dart';
import 'package:movie_tinder/ui/friends/show_pic.dart';

class SentRequest extends StatefulWidget {

  final String friendString;
  final MyUser user;
  SentRequest({this.friendString, this.user});

  @override
  _SentRequestState createState() => _SentRequestState();
}

class _SentRequestState extends State<SentRequest> {
  MyUser friend;

  Future<MyUser> getFriend() async{
    if(friend==null){
      friend= await DatabaseService(widget.user.uid).userAtUid(widget.friendString);
      setState(() {

      });
    }
    return friend;
  }

  void _accept( bool accept){
    MyUser _newUser = widget.user;
    MyUser _newFriend = friend;
    if(accept){
      _newUser.friends.add(friend.uid);
      _newFriend.friends.add(widget.user.uid);
    }else if(!accept){
      _newUser.sentRequest.removeWhere((element) => element==friend.uid);
      _newFriend.receivedRequest.removeWhere((element) => element==widget.user.uid);
    }
    DatabaseService(widget.user.uid).updateUser(_newFriend);
    DatabaseService(widget.user.uid).updateUser(_newUser);
  }

  @override
  Widget build(BuildContext context) {
   return FutureBuilder(
     future: getFriend(),
       builder: (context, snapshot){
     if(snapshot.hasData){
       return Card(
         child: ListTile(
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
             trailing: IconButton(
               icon: Icon(Icons.delete_rounded),
               onPressed: (){
                 _accept(false);
               },
             )
         ),
       );
     }else{
       return Card(child: SizedBox(height: 60,),);
     }
   });
  }
}
