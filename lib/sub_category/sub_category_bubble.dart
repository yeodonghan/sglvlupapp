import 'package:flutter/material.dart';
import '../quiz/quiz_layout.dart';

class SubCategoryBubble extends StatelessWidget {
  final String categoryName;
  final int categoryID;
  final String quizName;
  final int level;
  SubCategoryBubble(this.categoryName, this.categoryID, this.quizName, this.level);

  //test



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
            child: InkWell(
              onTap: () {
                print(this.categoryName);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuizLayout(this.categoryName, this.categoryID, this.quizName, this.level)),
                );
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Color(0xFF8CC5E1), shape: BoxShape.circle),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 60,
            height: 30,
            child: Flexible(
              child: Text(
                this.quizName,
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
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
