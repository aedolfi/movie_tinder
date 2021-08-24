import 'package:flutter/material.dart';
import 'package:movie_tinder/models/match.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/ui/CircularImage.dart';
import 'package:movie_tinder/ui/matches/match_Card.dart';

class MatchTile extends StatefulWidget {
  final String matchString;
  final MyUser user;
  MatchTile({this.matchString, this.user});
  @override
  _MatchTileState createState() => _MatchTileState();
}

class _MatchTileState extends State<MatchTile> {
  MyMatch match;

  Future<void> getMatch() async{
    if (match==null) {
      match = await MyMatch().fromString(widget.matchString);
    }
    return match;
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder(
        future: getMatch(),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            return ListTile(
              title: Text('Du und ${match.friend.name} interessiert euch beide für ${match.film.title}.'),
              subtitle: Text('Klicke hier um mehr zu erfahren.'),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleImage(radius: 40, image: match.friend.pic,),
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleImage(radius: 40, image: widget.user.pic,),
              ),
              onTap: (){
                 print('onPressed');
                showDialog(context: context, builder: (_)=> MatchCard(match: match));
            },
            );
          }else{
            return ListTile(
              title: SizedBox(height: 60,),
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleImage(radius: 40, image: widget.user.pic,),
              ),
            );
          }
        },
      ),
    );
  }
}
