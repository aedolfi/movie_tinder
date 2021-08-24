import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_tinder/models/film.dart';

class FilmCard extends StatelessWidget {
  final Film film;
  final double elevation;
  final double textOpacity;
  FilmCard(this.film, {this.elevation,this.textOpacity=1});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: elevation,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(film.poster)
                )
              ),
            ),
            Opacity(
              opacity: textOpacity,
              child: Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.white.withAlpha(0),
                      Colors.white12,
                      Colors.white
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    film.title,
                    style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold, ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
