import 'package:flutter/material.dart';

class RedCircle extends StatelessWidget {
  int time;
  RedCircle();
  RedCircle.withTime(this.time);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 30,
        height: 30,
        padding: EdgeInsets.only(top: 5),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFC8002)),
        child: Text(
          time.toString(),
          textAlign: TextAlign.center,
        ));
  }
}
