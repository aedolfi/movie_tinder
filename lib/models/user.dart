class MyUser{
  String name;
  String mail;
  String uid;
  String pic;
  List<dynamic> friends;
  List<dynamic> likes;
  List<dynamic> dislikes;
  List<dynamic> uploads;
  List<dynamic> sentRequest;
  List<dynamic> receivedRequest;
  List<dynamic> matches;


  MyUser({
    this.name,
    this.mail,
    this.uid,
    this.pic,
    this.friends,
    this.likes,
    this.dislikes,
    this.uploads,
    this.sentRequest,
    this.receivedRequest,
    this.matches
  });

  String toString(){
    return 'User{name: $name, mail: $mail, uid: $uid, pic: $pic, friends: ${friends.toString()}';
  }

  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'mail': mail,
      'uid': uid,
      'pic': pic,
      'friends': friends,
      'likes': likes,
      'dislikes': dislikes,
      'uploads': uploads,
      'sentRequests': sentRequest,
      'receivedRequests': receivedRequest,
      'matches' : matches
    };
  }
}