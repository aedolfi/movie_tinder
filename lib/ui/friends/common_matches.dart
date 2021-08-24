import 'package:flutter/material.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/ui/matches/match_tile.dart';

class CommonMatches extends StatefulWidget {
  final List<String> commonMatches;
  final MyUser user;
  CommonMatches({this.commonMatches, this.user});
  @override
  _CommonMatchesState createState() => _CommonMatchesState();
}

class _CommonMatchesState extends State<CommonMatches> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        leading: IconButton(icon: Icon(Icons.arrow_back_rounded), color: Theme.of(context).primaryColor, onPressed: ()=>Navigator.pop(context),),
        title: Text('Gemeinsame Matches', style: TextStyle(color: Theme.of(context).primaryColor),),
      ),
      body: widget.commonMatches.isEmpty? Center(child: Text('Ihr habt keine gemeinsamen Matches.'),) :
      ListView.builder(
        itemCount: widget.commonMatches.length,
        itemBuilder: (context, i)=>MatchTile(matchString: widget.commonMatches[i], user: widget.user,),
      ),
    );
  }
}
