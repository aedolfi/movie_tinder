import 'package:flutter/material.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:movie_tinder/shared/colors.dart';
import 'package:movie_tinder/ui/CircularImage.dart';

class AddAFriendDialog extends StatefulWidget {
  final MyUser user;
  AddAFriendDialog({this.user});
  @override
  _AddAFriendDialogState createState() => _AddAFriendDialogState();
}

class _AddAFriendDialogState extends State<AddAFriendDialog> {
  String mail='';
  MyUser friend;
  final _formKey= GlobalKey<FormState>();
  TextEditingController controller;
  List<MyUser> userSearch = <MyUser>[];
  DatabaseService databaseService;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =TextEditingController();
    databaseService =DatabaseService(widget.user.uid);
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Füge eine Freund*in hinzu', style: TextStyle(color: Theme.of(context).primaryColor),),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecorationWithIcon('Email deiner Freund*in', Icons.alternate_email_rounded),
                onChanged: (text)async{
                  setState(() {
                    mail=text;
                  });
                  if (mail.isNotEmpty) {
                    userSearch = (await databaseService.searchForUser(mail, 3)).where((element) => element.uid!=widget.user.uid).toList();
                  }else{
                    userSearch = <MyUser>[];
                  }
                  setState(() {

                  });
                  print(userSearch.toString());
                  if(userSearch.where((element) => element.mail==mail).isNotEmpty){
                    setState(() {
                      friend = userSearch.firstWhere((element) => element.mail==mail);
                    });
                  }
                },
                validator: (_){
                  if(friend==null){
                    return 'Die Mail konnte nicht gefunden werden';
                  }else if(widget.user.friends.contains(friend.uid)){
                    return 'Ihr seit bereits befreundet';
                  }else{
                    return null;
                  }
                },
              ),
              (userSearch.isEmpty)? SizedBox(height: 0,):
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Theme.of(context).secondaryHeaderColor, width: 2)
                    ),
                    height: 100,
                    width: 400,
                    child: ListView.builder(
                      itemCount: userSearch.length,
                        itemBuilder: (context,i){
                       return ListTile(
                         onTap: (){
                           setState(() {
                             friend=userSearch[i];
                             controller.text=friend.mail;
                           });
                         },
                          leading: CircleImage(
                            radius: 35,
                            image: userSearch[i].pic,
                          ),
                          title: Text(userSearch[i].name),
                         subtitle: Text(userSearch[i].mail),
                        );
                        }),
                  )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          if(_formKey.currentState.validate()){
            MyUser newUser = widget.user;
            newUser.sentRequest.add(friend.uid);
            friend.receivedRequest.add(newUser.uid);
            DatabaseService(widget.user.uid).updateUser(newUser);
            DatabaseService(widget.user.uid).updateUser(friend);
            Navigator.pop(context);
          }
        },
            child: Text('Hinzufügen')),
        TextButton(onPressed: (){
          Navigator.pop(context);
        },
            child: Text('Abbrechen'))
      ],
    );
  }
}
