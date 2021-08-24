import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {

  final double radius;
   final String image;

  CircleImage({this.radius, this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius,
      width: radius,
      child: Center(

        child: new Container(

            width: radius,

            height: radius,

            decoration: new BoxDecoration(

                shape: BoxShape.circle,

                image: new DecorationImage(

                    fit: BoxFit.cover,

                    image: new NetworkImage(

                        image==''? 'https://firebasestorage.googleapis.com/v0/b/movie-tinder-41126.appspot.com/o/Filmabend.jpg?alt=media&token=0b4620e5-48c3-484d-89a2-c4e814021b9d':
                        image)

                )

            )

        ),

      ),
    );
  }

}