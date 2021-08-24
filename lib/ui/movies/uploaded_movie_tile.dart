import 'package:flutter/material.dart';
import 'package:movie_tinder/models/film.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:movie_tinder/ui/CircularImage.dart';
import 'package:movie_tinder/ui/movies/add_movie/AddMovie.dart';
import 'package:movie_tinder/ui/movies/film_information.dart';
import 'package:provider/provider.dart';

class UploadedMovieTile extends StatefulWidget {
  final String filmString;
  UploadedMovieTile({this.filmString});
  @override
  _UploadedMovieTileState createState() => _UploadedMovieTileState();
}

class _UploadedMovieTileState extends State<UploadedMovieTile> {
  Film film;


  Future<Film> getFilm()async{
    if (film==null || film.id != widget.filmString) {
      Film otherFilm = await DataBaseServiceMatch().filmAtId(widget.filmString);
      setState(() {
        film=otherFilm;
      });
    }
    return film;
  }
  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
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
                trailing: IconButton(
                  onPressed: () {
                    showDialog(context: context,
                        builder: (_) =>
                            AddMovie(
                              film: film,
                              user: user,
                            ));
                  },
                  icon: Icon(Icons.edit, color: Theme
                      .of(context)
                      .primaryColor,),
                ),
              );
          }else{
              return SizedBox(height: 60,);
            }
          }
        ),
      ),
    );
  }
}
