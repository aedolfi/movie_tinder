
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_tinder/services/auth.dart';
import 'package:movie_tinder/ui/auth/authenticate.dart';
import 'package:movie_tinder/ui/error.dart';
import 'package:movie_tinder/ui/home/home.dart';
import 'package:movie_tinder/ui/loading.dart';
import 'package:provider/provider.dart';
import 'services/deeplink.dart';


void main() {
  runApp(App());
}


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomeThingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(home: Loading());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Cinematch',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.pink,
          secondaryHeaderColor: Color.fromRGBO(255, 200, 229, 1) ,//also change in shared/colors.dart
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper()
      ),
    );
  }
}


class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  void initState() {
    super.initState();
    DynamicLinkService().handleDynamicLinks(context);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    print('USER:' + user.toString());
    return (user==null)? Authenticate(): Home();
  }
}


