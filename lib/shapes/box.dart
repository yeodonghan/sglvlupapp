import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final String boxOption;

  Box(this.boxOption);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FractionallySizedBox(
        widthFactor: 0.75,
        child: Container(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 5,
            bottom: 5,
          ),
          decoration: BoxDecoration(
              color: Color(0xFFFFC823),
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Text(
            boxOption,
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
