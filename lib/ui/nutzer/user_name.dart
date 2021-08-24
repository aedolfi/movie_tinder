import 'package:flutter/material.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:movie_tinder/shared/colors.dart';
import 'package:provider/provider.dart';

class UserName extends StatefulWidget {
  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  bool editing = false;
  String name;
  String oldName;
  TextEditingController _editingController =TextEditingController();



  
  _onEditingComplete (MyUser user){
    if(name==null){
      setState(() {
        editing=false;
      });
    }
    if(name.isEmpty || name==null){
      setState(() {
        editing=false;
      });
    }else{
      user.name = name;
      DatabaseService(user.uid).updateUser(user);
      setState(() {
        editing=false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return
      editing ? ListTile(
            title: TextField(
              autofocus: true,
              controller: _editingController,
              decoration: inputDecoration('Name'),
              onChanged: (text){
                setState(() {
                  name=text;
                });
              },
              onEditingComplete: ()=>_onEditingComplete(user),
            ),
            trailing: IconButton(
              icon: Icon(Icons.check),
              onPressed: ()=> _onEditingComplete(user),
            ),
          ):
      ListTile(
        title: Text(user.name),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed:(){
             print('on Pressed');
              setState(() {
               _editingController.text = user.name;
               editing=true;
               oldName=name;
              });
           },
        ),
      )
    ;
  }
}
