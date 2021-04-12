import 'package:flutter/material.dart';

class RedCircle extends StatelessWidget {
  int value;
  RedCircle();
  RedCircle.withValue(this.value);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.height * 0.05,
        height: MediaQuery.of(context).size.height * 0.05,
        padding: EdgeInsets.only(top: 5),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFC8002)),
        child: Center(
          child: Text(
            value.toString(),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
