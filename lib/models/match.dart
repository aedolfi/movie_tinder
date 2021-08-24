import 'package:movie_tinder/models/film.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';

class MyMatch{
  MyUser friend;
  Film film;
  MyUser user;
  MyMatch({this.film, this.friend, this.user});
  DataBaseServiceMatch _databaseServiceMatch = DataBaseServiceMatch();

  Future<MyMatch> fromString(String string) async{
    List<String> parts = string.split(':');
    print(parts.toString());
    friend= await _databaseServiceMatch.userAtUid(parts[0]);
    film = await _databaseServiceMatch.filmAtId(parts[1]);
    user= await _databaseServiceMatch.userAtUid(parts[2]);
    return this;
  }

  String toString(){
    return friend.uid+':'+film.id+':'+ user.uid;
  }


}