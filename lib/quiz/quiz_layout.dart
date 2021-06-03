import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:SGLvlUp/ads/ad_helper.dart';
import 'package:SGLvlUp/audio/SoundsHandler.dart';
import 'package:SGLvlUp/quiz/question.dart';
import 'package:SGLvlUp/shapes/transparent_rounded_rectangle.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:SGLvlUp/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';

import './red_circle.dart';
import '../outcome_screens/lose_screen.dart';
import '../outcome_screens/win_screen.dart';
import '../shapes/yellow_rounded_rectangle.dart';
import 'Coins.dart';
import 'big_red_circle.dart';
import 'power_up.dart';

class QuizLayout extends StatefulWidget {
  final String categoryName;
  final int categoryID;
  final String quizName;
  final int level;
  final int maxLevel;
  final UserProfile user;

  QuizLayout(this.categoryName, this.categoryID, this.quizName, this.level,
      this.maxLevel, this.user);

  @override
  _QuizLayoutState createState() => _QuizLayoutState(
      categoryName, categoryID, quizName, level, maxLevel, user.user_coins);
}

class _QuizLayoutState extends State<QuizLayout> {
  final String quizName;
  final int categoryID;
  final String categoryName;
  final int level;
  final int maxLevel;
  var questionIndex = 1;
  var currentQuestion = 1;
  var currentScore = 0;
  var j = 0;
  Timer _timer;
  int _start = 30;
  bool isLoading = true;
  var coins;
  var points = 0;

  var _buttonA = 0;
  var _buttonB = 0;
  var _buttonC = 0;
  var _buttonD = 0;

  var _statA;
  var _statB;
  var _statC;
  var _statD;

  var _statOpacity = 0.0;
  var _statVisability = 0.0;

  var mapA = {"Right": 1.1};
  var mapB = {"Right": 1.1};
  var mapC = {"Right": 1.1};
  var mapD = {"Right": 1.1};

  var usedP1 = false;
  var usedP2 = false;
  var usedP3 = false;

  var _firstPress = true ;

  String apiUrl =
      "http://ec2-54-255-217-149.ap-southeast-1.compute.amazonaws.com:5000";

  List<Color> colorList = [
    Colors.black,
    Colors.grey,
  ];

  List<Color> buttonA = <Color>[
    Color(0xFFFFC823),
    Colors.green,
    Colors.redAccent,
    Colors.black45
  ];
  List<Color> buttonB = <Color>[
    Color(0xFFFFC823),
    Colors.green,
    Colors.redAccent,
    Colors.black45
  ];
  List<Color> buttonC = <Color>[
    Color(0xFFFFC823),
    Colors.green,
    Colors.redAccent,
    Colors.black45
  ];
  List<Color> buttonD = <Color>[
    Color(0xFFFFC823),
    Colors.green,
    Colors.redAccent,
    Colors.black45
  ];

  Future<void> updateQuestion(Question question, int a, int b, int c,
      int d) async {
    print("Updating question...");
    var response = await http
        .put(apiUrl + "/api/quiz/questions/" + question.qid.toString(), body: {
      "category": "${question.category}",
      "difficulty": "${question.level}",
      "question": "${question.question}",
      "option_a": "${question.a}",
      "option_b": "${question.b}",
      "option_c": "${question.c}",
      "option_d": "${question.d}",
      "answer": "${question.ans}",
      "stats_a": "$a",
      "stats_b": "$b",
      "stats_c": "$c",
      "stats_d": "$d",
    });

    if (response.statusCode == 200) {
      print("Stats updated");
    } else {
      print("Failed");
      throw Exception('Failed to update Stats');
    }
  }

  _QuizLayoutState(this.categoryName, this.categoryID, this.quizName,
      this.level, this.maxLevel, this.coins);

  List<Question> questions = List<Question>();
  BannerAd _bannerAd;
  bool isLoaded = true;

  @override
  void initState() {
    print('isLoading is True');

    Future.delayed(Duration(seconds: 2), () {
      this.getJsonData().then((value) {
        setState(() {
          questions.addAll(value);
          //make testing
          for (int i = 0; i < questions.length; i++) {
            print(questions[i].question);
          }
        });
      });

      isLoading = false;
    });

    print("Quiz initState Ran");

    _bannerAd = BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: AdRequest(),
        size: AdSize.fullBanner,
        listener: AdListener(onAdLoaded: (_) {
          setState(() {
            isLoaded = false;
          });
        }, onAdFailedToLoad: (_, error) {
          print('Ad Fail to Load with Error: $error');
        }));
    _bannerAd.load();
    super.initState();
    startTimer();
  }

  /// Ensure proper cleanup of timer and ads.
  @override
  void dispose() {
    _timer.cancel();
    _bannerAd.dispose();
    super.dispose();
  }

  Widget checkForAd() {
    return isLoaded
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Container(
      child: AdWidget(
        ad: _bannerAd,
      ),
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
      alignment: Alignment.center,
    );
  }

  Future<List<Question>> getJsonData() async {
    print("fetching questions...");
    var response = await http.get(apiUrl +
        "/api/quiz/questions/" +
        widget.categoryID.toString() +
        "/" +
        widget.level.toString());
    print(response.body);

    var questionlist = List<Question>();

    if (response.statusCode == 200) {
      print("Passed getting questions");

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

  ///Timer logic. If timer counts down to 0, retstar the timer and increase the
  ///question index.

  void startTimer() {
    _timer = new Timer.periodic(Duration(seconds: 1), (_timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          if (questionIndex == 10) {
            points = points - 1;
            quizOutcome();
            _timer.cancel();
          } else {
            _start = 30;
            questionIndex++;
            j++;
            points = points - 1;
          }
        }
        // initialise stats
        _statA = prepareQuestions(questions)[j].stats_a;
        _statB = prepareQuestions(questions)[j].stats_b;
        _statC = prepareQuestions(questions)[j].stats_c;
        _statD = prepareQuestions(questions)[j].stats_d;

        Map<String, double> dataMapA = {
          "Right": _statA.toDouble(),
          "Wrong": (_statB + _statC + _statD).toDouble(),
        };
        mapA = dataMapA;
        Map<String, double> dataMapB = {
          "Right": _statB.toDouble(),
          "Wrong": (_statA + _statC + _statD).toDouble(),
        };
        mapB = dataMapB;
        Map<String, double> dataMapC = {
          "Right": _statC.toDouble(),
          "Wrong": (_statA + _statB + _statD).toDouble(),
        };
        mapC = dataMapC;
        Map<String, double> dataMapD = {
          "Right": _statD.toDouble(),
          "Wrong": (_statA + _statB + _statC).toDouble(),
        };
        mapD = dataMapD;
      });
    });
  }

  void correctAnswer() {
    setState(() {
      // Data
      points = points + 2;

      if (questionIndex != 10) {
        questionIndex++;
        j++;
      }
      currentQuestion++;
      currentScore++;

      _start = 30;
      print("Correct Option clicked!");


      _buttonA = 0;
      _buttonB = 0;
      _buttonC = 0;
      _buttonD = 0;

      _statOpacity = 0.0;
      _statVisability = 0.0;
      _firstPress = true;
    });
    if (currentQuestion > 10) {
      _timer.cancel();
      quizOutcome();
    }
  }

  void wrongAnswer() {
    setState(() {
      // Data
      points = points - 1;

      if (questionIndex != 10) {
        questionIndex++;
        j++;
      }
      currentQuestion++;

      _start = 30;

      print("Wrong Option clicked!");

      _buttonA = 0;
      _buttonB = 0;
      _buttonC = 0;
      _buttonD = 0;

      _statOpacity = 0.0;
      _statVisability = 0.0;
      _firstPress = true;
    });

    if (currentQuestion > 10) {
      _timer.cancel();
      quizOutcome();
    }


    if (questionIndex > 10) {
      _timer.cancel();
      quizOutcome();
    }
  }

  /// Based on your current score, direct to success page or lose page.
  void quizOutcome() {
    isLoading = true;
    print('isLoading is True');

    if (points < 0) {
      setState(() {
        points = 0;
      });
    }

    //Update Coins!
    Future<Coins> updateCoins() async {
      var newCoin = this.coins + this.points;
      print("Updating coins...");
      var response = await http.put(apiUrl + "/api/user/coins/", body: {
        "user_email": "${widget.user.user_email}",
        "user_coins": "$newCoin"
      });
      print(response.body);

      if (response.statusCode == 200) {
        print("Passed");
      } else {
        print("Failed");
        throw Exception('Failed to load Questions');
      }
    }

    Future<void> updatePoints() async {
      print("Updating points...");
      var response = await http.put(apiUrl + "/api/score/scores/", body: {
        "category": "${widget.categoryName}",
        "user_email": "${widget.user.user_email}",
        "points": "$points",
      });

      if (response.statusCode == 200) {
        print("Passed");
      } else {
        print("Failed");
        throw Exception('Failed to load Questions');
      }
    }

    if (widget.user.user_name != "Guest") {
      updateCoins();
      updatePoints();
    }

    widget.user.setCoins(coins + points);

    Future.delayed(Duration(seconds: 2), () {
      if (currentScore >= 5) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WinScreen(
                      this.categoryName,
                      this.categoryID,
                      this.quizName,
                      this.level,
                      this.currentScore,
                      this.maxLevel,
                      widget.user,
                      this.points)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoseScreen(
                      this.categoryName,
                      this.categoryID,
                      this.quizName,
                      this.level,
                      this.currentScore,
                      this.maxLevel,
                      widget.user,
                      this.points)),
        );
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return isLoading
        ? Loader()
        : Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xff47443F),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(this.categoryName + " " + this.quizName)),
                Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Text(questionIndex.toString() + "/10")),
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
                  fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              SizedBox(
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Points:"),
                                  RedCircle.withValue(this.points),
                                  BigRedCircle.withTime(this._start),
                                  Text("Coins:"),
                                  RedCircle.withValue(this.coins),
                                ],
                              ),
                              SizedBox(
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.02,
                              ),
                              Container(
                                width:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.8,
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    YellowRoundedRectangle(
                                        prepareQuestions(questions)[j]
                                            .question)
                                  ],
                                ),
                              ),
                              Container(
                                width:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
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
                                      AlwaysStoppedAnimation<Color>(
                                          Color(0xFF4CFC0E)),
                                    ),
                                    // ProgressBar(currentScore),
                                    SizedBox(
                                      height:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.015,
                                    ),
                                    ElevatedButton(
                                      style:
                                      ElevatedButton.styleFrom(

                                          primary: buttonA[_buttonA],
                                          ),
                                      child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(),
                                              flex: 2,
                                            ),
                                            Expanded(
                                              child:
                                              TransparentRoundedRectangle(
                                                  prepareQuestions(
                                                      questions)[j]
                                                      .a,
                                                  prepareQuestions(
                                                      questions)[j]
                                                      .fontsize),
                                              flex: 8,
                                            ),
                                            Expanded(
                                              child: Opacity(
                                                opacity: _statVisability,
                                                child: AnimatedOpacity(
                                                  duration: Duration(
                                                      milliseconds: 1000),
                                                  opacity: _statOpacity,
                                                  child: PieChart(
                                                    dataMap: mapA,
                                                    legendOptions:
                                                    LegendOptions(
                                                        showLegends:
                                                        false),
                                                    colorList: colorList,
                                                    centerText: (100 *
                                                        prepareQuestions(
                                                            questions)[
                                                        j]
                                                            .stats_a /
                                                        (prepareQuestions(
                                                            questions)[j]
                                                            .stats_a +
                                                            prepareQuestions(
                                                                questions)[
                                                            j]
                                                                .stats_b +
                                                            prepareQuestions(
                                                                questions)[
                                                            j]
                                                                .stats_c +
                                                            prepareQuestions(
                                                                questions)[j]
                                                                .stats_d))
                                                        .round()
                                                        .toString() +
                                                        "%",
                                                    chartType: ChartType.ring,
                                                    chartRadius:
                                                    MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width,
                                                    ringStrokeWidth: 5,
                                                    initialAngleInDegree: 270,
                                                    chartValuesOptions:
                                                    ChartValuesOptions(
                                                      showChartValues: false,
                                                      showChartValueBackground:
                                                      false,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              flex: 2,
                                            ),
                                          ],
                                          mainAxisAlignment:
                                          MainAxisAlignment.center),
                                      onPressed: () {
                                        if(_firstPress) {
                                          _firstPress = false;
                                          updateQuestion(
                                              prepareQuestions(questions)[j],
                                              prepareQuestions(questions)[j]
                                                  .stats_a +
                                                  1,
                                              prepareQuestions(questions)[j]
                                                  .stats_b,
                                              prepareQuestions(questions)[j]
                                                  .stats_c,
                                              prepareQuestions(questions)[j]
                                                  .stats_d);
                                          if (prepareQuestions(questions)[j]
                                              .ans ==
                                              "a") {
                                            _buttonA = 1;
                                            SoundsHandler().playCorrect();
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 2000), () {
                                              correctAnswer();
                                            });
                                          } else {
                                            _buttonA = 2;
                                            SoundsHandler().playWrong();
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 2000), () {
                                              wrongAnswer();
                                            });
                                          }
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.003,
                                    ),
                                    ElevatedButton(
                                      style:
                                      ElevatedButton.styleFrom(

                                          primary: buttonB[_buttonB],),
                                      child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(),
                                              flex: 2,
                                            ),
                                            Expanded(
                                              child:
                                              TransparentRoundedRectangle(
                                                  prepareQuestions(
                                                      questions)[j]
                                                      .b,
                                                  prepareQuestions(
                                                      questions)[j]
                                                      .fontsize),
                                              flex: 8,
                                            ),
                                            Expanded(
                                              child: Opacity(
                                                opacity: _statVisability,
                                                child: AnimatedOpacity(
                                                  duration: Duration(
                                                      milliseconds: 1000),
                                                  opacity: _statOpacity,
                                                  child: PieChart(
                                                    dataMap: mapB,
                                                    legendOptions:
                                                    LegendOptions(
                                                        showLegends:
                                                        false),
                                                    colorList: colorList,
                                                    centerText: (100 *
                                                        prepareQuestions(
                                                            questions)[
                                                        j]
                                                            .stats_b /
                                                        (prepareQuestions(
                                                            questions)[j]
                                                            .stats_a +
                                                            prepareQuestions(
                                                                questions)[
                                                            j]
                                                                .stats_b +
                                                            prepareQuestions(
                                                                questions)[
                                                            j]
                                                                .stats_c +
                                                            prepareQuestions(
                                                                questions)[j]
                                                                .stats_d))
                                                        .round()
                                                        .toString() +
                                                        "%",
                                                    chartType: ChartType.ring,
                                                    chartRadius:
                                                    MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width,
                                                    ringStrokeWidth: 5,
                                                    initialAngleInDegree: 270,
                                                    chartValuesOptions:
                                                    ChartValuesOptions(
                                                      showChartValues: false,
                                                      showChartValueBackground:
                                                      false,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              flex: 2,
                                            ),
                                          ],
                                          mainAxisAlignment:
                                          MainAxisAlignment.center),
                                      onPressed: () {
                                        if(_firstPress) {
                                          _firstPress = false;
                                          updateQuestion(
                                              prepareQuestions(questions)[j],
                                              prepareQuestions(questions)[j]
                                                  .stats_a,
                                              prepareQuestions(questions)[j]
                                                  .stats_b +
                                                  1,
                                              prepareQuestions(questions)[j]
                                                  .stats_c,
                                              prepareQuestions(questions)[j]
                                                  .stats_d);

                                          if (prepareQuestions(questions)[j]
                                              .ans ==
                                              "b") {
                                            _buttonB = 1;
                                            SoundsHandler().playCorrect();
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 2000), () {
                                              correctAnswer();
                                            });
                                          } else {
                                            _buttonB = 2;
                                            SoundsHandler().playWrong();
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 2000), () {
                                              wrongAnswer();
                                            });
                                          }
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.003,
                                    ),
                                    ElevatedButton(
                                        style:
                                        ElevatedButton.styleFrom(

                                            primary: buttonC[_buttonC],),
                                        child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(),
                                                flex: 2,
                                              ),
                                              Expanded(
                                                  child: TransparentRoundedRectangle(
                                                      prepareQuestions(
                                                          questions)[j]
                                                          .c,
                                                      prepareQuestions(
                                                          questions)[j]
                                                          .fontsize),
                                                  flex: 8),
                                              Expanded(
                                                child: Opacity(
                                                  opacity: _statVisability,
                                                  child: AnimatedOpacity(
                                                    duration: Duration(
                                                        milliseconds: 1000),
                                                    opacity: _statOpacity,
                                                    child: PieChart(
                                                      dataMap: mapC,
                                                      legendOptions:
                                                      LegendOptions(
                                                          showLegends:
                                                          false),
                                                      colorList: colorList,
                                                      centerText: (100 *
                                                          prepareQuestions(
                                                              questions)[
                                                          j]
                                                              .stats_c /
                                                          (prepareQuestions(
                                                              questions)[j]
                                                              .stats_a +
                                                              prepareQuestions(
                                                                  questions)[j]
                                                                  .stats_b +
                                                              prepareQuestions(
                                                                  questions)[j]
                                                                  .stats_c +
                                                              prepareQuestions(
                                                                  questions)[j]
                                                                  .stats_d))
                                                          .round()
                                                          .toString() +
                                                          "%",
                                                      chartType:
                                                      ChartType.ring,
                                                      chartRadius:
                                                      MediaQuery
                                                          .of(
                                                          context)
                                                          .size
                                                          .width,
                                                      ringStrokeWidth: 5,
                                                      initialAngleInDegree:
                                                      270,
                                                      chartValuesOptions:
                                                      ChartValuesOptions(
                                                        showChartValues:
                                                        false,
                                                        showChartValueBackground:
                                                        false,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                flex: 2,
                                              ),
                                            ],
                                            mainAxisAlignment:
                                            MainAxisAlignment.center),
                                        onPressed: () {
                                          if(_firstPress) {
                                            _firstPress = false;
                                            updateQuestion(
                                                prepareQuestions(questions)[j],
                                                prepareQuestions(questions)[j]
                                                    .stats_a,
                                                prepareQuestions(questions)[j]
                                                    .stats_b,
                                                prepareQuestions(questions)[j]
                                                    .stats_c +
                                                    1,
                                                prepareQuestions(questions)[j]
                                                    .stats_d);

                                            if (prepareQuestions(questions)[j]
                                                .ans ==
                                                "c") {
                                              _buttonC = 1;
                                              SoundsHandler().playCorrect();
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 2000), () {
                                                correctAnswer();
                                              });
                                            } else {
                                              _buttonC = 2;
                                              SoundsHandler().playWrong();
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 2000), () {
                                                wrongAnswer();
                                              });
                                            }
                                          }
                                        }),
                                    SizedBox(
                                      height:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.003,
                                    ),
                                    ElevatedButton(
                                      style:
                                      ElevatedButton.styleFrom(
                                          primary: buttonD[_buttonD],
                                          ),
                                      child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(),
                                              flex: 2,
                                            ),
                                            Expanded(
                                              child:
                                              TransparentRoundedRectangle(
                                                  prepareQuestions(
                                                      questions)[j]
                                                      .d,
                                                  prepareQuestions(
                                                      questions)[j]
                                                      .fontsize),
                                              flex: 8,
                                            ),
                                            Expanded(
                                              child: Opacity(
                                                opacity: _statVisability,
                                                child: AnimatedOpacity(
                                                  opacity: _statOpacity,
                                                  duration: Duration(
                                                      milliseconds: 1000),
                                                  child: PieChart(
                                                    dataMap: mapD,
                                                    legendOptions:
                                                    LegendOptions(
                                                        showLegends:
                                                        false),
                                                    colorList: colorList,
                                                    centerText: (100 *
                                                        prepareQuestions(
                                                            questions)[
                                                        j]
                                                            .stats_d /
                                                        (prepareQuestions(
                                                            questions)[j]
                                                            .stats_a +
                                                            prepareQuestions(
                                                                questions)[
                                                            j]
                                                                .stats_b +
                                                            prepareQuestions(
                                                                questions)[
                                                            j]
                                                                .stats_c +
                                                            prepareQuestions(
                                                                questions)[j]
                                                                .stats_d))
                                                        .round()
                                                        .toString() +
                                                        "%",
                                                    chartType: ChartType.ring,
                                                    chartRadius:
                                                    MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width,
                                                    ringStrokeWidth: 5,
                                                    initialAngleInDegree: 270,
                                                    chartValuesOptions:
                                                    ChartValuesOptions(
                                                      showChartValues: false,
                                                      showChartValueBackground:
                                                      false,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              flex: 2,
                                            ),
                                          ],
                                          mainAxisAlignment:
                                          MainAxisAlignment.center),
                                      onPressed: () {
                                        if(_firstPress) {
                                          _firstPress = false;
                                          updateQuestion(
                                              prepareQuestions(questions)[j],
                                              prepareQuestions(questions)[j]
                                                  .stats_a,
                                              prepareQuestions(questions)[j]
                                                  .stats_b,
                                              prepareQuestions(questions)[j]
                                                  .stats_c,
                                              prepareQuestions(questions)[j]
                                                  .stats_d +
                                                  1);
                                          if (prepareQuestions(questions)[j]
                                              .ans ==
                                              "d") {
                                            _buttonD = 1;
                                            SoundsHandler().playCorrect();
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 2000), () {
                                              correctAnswer();
                                            });
                                          } else {
                                            _buttonD = 2;
                                            SoundsHandler().playWrong();
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 2000), () {
                                              wrongAnswer();
                                            });
                                          }
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          child:
                                          PowerUp(Icon(Icons.lightbulb)),
                                          onTap: () {
                                            SoundsHandler().playTap();
                                            // check
                                            if (usedP1 == true) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  '50/50 Hint can only be used once!',
                                                  toastLength:
                                                  Toast.LENGTH_SHORT,
                                                  gravity:
                                                  ToastGravity.CENTER);
                                            } else if (coins < 25) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  'Insufficient Coins, 25 Coins needed!',
                                                  toastLength:
                                                  Toast.LENGTH_SHORT,
                                                  gravity:
                                                  ToastGravity.CENTER);
                                            } else {
                                              setState(() {
                                                usedP1 = true;
                                                coins = coins - 25;
                                              });

                                              List<int> options = [
                                                0,
                                                1,
                                                2,
                                                3
                                              ];
                                              if (prepareQuestions(
                                                  questions)[j]
                                                  .ans ==
                                                  "a") {
                                                options.remove(0);
                                                print("Removed A");
                                              } else if (prepareQuestions(
                                                  questions)[j]
                                                  .ans ==
                                                  "b") {
                                                options.remove(1);
                                                print("Removed B");
                                              } else if (prepareQuestions(
                                                  questions)[j]
                                                  .ans ==
                                                  "c") {
                                                options.remove(2);
                                                print("Removed C");
                                              } else {
                                                options.remove(3);
                                                print("Removed D");
                                              }
                                              options.shuffle();
                                              print("Shuffled");
                                              for (int i = 0; i < 2; i++) {
                                                if (options[i] == 0) {
                                                  _buttonA = 3;
                                                } else if (options[i] == 1) {
                                                  _buttonB = 3;
                                                } else if (options[i] == 2) {
                                                  _buttonC = 3;
                                                } else {
                                                  _buttonD = 3;
                                                }
                                              }
                                            }
                                          },
                                        ),
                                        GestureDetector(
                                          child: PowerUp(Icon(Icons
                                              .hourglass_bottom_outlined)),
                                          onTap: () {
                                            SoundsHandler().playTap();
                                            if (usedP2 == true) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  'Time extension can only be used once!',
                                                  toastLength:
                                                  Toast.LENGTH_SHORT,
                                                  gravity:
                                                  ToastGravity.CENTER);
                                            } else if (coins < 10) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  'Insufficient Coins, 10 Coins needed!',
                                                  toastLength:
                                                  Toast.LENGTH_SHORT,
                                                  gravity:
                                                  ToastGravity.CENTER);
                                            } else {
                                              setState(() {
                                                usedP2 = true;
                                                coins = coins - 10;
                                              });
                                              Fluttertoast.showToast(
                                                  msg: 'Time Extended!',
                                                  toastLength:
                                                  Toast.LENGTH_SHORT,
                                                  gravity:
                                                  ToastGravity.CENTER);
                                              _start = _start + 30;
                                              print("Time Extended");
                                            }
                                          },
                                        ),
                                        GestureDetector(
                                          child: Transform.rotate(
                                            child: PowerUp(Icon(Icons.poll)),
                                            angle: 90 * pi / 180,
                                          ),
                                          onTap: () {
                                            SoundsHandler().playTap();
                                            if (usedP3 == true) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  'Statistics can only be used once!',
                                                  toastLength:
                                                  Toast.LENGTH_SHORT,
                                                  gravity:
                                                  ToastGravity.CENTER);
                                            } else if (coins < 20) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  'Insufficient Coins, 20 Coins needed!',
                                                  toastLength:
                                                  Toast.LENGTH_SHORT,
                                                  gravity:
                                                  ToastGravity.CENTER);
                                            } else {
                                              setState(() {
                                                usedP3 = true;
                                                coins = coins - 20;
                                              });

                                              _statOpacity = 1.0;
                                              _statVisability = 1.0;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                checkForAd(),
              ],
            ),
          ),
        ),
        /*
        AnimatedContainer(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          duration: Duration(
            microseconds: 1,
          ),
          transform: Matrix4.translationValues(0, _quizYOffset, 0),

          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
        */
      ],
    );
  }
}