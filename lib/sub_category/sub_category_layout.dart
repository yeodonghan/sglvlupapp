import 'dart:convert';

import 'package:SGLvlUp/ads/ad_helper.dart';
import 'package:SGLvlUp/audio/SoundsHandler.dart';
import 'package:SGLvlUp/quiz/quiz_layout.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:SGLvlUp/shared/loader.dart';
import 'package:SGLvlUp/sub_category/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

import './sub_category_bubble.dart';
import './sub_category_description.dart';
import '../category/category_title.dart';

class SubCategoryLayout extends StatefulWidget {
  final String categoryName;
  final int categoryID;
  final String pictureurl;
  final String description;
  final UserProfile user;

  SubCategoryLayout(this.categoryName, this.categoryID, this.pictureurl,
      this.user, this.description);

  @override
  _SubCategoryLayoutState createState() => _SubCategoryLayoutState();
}

class _SubCategoryLayoutState extends State<SubCategoryLayout> {
  List<SubCategoryBubble> testing = [];
  List<SubCategory> subcategories = [];
  bool isLoading = true;

  String apiUrl =
      "http://ec2-54-255-217-149.ap-southeast-1.compute.amazonaws.com:5000";

  int maxLevel = 0;
  BannerAd _bannerAd;
  bool isLoaded = true;

  /*void initialiseLists() {
    for (int i = 0; i < subcategories.length; i++) {
      print(subcategories[i].category);
      print(subcategories[i].level);
      maxLevel = subcategories.length;

      testing.add(SubCategoryBubble(
          subcategories[i].category,
          widget.categoryID,
          "Level " + subcategories[i].level.toString(),
          subcategories[i].level,
          maxLevel,
          widget.user));
    }
  }*/

  @override
  void initState() {
    this.getJsonData().then((value) {
      setState(() {
        subcategories.addAll(value);
        //make testing
        for (int i = 0; i < subcategories.length; i++) {
          print(subcategories[i].category);
          print(subcategories[i].level);
          maxLevel = subcategories.length;
          testing.add(SubCategoryBubble(
              categoryName: subcategories[i].category,
              categoryID: widget.categoryID,
              quizName: "Level " + subcategories[i].level.toString(),
              level: subcategories[i].level,
              maxLevel: maxLevel,
              user: widget.user));
        }
      });
    });

    setState(() {
      isLoading = !isLoading;
      print('isLoading is False');
    });

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

  Future<List<SubCategory>> getJsonData() async {
    print("fetching...");
    var response = await http.get(
        apiUrl + "/api/quiz/questions/levels/" + widget.categoryID.toString());
    print(response.body);
    var subcategorylist = List<SubCategory>();
    if (response.statusCode == 200) {
      print("Passed");
      var data = jsonDecode(response.body);
      for (var unit in data) {
        subcategorylist.add(SubCategory.fromJson(unit));
      }
      return subcategorylist;
    } else {
      print("Failed");
      throw Exception('Failed to load SubCategories');
    }
  }

  //Return a List of Rows that is populated by the CategoryBubble
  //This method is to aid the eventual addition of backend functionality
  List<Widget> prepareSubCategories(List<SubCategory> subcategoriesInput) {
    //List<SubCategory> subcategories = subcategoriesInput;
    List<Widget> compiled = [
      /*SubCategoryBubble(
          categoryName: subcategoriesInput[0].category,
          categoryID: widget.categoryID,
          quizName: "Level " + subcategoriesInput[0].level.toString(),
          level: subcategoriesInput[0].level,
          maxLevel: subcategoriesInput.length,
          user: widget.user)*/
    ];

    for (int j = 0; j < subcategoriesInput.length; j++) {
      SubCategoryBubble subcategory = SubCategoryBubble(
          categoryName: subcategoriesInput[j].category,
          categoryID: widget.categoryID,
          quizName: "Level " + subcategoriesInput[j].level.toString(),
          level: subcategoriesInput[j].level,
          maxLevel: subcategoriesInput.length,
          user: widget.user);
      compiled.add(subcategory);
    }
    return compiled;
  }

  List<Widget> scrollableRow(List<Widget> list) {
    return [
      Container(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: testing,
        ),
        height: 110,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loader()
        : Scaffold(
            backgroundColor: Color(0xff47443F),
            appBar: AppBar(
              backgroundColor: Color(0xff47443F),
              leading: BackButton(
                color: Color(0xFFFFC823),
              ),
              elevation: 0.0,
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.height * 0.013),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //TITLE
                                  CategoryTitle(this.widget.categoryName),
                                  //-------------------------
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.013),
                                  //DESCRIPTION CONTAINER
                                  //-------------------------
                                  SubCategoryDescription(
                                      widget.categoryID,
                                      widget.categoryName,
                                      widget.pictureurl,
                                      widget.description),
                                  //-------------------------
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  _categoryListView(),
                                  /*ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                  height:
                                      MediaQuery.of(context).size.height *
                                          0.035,
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.007,
                                      left: MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.02,
                                      bottom: MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.007),
                                  child: _categoryListView(),
                                  color: Colors.white,
                                    ),
                                  ),*/
                                ],
                              ),
                              color: Color(0xFFFFC823)),
                        ),
                      ),
                    ],
                  ),
                  checkForAd(),
                ],
              ),
            ),
          );
  }

  Widget _categoryListView() {
    return Flexible(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: subcategories.length,
              itemBuilder: (context, index) {
                return LevelItem(
                  category: subcategories[index],
                  maxLevel: subcategories.length,
                  categoryID: widget.categoryID,
                  user: widget.user,
                  categoryName: widget.categoryName,
                );
              }),
        ),
      ),
    );
  }
}

class LevelItem extends StatefulWidget {
  const LevelItem(
      {Key key,
      this.category,
      this.maxLevel,
      this.categoryID,
      this.user,
      this.categoryName})
      : super(key: key);
  final SubCategory category;
  final int maxLevel;
  final String categoryName;
  final int categoryID;
  final UserProfile user;

  @override
  _LevelItemState createState() => _LevelItemState();
}

class _LevelItemState extends State<LevelItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 6.0),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        onTap: () {
          SoundsHandler().playTap();
          print(widget.categoryName);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuizLayout(
                    widget.categoryName,
                    widget.categoryID,
                    "Level " + widget.category.level.toString(),
                    widget.category.level,
                    widget.maxLevel,
                    widget.user)),
          );
        },
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.height * 0.07,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/levels/level' +
                            widget.category.level.toString() +
                            '.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.height * 0.07,
                  height: MediaQuery.of(context).size.height * 0.035,
                  child: Text(
                    "Level " + widget.category.level.toString(),
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
