import 'package:flutter/material.dart';
import '../shapes/yellow_rounded_rectangle.dart';
import '../sub_category/sub_category_layout.dart';
import '../quiz/quiz_layout.dart';

class WinScreen extends StatelessWidget {
  final String categoryName;
  final String quizName;
  final int level;
  final int categoryID;
  final int finalScore;
  WinScreen(this.categoryName, this.categoryID, this.quizName, this.level, this.finalScore);
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
                YellowRoundedRectangle(
                    "Congratulations\nYou have won the quiz: " +
                        this.quizName +
                        " ! \n" + "Score: " + finalScore.toString() + "/10"),
                Spacer(
                  flex: 10,
                ),
                RaisedButton(
                  color: Color(0xff47443F),
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
                  color: Color(0xff47443F),
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
