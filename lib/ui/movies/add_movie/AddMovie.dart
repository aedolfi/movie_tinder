import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_tinder/models/film.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/services/database.dart';
import 'package:movie_tinder/services/storage.dart';
import 'package:movie_tinder/shared/colors.dart';
import 'package:movie_tinder/ui/CircularImage.dart';
import 'package:movie_tinder/ui/loading.dart';
import 'dart:math';

class AddMovie extends StatefulWidget {
  final MyUser user;
  final Film film;
  AddMovie({@required this.user , this.film});
  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  String title='';
  String poster;
  String id;
  bool posterLoading =false;
  bool loading = false;
  String trailer;
  String beschreibung;
  String error;
  ImagePicker _picker = ImagePicker();
  ImageSource source = ImageSource.gallery;
  final _formKey= GlobalKey<FormState>();
  PickedFile _imageFile;
  DatabaseService databaseService;
  List<Film> filmSearch;



  Future<void> _uploadPoster() async{
      try {
        final pickedFile = await _picker.getImage(
          source: source,
          maxWidth: 900,
          maxHeight: 900,
        );
        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          error='Upload fehlgeschlagen';
        });
        print(e);
      }
      if (_imageFile!= null){
        try {
          setState(() {
            posterLoading =true;
          });
          String name=(title ?? '' )+ (widget.film != null ? widget.film.id :((title ?? '' ) + DateTime.now().millisecondsSinceEpoch.toString()));
          print('NAME: $name');
          File savedImage = File(_imageFile.path);
          String url = await StorageService().uploadPoster(name, savedImage);
          poster = url;
          setState(() {
            posterLoading = false;
          });
        } on Exception catch (e) {
          print(e);
          setState(() {
            error= 'Upload fehlgeschlagen';
          });
        }
      }
  }

  TextEditingController _controllerTitle;
  TextEditingController _controllerTrailer;
  TextEditingController _controllerBeschreibung;



  @override
  void initState() {
    super.initState();
    if (widget.film != null) {
      title=widget.film.title;
      poster=widget.film.poster;
      trailer= widget.film.trailer;
      beschreibung = widget.film.beschreibung;
      id=widget.film.id;
    }
    _controllerBeschreibung=TextEditingController(text: beschreibung);
    _controllerTitle=TextEditingController(text: title);
    _controllerTrailer=TextEditingController(text: trailer);
    databaseService=DatabaseService(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return loading? Loading():
    Scaffold(
      appBar: AppBar(
        elevation: 0,
          backgroundColor: Colors.white.withOpacity(0),
          leading: IconButton(icon: Icon(Icons.arrow_back_rounded), onPressed: ()=>Navigator.pop(context), color: Theme.of(context).primaryColor,),
          title: Text('Film ${widget.film==null? 'hinzufügen' : 'bearbeiten'}', style: TextStyle(color: Theme.of(context).primaryColor),)),
      body: Column(
        children: [
          Expanded(
              child: ListView(
                children:[ Form(
                  key: _formKey,
                  child: ListBody(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller:_controllerTitle,
                          onChanged: (text) async{
                            setState(() {
                              title = text;
                            });
                            if (title.isNotEmpty) {
                              filmSearch = await databaseService.searchForMovie(title, 10);
                            }else{
                              filmSearch=<Film>[];
                            }
                          },

                          decoration: inputDecoration('Filmtitel'),
                          validator: (text) => (text.isEmpty || text== null)? 'Bitte gib einen Titel ein' : null,
                        ),
                      ),
                      filmSearch==null? SizedBox(height: 0,):
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Theme.of(context).secondaryHeaderColor, width: 2)
                              ),
                              height: min(60*filmSearch.length.toDouble(),180),
                              child: ListView.builder(
                                itemCount: filmSearch.length,
                                  itemBuilder: (context, i){
                                  return ListTile(
                                    onTap: (){
                                      _controllerTitle.text=filmSearch[i].title;
                                      _controllerBeschreibung.text=filmSearch[i].beschreibung;
                                      _controllerTrailer.text=filmSearch[i].trailer;
                                      poster= filmSearch[i].poster;
                                      id=filmSearch[i].id;
                                      setState(() {

                                      });
                                    },
                                    leading: CircleImage(
                                    radius: 25,
                                      image: filmSearch[i].poster,
                                    ),
                                    title: Text(filmSearch[i].title),
                                  );
                                  }),
                            ),
                          ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: posterLoading ?
                          SizedBox(height: 50, width: 50 ,child: CircularProgressIndicator()) :
                          InkWell(
                            onTap: _uploadPoster,
                            child: (poster==null?  Icon(Icons.add_photo_alternate_rounded, size: 50, color: Theme.of(context).secondaryHeaderColor,):
                            CircleImage(radius: 200, image: poster,)),
                          ),
                        ),
                      ),
                      error==null ? SizedBox(height: 5,) : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(error, style: errorStyle,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _controllerTrailer,
                          onChanged: (text){
                            setState(() {
                              trailer = text;
                            });
                          },
                          decoration: inputDecoration('Trailer (YouTube-Link)'),
                          validator: (text) => text.isEmpty ? null : ((text.contains('youtu'))? null : 'Bitte gib einen YouTube-Link ein'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _controllerBeschreibung,
                          onChanged: (text){
                            setState(() {
                              beschreibung = text;
                            });
                          },
                          maxLines: null,
                          decoration: inputDecoration('Beschreibung'),
                        ),
                      ),
                    ],
                  ),
                )],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: ()async{
                  bool pos = poster==null;
                  if(pos){
                    setState(() {
                      error = 'Bitte lade ein Poster hoch, sonst sieht das alles doof aus';
                    });
                  }
                  if(_formKey.currentState.validate() && !pos){
                    Film film = Film(
                        title: title,
                        poster: poster,
                        trailer: trailer ?? 'https://www.youtube.com/results?search_query=${title.replaceAll(' ', '+')}+trailer',
                        beschreibung: beschreibung,
                        id: id??'${title.replaceAll(' ', '_').replaceAll('/', '_').replaceAll(':', '_')}_${DateTime.now().millisecondsSinceEpoch.toString()}'
                    );
                    setState(() {
                      loading=true;
                    });
                    await DatabaseService(widget.user.uid).updateFilm(film);
                    MyUser newUser = widget.user;
                    if(widget.film==null) {
                      newUser.uploads.add(film.id);
                    }if (!newUser.likes.contains(film.id)) {
                      newUser.likes.add(film.id);
                      newUser.dislikes.removeWhere((element) => element==film.id);
                    }
                    await DatabaseService(widget.user.uid).updateUser(newUser);
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.film==null? 'Hochladen': 'Aktualisieren'),
              ),
              TextButton(
                child: Text('Abbrechen'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
