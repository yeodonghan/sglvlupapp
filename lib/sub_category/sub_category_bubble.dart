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
  List<String> urls = ["1VqUXcPuw7j7b0FcUf3uujj3-bnSoToHO",
  "1NO97chW6dVRs-ditTZY2h25CLN43mi5d",
  "1ZNkq69j8zxn1MhYhnKDztL3QSgYxHi0T",
  "1yNU77KHDAt31_EAo54St63GNzT_mJOpO",
  "1-k4BMAOfb1qCsPdLFchIch2IT8uVdqeF",
  "1JirD-3IAj8RJv_Ps_MrVaoF3UOTLd1bo",
  "1lx_fRw06i7R8XoQIdoaCSpiwxEb3AEim",
  "1Z6DaoFmMyRlAZP_BbcAfMYI46GIjgLoq",
  "1Bv9L81oNEi0x2-OG9OnM9ptsF8_App4D"];


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
                        "http://drive.google.com/uc?export=view&id=${widget.urls[widget.level-1]}"),
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
