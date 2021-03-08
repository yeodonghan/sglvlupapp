import 'package:SGLvlUp/quiz/question.dart';
import 'package:SGLvlUp/shapes/transparent_rounded_rectangle.dart';
import 'package:flutter/material.dart';
import '../shapes/yellow_rounded_rectangle.dart';
import './red_circle.dart';
import 'dart:async';
import 'big_red_circle.dart';
import 'power_up.dart';
import '../outcome_screens/win_screen.dart';
import '../outcome_screens/lose_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizLayout extends StatefulWidget {
  final String categoryName;
  final int categoryID;
  final String quizName;
  final int level;

  QuizLayout(this.categoryName, this.categoryID, this.quizName, this.level);
  @override
  _QuizLayoutState createState() => _QuizLayoutState(categoryName, categoryID, quizName, level);
}

class _QuizLayoutState extends State<QuizLayout> {
  final String quizName;
  final int categoryID;
  final String categoryName;
  final int level;
  var questionIndex = 1;
  var currentQuestion = 1;
  var currentScore = 0;
  var j = 0;
  Timer _timer;
  int _start = 30;

  var _buttonA = 0;
  var _buttonB = 0;
  var _buttonC = 0;
  var _buttonD = 0;


  List<Color> buttonA = <Color>[
    Color(0xFFFFC823), Colors.green, Colors.redAccent
  ];
  List<Color> buttonB = <Color>[
    Color(0xFFFFC823), Colors.green, Colors.redAccent
  ];
  List<Color> buttonC = <Color>[
    Color(0xFFFFC823), Colors.green, Colors.redAccent
  ];
  List<Color> buttonD = <Color>[
    Color(0xFFFFC823), Colors.green, Colors.redAccent
  ];



  _QuizLayoutState(this.categoryName, this.categoryID, this.quizName, this.level);

  List<Question> questions = List<Question>();


  @override
  void initState() {
    this.getJsonData().then((value) {
      print("HELLO");
      setState(() {
        questions.addAll(value);
        //make testing
        for (int i = 0; i < questions.length; i++) {
          print(questions[i].question);
        }
      });
    });
    print("Quiz initState Ran");
    super.initState();
    startTimer();

  }

  final String url = "http://10.0.2.2:5000/api/quiz/questions/";

  Future<List<Question>> getJsonData() async {
    print("fetching questions...");
    var response =
    await http.get(url + widget.categoryID.toString() + "/" + widget.level.toString()
    );
    print(response.body);

    var questionlist = List<Question>();

    if (response.statusCode == 200) {
      print("Passed");

      var data = jsonDecode(response.body);
      for (var unit in data) {
        questionlist.add(Question.fromJson(unit));
      }
      return questionlist;

    } else {
      print("Failed");
      throw Exception('Failed to load Questions');
    }
  }

  List<Question> prepareQuestions(List<Question> questionsInput) {
    List<Question> questions = questionsInput;
    List<Question> compiled = [questionsInput[0]];

    for (int i = 1; i < questions.length; i++) {

      Question current = questions[i];
      compiled.add(current);
    }

    return compiled;

  }

  /// Ensure proper cleanup of timer.
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  ///Timer logic. If timer counts down to 0, retstar the timer and increase the
  ///question index.

  void startTimer() {
    _timer = new Timer.periodic(Duration(seconds: 1), (_timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          if (questionIndex == 10) {
            quizOutcome();
            _timer.cancel();
          } else {
            _start = 30;
            questionIndex++;
            j++;
          }
        }
      });
    });
  }

  void correctAnswer() {
    setState(() {
      // Data

      if (questionIndex != 10) {
      questionIndex++;
      j++;
      }
      currentQuestion++;
      currentScore++;

      _start = 30;
      print("Correct Option clicked!");
    });

    if (currentQuestion > 10) {
      _timer.cancel();
      quizOutcome();
    }
  }

  void wrongAnswer() {
    setState(() {
      // Data

      if (questionIndex != 10) {
        questionIndex++;
        j++;
      }
      currentQuestion++;

      _start = 30;

      print("Wrong Option clicked!");
      if (currentQuestion > 10) {
        _timer.cancel();
        quizOutcome();
      }
    });

    if (questionIndex > 10) {
      _timer.cancel();
      quizOutcome();
    }
  }

  /// Based on your current score, direct to success page or lose page.
  void quizOutcome() {
    if (currentScore >= 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WinScreen(this.categoryName,this.categoryID, this.quizName, this.level, this.currentScore)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoseScreen(this.categoryName, this.categoryID, this.quizName, this.level, this.currentScore)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff47443F),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(this.categoryName + " " + this.quizName),
            Text(questionIndex.toString() + "/10"),
          ],
        ),
        backgroundColor: Color(0xFFFFC823),
        leading: BackButton(
          color: Colors.white,
        ),
        elevation: 0.0,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background/quiz_bg_easy.png'),
              fit: BoxFit.cover
          ),
        ),

        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RedCircle(),
                BigRedCircle.withTime(this._start),
                RedCircle(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  YellowRoundedRectangle(
                      prepareQuestions(questions)[j].question)
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    currentScore.toString() + " / 10",
                    style: TextStyle(color: Colors.white),
                  ),
                  LinearProgressIndicator(
                    value: currentScore / 10,
                    backgroundColor: Colors.white,
                    minHeight: 10,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF4CFC0E)),
                  ),
                  // ProgressBar(currentScore),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                    elevation: 0,
                    color: buttonA[_buttonA],
                    child: Column(
                        children: [TransparentRoundedRectangle(prepareQuestions(questions)[j].a)],
                        crossAxisAlignment: CrossAxisAlignment.stretch),
                    onPressed: () {
                      if (prepareQuestions(questions)[j].ans == "A") {
                        _buttonA = 1;
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          setState(() {
                            _buttonA = 0;
                          });
                          correctAnswer();
                        });
                      } else {
                        _buttonA = 2;
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          setState(() {
                            _buttonA = 0;
                          });
                          wrongAnswer();
                        });
                      }
                    },
                  ),
                  RaisedButton(
                    elevation: 0,
                    color: buttonA[_buttonB],
                    child: Column(
                        children: [TransparentRoundedRectangle(prepareQuestions(questions)[j].b)],
                        crossAxisAlignment: CrossAxisAlignment.stretch),
                    onPressed: () {
                      if (prepareQuestions(questions)[j].ans == "B") {
                        _buttonB = 1;
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          setState(() {
                            _buttonB = 0;
                          });
                          correctAnswer();
                        });
                      } else {
                        _buttonB = 2;
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          setState(() {
                            _buttonB = 0;
                          });
                          wrongAnswer();
                        });
                      }
                    },
                  ),
                  RaisedButton(
                    elevation: 0,
                    color: buttonA[_buttonC],
                    child: Column(
                        children: [TransparentRoundedRectangle(prepareQuestions(questions)[j].c)],
                        crossAxisAlignment: CrossAxisAlignment.stretch),
                    onPressed: () {
                      if (prepareQuestions(questions)[j].ans == "C") {
                        _buttonC = 1;
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          setState(() {
                            _buttonC = 0;
                          });
                          correctAnswer();
                        });
                      } else {
                        _buttonC = 2;
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          setState(() {
                            _buttonC = 0;
                          });
                          wrongAnswer();
                        });
                      }
                    }
                  ),
                  RaisedButton(
                    elevation: 0,
                    color: buttonA[_buttonD],
                    child: Column(
                        children: [TransparentRoundedRectangle(prepareQuestions(questions)[j].d)],
                        crossAxisAlignment: CrossAxisAlignment.stretch),
                    onPressed: () {
                      if (prepareQuestions(questions)[j].ans == "D") {
                        _buttonD = 1;
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          setState(() {
                            _buttonD = 0;
                          });
                          correctAnswer();
                        });
                      } else {
                        _buttonD = 2;
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          setState(() {
                            _buttonD = 0;
                          });
                          wrongAnswer();
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PowerUp(Icon(Icons.lightbulb)),
                      PowerUp(Icon(Icons.phone)),
                      PowerUp(Icon(Icons.cut)),
                      PowerUp(Icon(Icons.poll)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
