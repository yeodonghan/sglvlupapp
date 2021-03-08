import 'package:flutter/material.dart';

class TransparentRoundedRectangle extends StatelessWidget {
  final String message;
  TransparentRoundedRectangle(this.message);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        // color: Color(0xFFFFC823),
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 10,
          bottom: 10,
        ),
        child: Text(
          this.message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        decoration: BoxDecoration(color: Colors.transparent, boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ]),
      ),
    );
  }
}
