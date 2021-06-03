import 'dart:convert';

import 'package:SGLvlUp/ads/ad_helper.dart';
import 'package:SGLvlUp/audio/SoundsHandler.dart';
import 'package:SGLvlUp/category/category.dart';
import 'package:SGLvlUp/shared/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

import 'UserScore.dart';

class LeaderboardWidget extends StatefulWidget {
  LeaderboardWidget({Key key}) : super(key: key);

  @override
  _LeaderboardWidgetState createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends State<LeaderboardWidget> {
  String apiUrl =
      "http://ec2-54-255-217-149.ap-southeast-1.compute.amazonaws.com:5000";
  bool isLoading = true;
  String valueChoose;
  var start = 4;
  BannerAd _bannerAd;
  bool isLoaded = true;

  List<Category> categoriesName = List<Category>();
  List<String> listItem = List<String>();
  List<UserScore> userScore = List<UserScore>();

  @override
  void initState() {
    print("initState Initiated");
    this.getJsonData().then((value) {
      setState(() {
        categoriesName.addAll(value);
        for (var i = 0; i < categoriesName.length; i++) {
          listItem.add(categoriesName[i].category);
        }
      });
    });
    this.getJsonDataUserScore().then((value) {
      setState(() {
        userScore.addAll(value);
        print("Overall User Scores initialised");
        isLoading = false;
      });
    });
    print("initState Ran");

    _bannerAd = BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: AdRequest(),
        size: AdSize.fullBanner,
        listener: AdListener(onAdLoaded: (_) {
          setState(() {
            isLoaded = false;
          });
        }, onAdFailedToLoad: (_, error) {
          print('Ad Fail to Load with Error: $error');
        }));
    _bannerAd.load();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  Widget checkForAd() {
    return isLoaded
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            child: AdWidget(
              ad: _bannerAd,
            ),
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            alignment: Alignment.center,
          );
  }

  Future<List<Category>> getJsonData() async {
    print("fetching...");
    var response = await http.get(apiUrl + "/api/quiz/categories");
    //print(response.body);

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

  Future<List<UserScore>> getJsonDataUserScore() async {
    print("fetching...");
    var response = await http.get(apiUrl + "/api/score/scores/overall");
    //print(response.body);

    var userscorelist = List<UserScore>();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var unit in data) {
        userscorelist.add(UserScore.fromJson(unit));
      }
      return userscorelist;
    } else {
      throw Exception('Failed to load Categories');
    }
  }

  Future<List<UserScore>> getJsonDataNewUserScore(String value) async {
    print("fetching...");
    var response = await http.get(apiUrl + "/api/score/scores/category/$value");
    //print(response.body);

    var userscorelist = List<UserScore>();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var unit in data) {
        userscorelist.add(UserScore.fromJson(unit));
      }
      return userscorelist;
    } else {
      throw Exception('Failed to load Categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return isLoading
        ? Loader()
        : Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background/informationBG.png'),
                  fit: BoxFit.cover),
            ),
            child: SafeArea(
                child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      title: Text('Leaderboard'),
                      backgroundColor: Colors.transparent,
                    ),
                    body: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            padding: EdgeInsets.all(0),
                            color: Colors.white,
                            child: DropdownButton(
                              hint: Center(child: Text("Overall")),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              dropdownColor: Colors.white,
                              isExpanded: true,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              value: valueChoose,
                              onChanged: (newValue) {
                                SoundsHandler().playTap();
                                setState(() {
                                  print("Selected Category: " + newValue);
                                  valueChoose = newValue;

                                  this
                                      .getJsonDataNewUserScore(newValue)
                                      .then((value) {
                                    setState(() {
                                      print(value);
                                      List<UserScore> currUserScore =
                                          new List<UserScore>();
                                      currUserScore.addAll(value);
                                      userScore = currUserScore;
                                      print(
                                          "${valueChoose} User Scores initialised");
                                      //dispose();
                                    });
                                  });
                                });
                              },
                              items: listItem.map((valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem,
                                  child: Center(child: Text(valueItem)),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment(-0.9, 0.2),
                                  child: StackItem(
                                    placing: 2,
                                    userScore: userScore,
                                  )),
                              Align(
                                alignment: Alignment(0, -0.6),
                                child: StackItem(
                                  userScore: userScore,
                                  large: true,
                                  placing: 1,
                                ),
                              ),
                              Align(
                                  alignment: Alignment(0.9, 0.2),
                                  child: StackItem(
                                    userScore: userScore,
                                    placing: 3,
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                            //height: MediaQuery.of(context).size.height*0.493,
                            child: ListView(
                          children: [
                            new Container(
                              color: Colors.white.withOpacity(0.3),
                              child: new ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => ProfileItem(
                                  index: index + 4,
                                  userScore: userScore,
                                ),
                                itemCount: 7,
                              ),
                            )
                          ],
                        )),
                        checkForAd(),
                      ],
                    ))),
          );
    throw UnimplementedError();
  }
}

class ProfileItem extends StatelessWidget {
  final List<UserScore> userScore;
  final int index;

  const ProfileItem({
    Key key,
    this.index,
    this.userScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "$index",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          NetworkImage(userScore[index - 1].user_pictureurl))),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userScore[index - 1].user_name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                userScore[index - 1].points,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )
            ],
          )
        ],
      ),
    );
  }
}

class StackItem extends StatelessWidget {
  final bool large;
  final int placing;
  final List<UserScore> userScore;

  const StackItem({Key key, this.large = false, this.placing, this.userScore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: large
              ? MediaQuery.of(context).size.height * 0.16
              : MediaQuery.of(context).size.height * 0.15,
          height: large
              ? MediaQuery.of(context).size.height * 0.16
              : MediaQuery.of(context).size.height * 0.15,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Container(
                    height: large ? 80 : 70,
                    width: large ? 80 : 70,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                userScore[placing - 1].user_pictureurl))),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      color: placing == 1
                          ? Colors.green
                          : placing == 2
                              ? Colors.orangeAccent
                              : Colors.blue,
                      borderRadius: BorderRadius.circular(4)),
                  child: Center(
                      child: Text(
                    "$placing",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
              )
            ],
          ),
        ),
        Text(
          userScore[placing - 1].user_name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          userScore[placing - 1].points,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
