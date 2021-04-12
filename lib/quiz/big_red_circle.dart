import 'package:flutter/material.dart';

class BigRedCircle extends StatelessWidget {
  int time;
  BigRedCircle();
  BigRedCircle.withTime(this.time);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.height * 0.08,
        height: MediaQuery.of(context).size.height * 0.08,
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01,),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFC8002)),
        child: Center(
          child: Text(
            time.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ));
  }
}
