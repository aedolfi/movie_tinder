import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/ui/empty_Tile.dart';
import 'package:movie_tinder/ui/friends/add_friend_dialog.dart';
import 'package:movie_tinder/ui/friends/friend_card.dart';
import 'package:movie_tinder/ui/friends/received_request.dart';
import 'package:movie_tinder/ui/friends/sent_request.dart';
import 'package:movie_tinder/ui/loading.dart';
import 'package:provider/provider.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return Scaffold(
      body: (user==null)? Loading():
     CustomScrollView(
       slivers: [
         SliverStickyHeader(
           header: Header('Meine Freunde'),
           sliver: SliverList(
             delegate: user.friends.length==0 ?
                 SliverChildBuilderDelegate(
                     (context, i)=> EmptyTile(text: 'Du hast anscheined keine Freunde. Doof für dich.'),
                   childCount: 1
                 ):
             SliverChildBuilderDelegate(
                 (context, i)=>FriendCard(friendString: user.friends[i], user: user,),
               childCount: user.friends.length
             ),
           ),
         ),
         SliverStickyHeader(
           header: Header('Erhaltene Anfragen'),
           sliver: SliverList(
             delegate: user.receivedRequest.length==0?
             SliverChildBuilderDelegate(
                 (context, i)=> EmptyTile(text: 'Du hast keine neuen Anfragen erhalten'),
               childCount: 1
             )
             :SliverChildBuilderDelegate(
                 (context, i)=>ReceivedRequest(friendString: user.receivedRequest.reversed.toList()[i], user: user,),
               childCount: user.receivedRequest.length
             ),
           ),
         ),
         SliverStickyHeader(
           header: Header('Gesendete Anfragen'),
           sliver: SliverList(
             delegate: user.sentRequest.length==0?
             SliverChildBuilderDelegate(
                 (context, i)=>EmptyTile(text: 'Du hast keine austehenden Anfragen versendet'),
               childCount: 1
             )
             :SliverChildBuilderDelegate(
                 (context, i)=>SentRequest(friendString: user.sentRequest.reversed.toList()[i], user: user,),
               childCount: user.sentRequest.length
             ),
           ),
         )
       ],
     ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        showDialog(context: context,
        builder: (_)=>AddAFriendDialog(user: user,));
      },
          label: Text('Freund*in hinzufügen'),
        icon: Icon(Icons.person_add_alt_1_rounded),
      ),

    );
  }
}


class Header extends StatelessWidget {
  final String title;
  Header(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text(title)),
      ),
    );
  }
}

