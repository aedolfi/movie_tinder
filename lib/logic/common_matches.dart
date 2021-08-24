import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';

List<String> sharedMatches(MyUser user, MyUser friend){
  List<String> list = <String>[];
  DatabaseService databaseService = DatabaseService(user.uid);
  for(String film in user.likes){
    if(friend.likes.contains(film)){
      String friendMatch = user.uid+':'+film+':'+friend.uid;
      String userMatch = friend.uid+':'+film+':'+user.uid;
      list.add(userMatch);
      if(!friend.matches.contains(friendMatch)){
        friend.matches.add(friendMatch);
        databaseService.updateUser(friend);
      }
      if(!(user.matches.contains(userMatch))){
        user.matches.add(userMatch);
        databaseService.updateUser(user);
      }
    }
  }
  return list;
}