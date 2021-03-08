import 'package:SGLvlUp/sub_category/sub_category.dart';
import 'package:flutter/material.dart';
import './sub_category_bubble.dart';
import '../category/category_title.dart';
import './sub_category_description.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubCategoryLayout extends StatefulWidget {
  final String categoryName;
  final int categoryID;

  SubCategoryLayout(this.categoryName, this.categoryID);

  @override
  _SubCategoryLayoutState createState() => _SubCategoryLayoutState();
}

class _SubCategoryLayoutState extends State<SubCategoryLayout> {
  List<SubCategoryBubble> testing = List<SubCategoryBubble>();

  List<SubCategory> subcategories = List<SubCategory>();

  bool isLoading = true;


  void initialiseLists() {
    for (int i = 0; i < subcategories.length; i++) {
      print(subcategories[i].category);
      print(subcategories[i].level);

      testing.add(SubCategoryBubble(subcategories[i].category, widget.categoryID, "Level " + subcategories[i].level.toString(), subcategories[0].level));
    }

  }


  @override
  void initState() {
    this.getJsonData().then((value) {
      setState(() {
        subcategories.addAll(value);
        isLoading = false;
        //make testing
        for (int i = 0; i < subcategories.length; i++) {
          print(subcategories[i].category);
          print(subcategories[i].level);

          testing.add(SubCategoryBubble(subcategories[i].category, widget.categoryID, "Level " + subcategories[i].level.toString(), subcategories[0].level));
        }
      });
    });
    super.initState();

  }

  final String url = "http://10.0.2.2:5000/api/quiz/questions/levels/";

  Future<List<SubCategory>> getJsonData() async {
    print("fetching...");
    var response =
    await http.get(url + widget.categoryID.toString()
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
    List<Widget> compiled = [SubCategoryBubble(subcategories[0].category, widget.categoryID, "Level " + subcategories[0].level.toString(), subcategories[0].level)];

    for (int i = 1; i < subcategories.length; i++) {

      SubCategoryBubble subcategory = SubCategoryBubble(subcategories[i].category, widget.categoryID, "Level " + subcategories[i].level.toString(), subcategories[i].level);
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
        height: 130,
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
    return Scaffold(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              height: MediaQuery.of(context).size.height * 0.85,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top:15, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //TITLE
                        CategoryTitle(this.widget.categoryName),
                        //-------------------------
                        SizedBox(height: 10),
                        //DESCRIPTION CONTAINER
                        //-------------------------
                        SubCategoryDescription(widget.categoryID, widget.categoryName),
                        //-------------------------
                        SizedBox(height: 20),
                        Expanded(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: EdgeInsets.only(top: 20, left: 10),
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
            )
          ],
        ),
      ),
    );
  }
}
