import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_tinder/models/film.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:movie_tinder/ui/CircularImage.dart';
import 'package:movie_tinder/ui/movies/film_information.dart';

class LikedMovieTile extends StatefulWidget {
  final String filmString;
  final bool liked;
  final MyUser user;
  final Function onLiked;
  LikedMovieTile({this.filmString, this.liked, this.onLiked, this.user});
  @override
  _LikedMovieTileState createState() => _LikedMovieTileState();
}

class _LikedMovieTileState extends State<LikedMovieTile> {
  Film film;


  Future<Film> getFilm()async{
    if (film==null || film.id!=widget.filmString) {
      Film otherFilm = await DataBaseServiceMatch().filmAtId(widget.filmString);
      setState(() {
        film=otherFilm;
      });
    }
    return film;
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getFilm(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListTile(
                onTap: () {
                  showDialog(context: context,
                      builder: (_) =>
                          FilmInformationDialog(film: film,));
                },
                leading: CircleImage(
                  radius: 70,
                  image: film.poster,
                ),
                title: Text(film.title),
                trailing: IconButton(icon: Icon(
                  widget.liked ? Icons.favorite : Icons.favorite_border_rounded,
                  color: widget.liked ? Theme
                      .of(context)
                      .primaryColor : Colors.grey,),
                  onPressed: () {

                    widget.onLiked();
                  },),
              );
          }else{
              return SizedBox(height: 40,);
            }
          }
        ),
      ),
    );
  }
}
