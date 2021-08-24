import 'package:flutter/material.dart';

class EmptyTile extends StatelessWidget {
  final String text;
  EmptyTile({this.text});
  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(subtitle: Text(text),),);
  }
}
