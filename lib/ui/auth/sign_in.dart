import 'package:flutter/material.dart';
import 'package:movie_tinder/services/auth.dart';
import 'package:movie_tinder/shared/colors.dart';
import 'package:movie_tinder/ui/loading.dart';




class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn(this.toggleView);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey= GlobalKey<FormState>();

  String email='';
  String password='';
  String name = '';
  String error ='';

  bool loading= false;

  @override
  Widget build(BuildContext context) {
    return loading? Loading(): Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        title: Text('Anmelden', style: TextStyle(color: Theme.of(context).primaryColor),),),
      body: Builder(
        builder: (BuildContext context){
          return ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20,
                    horizontal: 50),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20,),
                          TextFormField(
                            validator: (value){
                              return value.isEmpty ? 'Bitte geben Sie eine Email ein' : null;
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
                              return value.isEmpty ? 'Bitte geben Sie ein Passwort ein' : null;
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
                          ElevatedButton(
                            child: Text('Anmelden',
                              style: TextStyle(
                              ),),
                            onPressed: ()async{
                              if(_formKey.currentState.validate()){
                                setState(() {
                                  loading=true;
                                });
                                dynamic result = await _auth.signInWithEmailAndPassword(email.trim(), password);
                                if(result == null){
                                  setState(() {
                                    loading=false;
                                    error='Passwort oder Email scheinen nicht korrekt zu sein. Bitte versuchen Sie es erneut.';
                                  });
                                }
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    TextButton(
                      child: Text('Registrieren'),
                      onPressed: (){
                        widget.toggleView();
                      },
                    ),
                    Text(error,
                      style: TextStyle(color: Colors.red),)
                  ],
                ),
              ),
            ],);
        },
      ),
    );
  }
}
