import 'package:flutter/material.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:movie_tinder/ui/CircularImage.dart';
import 'package:movie_tinder/ui/friends/show_pic.dart';

class ReceivedRequest extends StatefulWidget {

  final String friendString;
  final MyUser user;
  ReceivedRequest({this.friendString, this.user});

  @override
  _ReceivedRequestState createState() => _ReceivedRequestState();
}

class _ReceivedRequestState extends State<ReceivedRequest> {
  MyUser friend;

  Future<MyUser> getFriend()async{
    if(friend==null){
      friend = await DatabaseService(widget.user.uid).userAtUid(widget.friendString);
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
    }
    _newUser.receivedRequest.removeWhere((element) => element==friend.uid);
    _newFriend.sentRequest.removeWhere((element) => element==widget.user.uid);
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
           leading: friend.pic==''? Icon(Icons.perm_identity_rounded, size: 40,
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
           title: Row(
             mainAxisAlignment:
             MainAxisAlignment.spaceBetween,
             children: [
               Text(friend.name),
               Row(
                 children: [
                   IconButton(icon: Icon(Icons.clear), color: Colors.red, onPressed: (){_accept(false);}),
                   SizedBox(width: 20,),
                   IconButton(icon: Icon(Icons.check),color: Colors.green, onPressed: (){_accept(true);}),
                 ],
               )
             ],
           ),
         ),
       );
     }else{
       return Card( child: SizedBox(height: 60,),);
     }
   });
  }
}
