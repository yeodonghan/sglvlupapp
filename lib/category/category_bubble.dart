import 'package:flutter/material.dart';
import '../sub_category/sub_category_layout.dart';

class CategoryBubble extends StatelessWidget {
  final String categoryName;
  final int categoryID;
  CategoryBubble(this.categoryName, this.categoryID );



  @override
  Widget build(BuildContext context) {
    if(categoryName == null) {
      return
        Container(
          height: 120,
          width: 75,

          // ),
        );
    } else {
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
                              SubCategoryLayout(this.categoryName, this.categoryID)),
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/quizbanner/banner_' + categoryName.replaceAll(' ', '').replaceAll(':', '') + '.jpg'),
                            fit: BoxFit.cover
                        ),

                      )
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 70,
                height: 30,
                child: Flexible(
                  child: Text(
                    categoryName,
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
          color: Colors.white,
          // ),
        );
    }
  }
}
