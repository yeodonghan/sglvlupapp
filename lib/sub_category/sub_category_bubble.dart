import 'package:SGLvlUp/audio/SoundsHandler.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:flutter/material.dart';
import '../quiz/quiz_layout.dart';

class SubCategoryBubble extends StatefulWidget {

  final String categoryName;
  final int categoryID;
  final String quizName;
  final int level;
  final int maxLevel;
  final UserProfile user;

  SubCategoryBubble(this.categoryName, this.categoryID, this.quizName,
      this.level, this.maxLevel, this.user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
      return SubCategoryBubbleState(this.level, this.maxLevel);
  }
}


  //test


class SubCategoryBubbleState extends State<SubCategoryBubble> {
  final int level;
  final int maxLevel;

  SubCategoryBubbleState(this.level, this.maxLevel);

  @override
  void initState() {
    // TODO: implement initState
    print('This state is of Level: ' + widget.level.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // Flexible(
        //   child:
        Container(
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
                SoundsHandler().playTap();
                print(widget.categoryName);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuizLayout(widget.categoryName, widget.categoryID, widget.quizName, level, maxLevel, widget.user)),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.height * 0.07,
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/levels/level' + widget.level.toString() + '.jpg'),
                      fit: BoxFit.cover
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height:  MediaQuery.of(context).size.height * 0.01),
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
          SizedBox(
            height: 10,
          ),
        ],
      ),
      // ),
    );
  }

}