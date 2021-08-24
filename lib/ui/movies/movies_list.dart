import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:movie_tinder/ui/empty_Tile.dart';
import 'package:movie_tinder/ui/loading.dart';
import 'package:movie_tinder/ui/movies/add_movie/AddMovie.dart';
import 'package:movie_tinder/ui/movies/liked_movie_tile.dart';
import 'package:movie_tinder/ui/movies/uploaded_movie_tile.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class MoviesList extends StatefulWidget {
  @override
  _MoviesListState createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {

  int max;
  int showup;
  int showliked;
  int showdis;

  void like(String film, bool like, MyUser user){
    if(!like){
      user.dislikes.removeWhere((element) => element==film);
      user.likes.add(film);
    }else{
      user.likes.removeWhere((element) => element==film);
      user.dislikes.add(film);
    }
    DatabaseService(user.uid).updateUser(user);
  }


  @override
  void initState() {
    super.initState();
    max=10;
    showup=max;
    showliked=max;
    showdis=max;
  }

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return Scaffold(
      body: (user== null)? Loading() : CustomScrollView(
        slivers: [
          SliverStickyHeader(
            header: Header('Hinzugefügt'),
            sliver: user.uploads.length==0? SliverList(delegate: SliverChildBuilderDelegate(
                (context, i)=>EmptyTile(text: 'Du hast noch keine Filme hinzugefüht',),
              childCount: 1
            )):
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, i){
                    if(i==showup && !(showup+1==user.uploads.length)){
                      return InkWell(
                        onTap: (){
                          setState(() {
                            showup += max;
                          });
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('Mehr...'),
                          ),
                        ),
                      );
                    }else{
                      return UploadedMovieTile(filmString: user.uploads.reversed.toList()[i]);
                    }
                  },
                childCount: min(user.uploads.length, showup+1)
              ),
            ),
          ),
          SliverStickyHeader(
            header: Header('Will ich sehen'),
            sliver: user.likes.length==0? SliverList(delegate:
            SliverChildBuilderDelegate(
                (context, i)=> EmptyTile(text: 'Du hast noch keine Filme nach rechts geswiped'),
              childCount: 1
            )):
            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (context, i){
                    if(i==showliked && !(showliked+1==user.likes.length)){
                      return InkWell(
                        onTap: (){
                          setState(() {
                            showliked += max;
                          });
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('Mehr...'),
                          ),
                        ),
                      );
                    }else{
                      return LikedMovieTile(filmString: user.likes.reversed.toList()[i],
                          user: user,
                          liked: true,
                          onLiked: (){like(user.likes.reversed.toList()[i], true, user);});
                    }
                  },
                  childCount: min(user.likes.length, showliked+1)
              ),
            ),
          ),
          SliverStickyHeader(
            header: Header('Will ich nicht sehen'),
            sliver: user.dislikes.length==0? SliverList(
                delegate: SliverChildBuilderDelegate(
                        (context, i)=>EmptyTile(text: 'Du hast noch keine Filme nach links geswiped'),
                  childCount: 1,
                        )):
            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (context, i){
                    if(i==showdis && !(showdis+1==user.dislikes.length)){
                      return InkWell(
                        onTap: (){
                          setState(() {
                            showdis += max;
                          });
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('Mehr...'),
                          ),
                        ),
                      );
                    }else{
                      return LikedMovieTile(filmString: user.dislikes.reversed.toList()[i],
                          user: user,
                          liked: false,
                          onLiked: (){like(user.dislikes.reversed.toList()[i], false, user);});
                    }
                  },
                  childCount: min(user.dislikes.length, showdis+1)
              ),
            ),
          ),
          SliverList(delegate: SliverChildBuilderDelegate(
              (context, i)=>SizedBox(height: 65,),
            childCount: 1
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          showDialog(
            context: context,
            builder: (_) => AddMovie(user: user,),
          );
        },
        label: Text('Film hinzufügen'),
        icon: Icon(Icons.add),
      ),
    );
  }
}


class Header extends StatelessWidget {
  final String text;
  Header(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(text ),
        ),
      ),
    );
  }
}

