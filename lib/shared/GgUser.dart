import 'User.dart';

class GgUser extends User{
  String name;
  String email;
  String pictureURL;
  String type;

  GgUser({
    this.name,
    this.email,
    this.pictureURL,
    this.type
  });

  factory GgUser.fromJson(Map parsedJson){
    return GgUser(
        name: parsedJson['displayName'],
        email : parsedJson['email'],
        pictureURL : parsedJson['photoUrl'],
        type: "Google",
    );
  }

  String toString() {
    return this.name + " " + this.email + " " + this.pictureURL ;
  }

}
