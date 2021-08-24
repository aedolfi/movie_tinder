import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:movie_tinder/ui/friends/friends.dart';
import 'package:movie_tinder/ui/matches/matches.dart';
import 'package:movie_tinder/ui/movies/movies_list.dart';
import 'package:movie_tinder/ui/nutzer/profil.dart';
import 'package:provider/provider.dart';
import 'package:movie_tinder/ui/swipe/swipe.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tabIndex=0;
  List<Widget> tabs;

  toggleToFriends(){
    setState(() {
      tabIndex=3;
    });
  }



  @override
  void initState() {
    super.initState();
    tabs=[
      Swipe(),
      Matches(),
      MoviesList(),
      Friends(),
      Profil(toggle: toggleToFriends,)
    ];
  }
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DatabaseService _data = DatabaseService(user.uid);
    return StreamProvider<MyUser>.value(
      value: _data.user,
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: tabs[tabIndex],
            appBar: AppBar(
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: BottomNavigationBar(
                  elevation: 0,
                  selectedItemColor: Theme.of(context).primaryColor,
                  unselectedItemColor: Theme.of(context).secondaryHeaderColor,
                  currentIndex: tabIndex,
                  onTap: (int index){
                    setState(() {
                      tabIndex=index;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.thumbs_up_down_rounded),
                    //backgroundColor: Theme.of(context).primaryColor,
                    label: 'Swipe'),
                    BottomNavigationBarItem(icon: Icon(Icons.favorite),
                        //backgroundColor: Theme.of(context).primaryColor,
                        label: 'Matches'),
                    BottomNavigationBarItem(icon: Icon(Icons.movie_creation_rounded),
                        //backgroundColor: Theme.of(context).primaryColor,
                        label: 'Filme'),
                    BottomNavigationBarItem(icon: Icon(Icons.group),
                        //backgroundColor: Theme.of(context).primaryColor,
                        label: 'Freunde'),
                    BottomNavigationBarItem(icon: Icon(Icons.person_rounded),
                        //backgroundColor: Theme.of(context).primaryColor,
                        label: 'Profil'),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
