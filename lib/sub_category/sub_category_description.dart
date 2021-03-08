import 'package:flutter/material.dart';

class SubCategoryDescription extends StatelessWidget {
  final int categoryID;
  final String categoryName;
  SubCategoryDescription(this.categoryID, this.categoryName);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/quizbanner/banner_'+ categoryName.replaceAll(' ', '').replaceAll(':', '') + '.jpg'),
                  fit: BoxFit.cover
            ),

          )),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
              bottom: 10,
            ),
            constraints: BoxConstraints(maxHeight: 220),
            child: SingleChildScrollView(
              child: Text(
                "Though physically small, Singapore is an economic giant. It has been Southeast Asia's most modern city for over a century. The city blends Malay, Chinese, Arab, Indian and English cultures and religions. Its unique ethnic tapestry affords visitors a wide array of sightseeing and culinary opportunities from which to choose. A full calendar of traditional festivals and holidays celebrated throughout the year adds to its cultural appeal. In addition, Singapore offers luxury hotels, delectable cuisine and great shopping! The island nation of the Republic of Singapore lies one degree north of the Equator in Southern Asia. The country includes the island of Singapore and 58 or so smaller islands. Because of its efficient and determined government, Singapore has become a flourishing country that excels in trade and tourism and is a model to developing nations. The capital city, also called Singapore, covers about a third of the area of the main island. ",
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
