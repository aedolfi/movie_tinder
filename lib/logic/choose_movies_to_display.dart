import 'package:movie_tinder/models/film.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';

Future<List<Film>> moviesToDisplay({MyUser user})async{
  int i = 20;
  DatabaseService dataBaseServiceMatch = DatabaseService(user.uid);
  List<Film> chosen = <Film>[];
  for(String uid in user.friends){
    MyUser friend = await dataBaseServiceMatch.userAtUid(uid);
    for(String id in friend.likes){
      if(!(_xor(user.likes.contains(id),user.dislikes.contains(id)))&& i<20){
        Film film = await dataBaseServiceMatch.filmAtId(id);
        chosen.add(film);
        i++;
      }
    }
  }
  List<Film> someFilms = await dataBaseServiceMatch.getSomeFilms(25-chosen.length);
  for(Film movie in someFilms){
    String id = movie.id;
    if(!(_xor(user.likes.contains(id),user.dislikes.contains(id)))&& i<25){
      chosen.add(movie);
      i++;
    }
  }

  return chosen;
}


bool _xor(bool first, bool second){
  return ((first && !second) || (!first && second));
}