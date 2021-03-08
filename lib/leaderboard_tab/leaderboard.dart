import 'dart:convert';

import 'package:SGLvlUp/category/category.dart';
import 'package:SGLvlUp/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaderboardWidget extends StatefulWidget {
  LeaderboardWidget({Key key}) : super(key: key);

  @override
  _LeaderboardWidgetState createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends State<LeaderboardWidget> {

  bool isLoading = true;
  String valueChoose;
  var start = 4;

  List<Category> categoriesName = List<Category>();
  List<String> listItem  = List<String>();

  final String url = "http://10.0.2.2:5000/api/quiz/categories";

  @override
  void initState() {
    print("initState Initiated");
    this.getJsonData().then((value) {
      setState(() {
        categoriesName.addAll(value);
        isLoading = false;
        for(var i = 0; i < categoriesName.length; i++) {
          listItem.add(categoriesName[i].category);
        }
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


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return isLoading ? Loading() : Container(
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
                        hint: Center(child: Text("Select Category")),
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
                          setState(() {
                            valueChoose = newValue;
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
                    height: 200,
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment(-0.7, 0), child: StackItem(
                          placing: 2,
                        )),
                        Align(
                          alignment: Alignment(0, -0.6),
                          child: StackItem(
                            large: true,
                            placing: 1,
                          ),
                        ),
                        Align(alignment: Alignment(0.7, 0), child: StackItem(
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
                              itemBuilder: (context, index) => ProfileItem(index : index + 4),
                              itemCount: 6,
                        ),
                      )
                    ],
                  ))
                ],
              ))),
    );
    throw UnimplementedError();
  }
}

class ProfileItem extends StatelessWidget {
  final int index;
  const ProfileItem({
    Key key,
    this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8 ),
            child: Text("$index",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),),
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
                      image: AssetImage('assets/profile_picture_sample.jpg'))),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name 1",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
              SizedBox(height: 4,),
              Text("100",
                  style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey),
              )],
          )
        ],
      ),
    );
  }
}

class StackItem extends StatelessWidget {
  final bool large;
  final int placing;

  const StackItem({Key key, this.large = false, this.placing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: large ? 95 : 80,
          height: large ? 95 : 80,
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
                            image: AssetImage(
                                'assets/profile_picture_sample.jpg'))),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      color: placing == 1 ? Colors.green : placing == 2 ? Colors.orangeAccent : Colors.blue ,
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
          "Name 1",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          "200",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
