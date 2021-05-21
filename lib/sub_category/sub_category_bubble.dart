import 'package:SGLvlUp/audio/SoundsHandler.dart';
import 'package:SGLvlUp/quiz/quiz_layout.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:flutter/material.dart';

class SubCategoryBubble extends StatefulWidget {
  String categoryName;
  int categoryID;
  String quizName;
  int level;
  int maxLevel;
  UserProfile user;

  SubCategoryBubble(
      {Key key,
      this.categoryName,
      this.categoryID,
      this.quizName,
      this.level,
      this.maxLevel,
      this.user})
      : super(key: key);

  @override
  _SubCategoryBubbleState createState() {
    categoryName = this.categoryName;
    categoryID = this.categoryID;
    quizName = this.quizName;
    level = this.level;
    maxLevel = this.maxLevel;
    user = this.user;
    return _SubCategoryBubbleState();
  }
}

class _SubCategoryBubbleState extends State<SubCategoryBubble> {
  @override
  void initState() {
    print('This state is of Level: ' + widget.level.toString());
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SubCategoryBubble oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maxLevel != widget.maxLevel) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              SoundsHandler().playTap();
              print(widget.categoryName);
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
            child: Container(
              width: MediaQuery.of(context).size.height * 0.07,
              height: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage('assets/levels/level' +
                        widget.level.toString() +
                        '.jpg'),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.height * 0.07,
            height: MediaQuery.of(context).size.height * 0.035,
            child: Text(
              widget.quizName,
              style: TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/*class SubCategoryBubble extends StatefulWidget {
  String categoryName;
  int categoryID;
  String quizName;
  int level;
  int maxLevel;
  UserProfile user;

  SubCategoryBubble(
      {Key key,
      this.categoryName,
      this.categoryID,
      this.quizName,
      this.level,
      this.maxLevel,
      this.user})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    categoryName = this.categoryName;
    categoryID = this.categoryID;
    quizName = this.quizName;
    level = this.level;
    maxLevel = this.maxLevel;
    user = this.user;
    return _SubCategoryBubble();
  }
}

//test

class SubCategoryBubbleState extends State<SubCategoryBubble> {
  @override
  void initState() {
    print('This state is of Level: ' + widget.level.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                */ /*SoundsHandler().playTap();
                print(widget.categoryName);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuizLayout(
                          widget.categoryName,
                          widget.categoryID,
                          widget.quizName,
                          level,
                          maxLevel,
                          widget.user)),
                );*/ /*
              },
              child: Container(
                width: MediaQuery.of(context).size.height * 0.07,
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/levels/level' + level.toString() + '.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.height * 0.07,
            height: MediaQuery.of(context).size.height * 0.035,
            child: Text(
              widget.quizName,
              style: TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}*/
