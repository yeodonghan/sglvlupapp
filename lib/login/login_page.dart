

import 'package:SGLvlUp/information_tab/policy_dialogue.dart';
import 'package:SGLvlUp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  int _pageState = 0;

  double _loginYOffset = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  bool isLoggedIn = false;

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

    return Stack(
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
                          top: 100,
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
                        margin: EdgeInsets.all(24
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
                          _pageState = 1;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(32),
                        padding: EdgeInsets.all(20),
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
                children: [

                  SizedBox(height: 70,),
                  SignInButton(
                    Buttons.GoogleDark,
                    text: "Login with Google",
                    onPressed: () {},
                  ),
                  SizedBox(height: 15,),
                  SignInButton(
                    Buttons.Facebook,
                    text: "Login with Facebook",
                    onPressed: () {},
                  ),
                  SizedBox(height: 15,),
                  Divider(
                    height: 15,
                    thickness: 1,
                  ),
                  SizedBox(height: 20,),

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
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
      },
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(50)
        ),
        padding: EdgeInsets.all(15),
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