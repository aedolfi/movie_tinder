

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_tinder/models/film.dart';
import 'package:movie_tinder/models/user.dart';


class DataBaseServiceCreate{
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
  Future createUser(MyUser user)async{
    await userCollection.doc(user.uid).set(user.toMap());
    print('User '+user.uid+' ist erstellt');
  }
}

class DataBaseServiceMatch{

  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('user');
  final CollectionReference _filmCollection = FirebaseFirestore.instance.collection('movies');

  MyUser _userFromDocumentSnapshot(DocumentSnapshot snap){

    /*
    List _likes =  snap['likes'] ?? [];
    List _dislikes =  snap['dislikes'] ?? [];
    List _uploads = snap['uploads'] ?? [];

    List likes = [];
    for(String string in _likes){
      DocumentSnapshot documentSnapshot = await filmsCollection.doc(string).get();
      likes.add(_filmFromDocumentSnapshot(documentSnapshot));
    }

    List dislikes = [];
    for(String string in _dislikes){
      DocumentSnapshot documentSnapshot = await filmsCollection.doc(string).get();
      dislikes.add(_filmFromDocumentSnapshot(documentSnapshot));
    }

    List uploads = [];
    for(String string in _uploads){
      DocumentSnapshot documentSnapshot = await filmsCollection.doc(string).get();
      uploads.add(_filmFromDocumentSnapshot(documentSnapshot));
    }

    List _friends= snap['friends'] ?? [];
    List friends=[];
    for(String string in _friends){
      DocumentSnapshot documentSnapshot = await userCollection.doc(string).get();
      friends.add(_userFromDocumentSnapshot(documentSnapshot));
    }
    */
    return MyUser(
        name: snap['name'],
        mail: snap['mail'],
        uid: snap['uid'],
        pic: snap['pic'] ?? '',
        friends: snap['friends']??[],
        likes: snap['likes']??[],
        dislikes: snap['dislikes']??[],
        uploads: snap['uploads']??[],
        sentRequest: snap['sentRequests'] ??[],
        receivedRequest: snap['receivedRequests']??[],
        matches: snap['matches'] ?? []
    );
  }

  Film _filmFromDocumentSnapshot(DocumentSnapshot snap){
    return Film(
      title: snap['title'],
      poster: snap['poster'],
      id: snap['id'],
      beschreibung: snap['beschreibung'],
      trailer: snap['trailer'],
    );
  }


  Future<MyUser> userAtUid(String uid) async{
   DocumentSnapshot snapshot = await _userCollection.doc(uid).get();
   return _userFromDocumentSnapshot(snapshot);
  }

  Future<Film> filmAtId(String id) async{
    DocumentSnapshot snapshot= await _filmCollection.doc(id).get();
    return _filmFromDocumentSnapshot(snapshot);
  }

}




class DatabaseService{




  DatabaseService(String uid){
    _profilCollection = FirebaseFirestore.instance.collection('user').doc(uid);
  }
  //reference

  Future<MyUser> userAtUid(String uid) async{
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    return _userFromDocumentSnapshot(snapshot);
  }

  Future<Film> filmAtId(String id) async{
    DocumentSnapshot snapshot= await filmsCollection.doc(id).get();
    return _filmFromDocumentSnapshot(snapshot);
  }


  DocumentReference _profilCollection;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
  final CollectionReference filmsCollection = FirebaseFirestore.instance.collection('movies');

  Future createUser(MyUser user)async{
      await userCollection.doc(user.uid).set(user.toMap());
      print('User '+user.uid+' ist erstellt');
  }

  Future updateUser(MyUser user)async{
    await userCollection.doc(user.uid).set(user.toMap());
    print('User '+user.uid+' ist geändert');
  }

  Future updateFilm(Film film)async{
    await filmsCollection.doc(film.id).set(film.toMap());
  }


  MyUser _userFromDocumentSnapshot(DocumentSnapshot snap){

    /*
    List _likes =  snap['likes'] ?? [];
    List _dislikes =  snap['dislikes'] ?? [];
    List _uploads = snap['uploads'] ?? [];

    List likes = [];
    for(String string in _likes){
      DocumentSnapshot documentSnapshot = await filmsCollection.doc(string).get();
      likes.add(_filmFromDocumentSnapshot(documentSnapshot));
    }

    List dislikes = [];
    for(String string in _dislikes){
      DocumentSnapshot documentSnapshot = await filmsCollection.doc(string).get();
      dislikes.add(_filmFromDocumentSnapshot(documentSnapshot));
    }

    List uploads = [];
    for(String string in _uploads){
      DocumentSnapshot documentSnapshot = await filmsCollection.doc(string).get();
      uploads.add(_filmFromDocumentSnapshot(documentSnapshot));
    }

    List _friends= snap['friends'] ?? [];
    List friends=[];
    for(String string in _friends){
      DocumentSnapshot documentSnapshot = await userCollection.doc(string).get();
      friends.add(_userFromDocumentSnapshot(documentSnapshot));
    }
    */
    return MyUser(
      name: snap['name'],
      mail: snap['mail'],
      uid: snap['uid'],
      pic: snap['pic'] ?? '',
      friends: snap['friends']??[],
      likes: snap['likes']??[],
      dislikes: snap['dislikes']??[],
      uploads: snap['uploads']??[],
      sentRequest: snap['sentRequests'] ??[],
      receivedRequest: snap['receivedRequests']??[],
      matches: snap['matches'] ?? []
    );
  }

  Film _filmFromDocumentSnapshot(DocumentSnapshot snap){
    return Film(
      title: snap['title'],
      poster: snap['poster'],
      id: snap['id'],
      beschreibung: snap['beschreibung'],
      trailer: snap['trailer'],
    );
  }


  List<MyUser> _userListFromDocumentSnapshot(QuerySnapshot snap){
    var docs = snap.docs;
    List<MyUser> list= <MyUser>[];
    for(var doc in docs){
      list.add(_userFromDocumentSnapshot(doc));
    }
    return list;
  }

  List<Film> _filmListFromDocumentSnapshot(QuerySnapshot snap){
    var docs = snap.docs;
    List<Film> list=<Film>[];
    for(var doc in docs){
      list.add(_filmFromDocumentSnapshot(doc));
    }
    return list;
  }

  Future<List<MyUser>> searchForUser(String query, int i)async{
    QuerySnapshot snapshot = await userCollection.where('mail', isGreaterThanOrEqualTo: query).limit(i).get();
    return _userListFromDocumentSnapshot(snapshot);
  }


  Future<List<Film>> searchForMovie(String query, int i) async{
    QuerySnapshot snapshot = await filmsCollection.where('title', isGreaterThanOrEqualTo: query).limit(i).get();
    return _filmListFromDocumentSnapshot(snapshot);
  }

  Stream<List<MyUser>> get allUser{
    return userCollection.snapshots().map(_userListFromDocumentSnapshot);
  }

  Future<List<Film>> getSomeFilms(int i) async{
    QuerySnapshot snapshot = await filmsCollection.limit(i).get();
    return _filmListFromDocumentSnapshot(snapshot);
}

  Stream<List<Film>> get allFilms{
    return filmsCollection.snapshots().map(_filmListFromDocumentSnapshot);
  }












  Stream<MyUser> get user{
    return _profilCollection.snapshots().map(_userFromDocumentSnapshot);
        }

  Future<void> update(MyUser user) async{
    await _profilCollection.set(user.toMap());
    print('User '+user.uid+' ist geändert');
  }






}