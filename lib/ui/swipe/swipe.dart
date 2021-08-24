import 'package:flutter/material.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:movie_tinder/ui/swipe/film_card.dart';
import 'package:movie_tinder/models/film.dart';
import 'package:movie_tinder/ui/loading.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:movie_tinder/ui/swipe/film_information.dart';
import 'package:movie_tinder/logic/choose_movies_to_display.dart';

class Swipe extends StatefulWidget {
  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  AnimationController _zoomController;
  Animation _zoomAnimation;
  Offset _offset;
  Offset _informationOffset;
  double _angle;
  Offset _buttonsoffset;
  double _elevation;
  double _secondelevation;
  double _padding;
  double _opacity;
  bool _zoomed;
  int i =0;
  double dx = 0;
  double _swipeDirection= 1;
  bool _showInfo=true;
  List<Film> films = <Film>[];
  Offset _stackOffset;
  AnimationController _stackAnimationController;
  Animation _stackAnimation;
  double _reloadAngle;
  bool lookedForFilms = false;


  _onLike(Film film, MyUser user, int length)async{
    _like(film, user);
    setState(() {
      _swipeDirection = 1;
    });
    await _animationController.forward();
    if(i==length-1){
      setState(() {
        _showInfo=false;
      });
      await _zoomController.forward();
    }
    setState(() {
      i++;
    });
    _animationController.reset();
  }
  
  _like(Film film, MyUser user){
    user.likes.add(film.id);
    print('Liked ${film.title}, id: ${film.id}');
    DatabaseService(user.uid).update(user);
    _checkMatches(film, user);
  }

  Future<void> _checkMatches(Film film, MyUser user) async{
    DatabaseService databaseService = DatabaseService(user.uid);
    for(String uid in user.friends){
      MyUser friend = await databaseService.userAtUid(uid);
      if(friend.likes.contains(film.id)){
        String matchStringUser = friend.uid+':'+film.id+':'+user.uid;
        String matchStringFriend = user.uid+':'+film.id+':'+friend.uid;
        if (!user.matches.contains(matchStringUser)) {
          user.matches.add(matchStringUser);
          databaseService.updateUser(user);
        }
        if (!friend.matches.contains(matchStringFriend)) {
          friend.matches.add(matchStringFriend);
          databaseService.updateUser(friend);
        }
      }
    }
  }

  _onDislike(Film film, MyUser user, int length)async{
    _dislike(film, user);
    setState(() {
      _swipeDirection=-1;
    });
    await _animationController.forward();
    if(i==length-1){
      setState(() {
        _showInfo=false;
      });
      await _zoomController.forward();
    }
    setState(() {
      i++;
    });
    _animationController.reset();
  }
  
  _dislike(Film film, MyUser user){
    user.dislikes.add(film.id);
    print('Disliked ${film.title}, id: ${film.id}');
    DatabaseService(user.uid).update(user);
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offset = Offset.zero;
    _informationOffset = Offset(0, 1000);
    _angle = 0;
    double maxelev=10;
    _elevation = maxelev;
    _secondelevation = 0;
    _animationController = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = _animationController.drive(CurveTween(curve: Curves.easeInOut));
    _animation.addListener(() {
      setState(() {
        _offset=Offset(_swipeDirection*_animation.value*500 , 0);
        _angle = _swipeDirection*_animation.value* pi * 0.1;
        _secondelevation = _animation.value * 10;
      });
    });

    double maxpad=20;
    _padding = maxpad;
    _opacity = 0;
    _buttonsoffset = Offset.zero;
    _zoomController = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _zoomAnimation =_zoomController.drive(CurveTween(curve: Curves.easeInOut));
    _zoomAnimation.addListener(() {
      setState(() {
        _elevation = maxelev-_zoomAnimation.value*maxelev;
        _padding = maxpad - _zoomAnimation.value*maxpad;
        _opacity = _zoomAnimation.value;
        _buttonsoffset= Offset(0,200*_zoomAnimation.value);
        if (_showInfo) {
          _informationOffset = Offset(0,-1000*_zoomAnimation.value + 1000);
        }
      });
    });
    _zoomed = false;


    _stackOffset=Offset(0,-1000);
    _reloadAngle=0;
    _stackAnimationController=AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _stackAnimation = _stackAnimationController.drive(CurveTween(curve: Curves.easeOut));
    _stackAnimation.addListener(() {
      setState(() {
        _stackOffset= Offset(0,-1000*_stackAnimation.value + 1000);
        _reloadAngle= -2*pi*_stackAnimation.value;
      });
    });



  }

  Future<void> getFilms(MyUser user) async{
    films= await moviesToDisplay(user: user);
    setState(() {
      print('Selected Filme: '+films.toString());
    });
    _stackAnimationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    MyUser user=Provider.of<MyUser>(context);
    if(user!= null && (films.isEmpty) && !lookedForFilms){
     getFilms(user);
     setState(() {
       lookedForFilms =true;
     });
    }
    return (films == null || user == null)? Loading() :(i>films.length-1?
    Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0),
            radius: 75,
            child: Image.asset('assets/foreground.png')
        ),
        Text('One does not simply swipe all the Movies.'),
        Transform.rotate(
          angle: _reloadAngle,
          child: IconButton(
            iconSize: 25,
            icon: Icon(Icons.replay_rounded, color: Colors.grey,),
            onPressed: (){
              _stackAnimationController.reset();
              if(user!= null){
               getFilms(user);
              }
            },
          ),
        )
      ],
    ),):
        Container(
      padding: EdgeInsets.all(_padding),
      child: GestureDetector(
        onTap: (){
          if(_zoomed){
            _zoomController.reverse();
            setState(() {
              _zoomed=false;
            });
          }else{
            _zoomController.forward();
            setState(() {
              _zoomed=true;
            });
          }
        },
        onHorizontalDragUpdate: (details){
          if (!_zoomed) {
            setState(() {
              dx+=details.delta.dx;
              if(dx>0){
                _swipeDirection = 1;
              }else{
                _swipeDirection = -1;
              }
              _animationController.value=_swipeDirection*dx/250;
            });
          }
        },
        onHorizontalDragEnd: (_)async{
          if(_swipeDirection*dx>100){
            setState(() {
              dx=0;
              if(_swipeDirection==1){
                _like(films[i], user);
              }else{
                _dislike(films[i], user);
              }
            });
            await _animationController.forward();
            if(i==films.length-1){
              setState(() {
                _showInfo=false;
              });
              await _zoomController.forward();
            }
            setState(() {
              _animationController.value=0;
              i++;
            });
          }else{
            _animationController.reverse();
            setState(() {
              dx=0;
            });
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
        Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0),
              radius: 75,
              child: Image.asset('assets/foreground.png')
            ),
            Text('One does not simply swipe all the Movies.'),
            IconButton(
              iconSize: 25,
              icon: Icon(Icons.replay_rounded, color: Colors.grey,),
              onPressed: (){
                print('furz');
              },
            )
          ],
        )),
            Transform.translate(
              offset: _stackOffset,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  i<films.length -1 ? FilmCard(films[i+1], elevation: _secondelevation,) :Container() ,

                  i<=films.length -1 ?Transform.translate(
                    offset: _offset,
                      child: Transform.rotate(
                        angle: _angle,
                          child: Opacity(
                            opacity: 1,
                              child: FilmCard(films[i], elevation: _elevation, textOpacity: 1-_opacity)
                          )
                      )) : Container(),
                  Transform.translate(
                    offset: _buttonsoffset,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FloatingActionButton(onPressed: ()=> _onDislike(films[i], user, films.length), child: Icon(Icons.thumb_down_alt_rounded),),
                        FloatingActionButton(onPressed: ()=>_onLike(films[i], user, films.length), child: Icon(Icons.thumb_up_alt_rounded),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(offset: _informationOffset,
                child: FilmInformation(film: films[i], backgroundColor: Colors.black.withOpacity(0.5))),
          ],
        ),
      ),
    ));
  }
}



