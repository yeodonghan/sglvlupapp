import 'dart:convert';

import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:SGLvlUp/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './category.dart';
import './category_bubble.dart';

class CategoriesContainer extends StatefulWidget {
  final UserProfile user;

  const CategoriesContainer(this.user);

  @override
  CategoryState createState() => new CategoryState();
}

class CategoryState extends State<CategoriesContainer> {
  bool isLoading = true;
  List<Category> categoriesName = List<Category>();

  String apiUrl =
      "http://ec2-54-255-217-149.ap-southeast-1.compute.amazonaws.com:5000";

  //Init Fetch

  @override
  void initState() {
    this.getJsonData().then((value) {
      setState(() {
        categoriesName.addAll(value);

        isLoading = false;
      });
    });
    print("initState Ran");
    super.initState();
  }

  Future<List<Category>> getJsonData() async {
    print("fetching...");
    var response = await http.get(apiUrl + "/api/quiz/categories");
    print(response.body);

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

  //Return a List of Rows that is populated by the CategoryBubble
  //This method is to aid the eventual addition of backend functionality
  List<Widget> prepareCategories(List<Category> categoriesInput) {
    List<Category> categories = categoriesInput;
    List<Widget> compiled = [];
    List<Widget> currentRow = [
      CategoryBubble(categories[0].category, categories[0].cid,
          categories[0].pictureurl, widget.user, categories[0].description)
    ];

    while (categories.length % 3 != 0) {
      categories.add(new Category());
    }

    for (int i = 1; i < categories.length; i++) {
      if (i % 3 == 0) {
        Row toAdd = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textDirection: TextDirection.ltr,
          children: currentRow,
        );
        compiled.add(toAdd);
        currentRow = [];
      }
      CategoryBubble category = CategoryBubble(
          categories[i].category,
          categories[i].cid,
          categories[i].pictureurl,
          widget.user,
          categories[i].description);
      currentRow.add(category);
    }

    Row toAdd = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        textDirection: TextDirection.ltr,
        children: currentRow);
    compiled.add(toAdd);
    return compiled;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loader()
        : Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            //height: MediaQuery.of(context).size.height * 0.6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      // CATEGORIES TITLE -------------------------
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            "Categories",
                            style: TextStyle(fontSize: 20),
                          ),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Expanded(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.only(top: 20),
                          child: SingleChildScrollView(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: prepareCategories(categoriesName))),
                          color: Colors.white,
                        ),
                      )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      )
                    ],
                  ),
                  color: Color(0xFFFFC823)),
            ),
          );
  }
}
