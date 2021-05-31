import 'package:SGLvlUp/audio/SoundsHandler.dart';
import 'package:SGLvlUp/quiz/quiz_layout.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:asset_cache/asset_cache.dart';

final imageCache = ImageAssetCache(basePath: "assets/levels/");

class SubCategoryBubble extends StatefulWidget {
  String categoryName;
  int categoryID;
  String quizName;
  int level;
  int maxLevel;
  UserProfile user;
  String lvl1 = "1VqUXcPuw7j7b0FcUf3uujj3-bnSoToHO";
  String lvl2 = "1NO97chW6dVRs-ditTZY2h25CLN43mi5d";
  String lvl3 = "1ZNkq69j8zxn1MhYhnKDztL3QSgYxHi0T";
  String lvl4 = "1yNU77KHDAt31_EAo54St63GNzT_mJOpO";
  String lvl5 = "1-k4BMAOfb1qCsPdLFchIch2IT8uVdqeF";
  String lvl6 = "1JirD-3IAj8RJv_Ps_MrVaoF3UOTLd1bo";
  String lvl7 = "1lx_fRw06i7R8XoQIdoaCSpiwxEb3AEim";
  String lvl8 = "1Z6DaoFmMyRlAZP_BbcAfMYI46GIjgLoq";
  String lvl9 = "1Bv9L81oNEi0x2-OG9OnM9ptsF8_App4D";


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
  String levelUrl;


  @override
  void initState() {
    print('This state is of Level: ' + widget.level.toString());
    switch(widget.level) {
      case 1: {
        levelUrl = widget.lvl1;
      }
      break;
      case 2: {
        levelUrl = widget.lvl2;
      }
      break;
      case 3: {
        levelUrl = widget.lvl3;
      }
      break;
      case 4: {
        levelUrl = widget.lvl4;
      }
      break;
      case 5: {
        levelUrl = widget.lvl5;
      }
      break;
      case 6: {
        levelUrl = widget.lvl6;
      }
      break;
      case 7: {
        levelUrl = widget.lvl7;
      }
      break;
      case 8: {
        levelUrl = widget.lvl8;
      }
      break;
      default: {
        levelUrl = widget.lvl9;
      }
      break;
    }
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
                    image: CachedNetworkImageProvider(
                        "http://drive.google.com/uc?export=view&id=$levelUrl"),
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
