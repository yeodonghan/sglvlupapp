import 'package:flutter/material.dart';

class CategoryTitle extends StatelessWidget {
  final String categoryTitle;
  CategoryTitle(this.categoryTitle);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 10,
          bottom: 10,
        ),
        child: Text(
          this.categoryTitle,
          style: TextStyle(fontSize: 20),
        ),
        color: Colors.white,
      ),
    );
  }
}
