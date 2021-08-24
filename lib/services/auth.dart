import 'package:firebase_auth/firebase_auth.dart' as au;
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{
  final au.FirebaseAuth _auth= au.FirebaseAuth.instance;
  final DataBaseServiceCreate _databaseService = DataBaseServiceCreate();
  String mail;
  String pw;
  String uid;


  Stream<au.User> get user {
    return _auth.authStateChanges();
  }


  //sign in email
  Future signInWithEmailAndPassword(String email, String password)async{
    try{
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      prefs.setString('password', password);
      au.UserCredential result= await _auth.signInWithEmailAndPassword(email: email, password: password);
      au.User user = result.user;
      return user;
    }catch(_){
      print(_.toString());
      print('am in catch part, returning null');
      return null;
    }
  }



  //register with email and password
  Future registerWithEmailAndPassword(String email, String password, String name)async{
    try{
      final prefs = await SharedPreferences.getInstance();
      au.UserCredential result= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      au.User user = result.user;
      prefs.setString('uid', user.uid);
      MyUser myUser = MyUser(
          name: name,
          mail: email,
          uid: user.uid,
      );
      mail = email;
      uid = user.uid;
     _databaseService.createUser(myUser);
      print('newuser');
      print(result);
      return user;
    }catch(_){
      print(_.toString());
      print('am in catch part, returning null');
      return null;
    }
  }

  //current mail

  Future<String> currentMail() async{
    final prefs =await SharedPreferences.getInstance();
    String mail = prefs.getString('email');
    return mail;
  }

  //sign out
  Future signOut() async{
    try{
      return _auth.signOut();
    }catch(_){
      print(_.toString());
      return null;
    }
  }

}