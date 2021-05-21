import 'package:SGLvlUp/audio/SoundsHandler.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../sub_category/sub_category_layout.dart';

class CategoryBubble extends StatelessWidget {
  final String categoryName;
  final int categoryID;
  final String pictureurl;
  final String description;
  final UserProfile user;

  CategoryBubble(this.categoryName, this.categoryID, this.pictureurl, this.user,
      this.description);

  @override
  Widget build(BuildContext context) {
    if (categoryName == null) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.172,
        width: MediaQuery.of(context).size.height * 0.09,

        // ),
      );
    } else {
      return
          // Flexible(
          //   child:
          Container(
        height: MediaQuery.of(context).size.height * 0.172,
        width: MediaQuery.of(context).size.height * 0.09,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  SoundsHandler().playTap();
                  print(this.categoryName);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubCategoryLayout(
                            this.categoryName,
                            this.categoryID,
                            this.pictureurl,
                            this.user,
                            this.description)),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.09,
                  height: MediaQuery.of(context).size.height * 0.09,
                  //padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            "http://drive.google.com/uc?export=view&id=$pictureurl"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.002),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.height * 0.09,
              height: MediaQuery.of(context).size.height * 0.03,
              child: Text(
                categoryName,
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
          ],
        ),
        color: Colors.white,
        // ),
      );
    }
  }
}
