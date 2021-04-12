import 'dart:math';

import 'package:SGLvlUp/ads/ad_helper.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:SGLvlUp/shared/loader.dart';
import 'package:SGLvlUp/sub_category/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import './sub_category_bubble.dart';
import '../category/category_title.dart';
import './sub_category_description.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubCategoryLayout extends StatefulWidget {
  final String categoryName;
  final int categoryID;
  final String pictureurl;
  final String description;
  final UserProfile user;


  SubCategoryLayout(this.categoryName, this.categoryID, this.pictureurl, this.user, this.description);

  @override
  _SubCategoryLayoutState createState() => _SubCategoryLayoutState();
}

class _SubCategoryLayoutState extends State<SubCategoryLayout> {
  List<SubCategoryBubble> testing = List<SubCategoryBubble>();

  List<SubCategory> subcategories = List<SubCategory>();

  bool isLoading = true;

  String apiUrl = "http://ec2-54-255-217-149.ap-southeast-1.compute.amazonaws.com:5000";

  int maxLevel = 0;

  BannerAd _ad;
  bool isLoaded;


  void initialiseLists() {
    for (int i = 0; i < subcategories.length; i++) {
      print(subcategories[i].category);
      print(subcategories[i].level);
      maxLevel = subcategories.length;

      testing.add(SubCategoryBubble(subcategories[i].category, widget.categoryID, "Level " + subcategories[i].level.toString(), subcategories[i].level, maxLevel, widget.user));
    }

  }


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

          testing.add(SubCategoryBubble(subcategories[i].category, widget.categoryID, "Level " + subcategories[i].level.toString(), subcategories[i].level, maxLevel, widget.user));
        }
      });
    });

      setState(() {
        isLoading = !isLoading;
        print('isLoading is False');

      });

    _ad = BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: AdRequest(),
        size: AdSize.fullBanner,
        listener: AdListener(
            onAdLoaded: (_) {
              setState(() {
                isLoaded = true;
              });
            },
            onAdFailedToLoad: (_, error){
              print('Ad Fail to Load with Error: $error');
            }
        )
    );

    _ad.load();
    super.initState();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  Widget checkForAd() {
    if(isLoaded == true) {
      return Container(
        padding: EdgeInsets.all(0),
        child: AdWidget(
          ad: _ad,
        ),
        width: _ad.size.width.toDouble(),
        height: _ad.size.height.toDouble(),
        alignment: Alignment.center,
      );
    } else {
      return CircularProgressIndicator();
    }
  }



  Future<List<SubCategory>> getJsonData() async {
    print("fetching...");
    var response =
    await http.get(apiUrl + "/api/quiz/questions/levels/" + widget.categoryID.toString()
    );
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
    List<SubCategory> subcategories = subcategoriesInput;
    List<Widget> compiled = [SubCategoryBubble(subcategories[0].category, widget.categoryID, "Level " + subcategories[0].level.toString(), subcategories[0].level, subcategories.length, widget.user)];

    for (int i = 1; i < subcategories.length; i++) {
      //print(subcategories[i].level.toString());

      SubCategoryBubble subcategory = new SubCategoryBubble(subcategories[i].category, widget.categoryID, "Level " + subcategories[i].level.toString(), subcategories[i].level, subcategories.length, widget.user);
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
      /*Container(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: testing,
        ),
        height: 130,
      ),
      Container(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: testing,
        ),
        height: 130,
      )
      */

    ];
  }

  @override
  Widget build(BuildContext context) {
    //initialiseLists();
    return isLoading ? Loader() : Scaffold(
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
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.013),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //TITLE
                            CategoryTitle(this.widget.categoryName),
                            //-------------------------
                            SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                            //DESCRIPTION CONTAINER
                            //-------------------------
                            SubCategoryDescription(widget.categoryID, widget.categoryName, widget.pictureurl, widget.description),
                            //-------------------------
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                            Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.035,
                                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.007, left: MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.007),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: scrollableRow(prepareSubCategories(subcategories)),
                                      ),
                                    ),
                                    color: Colors.white,
                                  ),
                                )),
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
}
