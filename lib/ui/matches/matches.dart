import 'package:flutter/material.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/ui/loading.dart';
import 'package:movie_tinder/ui/matches/match_tile.dart';
import 'package:provider/provider.dart';

class Matches extends StatefulWidget {
  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return user==null? Loading():
    user.matches.isEmpty?
    Center(
      child: Column(
        children: [
          CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0),
              radius: 75,
              child: Image.asset('assets/foreground.png')
          ),
          Center(child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text('Du hast noch keine Matches. Fleißig swipen ist angesagt.'),
          ),),
        ],
      ),
    ):
    ListView.builder(
      shrinkWrap: true,
      itemCount: user.matches.reversed.toList().length,
      itemBuilder: (context, i){
        return MatchTile(matchString: user.matches.reversed.toList()[i], user: user,);
      },
    );
  }
}
