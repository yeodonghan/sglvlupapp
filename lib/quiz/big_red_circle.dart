import 'package:flutter/material.dart';

class BigRedCircle extends StatelessWidget {
  int time;
  BigRedCircle();
  BigRedCircle.withTime(this.time);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 45,
        height: 45,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFC8002)),
        child: Text(
          time.toString(),
          textAlign: TextAlign.center,
        ));
  }
}
