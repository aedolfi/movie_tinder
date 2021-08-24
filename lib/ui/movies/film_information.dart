import 'package:flutter/material.dart';
import 'package:movie_tinder/models/film.dart';
import 'package:movie_tinder/ui/swipe/film_card.dart';
import 'package:movie_tinder/ui/swipe/film_information.dart';

class FilmInformationDialog extends StatefulWidget {
  final Film film;
  FilmInformationDialog({this.film});

  @override
  _FilmInformationDialogState createState() => _FilmInformationDialogState();
}

class _FilmInformationDialogState extends State<FilmInformationDialog> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  Animation _animation;
  Offset _offset;
  bool _info=true;



  @override
  void initState() {
    super.initState();
    _animationController= AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation= _animationController.drive(CurveTween(curve: Curves.easeIn));

    _offset=Offset.zero;
    _animation.addListener(() {
      setState(() {
        _offset=Offset(0, 1000*_animation.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: GestureDetector(
        onTap: (){
          if(_info){
            setState(() {
              _info=false;
            });
            _animationController.forward();
          }else{
            setState(() {
              _info=true;
            });
            _animationController.reverse();
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            FilmCard(widget.film, textOpacity: 0,),
            Transform.translate(
                offset: _offset,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                         FilmInformation(film: widget.film, backgroundColor: Colors.black.withOpacity(0.5), showButton: false,),
                    ],
                  ),
                ),)
          ],
        ),
      ),
    );
  }
}
