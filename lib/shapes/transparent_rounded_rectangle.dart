import 'package:flutter/material.dart';

class TransparentRoundedRectangle extends StatelessWidget {
  final String message;
  final double fontsize;
  TransparentRoundedRectangle(this.message, this.fontsize);


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        // color: Color(0xFFFFC823),
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.height * 0.015,
          right: MediaQuery.of(context).size.height * 0.015,
          top: MediaQuery.of(context).size.height * 0.010,
          bottom: MediaQuery.of(context).size.height * 0.010,
        ),
        child: Text(
          this.message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: this.fontsize),
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
