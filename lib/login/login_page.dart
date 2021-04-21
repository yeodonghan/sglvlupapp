

import 'dart:convert';
import 'dart:io' show Platform;
import 'package:SGLvlUp/audio/SoundsHandler.dart';
import 'package:SGLvlUp/category/category.dart';
import 'package:SGLvlUp/information_tab/policy_dialogue.dart';
import 'package:SGLvlUp/main.dart';
import 'package:SGLvlUp/shared/FbUser.dart';
import 'package:SGLvlUp/shared/GgUser.dart';
import 'package:SGLvlUp/shared/LifecycleManager.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:SGLvlUp/shared/loader.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:SGLvlUp/audio/SoundsHandler.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isLoading = false;
  String apiUrl = "http://ec2-54-255-217-149.ap-southeast-1.compute.amazonaws.com:5000";

  int _pageState = 0;

  double _loginYOffset = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  bool _isLoggedIn = false;
  Map fbuserProfile;
  FbUser fbuser;
  GgUser gguser;
  UserProfile finalUser;
  Future<UserProfile> loggedUserProfile;
  bool isANewUser = false;
  final facebookLogin = FacebookLogin();

  final googleSignIn = GoogleSignIn(
      scopes: [
        'profile',
        'email',
      ]);
  GoogleSignInAccount _currentUser;

  List<Category> listOfCategories  = List<Category>();

  Future<List<Category>> getJsonData() async {
    print("fetching...");
    var response =
    await http.get(apiUrl + "/api/quiz/categories"
    );

    var categorylist = List<Category>();

    if (response.statusCode == 200) {

      var data = jsonDecode(response.body);
      for (var unit in data) {
        categorylist.add(Category.fromJson(unit));
      }
      return categorylist;

    } else {
      throw Exception('Failed to load Categories');
    }
  }
  
  @override
  void initState() {
    Flame.audio.loadAll(['bgm.mp3', 'tap.ogg']);
    SoundsHandler().playBGM();

    this.getJsonData().then((value) {
      setState(() {
        listOfCategories.addAll(value);
      });
    });
    print("Categories initialised Ran");
    super.initState();

    googleSignIn.disconnect();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
        _isLoggedIn = true;
        gguser = GgUser(name: _currentUser.displayName, email: _currentUser.email, pictureURL: _currentUser.photoUrl);
        print(_currentUser);

        Future<UserProfile> getProfile() async{
          http.Response res = await http.post(apiUrl + "/api/user/users/email/",
              body: {
                "user_email" : "${gguser.email}",
              });

          if(res.statusCode == 200) {
            var body = json.decode(res.body);
            UserProfile userProfile = UserProfile.fromJson(body);
            print("User profile found in database");
            print(userProfile);
            finalUser = userProfile;
            print("User Profile used :" + userProfile.user_name);
            return userProfile;
          } else {
            print("Nothing found, creating new User...");

            Future<UserProfile> createProfile() async{
              http.Response res = await http.post(apiUrl + "/api/user/users",
                  body: {
                    "user_name" : "${gguser.name}",
                    "user_pictureurl" : "${gguser.pictureURL}",
                    "user_email" : "${gguser.email}",
                    "user_mobile" : "",
                    "user_accounttype" : "Google",
                    "user_registerdate" : "${DateTime.now().toString()}",
                    "user_coins" : "0",
                    "user_notification" : "1"
                  });
              if(res.statusCode == 200) {
                var body = json.decode(res.body);
                UserProfile userProfile = UserProfile.fromJson(body);
                print(userProfile);
                finalUser = userProfile;
                return userProfile;
              } else {
                print("Error Creating profile in database!");
              }
            }
            isANewUser = true;
            createProfile();
          }
        }

        setState(() {
          loggedUserProfile = getProfile();
          Future.delayed(Duration(seconds: 1), () async {
            if (isANewUser == true) {
              for (int i = 0; i < listOfCategories.length; i++) {
                http.Response res = await http.post(apiUrl + "/api/score/scores",
                    body: {
                      "category" : "${listOfCategories[i].category}",
                      "user_email" : "${finalUser.user_email}",
                      "points" : "0"
                    });
                if (res.statusCode == 200) {
                  print("Initialised scores");
                } else {
                  print("error adding new scores for new users");
                }
              }
            }

          });
        });
        isLoading = true;
        print('isLoading is True');

        Future.delayed(Duration(seconds: 2), () {
          print("Pushing to next screen: " + finalUser.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(finalUser)));
          setState(() {
            isLoading = false;
            print('isLoading is False');
            _isLoggedIn = false;
            googleSignIn.disconnect();
          });

        });

      });
    });
    googleSignIn.signInSilently();

  }


  _loginWithFB() async {
    /*if(Platform.isIOS){
      facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    }*/
    final result = await facebookLogin.logIn(['email']);
    print("Fetched fb user");
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);

        Future<UserProfile> getProfile() async{
          http.Response res = await http.post(apiUrl + "/api/user/users/email/",
            body: {
              "user_email" : "${FbUser.fromJson(profile).email}",
            });

          if(res.statusCode == 200) {
            var body = json.decode(res.body);
            UserProfile userProfile = UserProfile.fromJson(body);
            print("User profile found in database");
            print(userProfile);
            finalUser = userProfile;
            return userProfile;
          } else {
            print("Nothing found, creating new User...");

            Future<UserProfile> createProfile() async{
              http.Response res = await http.post(apiUrl + "/api/user/users",
              body: {
                "user_name" : "${FbUser.fromJson(profile).name}",
                "user_pictureurl" : "${FbUser.fromJson(profile).pictureURL}",
                "user_email" : "${FbUser.fromJson(profile).email}",
                "user_mobile" : "",
                "user_accounttype" : "Facebook",
                "user_registerdate" : "${DateTime.now().toString()}",
                "user_coins" : "0",
                "user_notification" : "1",
              });
              if(res.statusCode == 200) {
                var body = json.decode(res.body);
                UserProfile userProfile = UserProfile.fromJson(body);
                print(userProfile);
                finalUser = userProfile;
                return userProfile;
              } else {
                print("Error Creating profile in database!");
              }
            }
            isANewUser = true;
            createProfile();
          }
        }

        setState(() {
          loggedUserProfile = getProfile();
          fbuserProfile = profile;
          _isLoggedIn = true;
          fbuser = FbUser.fromJson(profile);
          Future.delayed(Duration(seconds: 1), () async {
            if(isANewUser == true) {
              for (int i = 0; i < listOfCategories.length; i++) {
                http.Response res = await http.post(apiUrl + "/api/score/scores",
                    body: {
                      "category" : "${listOfCategories[i].category}",
                      "user_email" : "${finalUser.user_email}",
                      "points" : "0"
                    });
                if (res.statusCode == 200) {
                  print("Initialised scores");
                } else {
                  print("error adding new scores for new users");
                }
              }
            }

          });

          isLoading = true;
          print('isLoading is True');

          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              isLoading = !isLoading;
              print('isLoading is False');
            });

            Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(finalUser), maintainState: false));
          });
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }
  }


  Future<void> _handleGoogleSignIn() async {
    try {
      print("step 1 reached");
      await googleSignIn.signIn();
    } catch(error) {
      print(error);
      print("Failed to sign in");
    }
  }



  @override
  Widget build(BuildContext context) {

    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    switch(_pageState) {
      case 0:
        _loginYOffset = windowHeight;
        break;

      case 1:
        _loginYOffset = 250;
        break;

      case 2:
        _loginYOffset = 250;
        break;
    }

    return isLoading ? Loader()
        :
    LifeCycleManager(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _pageState = 0;
              });
            },
            child: AnimatedContainer(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(
                milliseconds: 1000
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background/informationBG.png'),
                      fit: BoxFit.cover
                  ),

                ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: <Widget>[
                  Container(

                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.1,
                          ),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 100
                                ),
                                child: Center(
                                  child: Image.asset("assets/images/Asset_Logotitle.png"),
                                )
                            ),
                        ),
                        Container(
                          margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Do you know about Singapore's history and culture? Join us to learn more about it!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: "Londrina",
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 100
                    ),
                      child: Center(
                        child: Image.asset("assets/images/Asset_Mascot.png"),
                      )
                  ),
                  Container(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {

                            SoundsHandler().playTap();
                            _pageState = 1;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
                          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFB40284A),
                            borderRadius: BorderRadius.circular(50)
                          ),
                          child: Center(
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: "Londrina",
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              )
            ),
          ),
          AnimatedContainer(
            height: windowHeight - 250,
            padding: EdgeInsets.all(32),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
              milliseconds: 500,
            ),
            transform: Matrix4.translationValues(0, _loginYOffset, 1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25)
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                    SignInButton(
                      Buttons.GoogleDark,
                      text: "Login with Google",
                      onPressed: () {
                        SoundsHandler().playTap();
                        _handleGoogleSignIn();
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    SignInButton(
                      Buttons.Facebook,
                      text: "Login with Facebook",
                      onPressed: () {
                        SoundsHandler().playTap();
                        print("Logging in with FB!");
                        _loginWithFB();
                        print("Done Logging in with FB!");
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Divider(
                      height: 15,
                      thickness: 1,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.025),

                    LoginButton(
                      btnText: "Play as Guest",
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(context: context, builder:(context) {
                          return PolicyDialog(mdFileName: 'privacy_policy.md');
                        },);
                      },
                      child: Text("privacy policy",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 10,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(context: context, builder:(context) {
                          return PolicyDialog(mdFileName: 'terms_and_services.md');
                        },);
                      },
                      child: Text("terms and services",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 10,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}


class LoginButton extends StatefulWidget {
  final String btnText;
  LoginButton({this.btnText});
  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UserProfile guest = UserProfile();
        guest.setCoins(0);
        guest.setUsername("Guest");
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(guest)));
      },
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(50)
        ),
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        child: Center(
          child: Text(widget.btnText,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: "Londrina",
            decoration: TextDecoration.none,
          ),),
        ),
      ),
    );
    throw UnimplementedError();
  }
}