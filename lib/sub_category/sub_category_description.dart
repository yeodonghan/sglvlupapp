import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SubCategoryDescription extends StatelessWidget {
  final int categoryID;
  final String categoryName;
  final String pictureurl;
  final String description;
  SubCategoryDescription(
      this.categoryID, this.categoryName, this.pictureurl, this.description);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            //padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: NetworkImage(
                      "http://drive.google.com/uc?export=view&id=" +
                          pictureurl),
                  fit: BoxFit.cover),
            ),
            /*
            child: CachedNetworkImage(
              imageUrl: "http://drive.google.com/uc?export=view&id=" + this.pictureurl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),

             */
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
              bottom: 10,
            ),
            height: MediaQuery.of(context).size.height * 0.25,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.25),
            child: SingleChildScrollView(
              child: Text(
                this.description,
                style: TextStyle(fontSize: 14),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
