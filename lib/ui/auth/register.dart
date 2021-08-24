import 'package:flutter/material.dart';
import 'package:movie_tinder/services/auth.dart';
import 'package:movie_tinder/shared/colors.dart';
import 'package:movie_tinder/ui/loading.dart';



class Register extends StatefulWidget {
  final Function toggleView;
  Register(this.toggleView);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey= GlobalKey<FormState>();


  String email='';
  String password='';
  String otherpassword='';
  String name = '';
  bool loading=false;


  String error ='';
  String suceed = '';

  @override
  Widget build(BuildContext context) {
    return loading? Loading(): Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
    title: Text('Registrieren', style: TextStyle(color: Theme.of(context).primaryColor),)),
      body: Builder(
        builder: (BuildContext context){
          return ListView(
            children: <Widget>[Container(
              padding: EdgeInsets.symmetric(vertical: 0,
                  horizontal: 50),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20,),
                        TextFormField(
                          onChanged: (value){
                            setState(() {
                              name=value;
                            });
                          },
                          validator: (value){
                            return value.isEmpty? 'Bitte einen Namen eingeben' : null;
                          },
                          decoration: inputDecorationWithIcon('Name', Icons.perm_identity),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          validator: (value){
                            return value.isEmpty? 'Bitte eine E-Mail eingeben': null;
                          },
                          decoration: inputDecorationWithIcon(
                            'e-mail',
                            Icons.alternate_email,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value){
                            setState(() {
                              email=value;
                            });
                          },
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          validator: (value){
                            return value.length<6 ? 'Bitte mindestens 6 Zeichen eingeben' : null;
                          },
                          decoration: inputDecorationWithIcon('Passwort', Icons.vpn_key),
                          obscureText: true,
                          onChanged: (value){
                            setState(() {
                              password=value;
                            });
                          },
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          validator: (value){
                            return value==password ? null : 'Die Passwörter stimmen nicht überein';
                          },
                          decoration:inputDecorationWithIcon('Passwort bestätigen', Icons.vpn_key),
                          obscureText: true,
                          onChanged: (value){
                            setState(() {
                              otherpassword=value;
                            });
                          },
                        ),
                        SizedBox(height: 20,),
                        OutlinedButton(
                          child: Text('Nutzer registrieren',),
                          onPressed: ()async{
                            setState(() {
                              error='';
                              suceed='';
                            });
                            if(_formKey.currentState.validate()){
                              setState(() {
                                loading=true;
                              });
                              dynamic result;
                              result = await _auth.registerWithEmailAndPassword(email.trim(), password, name);
                              print((result==null));
                              if(result == null){
                                setState(() {
                                  loading=false;
                                });
                                setState(() {
                                  error = 'Sorry. Etwas ist schiefgelaufen. Bitte versuchen Sie es erneut.';
                                });
                              }else{
                                setState(() {
                                  loading=false;
                                });
                                suceed = 'Der Sportler '+result.email + ' wurde erfolgreich hinzugefügt.';
                              }
                            }
                          },
                        ),
                        TextButton(
                          child: Text('Login'),
                          onPressed: (){
                            widget.toggleView();
                          },
                        ),
                        Text(error, style: TextStyle(color: Colors.red),),
                        Text(suceed),
                      ],
                    ),
                  ),
                ],
              ),
            )],
          );
        },
      ),
    );
  }
}
