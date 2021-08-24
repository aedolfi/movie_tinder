import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_tinder/models/user.dart';

class ShowPicture extends StatelessWidget {
  final MyUser user;
  ShowPicture(this.user);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Hero(
        tag: user.pic,
        child: Container(
          height: 500,
          width: 500,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(user.pic)
            )
          ),
        ),
      ),
    );
  }
}
