class Film{
  String title;
  String poster;
  String id;
  String trailer;
  String beschreibung;


  Film({this.title, this.poster, this.id, this.trailer, this.beschreibung});

  String toString(){
    return 'Film{title: $title, poster: $poster, id: $id}';
  }

  Map<String, dynamic> toMap(){
    return{
      'title': title,
      'poster': poster,
      'id': id,
      'trailer': trailer,
      'beschreibung': beschreibung,
    };
  }

}