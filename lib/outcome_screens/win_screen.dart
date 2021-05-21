import 'package:SGLvlUp/ads/ad_helper.dart';
import 'package:SGLvlUp/audio/SoundsHandler.dart';
import 'package:SGLvlUp/category/categories_layout.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:SGLvlUp/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../main.dart';
import '../quiz/quiz_layout.dart';
import '../shapes/yellow_rounded_rectangle.dart';

class WinScreen extends StatefulWidget {
  final String categoryName;
  final String quizName;
  final int level;
  final int categoryID;
  final int finalScore;
  final int maxLevel;
  final UserProfile user;
  final int points;

  WinScreen(this.categoryName, this.categoryID, this.quizName, this.level,
      this.finalScore, this.maxLevel, this.user, this.points);

  @override
  WinScreenState createState() => WinScreenState();
}

class WinScreenState extends State<WinScreen> {
  bool isLoading = true;
  InterstitialAd _ad;
  bool isLoaded;

  @override
  void initState() {
    // TODO: implement initState
    _ad = InterstitialAd(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        listener: AdListener(
          onAdLoaded: (Ad ad) {
            setState(() {
              isLoaded = true;
            });
            print('Ad loaded.');
            _ad.show();
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            print('Ad failed to load: $error');
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) {
            ad.dispose();
            print('Ad closed.');
          },
          // Called when an ad is in the process of leaving the application.
          onApplicationExit: (Ad ad) => print('Left application.'),
        ));

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = !isLoading;
        print('isLoading is False');
        _ad.load();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _ad?.dispose();
    print("Ads Disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loader()
        : (widget.level == widget.maxLevel
            ? (widget.user.user_name != "Guest"
                ? WillPopScope(
                    onWillPop: () => Future.value(false),
                    child: Scaffold(
                      backgroundColor: Color(0xff47443F),
                      appBar: AppBar(
                        backgroundColor: Color(0xff47443F),
                        automaticallyImplyLeading: false,
                        elevation: 0.0,
                      ),
                      body: Center(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              YellowRoundedRectangle(
                                  "Congratulations\nYou have completed the quiz: " +
                                      "\n\n" +
                                      widget.categoryName +
                                      " " +
                                      widget.quizName +
                                      " ! \n\n" +
                                      "Score: " +
                                      widget.finalScore.toString() +
                                      "/10" +
                                      "\n" +
                                      "You have earned " +
                                      widget.points.toString() +
                                      " Coins!"),
                              Spacer(
                                flex: 10,
                              ),
                              RaisedButton(
                                color: Color(0xff47443F),
                                child: Column(
                                  children: [
                                    YellowRoundedRectangle("Reattempt"),
                                  ],
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QuizLayout(
                                            widget.categoryName,
                                            widget.categoryID,
                                            widget.quizName,
                                            widget.level,
                                            widget.maxLevel,
                                            widget.user)),
                                  );
                                },
                              ),
                              RaisedButton(
                                color: Color(0xff47443F),
                                child: Column(
                                  children: [
                                    YellowRoundedRectangle(
                                        "Browse other quizzes"),
                                  ],
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyHomePage(user: widget.user,),
                                          maintainState: false));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CategoriesLayout(widget.user)),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : WillPopScope(
                    onWillPop: () => Future.value(false),
                    child: Scaffold(
                      backgroundColor: Color(0xff47443F),
                      appBar: AppBar(
                        backgroundColor: Color(0xff47443F),
                        automaticallyImplyLeading: false,
                        elevation: 0.0,
                      ),
                      body: Center(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              YellowRoundedRectangle(
                                  "Congratulations\nYou have completed the quiz: " +
                                      "\n\n" +
                                      widget.categoryName +
                                      " " +
                                      widget.quizName +
                                      " ! \n\n" +
                                      "Score: " +
                                      widget.finalScore.toString() +
                                      "/10" +
                                      "\n" +
                                      "Register to earn Coins!"),
                              Spacer(
                                flex: 10,
                              ),
                              RaisedButton(
                                color: Color(0xff47443F),
                                child: Column(
                                  children: [
                                    YellowRoundedRectangle("Reattempt"),
                                  ],
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QuizLayout(
                                            widget.categoryName,
                                            widget.categoryID,
                                            widget.quizName,
                                            widget.level,
                                            widget.maxLevel,
                                            widget.user)),
                                  );
                                },
                              ),
                              RaisedButton(
                                color: Color(0xff47443F),
                                child: Column(
                                  children: [
                                    YellowRoundedRectangle(
                                        "Browse other quizzes"),
                                  ],
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyHomePage(user: widget.user,),
                                          maintainState: false));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CategoriesLayout(widget.user)),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
            : (widget.user.user_name != "Guest"
                ? WillPopScope(
                    onWillPop: () => Future.value(false),
                    child: Scaffold(
                      backgroundColor: Color(0xff47443F),
                      appBar: AppBar(
                        backgroundColor: Color(0xff47443F),
                        automaticallyImplyLeading: false,
                        elevation: 0.0,
                      ),
                      body: Center(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              YellowRoundedRectangle(
                                  "Congratulations\nYou have completed the quiz: " +
                                      "\n\n" +
                                      widget.categoryName +
                                      " " +
                                      widget.quizName +
                                      " ! \n\n" +
                                      "Score: " +
                                      widget.finalScore.toString() +
                                      "/10" +
                                      "\n" +
                                      "You have earned " +
                                      widget.points.toString() +
                                      " Coins!"),
                              Spacer(
                                flex: 10,
                              ),
                              RaisedButton(
                                color: Color(0xff47443F),
                                child: Column(
                                  children: [
                                    YellowRoundedRectangle("Next Level"),
                                  ],
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                ),
                                onPressed: () {
                                  SoundsHandler().playTap();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => new QuizLayout(
                                            widget.categoryName,
                                            widget.categoryID,
                                            "Level " +
                                                (widget.level + 1).toString(),
                                            widget.level + 1,
                                            widget.maxLevel,
                                            widget.user)),
                                  );
                                },
                              ),
                              RaisedButton(
                                color: Color(0xff47443F),
                                child: Column(
                                  children: [
                                    YellowRoundedRectangle("Reattempt"),
                                  ],
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                ),
                                onPressed: () {
                                  SoundsHandler().playTap();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QuizLayout(
                                            widget.categoryName,
                                            widget.categoryID,
                                            widget.quizName,
                                            widget.level,
                                            widget.maxLevel,
                                            widget.user)),
                                  );
                                },
                              ),
                              RaisedButton(
                                color: Color(0xff47443F),
                                child: Column(
                                  children: [
                                    YellowRoundedRectangle(
                                        "Browse other quizzes"),
                                  ],
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                ),
                                onPressed: () {
                                  SoundsHandler().playTap();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyHomePage(user: widget.user,),
                                          maintainState: false));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CategoriesLayout(widget.user)),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : WillPopScope(
                    onWillPop: () => Future.value(false),
                    child: Scaffold(
                      backgroundColor: Color(0xff47443F),
                      appBar: AppBar(
                        backgroundColor: Color(0xff47443F),
                        automaticallyImplyLeading: false,
                        elevation: 0.0,
                      ),
                      body: Center(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              YellowRoundedRectangle(
                                  "Congratulations\nYou have completed the quiz: " +
                                      "\n\n" +
                                      widget.categoryName +
                                      " " +
                                      widget.quizName +
                                      " ! \n\n" +
                                      "Score: " +
                                      widget.finalScore.toString() +
                                      "/10" +
                                      "\n" +
                                      "Register to earn Coins!"),
                              Spacer(
                                flex: 10,
                              ),
                              RaisedButton(
                                color: Color(0xff47443F),
                                child: Column(
                                  children: [
                                    YellowRoundedRectangle("Next Level"),
                                  ],
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                ),
                                onPressed: () {
                                  SoundsHandler().playTap();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => new QuizLayout(
                                            widget.categoryName,
                                            widget.categoryID,
                                            "Level " +
                                                (widget.level + 1).toString(),
                                            widget.level + 1,
                                            widget.maxLevel,
                                            widget.user)),
                                  );
                                },
                              ),
                              RaisedButton(
                                color: Color(0xff47443F),
                                child: Column(
                                  children: [
                                    YellowRoundedRectangle("Reattempt"),
                                  ],
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                ),
                                onPressed: () {
                                  SoundsHandler().playTap();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QuizLayout(
                                            widget.categoryName,
                                            widget.categoryID,
                                            widget.quizName,
                                            widget.level,
                                            widget.maxLevel,
                                            widget.user)),
                                  );
                                },
                              ),
                              RaisedButton(
                                color: Color(0xff47443F),
                                child: Column(
                                  children: [
                                    YellowRoundedRectangle(
                                        "Browse other quizzes"),
                                  ],
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                ),
                                onPressed: () {
                                  SoundsHandler().playTap();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyHomePage(user: widget.user,),
                                          maintainState: false));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CategoriesLayout(widget.user)),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )));
  }
}
