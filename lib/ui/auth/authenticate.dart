import 'package:flutter/material.dart';
import 'package:movie_tinder/ui/auth/register.dart';
import 'package:movie_tinder/ui/auth/sign_in.dart';





class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool signin = true;
  void toggleView(){
    setState(() {
      signin=!signin;
    });
  }




  @override
  Widget build(BuildContext context) {
    return  signin? SignIn(toggleView): Register(toggleView);
  }
}
