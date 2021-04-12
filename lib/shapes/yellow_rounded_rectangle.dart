import 'package:flutter/material.dart';

class YellowRoundedRectangle extends StatelessWidget {
  final String message;
  YellowRoundedRectangle(this.message);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
        child: Container(
        color: Color(0xFFFFC823),
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 10,
          bottom: 10,
        ),
          child: SingleChildScrollView(
            child: Text(
              this.message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        /*
        decoration: BoxDecoration(color: Color(0xFFFFC823), boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ]),

         */
      );

  }
}
