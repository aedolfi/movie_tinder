import 'package:movie_tinder/models/film.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FilmInformation extends StatelessWidget {
  final Film film;
  final Color backgroundColor;
  final Color _textColor = Colors.white;
  final TextStyle _textStyle = TextStyle(color: Colors.white);
  final bool showButton;
  FilmInformation({this.film, this.backgroundColor, this.showButton=true});


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          showButton? FloatingActionButton(
            onPressed: null,
            child: Icon(Icons.arrow_downward_rounded, color: _textColor,),
            backgroundColor: backgroundColor,
          ) : SizedBox(height: 0,),
          Container(
            decoration: BoxDecoration(
                color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(film.title ?? '', style:  _textStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                ListTile(
                  title: Text(film.beschreibung ?? '', style: _textStyle,),
                ),
                ListTile(
                  title: Text('Hier gehts zum Trailer', style: _textStyle,),
                  trailing: Icon(Icons.ondemand_video, color: _textColor,),
                  onTap: ()async{
                    String url = film.trailer;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
