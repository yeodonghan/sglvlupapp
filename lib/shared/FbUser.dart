import 'User.dart';

class FbUser extends User{
  String name;
  String email;
  String pictureURL;
  String type;

  FbUser({
    this.name,
    this.email,
    this.pictureURL,
    this.type,
  });

  factory FbUser.fromJson(Map parsedJson){
    return FbUser(
        name: parsedJson['name'],
        email : parsedJson['email'],
        pictureURL : parsedJson['picture']['data']['url'],
        type : "Facebook"
    );
  }


}
