import 'package:flutter/material.dart';

Color secondaryHeaderColor = Color.fromRGBO(255, 200, 229, 1);



InputDecoration inputDecorationWithIcon(String hintText, IconData icon){
  return InputDecoration(
    icon: Icon(icon),
    hintText: hintText,
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: secondaryHeaderColor ,
          width: 2,
        )
    ),
  );
}

InputDecoration inputDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: secondaryHeaderColor ,
          width: 2,
        )
    ),
  );
}

InputDecoration inputDecorationForPositionDetails(){
  return InputDecoration(
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: secondaryHeaderColor,
          width: 2,
        )
    ),
    border: InputBorder.none,
    );
}

TextStyle errorStyle= TextStyle(color: Colors.red[700], fontSize: 12);