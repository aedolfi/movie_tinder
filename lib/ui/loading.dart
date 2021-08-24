import 'package:flutter/material.dart';
import 'package:movie_tinder/ui/CircularImage.dart';


class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Center(
        child: Stack(
          children: [
           Center(
             child: CircleAvatar(
               backgroundColor: Colors.white.withOpacity(0),
               radius: 75,
               child: Image.asset('assets/foreground.png'),
             ),
           ),
            Center(child: SizedBox(height:150, width: 150, child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}
