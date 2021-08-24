import 'package:movie_tinder/services/deeplink.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_tinder/models/match.dart';
import 'package:movie_tinder/ui/CircularImage.dart';
import 'package:movie_tinder/ui/movies/film_information.dart';
import 'package:pimp_my_button/pimp_my_button.dart';
import 'package:share/share.dart';

class MatchCard extends StatefulWidget {
 final MyMatch match;
  MatchCard({this.match});
  @override
  _MatchCardState createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  double _height = 20;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
          child: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: _height,),
                        Stack(alignment: Alignment.center,
                          children: [
                            PimpedButton(
                              particle: DemoParticle(),
                              pimpedWidgetBuilder: (context, controller){
                                controller.duration=Duration(seconds: 1);
                                controller.addListener(() {
                                  if(controller.isCompleted){
                                    controller.reset();
                                    controller.forward();
                                  }
                                });
                                controller.forward();
                                return SizedBox(height: 25, width: 100,);
                              },
                            ),
                              Text('It\'s a Match!',
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                              )
                          ],
                        ),
                        SizedBox(height: _height,),
                        Text('Du und ${widget.match.friend.name} wollt den gleichen Film ansehen.'),
                        SizedBox(height: _height,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleImage(
                              radius: 100,
                              image: widget.match.user.pic,
                            ),
                            CircleImage(
                              radius: 100,
                              image: widget.match.friend.pic
                            )
                          ],
                        ),
                        SizedBox(height: _height,),
                        Text('Ihr interessiert euch beide für:'),
                        SizedBox(height: _height,),
                        TextButton(onPressed: () {
                          showDialog(context: context,
                          builder: (_) => FilmInformationDialog(film: widget.match.film));
                        }, child: Text(widget.match.film.title)),
                        FlatButton(
                          color: Theme.of(context).primaryColor,
                            onPressed: ()async{
                            Uri uri = await DynamicLinkService().createDynamicUrl(widget.match);
                            String link = uri.toString();
                            print(link);
                          Share.share('Lass uns zusammen ${widget.match.film.title} gucken. $link', subject: 'It\'s a Match!');
                        },
                            child: Text('Verabredet euch zum Filmabend', style: TextStyle(color: Colors.white),)),
                        SizedBox(height: _height,),
                      ],
                    ),
                  ),
      ),
    );
  }
}
