import 'package:flutter/material.dart';
import '../shapes/yellow_rounded_rectangle.dart';
import '../sub_category/sub_category_layout.dart';
import '../quiz/quiz_layout.dart';

class LoseScreen extends StatelessWidget {
  final String categoryName;
  final String quizName;
  final int level;
  final int categoryID;
  final int finalScore;
  LoseScreen(this.categoryName, this.categoryID, this.quizName, this.level, this.finalScore);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    // color: Color(0xFFFFC823),
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Text(
                      "Oh no!\nYou have failed the quiz: " +
                          this.quizName +
                          "!\n" + "Score: " + finalScore.toString() + "/10",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    decoration: BoxDecoration(color: Color(0xfffc8002)),
                  ),
                ),
                Spacer(
                  flex: 10,
                ),
                RaisedButton(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      YellowRoundedRectangle("Reattempt"),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              QuizLayout(this.categoryName, this.categoryID, this.quizName, this.level)),
                    );
                  },
                ),
                RaisedButton(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      YellowRoundedRectangle("Browse other quizzes"),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
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
    );
  }
}
