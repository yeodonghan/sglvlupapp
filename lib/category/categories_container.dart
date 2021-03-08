import 'dart:convert';

import 'package:SGLvlUp/shared/loading.dart';
import 'package:flutter/material.dart';
import './category.dart';
import './category_bubble.dart';
import 'package:http/http.dart' as http;

class CategoriesContainer extends StatefulWidget {
  @override
  CategoryState createState() => new CategoryState();
}

class CategoryState extends State<CategoriesContainer> {
  bool isLoading = true;
  List<Category> categoriesName = List<Category>();

  final String url = "http://10.0.2.2:5000/api/quiz/categories";

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
    var response =
    await http.get(url
        );
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
    List<Widget> currentRow = [CategoryBubble(categories[0].category, categories[0].cid)];

    while(categories.length % 3 != 0) {
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
      CategoryBubble category = CategoryBubble(categories[i].category, categories[1].cid);
      currentRow.add(category);
    }


    Row toAdd = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        textDirection: TextDirection.ltr, children: currentRow);
    compiled.add(toAdd);
    return compiled;



  }


  @override
  Widget build(BuildContext context) {
    print("Build ran");
    return isLoading ? Loading() : Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: MediaQuery.of(context).size.height * 0.85,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(

            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
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
                SizedBox(height: 20),
                Expanded(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: prepareCategories(categoriesName))),
                    color: Colors.white,
                  ),
                )),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            color: Color(0xFFFFC823)),
      ),

    );
  }


}
